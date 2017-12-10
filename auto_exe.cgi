#!/usr/bin/perl

###################
# BMCOM実行プログラム
###################

use lib './lib', './extlib';
use CGI::Carp qw/fatalsToBrowser/;

use Jikkoku::Util;
use Jikkoku::Model::Chara::AutoModeList;

require './ini_file/index.ini';
require 'suport.pl';
require 'lib/skl_lib.pl';

#時間制限 19-25時
&TIME_RIMIT;

#サブルーチン定義
#AUTO_COM書き込み
sub AUTO_COM_WRITE {

  # デバッグ用
  # use Carp qw/longmess/;
  # $mess .= "\n<pre>err_flag: $err_flag, cid : $cid" . longmess() . "</pre>";

  splice(@AUTO_COM,0,1);
  push(@AUTO_COM,"<><><><><><><>\n");

  open(OUT,">./charalog/auto_com/$kid\.cgi");
  print OUT @AUTO_COM;
  close(OUT);
}

# ここでのエラー処理(suport.plのsub ERRを再定義)
*ERR = sub {
  my $mes = shift;

  if ($tekiiru && $cend eq "0") {
    $idate = time();
    $tekiiru = 0;
    if ($idate < $kkoutime) {
      my $nokori = $kkoutime - $idate;
      ERR("あと $nokori秒 行動できません。");
    }
    TOWN_DATA_OPEN($kiti);

    #掩護があった場合の処理 ./lib/skl_lib.pl
    NEW_ENGO_SYORI($kid, $in{eid});
    TOWN_DATA_OPEN($kiti);
    require "./battlecm/battle.pl";
    $err_flag = 1;
    BATTLE();
  }

  # AUTO_COM_WRITE をしたくない時の処理
  if ($mes eq '移動ポイントが足りません。') {
    if ($idate >= $kbattletime) {
      #移p補充 ./lib/skl_lib.pl
      IDOUSKL();
      IDOUSKL2();
      return;
    } else {
      $mess .= "\n移動ポイントも補充時間もありません。";
      next AUTO;
    }
  }
  elsif ($mes =~ /移Pが足りず補充することもできません/) {
    $mess .= "\n移P&補充時間不足 by 自動移動";
    next AUTO;
  }
  elsif ($mes =~ /行動できません。/) {
    $mess .= "\n行動待機時間が..";
    next AUTO;
  }

  if ($cnum eq "0") {
    AUTO_COM_WRITE();
  }

  $mess .= "\n$mes";
  next AUTO;
};
# $originに元の sub HEADER を記録
$origin = \&HEADER;

# ここでのheader処理(suport.plのsub HEADERを再定義)
# 自動移動以外の場合は、コマンド実行終了時にコマンドを消費するようにする
*HEADER = sub {

  if ($cid != 9) {
    if (!$err_flag) {
      AUTO_COM_WRITE();
    } else {
      $err_flag = 0;
      if ($cnum eq "0") {
        &AUTO_COM_WRITE;
      }
    }
  }

  next AUTO;
};

# ここでのchara_main_open処理
*CHARA_MAIN_OPEN = sub {};


#メイン部分
&MAIN;

