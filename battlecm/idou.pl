#_/_/_/_/_/_/_/_/_/_/#
#      移動      #
#_/_/_/_/_/_/_/_/_/_/#

use Jikkoku::Model::Chara;

sub change_move_cost {
  my ($chara, $x, $y) = @_;

  my $origin_cost = $CAN_MOVE[ $BM_TIKEI[$y][$x] ];
  # skl_lib.pl
  KINTOUN($x, $y);
  skl_lib_adjust_state_move_cost($x, $y, $chara, time);
  $kidoup -= $CAN_MOVE[$BM_TIKEI[$y][$x]];
  if($kidoup < 0){
    &ERR("移動ポイントが足りません。");
  }
  $CAN_MOVE[ $BM_TIKEI[$y][$x] ] = $origin_cost;
}

sub IDOU {

  my $nodisplay = shift; #0:battlecmから 1:status.newbm,i-newbm.cgiから 2:auto_exe.cgiから

  # 時間制限 19-25時
  &TIME_RIMIT;

  &CHARA_MAIN_OPEN;
  &TOWN_DATA_OPEN;

  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara       = $chara_model->get($kid);

  ($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
  ($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
  ($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);
  ($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);

  if(!$ksyuppei){
    &ERR("出撃していません。");
  }elsif($ksol <= 0){
    $ksol = 0;
    &TETTAI();	#>lib/skl_lib.pl
      &CHARA_MAIN_INPUT;
    &ERR("兵士がいません。");
  }else{

#水軍使用時
    if($SOL_ZOKSEI[$ksub1_ex] eq "水"){
      do './ini_file/suigun.ini';
    }

#移動スキル表示処理#
    if($nodisplay == 0){	#BM系,auto_exe.cgiから呼び出していない時
      &IDOUSKL_HYOJI;
    }

#武将データ全open
    my @page = ();
    my @ICL_DATA = ();
    opendir(dirlist,"./charalog/main");
    while($file = readdir(dirlist)){
      if($file =~ /\.cgi/i){
        if(!open(page,"./charalog/main/$file")){
          &ERR2("ファイルオープンエラー！");
        }
        @page = <page>;
        close(page);
        push(@ICL_DATA,"@page<br>");
      }
    }
    closedir(dirlist);

#バトルマップ読み込み
    do "./log_file/map_hash/$kiti.pl";

    $idate = time();
    $tekiiru = 0;
          
#左に移動
    if($in{'zahyou'} eq "2"){
      $ikx = $kx - 1;

      if($ikx < 0){
        &ERR("その座標は存在しません。");
      }else{
        foreach(@ICL_DATA){
          ($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
          ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
          ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);

          if($kiti eq $eiti){
            if($kcon ne $econ){
              if($ikx == $ex && $ky == $ey){
                $in{'eid'} = "$eid";
                $tekiiru = 1;
                last;
              }
            }
          }
        }

        if($BM_TIKEI[$ky][$ikx] eq "" || ( ($BM_TIKEI[$ky][$ikx] == 18 || $BM_TIKEI[$ky][$ikx] == 22) && $town_cou[$kiti] ne $kcon) ) {
          &ERR("その座標には移動できません。");
        }elsif($tekiiru){
          &ERR("その座標には敵がいるので移動できません。");
        }else{
          change_move_cost($chara, $ikx, $ky);
          $mkx = $kx+1;
          $mky = $ky+1;
          $kx = $ikx;
          $lkx = $kx+1;
          $lky = $ky+1;
          $mess = "座標($mkx,$mky)から($lkx,$lky) に移動しました。移動P $kidoup / $SOL_MOVE[$ksub1_ex]";
          if($BM_TIKEI[$ky][$ikx] eq "6"){
            $dkdie = int($ksol/20);
            $ksol -= $dkdie;
            &K_LOG("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
            &K_LOG2("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
          }
        }
      }

#右に移動
    }elsif($in{'zahyou'} eq "3"){
      $ikx = $kx + 1;

      if($ikx >= $BM_X){
        &ERR("その座標は存在しません。");
      }else{
        foreach(@ICL_DATA){
          ($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
          ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
          ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);

          if($kiti eq $eiti){
            if($kcon ne $econ){
              if($ikx == $ex && $ky == $ey){
                $in{'eid'} = "$eid";
                $tekiiru = 1;
                last;
              }
            }
          }
        }

        if($BM_TIKEI[$ky][$ikx] eq "" || ( ($BM_TIKEI[$ky][$ikx] == 18 || $BM_TIKEI[$ky][$ikx] == 22 ) && $town_cou[$kiti] ne $kcon)){
          &ERR("その座標には移動できません。");
        }elsif($tekiiru){
          &ERR("その座標には敵がいるので移動できません。");
        }else{
          change_move_cost($chara, $ikx, $ky);
          $mkx = $kx+1;
          $mky = $ky+1;
          $kx = $ikx;
          $lkx = $kx+1;
          $lky = $ky+1;
          $mess = "座標($mkx,$mky)から($lkx,$lky) に移動しました。移動P $kidoup / $SOL_MOVE[$ksub1_ex]";
          if($BM_TIKEI[$ky][$ikx] eq "6"){
            $dkdie = int($ksol/20);
            $ksol -= $dkdie;
            &K_LOG("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
            &K_LOG2("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
          }
        }
      }

#下に移動
    }elsif($in{'zahyou'} eq "4"){
      $iky = $ky + 1;

      if($iky >= $BM_Y){
        &ERR("その座標は存在しません。");
      }else{
        foreach(@ICL_DATA){
          ($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
          ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
          ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);

          if($kiti eq $eiti){
            if($kcon ne $econ){
              if($kx == $ex && $iky == $ey){
                $in{'eid'} = "$eid";
                $tekiiru = 1;
                last;
              }
            }
          }
        }

        if($BM_TIKEI[$iky][$kx] eq "" || ( ($BM_TIKEI[$iky][$kx] == 18 || $BM_TIKEI[$iky][$kx] == 22) && $town_cou[$kiti] ne $kcon)){
          &ERR("その座標には移動できません。");
        }elsif($tekiiru){
          &ERR("その座標には敵がいるので移動できません。");
        }else{
          change_move_cost($chara, $kx, $iky);
          $mkx = $kx+1;
          $mky = $ky+1;
          $ky = $iky;
          $lkx = $kx+1;
          $lky = $ky+1;
          $mess = "座標($mkx,$mky)から($lkx,$lky) に移動しました。移動P $kidoup / $SOL_MOVE[$ksub1_ex]";
          if($BM_TIKEI[$iky][$kx] eq "6"){
            $dkdie = int($ksol/20);
            $ksol -= $dkdie;
            &K_LOG("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
            &K_LOG2("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
          }
        }
      }

#上に移動
    }elsif($in{'zahyou'} eq "5"){
      $iky = $ky - 1;

      if($iky < 0){
        &ERR("その座標は存在しません。");
      }else{
        foreach(@ICL_DATA){
          ($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
          ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
          ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);

          if($kiti eq $eiti){
            if($kcon ne $econ){
              if($kx == $ex && $iky == $ey){
                $in{'eid'} = "$eid";
                $tekiiru = 1;
                last;
              }
            }
          }
        }

        if($BM_TIKEI[$iky][$kx] eq "" || ( ($BM_TIKEI[$iky][$kx] == 18 || $BM_TIKEI[$iky][$kx] == 22) && $town_cou[$kiti] ne $kcon)){
          &ERR("その座標には移動できません。");
        }elsif($tekiiru){
          &ERR("その座標には敵がいるので移動できません。");
        }else{
          change_move_cost($chara, $kx, $iky);
          $mkx = $kx+1;
          $mky = $ky+1;
          $ky = $iky;
          $lkx = $kx+1;
          $lky = $ky+1;
          $mess = "座標($mkx,$mky)から($lkx,$lky) に移動しました。移動P $kidoup / $SOL_MOVE[$ksub1_ex]";
          if($BM_TIKEI[$iky][$kx] eq "6"){
            $dkdie = int($ksol/20);
            $ksol -= $dkdie;
            &K_LOG("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
            &K_LOG2("【<font color=purple>地形効果</font>】地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$dkdie</font>人");
          }
        }
      }
    }else{
      &ERR("フォームに不正な値が含まれています。");
    }

    if($ksol <= 0){
      $ksol = 0;
      &TETTAI();	#>lib/skl_lib.pl
    }

    $ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
    &CHARA_MAIN_INPUT;

  }

#status.cgiから呼び出されたとき
  if($nodisplay == 1){
    return;
  }

  &HEADER;

print <<"EOM";
  <CENTER><hr size=0><h2>$mess</h2><p>
    <form action="$BACK" method="post">
    <input type=hidden name=id value=$kid>
    <input type=hidden name=pass value=$kpass>
    <input type=hidden name=mode value=STATUS>
    <input type=submit value="OK">
    </form>
    </CENTER>
EOM
    &FOOTER;

}

1;