sub MAIN {

  # BMCOM登録リストオープン
  my $auto_list_model = Jikkoku::Model::Chara::AutoModeList->new;
  my $auto_list       = $auto_list_model->get_all;

  require Jikkoku::Model::Chara;
  my $chara_model = Jikkoku::Model::Chara->new;

#実行処理
  $i=0;
  $suigun_mode = 0;
  AUTO: foreach (@$auto_list) {
       my $id = $_;
       my $textdata = Jikkoku::Util::open_data("./charalog/main/$_.cgi")->[0];
       suport_expand_my_chara_to_global_variables($textdata);

       $in{'eid'} = "";
       $tettai = 0;
       $err_flag = 0;
       @ROOT = ();
       @BM_TIKEI = ();

       #消費IPの値が水軍の時,通常の値に戻す
       if ($suigun_mode) {
         do './ini_file/nomal_move.ini';
       }

       if ($ksol <= 0 && $ksyuppei eq "1") {
         $ksyuppei = 0;
         $tettai = 1;
       }

       if ($ksyuppei) {
#AUTO_COMデータ読み込み
         open(IN,"./charalog/auto_com/$kid.cgi");
         @AUTO_COM = <IN>;
         close(IN);
         ($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$AUTO_COM[0]);

         $in{'id'} = $kid;
         $in{'pass'} = $kpass;

#AUTO_COM実行処理
         if($cid eq "0" || $cid eq ""){  #AUTOMODE解除

           $auto_list_model->delete($kid);
           &AUTO_COM_WRITE;
           &K_LOG("BM自動モードを解除しました。");

         }elsif($cid eq "1"){  #移動

           $in{'zahyou'} = $cno+1;
           require './battlecm/idou.pl';
           &IDOU(2);

         }elsif($cid eq "5"){  #出城&入城

           do "./log_file/map_hash/$kiti.pl";

           if($BM_TIKEI[$ky][$kx] == 16 || $BM_TIKEI[$ky][$kx] == 17){
             $in{'sekisyo'} = "$kx,$ky";
           }if($ky-1 >= 0){
             if($BM_TIKEI[$ky-1][$kx] == 16 || $BM_TIKEI[$ky-1][$kx] == 17){
               my $iky = $ky-1;
               $in{'sekisyo'} = "$kx,$iky";
             }
           }if($ky+1 < $BM_Y){
             if($BM_TIKEI[$ky+1][$kx] == 16 || $BM_TIKEI[$ky+1][$kx] == 17){
               my $iky = $ky+1;
               $in{'sekisyo'} = "$kx,$iky";
             }
           }if($kx-1 >= 0){
             if($BM_TIKEI[$ky][$kx-1] == 16 || $BM_TIKEI[$ky][$kx-1] == 17){
               my $ikx = $kx-1;
               $in{'sekisyo'} = "$ikx,$ky";
             }
           }if($kx+1 < $BM_X){
             if($BM_TIKEI[$ky][$kx+1] == 16 || $BM_TIKEI[$ky][$kx+1] == 17){
               my $ikx = $kx+1;
               $in{'sekisyo'} = "$ikx,$ky";
             }
           }if($in{'sekisyo'} eq ""){
             &ERR("入城/出城できる位置にいません。");
           }

           require './battlecm/sekisyo.pl';
           &SEKISYO;

         }elsif($cid eq "6"){  #戦闘

           $idate = time();
           my $zsa=0,$zsa2=0,$zsa3=0;

           if($idate < $kkoutime){
             my $nokori = $kkoutime-$idate;
             &ERR("あと $nokori秒 行動できません。");
           }else{
             $tikeishiro = 0;
#バトルマップ読み込み
             do "./log_file/map_hash/$kiti.pl";


         MAP:for($i=0;$i<$BM_Y;$i++){
               for($j=0;$j<$BM_X;$j++){
                 if($BM_TIKEI[$i][$j] == 18 || $BM_TIKEI[$i][$j] == 22){
                   &TOWN_DATA_OPEN("$kiti");
                   if($kcon ne "$zcon"){
                     $fx = $j;
                     $fy = $i;
                     $tikeishiro = 1;
                   }
                   last MAP;
                 }
               }
             }

		         if($tikeishiro){
		           $zsa = abs($kx-$fx);
		           $zsa2 = abs($ky-$fy);
		           $zsa3 = $zsa+$zsa2;
		           if($zsa3 > $SOL_AT[$ksub1_ex]){
		           #城に攻撃できる場所にはいません。
		             $tikeishiro=0;
		           }else{
		             $in{'eid'} = "jyouhekisyugohei";
		           }
		         }

				     #全武将データ読み込み
						 my @page=();
						 my @CL_DATA=();
						 opendir('dirlist',"./charalog/main");
						 while($file = readdir('dirlist')){
					     if($file =~ /\.cgi/i){
						 		 if(!open('page',"./charalog/main/$file")){
								   &ERR2("ファイルオープンエラー！");
								 }
								 @page = <page>;
								 close('page');
								 push(@CL_DATA,"@page<br>");
							 }
						 }
						 closedir('dirlist');

						 foreach(@CL_DATA){
               suport_expand_enemy_chara_to_global_variables($_);

							 if($kiti eq $eiti && $kcon ne $econ){
								 if($fx == $ex && $fy == $ey && $tikeishiro){
								   $in{'eid'} = "$eid";
								   last;
								 }
		  					 $zsa = abs($kx-$ex);
								 $zsa2 = abs($ky-$ey);
								 $zsa3 = $zsa+$zsa2;
								 if($zsa3 <= $SOL_AT[$ksub1_ex] && $esyuppei && !$tikeishiro){
								   $in{'eid'} = "$eid";
								   last;
								 }
							 }
						 }

				    #掩護処理 ./lib/skl_lib.pl
						NEW_ENGO_SYORI($kid, $in{eid});

            # 都市データを開くたびに各国の都市数が増えていくため(myつけたい...
            @town_get = ();
						&TOWN_DATA_OPEN("$kiti");

						require "./battlecm/battle.pl";
						&BATTLE;
						
						}

         }elsif($cid eq "9"){  # 自動移動 #

#バトルマップ、ルートファイル読み込み
           do "./log_file/map_hash/$kiti.pl";
           do "./log_file/map_road/$csub.pl";

           if($ROOT[$ky][$kx]->{"$kiti"} =~ /,/){
             ($ry,$rx) = split(/,/,$ROOT[$ky][$kx]->{"$kiti"});

             COUNTRY_DATA_OPEN($kcon);
             @town_get = ();
						 TOWN_DATA_OPEN("$kiti");

#敵国城壁のマスだった場合終了
             if( ($BM_TIKEI[$ry][$rx] == 18 || $BM_TIKEI[$ry][$rx] == 22) && $town_cou[$kiti] ne "$kcon"){
               $mess .= "敵国城壁マスです $town_cou[$kiti], $kcon";
               &AUTO_COM_WRITE;
               next;
             }

#全武将データ読み込み
             my @page=();
             my @CL_DATA=();
             opendir('dirlist',"./charalog/main");
             while($file = readdir('dirlist')){
               if($file =~ /\.cgi/i){
                 if(!open('page',"./charalog/main/$file")){
                   &ERR2("ファイルオープンエラー！");
                 }
                 @page = <page>;
                 close('page');
                 push(@CL_DATA,"@page<br>");
               }
             }
             closedir('dirlist');
#移動先に敵がいないか
             $tekiiru=0;
             foreach(@CL_DATA){
               suport_expand_enemy_chara_to_global_variables($_);

               if($kiti eq $eiti){
                 if($kcon ne $econ){
                   if($rx == $ex && $ry == $ey){
                     $tekiiru = 1;
                     $in{'eid'} = $eid;
                     last;
                   }
                 }
               }
             }
#敵がいた場合
             if($tekiiru){
               if($cend eq "0"){
#戦闘
                 &ERR("移動先のマスに敵武将がいるので戦闘します");
               }else{
#何もしない
                 $tekiiru=0;
                 &ERR("移動先のマスに敵武将がいます。");
               }
             }


             $idate = time();

#水軍使用時
             if($SOL_ZOKSEI[$ksub1_ex] eq "水"){
               do './ini_file/suigun.ini';
             }

#筋斗雲　./lib/skl_lib.pl
             my $origin_cost = $CAN_MOVE[ $BM_TIKEI[$ry][$rx] ];
             KINTOUN($rx, $ry);

             my $chara = $chara_model->get($kid);
             skl_lib_adjust_state_move_cost($rx, $ry, $chara, $idate);

             $kidoup -= $CAN_MOVE[$BM_TIKEI[$ry][$rx]];
             if($kidoup < 0){
               if($idate >= $kbattletime){
#移動スキル./lib/skl_lib.pl
                 &IDOUSKL;
                 &IDOUSKL2;
                 $kidoup -= $CAN_MOVE[$BM_TIKEI[$ry][$rx]];
               }else{
                 ERR("移Pが足りず補充することもできません");
               }
             }
             $CAN_MOVE[ $BM_TIKEI[$ry][$rx] ] = $origin_cost;

             #毒地形
               if($BM_TIKEI[$ry][$rx] eq "6"){
                 $dkdie = int($ksol/20);
                 $ksol -= $dkdie;
                 &K_LOG("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
                 &K_LOG2("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
               }

             $ky = $ry;
             $kx = $rx;
             $ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
             &CHARA_MAIN_INPUT;

           }elsif($ROOT[$ky][$kx]->{"$kiti"} eq "exit"){
             $mess .= "最終点に達しました。終了します";
             &AUTO_COM_WRITE;
             next;

           }elsif($ROOT[$ky][$kx]->{"$kiti"} eq ""){
             &ERR("【BM自動モード】自動移動ができる位置にいません。");
             next;

           }else{
             require './battlecm/sekisyo.pl';
             $in{'sekisyo'} = "$kx,$ky";
             &SEKISYO;
           }

         }elsif($cid eq "10"){  # NPC専用 PCに攻撃しかける #

#全武将データ読み込み
           my @page=();
           my @CL_DATA=();
           opendir('dirlist',"./charalog/main");
           while($file = readdir('dirlist')){
             if($file =~ /\.cgi/i){
               if(!open('page',"./charalog/main/$file")){
                 &ERR2("ファイルオープンエラー！");
               }
               @page = <page>;
               close('page');
               push(@CL_DATA,"@page<br>");
             }
           }
           closedir('dirlist');
           $tekiiru=0;
           my $mzsa=99,$zsa=0,$ax=0,$ay=0;
           foreach(@CL_DATA){
             suport_expand_enemy_chara_to_global_variables($_);

             if($kiti eq $eiti){
               if($kcon ne $econ){
                 $zsa = abs($kx-$ex)+abs($ky-$ey);
                 if($mzsa > $zsa){
                   $tekiiru = 1;
                   $in{'eid'} = $eid;
                   $mzsa = $zsa;
                   $ax = $ex;
                   $ay = $ey;
                   $asub1_ex = $esub1_ex;
                 }
               }
             }
           }

           if(!$tekiiru){
             next AUTO;
           }else{  #敵が同じマップにいた時

             if($SOL_AT[$ksub1_ex] == 1){
               if($mzsa <= 1){
                 &this_TIMELESS; #行動待機時間
                 NEW_ENGO_SYORI($kid, $in{eid});    #掩護処理 ./lib/skl_lib.pl
                 &TOWN_DATA_OPEN("$kiti");
                 require "./battlecm/battle.pl";
                 &BATTLE;
               }else{
#近づく、移動する方向指定
                 $in{'zahyou'} = 0;
                 if(abs($kx-$ax) > abs($ky-$ay)){
                   if($kx-$ax < 0){
                     $in{'zahyou'} = 3; #右
                   }elsif($kx-$ax > 0){
                     $in{'zahyou'} = 2; #左
                   }
                 }elsif(abs($kx-$ax) < abs($ky-$ay)){
                   if($ky-$ay < 0){
                     $in{'zahyou'} = 4; #下
                   }elsif($ky-$ay > 0){
                     $in{'zahyou'} = 5; #上
                   }
                 }else{
                   if($kx-$ax < 0){
                     $in{'zahyou'} = 3; #右
                   }elsif($kx-$ax > 0){
                     $in{'zahyou'} = 2; #左
                   }elsif($ky-$ay < 0){
                     $in{'zahyou'} = 4; #下
                   }else{
                     $in{'zahyou'} = 5; #上
                   }
                 }
                 require './battlecm/idou.pl';
                 &IDOU(2);
               }
             }else{
#攻撃しても反撃受けない
               if($SOL_AT[$ksub1_ex] > $SOL_AT[$asub1_ex]){
                 if($SOL_AT[$ksub1_ex] >= $mzsa && $mzsa > $SOL_AT[$asub1_ex]){
#自分リーチ内かつ敵リーチ外に敵→攻撃
                   &this_TIMELESS; #行動待機時間
                     NEW_ENGO_SYORI($kid, $in{eid}); #掩護処理 ./lib/skl_lib.pl
                     &TOWN_DATA_OPEN("$kiti");
                   require "./battlecm/battle.pl";
                   &BATTLE;
                 }elsif($SOL_AT[$ksub1_ex] < $mzsa){
#自リーチ外に敵→近づく
                   $in{'zahyou'} = 0;
                   if(abs($kx-$ax) > abs($ky-$ay)){
                     if($kx-$ax < 0){
                       $in{'zahyou'} = 3; #右
                     }elsif($kx-$ax > 0){
                       $in{'zahyou'} = 2; #左
                     }
                   }elsif(abs($kx-$ax) < abs($ky-$ay)){
                     if($ky-$ay < 0){
                       $in{'zahyou'} = 4; #下
                     }elsif($ky-$ay > 0){
                       $in{'zahyou'} = 5; #上
                     }
                   }else{
                     if($kx-$ax < 0){
                       $in{'zahyou'} = 3; #右
                     }elsif($kx-$ax > 0){
                       $in{'zahyou'} = 2; #左
                     }elsif($ky-$ay < 0){
                       $in{'zahyou'} = 4; #下
                     }else{
                       $in{'zahyou'} = 5; #上
                     }
                   }
                   require './battlecm/idou.pl';
                   &IDOU(2);
                 }else{
#遠ざかれるだけ遠ざかる
                   $in{'zahyou'} = 0;
                   if(abs($kx-$ax) > abs($ky-$ay)){
                     if($kx-$ax < 0){
                       $in{'zahyou'} = 2; #左
                     }elsif($kx-$ax > 0){
                       $in{'zahyou'} = 3; #右
                     }
                   }elsif(abs($kx-$ax) < abs($ky-$ay)){
                     if($ky-$ay < 0){
                       $in{'zahyou'} = 5; #上
                     }elsif($ky-$ay > 0){
                       $in{'zahyou'} = 4; #下
                     }
                   }else{
                     if($kx-$ax < 0){
                       $in{'zahyou'} = 2; #左
                     }elsif($kx-$ax > 0){
                       $in{'zahyou'} = 3; #右
                     }elsif($ky-$ay < 0){
                       $in{'zahyou'} = 5; #上
                     }else{
                       $in{'zahyou'} = 4; #下
                     }
                   }
                   require './battlecm/idou.pl';
                   &IDOU(2);
                 }
               }else{
#攻撃できる範囲にいる→攻撃
                 if($SOL_AT[$ksub1_ex] <= $mzsa){
                   &this_TIMELESS; #行動待機時間
                     NEW_ENGO_SYORI($kid, $in{eid}); #掩護処理 ./lib/skl_lib.pl
                     &TOWN_DATA_OPEN("$kiti");
                   require "./battlecm/battle.pl";
                   &BATTLE;
#近づけるだけ近づく
                 }else{
                   $in{'zahyou'} = 0;
                   if(abs($kx-$ax) > abs($ky-$ay)){
                     if($kx-$ax < 0){
                       $in{'zahyou'} = 3; #右
                     }elsif($kx-$ax > 0){
                       $in{'zahyou'} = 2; #左
                     }
                   }elsif(abs($kx-$ax) < abs($ky-$ay)){
                     if($ky-$ay < 0){
                       $in{'zahyou'} = 4; #下
                     }elsif($ky-$ay > 0){
                       $in{'zahyou'} = 5; #上
                     }
                   }else{
                     if($kx-$ax < 0){
                       $in{'zahyou'} = 3; #右
                     }elsif($kx-$ax > 0){
                       $in{'zahyou'} = 2; #左
                     }elsif($ky-$ay < 0){
                       $in{'zahyou'} = 4; #下
                     }else{
                       $in{'zahyou'} = 5; #上
                     }
                   }
                   require './battlecm/idou.pl';
                   &IDOU(2);
                 }
               }

             }
           }

         }else{  #実行処理追加...

         }

       }else{
         if($tettai){
#兵士いない時撤退 <-lib/skl_lib.pl
           &TETTAI("BM自動モード中に兵士が全滅したので撤退しました。");
           &CHARA_MAIN_INPUT;
         }else{
           next;
         }
       }

       $i++;
     }

     $auto_list_model->save;


#元のサブルーチンに戻す
     *HEADER = sub{ &$origin; };
     &HEADER;
     print"$mess";
     &FOOTER;

     exit;
}


sub this_TIMELESS{
  if($idate < $kkoutime){
    my $nokori = $kkoutime-$idate;
    &ERR("あと $nokori秒 行動できません。");
  }
}
