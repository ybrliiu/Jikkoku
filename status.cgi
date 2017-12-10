#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

use Time::HiRes;
my $start_time;
BEGIN { $start_time = Time::HiRes::time; }

require './ini_file/index.ini';
require './ini_file/com_list.ini';
require './lib/skl_lib.pl';
require 'suport.pl';

use lib './lib', './extlib';
use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use Jikkoku::Class::Town;
my $town_class = 'Jikkoku::Class::Town';
use Jikkoku::Model::Chara;
use Jikkoku::Model::Chara::Command;
use Jikkoku::Model::Town;
use Jikkoku::Model::Country;
use Jikkoku::Model::Unit;
use Jikkoku::Model::GameDate;
use Jikkoku::Model::StopUpdate;
use Jikkoku::Model::MapLog;
use Jikkoku::Model::LoginList;
use Jikkoku::Model::Diplomacy;
use Jikkoku::Model::BattleMap;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Model::ExtensiveStateRecord;

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($in{'MOVE'}) { require './battlecm/idou.pl';&IDOU(1);}  #BM移動時
if($mode eq 'STATUS') { &STATUS; }
elsif($mode eq 'OSIRASE') { &OSRS("$OSIRASEA"); }
else { &ERR("不正なアクセスです。"); }

sub controller {
  my ($id, $pass) = ($in{id}, $in{pass});

  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = $chara_model->get_with_option($id)->match(
    Some => sub { $_ },
    None => sub { ERR2("ID, もしくはパスワードが間違っています。") },
  );
  ERR2("ID, もしくはパスワードが間違っています。") unless $chara->check_pass($pass);

  my $cookie = $in{cookie};
  SET_COOKIE() if $cookie eq 'yes';

  Jikkoku::Class::Chara::ExtChara->new(chara => $chara, record_model => $ext_state_rec_model);
}

sub STATUS {

  my $chara = controller();

  if (!$chara->is_authed) {
    ERR2("認証が済んでいません。登録したメールアドレスに認証IDが添付されているので登録してください。");
  }

  # IP記録
  if($ENV{'HTTP_REFERER'} =~ /index.cgi/){
    $chara->last_login_host( $ENV{'REMOTE_HOST'} // '' );
    $chara->save;
  }

  my $chara_model     = Jikkoku::Model::Chara->new;
  my $country_model   = Jikkoku::Model::Country->new;
  my $country         = $country_model->get_with_option( $chara->country_id )->get_or_else( $country_model->neutral );
  my $diplomacy_model = Jikkoku::Model::Diplomacy->new;
  my $diplomacy_list  = $diplomacy_model->get_by_country_id( $country->id );
  my $town_model      = Jikkoku::Model::Town->new;
  my $town            = $town_model->get( $chara->town_id );
  my $game_date_model = Jikkoku::Model::GameDate->new;
  my $game_date       = $game_date_model->get;
  my $map_log         = Jikkoku::Model::MapLog->new->get(11);
  my $town_battle_map = Jikkoku::Model::BattleMap->new->get( $chara->town_id );
  my $ext_state_rec_model = Jikkoku::Model::ExtensiveStateRecord->new;

  my ($total_salary_money, $total_salary_rice) = $country->total_salary( $town_model->get_all );

  # 自国滅亡時
  if ($country->id == 0 && $chara->country_id != 0) {
    $chara->country_id(0);
    $chara->save;
    OSRS("あなたの所属国は滅亡しました。");
  }

  my $unit_model = Jikkoku::Model::Unit->new;
  my $unit = $unit_model->get_with_option( $chara->id )->get_or_else( $unit_model->neutral );
  if ($unit->is_leader) {
    $add_com = "<option value=28>集合";
  }

  my $login_list_model = Jikkoku::Model::LoginList->new;
  $login_list_model->add( $chara );
  my $login_list = $login_list_model->get_by_country_id( $chara->country_id );
  $login_list_model->save;

# regacy #
  &CHARA_MAIN_OPEN;
  &TOWN_DATA_OPEN( $chara->town_id );
  &COUNTRY_DATA_OPEN( $chara->country_id );

  ($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
  ($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);
  ($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
  ($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);
  ($ksingeki_time,$kanother) = split(/,/,$kskldata);

  open(IN,"$LOG_DIR/date_count.cgi") or &ERR('ファイルを開けませんでした。');
  @MONTH_DATA = <IN>;
  close(IN);
  ($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);

  &TIME_DATA;

# done #

  my $command_game_date = Jikkoku::Class::GameDate->new({
    elapsed_year => $game_date->elapsed_year,
    month        => $game_date->month,
    time         => $game_date->time,
  });

  my $next_time = int( ($kdate + $TIME_REMAKE - $tt) / 60 );
  $next_time    = 0 if $next_time < 0;
  my $next_sec  = ($kdate + $TIME_REMAKE - $tt) - ($next_time * 60);
  $next_sec     = 0 if $next_sec < 0;
  
  my $not_update_yet = $game_date->time > $chara->update_time or ($next_time == 0 and $next_sec == 0);
  # コマンドを更新していない時か、更新開始前の時
  if ( $command_game_date->month != 0 and $not_update_yet ) {
    $command_game_date--;
    $comlistplus = 1;
  }

  my $com_list = "";
  my $next_time_2 = $chara->update_time;
  my $chara_command    = Jikkoku::Model::Chara::Command->new->get($chara->id);
  my $command_list     = $chara_command->get_all;
  my $update_end_until = Jikkoku::Model::StopUpdate->update_end_until($comlistplus);

  for my $i (0 .. $chara_command->MAX - 1) {

      my $no = $i + 1;
      $next_time_2 += $TIME_REMAKE;
      #更新停止時処理
      if ($i != 0 && $i % 18 == $update_end_until) {
        $next_time_2 += 18 * 3600;
      }
      my ($acsec,$acmin,$achour,$acday,$acmon,$acyear,$acwday,$acyday) = localtime($next_time_2);

      $command_game_date++;

      my $command_description = $command_list->[$i]->id ? $command_list->[$i]->description : ' - ';
      $com_list .= qq{
        <tr id="$i">
          <th><input type="checkbox" value="$i" name="no">$no</th>
          <th>【@{[ $command_game_date->year ]}年@{[ $command_game_date->month ]}月】</th>
          <th>　$acday日$achour時$acmin分$acsec秒　</th>
          <th> $command_description </th>
        </tr>
      };

  }

  opendir(dirlist,"./charalog/main");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      if(!open(page,"./charalog/main/$file")){
        &ERR2("ファイルオープンエラー！");
      }
      @page = <page>;
      close(page);
      push(@CL_DATA,"@page<br>");
    }
  }
  closedir(dirlist);

  #バトルマップ読み込み
  require "./log_file/map_hash/$kpos.pl";

# ここまで置換
#
#
#
#
#


  $del_out = $DEL_TURN - $ksub2;

  $dilect_mes = "";$m_hit=0;$i=1;$h=1;$j=1;$k=1;
  open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
  while (<IN>){
    my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon,$hunit) = split(/<>/);
    if($MES_MAN < $i && $MES_ALL < $h && $MES_COU < $j && $MES_UNI < $k) { last; }
    if(111 eq "$pid" && $kpos eq $hpos){
      if($MES_ALL < $h ) { next; }

      if($prf_mes !~ /(\".$hid\")/){
        $prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$hid&send=1'></iframe></td></tr></table></div>\"));}num++;});
";
      } 
      $all_mes .= "<TR><TD style=\"width:100%;\"><p style=\"color:#FFFFFF\"><b><span class=$hid\>$hname</span>\@$town_name[$hpos]から</b><BR>「<b>$hmessage</b>」<BR>$htime</p></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>\n";
      $h++;

    } elsif ($kcon eq "$pid") {
      if($MES_COU < $j ) { next; }

      if($prf_mes !~ /(\".$hid\")/){
        $prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$hid&send=1'></iframe></td></tr></table></div>\"));}num++;});
";
      }
      $cou_mes .= "<TR><TD style=\"width:100%;\"><b>  <span class=\"$hid\">$hname</span><p style=\"color:#FFCC33;\">\@$town_name[$hpos]から$pnameへ</p></b><BR><span style=\"color:#FFFFFF;\">  「<b>$hmessage</b>」<BR>$htime</span></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>";
      $j++;

    } elsif ($kid eq "$pid") {
      if ($MES_MAN < $i ) { next; }

      if ($prf_mes !~ /(\".$hid\")/) {
        $prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$hid&send=1'></iframe></td></tr></table></div>\"));}num++;});
";
      }
      $add_mes = "<b><p style=\"color:orange;\"><span class=\"$hid\">$hname</span>\@$town_name[$hpos]から$pnameへ</p></b> <BR>";
      $man_mes .= "<TR><TD style=\"width:100%;\">$add_mes<p style=\"color:#FFFFFF;\">「<b>$hmessage</b>」<BR>$htime</p></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>\n";
      $dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
      $i++;

    } elsif (333 eq "$pid" && $hunit eq $unit->id && $hcon eq $chara->country_id) {
      if ($MES_UNI < $k ) { next; }
      if ($prf_mes !~ /(\".$hid\")/) {
        $prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$hid&send=1'></iframe></td></tr></table></div>\"));}num++;});
";
      }
      $unit_mes .= "<TR><TD style=\"width:100%;\"><p style=\"color:orange;\"><b><span class=$hid\>$hname</span>\@$town_name[$hpos]から$pnameへ</b></p><BR><span style=\"color:#FFFFFF;\">  「<b>$hmessage</b>」<BR>$htime</span></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>";
      $k++;
    } elsif($kid eq "$hid") {
      if($MES_MAN < $i ) { next; }
      $man_mes .= "<TR><TD style=\"width:100%;\"><span style=\"color:skyblue;\"><b>$knameから$pnameへ</b></span><BR><span style=\"color:#FFFFFF;\">  「<b>$hmessage</b>」<BR>$htime</span></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>";
      $i++;
    }
  }
  close(IN);

  $m_hit=0;$i=1;$h=1;$j=1;$k=1;
  open(IN,"$MESSAGE_LIST2") or &ERR('ファイルを開けませんでした。');
  while (<IN>){
    my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon) = split(/<>/);

    if ($MES_MAN < $i) { last; }
    if ($kid eq "$pid") {

      if($prf_mes !~ /(\".$hid\")/){
        $prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$hid&send=1'></iframe></td></tr></table></div>\"));}num++;});
      ";
      }

      $add_mes="";
      $add_sel="";
      $add_form1="";
      $add_form2="";
  
      if ($htime eq "9999") {
        $add_mes = "<p style=\"color:skyblue;\"><B><span class=$hid\>$hname</span>が$cou_name[$hcon]への仕官を勧めています。<BR></B></p>";
        $add_sel = "<BR><input type=radio name=sel value=1>承諾する<input type=radio name=sel value=0>断る<input type=submit id=input  value=\"返事\">";
        $add_form1="<form action=\"./mydata.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=hcon value=$hcon><input type=hidden name=hid value=$hid><input type=hidden name=hpos value=$hpos><input type=hidden name=mode value=COU_CHANGE>";
        $add_form2="</form>";
      }else{
        $add_mes = "<B><p style=\"color:skyblue;\"><span class=$hid\>$hname</span>から$pnameへ</p><BR></B>";
      }
  
      $man_mes2 .= "$add_form1<TR><TD style=\"width:100%;\">$add_mes<p style=\"color:#FFFFFF;\">「<b>$hmessage</b>」$add_sel</p></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>$add_form2\n";
      $dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
      $i++;

    } elsif ($kid eq "$hid") {
      $man_mes2 .= "<TR><TD style=\"width:100%;\"><span style=\"color:skyblue;\"><b>$knameさんから$pnameへ</b></span><BR><span style=\"color:#FFFFFF;\">  「<b>$hmessage</b>」<BR>$htime</span></TD><TD><img src=\"$IMG/$hchara.gif\"></TD></TR>";
      $i++;
    }

  }
  close(IN);


  if($xking eq $kid || $xgunshi eq $kid || $xxsub1 eq $kid){
    $king_com = "<form action=\"./mydata.cgi\" method=\"post\"><TR><TH colspan=6><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM><input type=submit id=input  value=\"指令部\"></TH></TR></form>";
    foreach(@COU_DATA){
      ($xvcid,$xvname)=split(/<>/);
      $dilect_mes .= "<option value=\"$xvcid\">$xvnameへ";
    }
    $dilect_mes .= "<option value=\"0\">無所属へ";
  }
  if (!$country->is_headquarters_exist && $country->name ne '無所属') {
    $kari_gunshi = '<form action="./mydata.cgi" method="post" onSubmit="return check(\'臨時で軍師になる場合は事前に仲間と相談してからにしましょう！\n\n本当に臨時で軍師になってもよろしいですか？\')"><TR><TH colspan=6><input type=hidden name=id value='.$kid.'><input type=hidden name=pass value='.$kpass.'><input type=hidden name=mode value=KARI_GUNSHI><input type=submit value="上層部が誰もいないので臨時で軍師になる"></TH></TR></form>';
  }


  if($xmark < $BATTLE_STOP){
    $xc = $BATTLE_STOP - $xmark;
    $xaddmes = "<BR>戦闘解除まで残り <span style=\"color:red;\">$xc</span> ターン";
  }

#階級
  $klank = int($kclass / $LANK);
  if($klank > 100){
    $klank=100;
  }

#城耐久計算
  $taikyu = $myear*125;
  if($taikyu<1000){
    $taikyu = 1000;
  }elsif($taikyu>9999){
    $taikyu = 9999;
  }

#都市データ棒グラフ
  $num_bar1 = int($znum/$zsub2*100);
  $num_bar2 = 100 - $num_bar1;
  $pri_bar1 = int($zpri/100*100);
  $pri_bar2 = 100 - $pri_bar1;
  $nou_bar1 = int($znou/$znou_max*100);
  $nou_bar2 = 100 - $nou_bar1;
  $syo_bar1 = int($zsyo/$zsyo_max*100);
  $syo_bar2 = 100 - $syo_bar1;
  $tec_bar1 = int($zsub1/9999*100);
  $tec_bar2 = 100 - $tec_bar1;
  $shiro_bar1 = int($zshiro/$zshiro_max*100);
  $shiro_bar2 = 100 - $shiro_bar1;
  $Tshiro_bar1 = int(($zdef_att/$taikyu)*100);
  $Tshiro_bar2 = 100 - $Tshiro_bar1;

#城壁の兵種
  if(($zshiro >= 8000)&&($zsub1 >= 8000)&&($znum >= 80000)&&($znou >= 8000)&&($zsyo >= 8000)&&($zdef_att >= 8000)){$syogohei=4;}
  elsif(($zshiro >= 4000)&&($zsub1 >= 4000)&&($znum >= 40000)&&($znou >= 4000)&&($zsyo >= 4000)&&($zdef_att >= 4000)){$syogohei=4;}
  elsif(($zshiro >= 1000)&&($znum >= 10000)&&($znou >= 1000)&&($zsyo >= 1000)&&($zsub1 >= 1000)&&($zdef_att >= 1000)){$syogohei=8;}
  elsif(($zshiro > 500)&&($znum > 5000)&&($znou > 500)&&($zsyo > 500)&&($zsub1 > 500)&&($zdef_att > 500)){
  $syogohei=1;
  }else{$syogohei="0";}



#役職補正、表示（自分）#

  $katt_add2 = "";
  $katt_def2 = "";
  if($xking eq "$kid"){
    $rank_mes = "【君主】";
    $katt_add2 = "（役職補正で更に+10）";
    $katt_def2 = "（役職補正で更に+10）";
  }elsif($xgunshi eq "$kid"){
    $rank_mes = "【軍師】";
    $katt_add2 = "（役職補正で更に+10）";
  }elsif($xdai eq "$kid"){
    $rank_mes = "【大将軍】";
    $katt_add2 = "（役職補正で更に+20）";
  }elsif($xuma eq "$kid"){
    $rank_mes = "【騎馬将軍】";
    $katt_add2 = "（役職補正で更に+15）";
  }elsif($xgoei eq "$kid"){
    $rank_mes = "【護衛将軍】";
    $katt_def2 = "（役職補正で更に+10）";
  }elsif($xyumi eq "$kid"){
    $rank_mes = "【弓将軍】";
    $katt_add2 = "（役職補正で更に+10）";
  }elsif($xhei eq "$kid"){
    $rank_mes = "【将軍】";
    $katt_add2 = "（役職補正で更に+10）";
  }elsif($xxsub1 eq "$kid"){
    $rank_mes = "【宰相】";
  }



#自分武器相性#

      if($SOL_ZOKSEI[$ksub1_ex] eq "$kazoku"){
        $kai = int($kaai);
        $kai2 = int($kaai / 2);
        if($SOL_ZOKSEI[$ksub1_ex] eq "機"){
          $kaikmes = "（武器相性で更に+$kai）";
        }elsif($SOL_ZOKSEI[$ksub1_ex] eq "水"){
          $kai2 = int($kaai * 2);
          $kaikmes = "（武器相性で更に+$kai〜+$kai2）";
        }else{
          $kaikmes = "（武器相性で更に+$kai2〜+$kai）";
        }
      }elsif(($kazoku eq "騎")&&($SOL_ZOKSEI[$ksub1_ex] eq "弓騎")){
        $kai = int($kaai);
        $kai2 = int($kaai / 2);
        $kaikmes = "（武器相性で更に+$kai2〜+$kai）";
      }elsif(($kazoku eq "弓")&&($SOL_ZOKSEI[$ksub1_ex] eq "弓騎")){
        $kai = int($kaai);
        $kai2 = int($kaai / 2);
        $kaikmes = "（武器相性で更に+$kai2〜+$kai）";
      }else{
        $kai2 = 0;
        if($kazoku ne  "" && $kazoku ne "無"){
          if($kazoku eq "水"){
            $kai = $kaai;
          }else{
            $kai = int($kaai / 2);
          }
          $kaikmes = "（武器相性が有利だと+$kai）";
          if($kazoku eq "機"){
            $kaikmes = "";
          }
        }else{
          $kai = 0;
          $kaikmes = "";
        }
      }


#水軍使用時
  if($SOL_ZOKSEI[$ksub1_ex] eq "水"){
  require './ini_file/suigun.ini';
  }


#兵種能力値計算
  require './lib/hs_keisan.pl';
  ($katt_add,$katt_def) = &HS_KEISAN(1,0,$ksub1_ex,$kstr,$kint,$klea,$kcha,$karm,$kbook,$kmes);

  if($ksub1_ex eq "12" || $ksub1_ex eq "28" || $ksub1_ex eq "29" || $ksub1_ex eq "68"){
  ($katt_add3,$katt_def3) = &HS_KEISAN(1,1,$ksub1_ex,$kstr,$kint,$klea,$kcha,$karm,$kbook,$kmes);
  $katt_add3 -= $katt_add;
  $katt_def3 -= $katt_def;
  $katt_add3 = "（城壁戦+$katt_add3）";
  $katt_def3 = "（城壁戦+$katt_def3）";
  }
  $kkou = int($kstr + $karm + $katt_add);
  $kbou = int($katt_def + $kmes + ($kgat / 2));


#侵攻防衛判定#
  my $ksinko=0;
  if($kiti =~ /-/){
    @kitilist=split(/-/,$kiti);
    $kiti_1=$kitilist[0];
    $kiti_2=$kitilist[1];
    if($town_cou[$kiti_1] != $kcon || $town_cou[$kiti_2] != $kcon){
    $ksinkomes="【侵攻側】";
    $ksinko = 1;
    }else{
    $ksinkomes="【防衛側】";
    $ksinko = 0;
    }
  }else{
    if($town_cou[$kiti] == $kcon){
    $ksinkomes="【防衛側】";
    $ksinko = 0;
    }else{
    $ksinkomes="【侵攻側】";
    $ksinko = 1;
    }
  }


#階級制限コマンド
  if($kclass>=5000){
    $add_com7 = "<option value=$NOUKAKU>農地開拓(50G)";
    $add_com8 = "<option value=$SYOKAKU>市場建設(50G)";
    $add_com9 = "<option value=$SHIROKAKU>城壁拡張(50G)";
    $add_com10 = "<option value=$NYUSYOKU>開拓($kcha\R)";
    $add_com17 = "<option value=$TYOUSA>調査(500G)";
  }

  if($kclass>=6000){
    $add_com11 = "<option value=$MOUKUNREN>兵士猛訓練(50G)";
  }

  if($kclass>=10000){
    $add_com2 = "<option value=$NOUEX>農地破壊(200G)";
    $add_com3 = "<option value=$SYOUEX>市場破壊(200G)";
    $add_com4 = "<option value=$TECEX>技術衰退(200G)";
    $add_com5 = "<option value=$STEX>城壁劣化(200G)";
    $add_com6 = "<option value=$PRIEX>流言(200G)";
    $add_com14 = "<option value=$TEI>偵察(500G)";
  }

  if($kclass>=15000){
    $add_com15 = "<option value=$KAITAKU>入植(500G&500R)";
  }

  if($kclass>=25000){
    $add_com12 = "<option value=$TKUNREN>兵士特訓(100G)";
  }

  if($kclass>=50000){
    $add_com13 = "<option value=$MTKUNREN>兵士猛特訓(200G)";
  }

  if($ksyuppei){
    $add_com16 = "<option value=$TAIKYAKU>退却";
  }

#都市データグラフ色変更
  $uhuhu = $zshiro / $zshiro_max;
  if($uhuhu <  0.2){$yshiro = "#FFD733";}else{$yshiro = "#5555FF";}
  $uhuhu2 = $znou / $znou_max;
  if($uhuhu2 <  0.2){$ynou = "#FFD733";}else{$ynou = "#5555FF";}
  $uhuhu3 = $zsyo / $zsyo_max;
  if($uhuhu3 <  0.2){$ysyo = "#FFD733";}else{$ysyo = "#5555FF";}
  $uhuhu4 = $zdef_att / $taikyu;
  if($uhuhu4 <  0.2){$yTshiro = "#FFD733";}else{$yTshiro = "#5555FF";}
  $uhuhu5 = $zsub1 / 9999;
  if($uhuhu5 <  0.2){$ytec = "#FFD733";}else{$ytec = "#5555FF";}
  $uhuhu6 = $znum / $zsub2;
  if($uhuhu6 <  0.2){$ynum = "#FFD733";}else{$ynum = "#5555FF";}
  $uhuhu7 = $zpri / 100;
  if($uhuhu7 <  0.2){$ypri = "#FFD733";}else{$ypri = "#5555FF";}

#初心者の時の表示(チュートリアル)#
  if($in{'hajime'} eq "yes"){
  $syosin_js = "\$(\"div:last\").append(\"<div id=ballon style='background-color:rgba(202,202,202,0.7);box-shadow:0 0 0 600px rgba(0,0,0,0.7);width:800px;height:400px;margin:-200px 0 0 -400px;'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100%;height:100%;'><iframe src='./syosin_1.html'></iframe></td></tr></table></div>\");";
  }

#裏武器屋表示#
  $ihihi = int(rand(100));
  if($ihihi eq "1"){
  $ahaha = "<form action=\"./modoru.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=image src=image/img/3578.png></form>";
  }

#移動スキル表示処理 lib/skl_lib.pl#
  &IDOUSKL_HYOJI;

#大きい文字サイズ
  $kbig_char = $ksettei+3;

#必要なcss,jsファイルを読み込むためのフラグ
  $status_css = 1;
  $b_js = 1;
  $zukei = 1;
  &HEADER;
print <<"EOM";

<script src="public/js/jquery-3.1.0.min.js"></script>
<script src="public/js/sangoku.js"></script>
<script src="public/js/sangoku/base.js"></script>
<script src="public/js/sangoku/player/mypage/controll-command.js"></script>


<!-- 右下のボタン -->
<div id="zukei">
<form action="./status.cgi" method="post"><input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS>
<button id="botan" type="submit"><div id="reload"></div></button>
<a href="#letter_"><div id="botan"><div id="letter"></div></div></a>
<a href="#siji"><div id="botan"><div id="com_in"></div></div></a>
<a href="#top"><div id="botan"><div id="up_arrow"></div></div></a>
<a href="#sita"><div id="botan"><div id="down_arrow"></div></div></a>
</form>
</div>


<div id="sirei" style="background-color:$ELE_BG[$cou_ele[$zcon]];"><span style="color:$ELE_C[$cou_ele[$zcon]];font-size:$kbig_char\pt;"><strong>$xname指令:</strong>$xmes</span></div>


<div style="width:100%;overflow:hidden;">

<TABLE class="swindow" id="map" style="background-color:@{[ $game_date->map_bg_color ]};"><TBODY>
<TR><TH colspan="11" style="background-color:#442200;" class="inwindow"><span style="color:#ffffff;">- 大陸地図 - (@{[ $game_date->date($F_YEAR) ]})</span></TH></TR>
<TR><TD width="20" style="background-color:$TD_C2;">-</TD>
EOM

#隠し都市
  if($kcon eq "0" || $kpos eq "16"){
  $clear = 12;
  }else{
  $clear = 10;
  }

    for($i=1;$i<11;$i++){
    print "<TD bgcolor=$TD_C1>$i</TD>";
  }
  print "</TR>";
     for($i=0;$i<$clear;$i++){
    $n = $i+1;
    print "<TR><TD bgcolor=$TD_C3>$n</td>";
    for($j=0;$j<10;$j++){
        $m_hit=0;$zx=0;
        foreach(@TOWN_DATA){
          ($zzname,$zzcon,$zznum,$zznou,$zzsyo,$zzshiro,$zznou_max,$zzsyo_max,$zzshiro_max,$zzpri,$zzx,$zzy,$zzsouba,$zzdef_att,$zzsub1)=split(/<>/);
          if("$zzx" eq "$j" && "$zzy" eq "$i"){$m_hit=1;last;}
          $zx++;
        }
        $col="";
        if($m_hit){
          if($zx eq $kpos){
            $col = "$ELE_C[$cou_ele[$zzcon]]";
          }else{
            $col = "$ELE_BG[$cou_ele[$zzcon]]";
          }

        $white = "#000000";
        if($col eq "#000000"){
        $white = "white";
        }

        if(($zzshiro > 7000)&&($zznum > 140000)&&($zznou > 7000)&&($zzsyo > 7000)&&($zzsub1 > 7000)&&($zzdef_att > 7000)){
            print "<TH style=\"background-color:$col;\"><span id=\"tooltip\"><span>$zzname【$cou_name[$zzcon]】</span><p style=\"display:inline;color:$white;\">$zzname</p><br><img src=\"$IMG/m_1.gif\" title=\"$zzname【$cou_name[$zzcon]】\"></span></TH>";
        }elsif(($zzshiro >= 5000)&&($zznum >= 100000)&&($zznou >= 5000)&&($zzsyo >= 5000)&&($zzsub1 >= 5000)&&($zzdef_att >= 5000)){
            print "<TH style=\"background-color:$col;\"><span id=\"tooltip\"><span>$zzname【$cou_name[$zzcon]】</span><p style=\"display:inline;color:$white;\">$zzname</p><br><img src=\"$IMG/m_2.gif\" title=\"$zzname【$cou_name[$zzcon]】\"></span></TH>";
        }elsif(($zzshiro >= 1000)&&($zzsub1 >= 1000)&&($zznum >= 20000)&&($zznou >= 1000)&&($zzsyo >= 1000)&&($zzdef_att >= 1000)){
            print "<TH style=\"background-color:$col;\"><span id=\"tooltip\"><span>$zzname【$cou_name[$zzcon]】</span><p style=\"display:inline;color:$white;\">$zzname</p><br><img src=\"$IMG/m_3.gif\" title=\"$zzname【$cou_name[$zzcon]】\"></span></TH>";
          }else{
            print "<TH style=\"background-color:$col;\"><span id=\"tooltip\"><span>$zzname【$cou_name[$zzcon]】</span><p style=\"display:inline;color:$white;\">$zzname</p><br><img src=\"$IMG/m_4.gif\" title=\"$zzname【$cou_name[$zzcon]】\"></span></TH>";
          }
        }else{
          print "<TH>&nbsp;</TH>";
        }
    }
    print "</TR>\n";
  }
print <<"EOM";
</TBODY>
</TABLE>

<TABLE class="swindow" id="towndata" style="background-color:$ELE_BG[$cou_ele[$zcon]];">
<TBODY style="background-color:$ELE_C[$cou_ele[$zcon]];">
<TR><TH bgcolor=$ELE_BG[$country->color_id] colspan=2><span style="color:$ELE_C[$country->color_id];">$zname</span></TH></TR>
<TR><TD style="width:85px;">支配</TD><TH bgcolor$TD_C1>$cou_name[$zcon]</Th></TR>
<TR><TD>農民</TD><TD style="text-align:right;"><div style="background-color:$ynum;width:$num_bar1\%;"></div><div style="background-color:#FF5555;width:$num_bar2\%;"></div>$znum/$zsub2</TD></TR>
<TR><TD>民忠</TD><TD style="text-align:right;"><div style="background-color:$ypri;width:$pri_bar1\%;"></div><div style="background-color:#FF5555;width:$pri_bar2\%;"></div>$zpri/100</TD></TR>
<TR><TD>農業</TD><TD style="text-align:right;"><div style="background-color:$ynou;width:$nou_bar1\%;"></div><div style="background-color:#FF5555;width:$nou_bar2\%;"></div>$znou/$znou_max</TD></TR>
<TR><TD>商業</TD><TD style="text-align:right;"><div style="background-color:$ysyo;width:$syo_bar1\%;"></div><div style="background-color:#FF5555;width:$syo_bar2\%;"></div>$zsyo/$zsyo_max</TD></TR>
<TR><TD>技術力</TD><TD style="text-align:right;"><div style="background-color:$ytec;width:$tec_bar1\%;"></div><div style="background-color:#FF5555;width:$tec_bar2\%;"></div>$zsub1/9999</TD></TR>
<TR><TD>城壁</TD><TD style="text-align:right;"><div style="background-color:$yshiro;width:$shiro_bar1\%;"></div><div style="background-color:#FF5555;width:$shiro_bar2\%;"></div>$zshiro/$zshiro_max</TD></TR>
<TR><TD>城壁耐久力</TD><TD style="text-align:right;"><div style="background-color:$yTshiro;width:$Tshiro_bar1\%;"></div><div style="background-color:#FF5555;width:$Tshiro_bar2\%;"></div>$zdef_att/$taikyu</TD></TR>
<TR><TD>迂回阻止度</TD><TD style="text-align:right;">@{[ $town_class->stop_around_degree($zshiro, $myear) ]}% (足止め効果:@{[ $town_class->stop_around_move_time($zshiro, $myear, $BMT_REMAKE) ]}秒)</TD></TR>
<TR><TD>相場</TD><TD style="text-align:right;">$zsouba</TD></TR>
<TR><TD>城壁の兵種</TD><TD style="text-align:right;">$SOL_TYPE[$syogohei]</TD></TR>
<TR>
  <TD>@{[ $town->name ]}の守備</TD>
  <TD style="text-align:left;">@{[ map { $_->name . '(' . $_->soldier_num . ') ' } @{ $town->defender_list($town_battle_map, $chara_model) } ]}</TD>
</TR>
<form action="./mylog.cgi" method="post"><TR><TH colspan=2>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input  value="滞在武将">
</form>
</TH></TR>
<TR><TD colspan="2" style="text-align:right;">[<a href="./manual.html#tosi" target="_blank">都市データの説明</a>]</TD></TR>
</TBODY></TABLE>

<TABLE class="swindow" id="coudata" style="background-color:$ELE_BG[$country->color_id];">
<TBODY style="background-color:$ELE_C[$country->color_id];">
<TR><TH colspan="8" class="inwindow" style="background-color:$ELE_BG[$country->color_id];"><span style="color:$ELE_C[$country->color_id];">$xname$xaddmes</span></TH></TR>
<TR>
  <TD>君主</TD>
  <TH colspan=2>@{[ $country->king_name ]}</TH>
  <TD>軍師</TD>
  <TH colspan=2>@{[ $country->strategist_name ]}</TH>
</TR>
<TR>
  <TD>宰相</TD>
  <TH colspan=2>@{[ $country->premier_name ]}</TH>
  <TD>大将軍</TD>
  <TH colspan=2>@{[ $country->great_general_name ]}</TH>
</TR>
<tr>
  <td>支配都市</td><td style="text-align:right;">$town_get[$kcon]</td>
  <td>収穫</td><td style="text-align:right;">$total_salary_rice</td>
  <td>税金</td><td style="text-align:right;">$total_salary_money</td>
</tr>
<TR><TD style="height:50px;">Online</TD><TD colspan="5" style="vertical-align:top;">@{[ join '', map { $_->show( $town_model ) . ' ' } @$login_list ]}</TD></TR>
<TR><TD colspan="1">外交状況</TD><TH colspan="5">@{[ map { $_->show_status( $country->id, $country_model ) . '<br>' } @$diplomacy_list ]}</TH></TR>
<form action="./mydata.cgi" method="post"><TR><TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=submit id=input  value="会議室">
</TH></form>
<form action="./mydata.cgi" method="post"><TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=LOCAL_RULE>
<input type=submit id=input  value="国法">
</TH></TR></form>
<form action="./mycou.cgi" method="post"><TR><TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input  value="国データ">
</TH></form>
<form action="./mycou2.cgi" method="post"><TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input  value="国の武将データ">
</TH></TR></form>
$king_com
$kari_gunshi
</TBODY></TABLE>

</div>


EOM

if($ksyuppei && !$kindbmm){
print <<"EOM";
<TABLE style="width:99%;margin:4px;border:2px $ELE_BG[$country->color_id] solid;background-color:$ELE_BG[$country->color_id];">
<TR><TH id="inline" colspan="2"><span id="mes" style="color:$ELE_C[$country->color_id]">▼</span><span id="mes" style="display:none;color:$ELE_C[$country->color_id]">▲</span><span style="color:$ELE_C[$country->color_id];">バトルマップ </span><span id="mes" style="color:$ELE_C[$country->color_id]">[非表示]</span><span id="mes" style="display:none;color:$ELE_C[$country->color_id]">[表示]</span></TH></TR>
<TR><TD id="frame" colspan="2" style="padding:4px;height:700px;background-color:#FFFFFF;"><iframe src="./newbm.cgi?id=$kid&pass=$kpass&mode=STATUS&inline=1"></iframe></TD></TR>
<TR><TD bgcolor="$ELE_C[$country->color_id]">BMを別窓で表示</TD><form action="./newbm.cgi" method="post" target="_blank"><TH bgcolor="$ELE_C[$country->color_id]"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=bm value=\"表示\"></form></TH></TR>
</TABLE>
EOM
}elsif($ksyuppei && $kindbmm eq "1"){
print <<"EOM";
<TABLE style="width:99%;margin:4px;border:2px $ELE_BG[$country->color_id] solid;background-color:$ELE_BG[$country->color_id];">
<TR><TH id="inline" colspan="2"><span id="mes" style="color:$ELE_C[$country->color_id]">▲</span><span id="mes" style="display:none;color:$ELE_C[$country->color_id]">▼</span><span style="color:$ELE_C[$country->color_id];">バトルマップ </span><span id="mes" style="color:$ELE_C[$country->color_id]">[表示]</span><span id="mes" style="display:none;color:$ELE_C[$country->color_id]">[非表示]</span></TH></TR>
<TR><TD id="frame" colspan="2" style="padding:4px;display:none;height:700px;background-color:#FFFFFF;"><iframe src="./newbm.cgi?id=$kid&pass=$kpass&mode=STATUS&inline=1"></iframe></TD></TR>
<TR><TD bgcolor="$ELE_C[$country->color_id]">BMを別窓で表示</TD><form action="./newbm.cgi" method="post" target="_blank"><TH bgcolor="$ELE_C[$country->color_id]"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=bm value=\"表示\"></form></TH></TR>
</TABLE>
EOM
}


  $idate = time();

#状態表示（自分）
  if($kago > $idate){ $jyoutai .= "<img src=\"./image/img/def_up.gif\"> "; }
  if($kyoudou > $idate){ $jyoutai .= "<img src=\"./image/img/def_down.gif\"> "; }
  if($ksendou > $idate){ $jyoutai .= "<img src=\"./image/img/att_down.gif\"> "; }
  if($kobu > $idate){ $jyoutai .= "<img src=\"./image/img/att_up.gif\"> "; }
  if($kagoL > $idate){ $jyoutai .= "<img src=\"./image/img/def_upL.gif\"> "; }
  if($kyoudouL > $idate){ $jyoutai .= "<img src=\"./image/img/def_downL.gif\"> "; }
  if($ksendouL > $idate){ $jyoutai .= "<img src=\"./image/img/att_downL.gif\"> "; }
  if($kobuL > $idate){ $jyoutai .= "<img src=\"./image/img/att_upL.gif\"> "; }
  if($kkinto > $idate){ $jyoutai .= "<img src='./image/img/kumo.png'> "; }
  if($kkicn > 0){ $jyoutai .= "<img src=\"./image/img/kei.png\">+$kkicn "; }
  if($kksup > 0){ $jyoutai .= "<img src=\"./image/img/kousei.png\">+$kksup "; }
  if($kmsup > 0){ $jyoutai .= "<img src=\"./image/img/missyu.png\">+$kmsup "; }

  my $available_states = $chara->states->get_available_states_with_result($idate);
  for my $state (@$available_states) {
    $jyoutai .= qq{<img src="image/img/@{[ $state->icon ]}">};
  }

  if($ksingeki_time-$idate <= 1200 && $ksingeki_time-$idate > 790 && $ksinko){ $jyoutai .= "<img src=\"./image/img/singeki_up.png\"> "; }
  elsif(($ksingeki_time-$idate <= 790 && $ksingeki_time-$idate > 590 && $ksinko) || ($ksingeki_time-$idate <= 1200 && $ksingeki_time-$idate > 590 && !$ksinko)){ $jyoutai .= "<img src=\"./image/img/singeki_down.png\"> "; }


if($ksyuppei && $kindbmm eq "2"){

  #掩護データ
  for my $ext_state (@{ $chara->extensive_states->get_give_effect_states_with_result }) {
    $jyoutai .= qq{<img src="./image/img/@{[ $ext_state->icon ]}">};
  }

  #陣形データ読み込み#
  open(IN,"./log_file/jinkei.cgi") or &ERR2("陣形データ読み込み失敗");
  @JINKEI = <IN>;
  close(IN);
  $i = 0;
  if($kjinkei eq ""){$kjinkei=0;}
  foreach(@JINKEI){
  ($jinname,$jinaup,$jindup,$jinaup2,$jindup2,$jinaup3,$jindup3,$jin_tokui,$jinchange,$jinclas,$jinsetumei,$jinsub,$jinsub2)=split(/<>/);
    if($kjinkei eq $i){
    $jin = "$jinname";
    $jinmes ="$jinsetumei陣形を整えるのにかかる時間は$jinchange秒。";
    $sel ="SELECTED";
      }else{
        $sel ="";
    }
    if($jinclas <= $kclass && $jinsub2 eq ""){
    $JINNAME[$i] = "<option value=\"$i\" $sel>$jinname";
      }
  $i++;
  }
  if($idate < $ksakup){
  $jinhenk = $ksakup-$idate;
  $jinhenkou = "<span id=\"Jdown\">あと$jinhenk秒で変更可能です</span>";
  $js_set = 1;
  $js_jikan .= "
myJCnt = $jinhenk;
";
  $koudoujs .= "
  if ( myJCnt == 0 ){
  document.getElementById( \"Jdown\" ).innerHTML = \"<input type=submit id=input value=変更>\";
  myJCnt--;
  }else if(myJCnt > 0){
  myJCnt--;
  document.getElementById( \"Jdown\" ).innerHTML = \"あと\" + myJCnt + \"秒で変更可能です\";
  }
";
  }else{
  $js_jikan .= "
myJCnt = -1;
";
  $jinhenkou = "<input type=submit id=input value=\"変更\">";
  }


  if($SOL_ZOKSEI[$ksub1_ex] eq "歩"){
  $saihen = "<option value=\'ENGO\'>掩護（消費士気$MOR_ENGO）</option>";
  }if($ksien ne "" && $ksien ne "0"){
  $hokyusi .= "<option value=\'HOKYU\'>補給（1マス）（消費士気$MOR_HOKYU）</option>";
  }if(($ksien eq "2")||($ksien eq "3")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){
  $hokyusi .= "<option value=\'KAGO\'>加護【小】（3マス）（消費士気$MOR_S）</option>";
  }if(($ksien eq "3")||($ksien eq "7")||($ksien eq "8")){
  $hokyusi .= "<option value=\'KAGOL\'>加護【大】（4マス）（消費士気$MOR_L）</option>";
  }if(($ksien eq "4")||($ksien eq "5")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){
  $hokyusi .= "<option value=\'YOUDOU\'>陽動【小】（3マス）（消費士気$MOR_S）</option>";
  }if(($ksien eq "5")||($ksien eq "8")||($ksien eq "9")){
  $hokyusi .= "<option value=\'YOUDOUL\'>陽動【大】（4マス）（消費士気$MOR_L）</option>";
  }if($kskl1 ne "" && $kskl1 ne "0"){
  $konran .= "<option value=\'KONRAN\'>混乱（2マス）（消費士気$MOR_KONRAN）</option>";
  }if($kskl1 >= 2){
  $konran .= "<option value=\'ASIDOME\'>足止め（5マス）（消費士気$MOR_ASIDOME）</option>";
  }if($kskl2 ne "" && $kskl2 ne "0"){
  $kahei .= "<option value=\'KAHEI\'>徴募（消費士気$MOR_TYOUBO）</option>";
  }if(($kskl2 eq "2")||($kskl2 eq "3")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){
  $kahei .= "<option value=\'KOBU\'>鼓舞【小】（3マス）（消費士気$MOR_S）</option>";
  }if(($kskl2 eq "3")||($kskl2 eq "7")||($kskl2 eq "8")){
  $kahei .= "<option value=\'KOBUL\'>鼓舞【大】（4マス）（消費士気$MOR_L）</option>";
  }if(($kskl2 eq "4")||($kskl2 eq "5")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){
  $kahei .= "<option value=\'SENDOU\'>扇動【小】（3マス）（消費士気$MOR_S）</option>";
  }if(($kskl2 eq "5")||($kskl2 eq "8")||($kskl2 eq "9")){
  $kahei .= "<option value=\'SENDOUL\'>扇動【大】（4マス）（消費士気$MOR_L）</option>";
  }if($kskl8 =~ /1/){
  $kahei .= "<option value=\'SYUKUTI\'>縮地（4マス）（消費士気$MOR_SYUKUTI）</option>";
  }if($kskl8 =~ /2/){
  $kahei .= "<option value=\'KASOKU\'>加速（5マス）（消費士気$MOR_KASOKU）</option>";
  }if($kskl8 =~ /3/){
  $kahei .= "<option value=\'KINTO\'>觔斗雲（4マス）（消費士気$MOR_KINTOUN）</option>";
  }if($kskl4 =~ /4/){
  $kyosyu = "<option value=\'BATTLE,KYOSYU\'>強襲($SOL_AT[$ksub1_ex]マス）（消費士気$MOR_KYOSYU）</option>";
  }if($kskl7 =~ /2/){
  $kahei .= "<option value=\'SINGEKI\'>進撃（消費士気$MOR_SINGEKI）</option>";
  }if($kskl7 =~ /4/){
  $hajyo = "<option value=\'BATTLE,HAJYO\'>波状攻撃（$SOL_AT[$ksub1_ex]マス）（消費士気$MOR_HAJYO）</option>";
  $hajyo2 = "<form action=\"./battlecm.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value='BATTLE,HAJYO'><input type=hidden name=eid value=jyouhekisyugohei><input type=submit value=\"波状攻撃（消費士気$MOR_HAJYO)\"></form>";
  }if($kskl5 =~ /3/){
  $houi = "<option value=\'BATTLE,HOUI\'>包囲（$SOL_AT[$ksub1_ex]マス）（消費士気$MOR_HOUI）</option>";
  }if($kskl5 =~ /4/){
  $saihen .= "<option value=\'SAIHEN\'>陣形再編（消費士気$MOR_SAIHEN）</option>";
  }


  $GENZAI[0] = "";
  $GENZAI[1] = "<br><span style=\"color:red;\">(現在地)</span>";
  $GENZAI[2] = "<br><form action=\"./status.cgi\" method=\"post\"><input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=2><input type=hidden name=MOVE value=1><input type=submit id=input  value=\"移動\"></form>";
  $GENZAI[3] = "<br><form action=\"./status.cgi\" method=\"post\"><input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=3><input type=hidden name=MOVE value=1><input type=submit id=input  value=\"移動\"></form>";
  $GENZAI[4] = "<br><form action=\"./status.cgi\" method=\"post\"><input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=4><input type=hidden name=MOVE value=1><input type=submit id=input  value=\"移動\"></form>";
  $GENZAI[5] = "<br><form action=\"./status.cgi\" method=\"post\"><input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=5><input type=hidden name=MOVE value=1><input type=submit id=input  value=\"移動\"></form>";

  $idoucant = 1;


  #敵味方座標検索

  $mikatajin = 0;
  $enemyjin = 0;

  foreach(@CL_DATA){
  ($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

  ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
  ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);
  ($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL) = split(/,/,$esub4);
  ($esingeki_time,$eanother) = split(/,/,$eskldata);

    if ($kiti eq $eiti) {
      if ($kid eq $eid) {
        $hex = $ex+1;
        $hey = $ey+1;
        $MIKATAJIN2[$mikatajin] = "<option value=$eid>($hex,$hey) $ename\[$cou_name[$econ]\] $esol人 0マス</option>";
        $mikatajin++;
      } elsif ($kcon eq $econ) {
        $MIKATAJIN[$mikatajin] = "$ex<>$ey<>$eid<>";
        $zsa = abs($kx-$ex);
        $zsa2 = abs($ky-$ey);
        $zsa3 = $zsa+$zsa2;
        $hex = $ex+1;
        $hey = $ey+1;
  if($eago > $idate){ $ejyoutai .= "<img src='./image/img/def_up.gif'> "; }
  if($eyoudou > $idate){ $ejyoutai .= "<img src='./image/img/def_down.gif'> "; }
  if($esendou > $idate){ $ejyoutai .= "<img src='./image/img/att_down.gif'> "; }
  if($eobu > $idate){ $ejyoutai .= "<img src='./image/img/att_up.gif'> "; }
  if($eagoL > $idate){ $ejyoutai .= "<img src='./image/img/def_upL.gif'> "; }
  if($eyoudouL > $idate){ $ejyoutai .= "<img src='./image/img/def_downL.gif'> "; }
  if($esendouL > $idate){ $ejyoutai .= "<img src='./image/img/att_downL.gif'> "; }
  if($eobuL > $idate){ $ejyoutai .= "<img src='./image/img/att_upL.gif'> "; }
  if($ekinto > $idate){ $ejyoutai .= "<img src='./image/img/kumo.png'> "; }
  if($ekicn > 0){ $ejyoutai .= "<img src='./image/img/kei.png'>+$ekicn "; }
  if($eksup > 0){ $ejyoutai .= "<img src='./image/img/kousei.png'>+$eksup "; }
  if($emsup > 0){ $ejyoutai .= "<img src='./image/img/missyu.png'>+$emsup "; }
  if ($esingeki_time-$idate <= 1200 && $esingeki_time-$idate > 790 && $ksinko) {
    $ejyoutai .= "<img src=\"./image/img/singeki_up.png\"> ";
  }
  elsif (
    ($esingeki_time-$idate <= 790 && $esingeki_time-$idate > 590 && $ksinko) ||
    ($esingeki_time-$idate <= 1200 && $esingeki_time-$idate > 590 && !$ksinko)
  ) {
    $ejyoutai .= "<img src=\"./image/img/singeki_down.png\"> ";
  }

        my $ally = $chara_model->get($eid);
        my $ext_ally = Jikkoku::Class::Chara::ExtChara->new(
          chara => $ally,
          extensive_state_record_model => $ext_state_rec_model,
        );
        my $ally_available_states = $ext_ally->states->get_available_states_with_result($idate);
        for my $state (@$ally_available_states) {
          $ejyoutai .= qq{<img src="image/img/@{[ $state->icon ]}">};
        }
        my $available_states = $ext_ally->extensive_states->get_give_effect_states_with_result($idate);
        for my $state (@$available_states) {
          $ejyoutai .= qq{<img src="image/img/@{[ $state->icon ]}">};
        }
        $engo = $ext_ally->extensive_states->get_with_option('Protect')->match(
          Some => sub { $_->is_give_effect ? '【掩護中】' : '' },
          None => sub { '' },
        );
        
        $MIKATAJIN2[$mikatajin] = "<option value=$eid>($hex,$hey) $ename\[$cou_name[$econ]\] $esol人 $zsa3マス $engo</option>";
        $busyoprf .= "\$(\"#$eid\").hover(function () {\$(this).append(\$(\"<div id=sballon><table style='border:solid 2px $ELE_BG[$cou_ele[$econ]];'><tr><td rowspan=4><img src='$IMG/$echara.gif' style='width:64px;height:64px;'></td><td>($hex,$hey) $ename</td></tr><tr><td>・所属国:$cou_name[$econ]\</td></tr><tr><td>・兵士:$SOL_TYPE[$esub1_ex]($SOL_ZOKSEI[$esub1_ex]) $esol人</td></tr><tr><td>・距離:$zsa3マス</td></tr><tr><td>・武力:$estr</td><td>・知力:$eint</td></tr><tr><td>・統率力:$elea</td><td>・人望:$echa</td></tr><tr><td>・状態:</td><td>$ejyoutai</td></tr></table></div>\"));}, function () {\$(this).find(\"div:last\").remove();});\n";
        $mikatajin++;
      }else{
        $ENEMYJIN[$enemyjin] = "$ex<>$ey<>$eid<>";
        $zsa = abs($kx-$ex);
        $zsa2 = abs($ky-$ey);
        $zsa3 = $zsa+$zsa2;
        $hex = $ex+1;
        $hey = $ey+1;
        my $enemy = $chara_model->get($eid);
        my $ext_enemy = Jikkoku::Class::Chara::ExtChara->new(
          chara => $enemy,
          extensive_state_record_model => $ext_state_rec_model,
        );
        my $enemy_available_states = $ext_enemy->states->get_available_states_with_result($idate);
        for my $state (@$enemy_available_states) {
          $ejyoutai .= qq{<img src="image/img/@{[ $state->icon ]}">};
        }
        my $available_states = $ext_enemy->extensive_states->get_give_effect_states_with_result($idate);
        for my $state (@$available_states) {
          $ejyoutai .= qq{<img src="image/img/@{[ $state->icon ]}">};
        }
        $engo = $ext_enemy->extensive_states->get_with_option('Protect')->match(
          Some => sub { $_->is_give_effect ? '【掩護中】' : '' },
          None => sub { '' },
        );
        $ENEMYJIN2[$enemyjin] = "<option value=$eid>($hex,$hey) $ename\[$cou_name[$econ]\] $esol人 $zsa3マス $engo</option>";
        $busyoprf .= "\$(\"#$eid\").hover(function () {\$(this).append(\$(\"<div id=sballon><table style='border:solid 2px $ELE_BG[$cou_ele[$econ]];'><tr><td rowspan=4><img src='$IMG/$echara.gif' style='width:64px;height:64px;'></td><td>($hex,$hey) $ename</td></tr><tr><td>・所属国:$cou_name[$econ]\</td></tr><tr><td>・兵士:$SOL_TYPE[$esub1_ex]($SOL_ZOKSEI[$esub1_ex]) $esol人</td></tr><tr><td>・距離:$zsa3マス</td></tr><tr><td>・武力:$estr</td><td>・知力:$eint</td></tr><tr><td>・統率力:$elea</td><td>・人望:$echa</td></tr><tr><td>・状態:</td><td>$ejyoutai</td></tr></table></div>\"));}, function () {\$(this).find(\"div:last\").remove();});\n";
        $enemyjin++;
      }
    }
  }


print "\n\n<script type=\"text/javascript\"><!--
\$(document).ready(function(){

$busyoprf

});
--></script>\n\n";


  #バトルマップ読み込み(ここだけ require でなく do なのは移動時に２回読み込ませるため)
  do "./log_file/map_hash/$kiti.pl";


  $bmcolspan = $BM_X + 1;

  print "<div style=\"width:100%;\"><TABLE class=\"swindow\" id=\"battlemap\" style=\"background-color:@{[ $game_date->map_bg_color ]};\"><TBODY><TR><TH colspan=\"$bmcolspan\" class=\"inwindow\" style=\"background-color:#442200;height:5px;\"><span style=\"color:#FFFFFF\">- $battkemapnameマップ - (@{[ $game_date->date($F_YEAR) ]})</span></TH></TR><TR><TD style=\"background-color:$TD_C2;width:5px;\">\-</TD>";

  for($i=1;$i<$BM_X+1;$i++){
    print "<TD style=\"background-color:$TD_C1;width:35px;\">$i</TD>";
  }
  print "</TR>";

  for($i=0;$i<$BM_Y;$i++){
    $n = $i+1;
    print "<TR><TD style=\"background-color:$TD_C3;width:5px;\">$n</TD>";
    for($j=0;$j<$BM_X;$j++){

      #筋斗雲 ./lib/skl_lib.pl
      KINTOUN($j,$i);
      skl_lib_adjust_state_move_cost($j, $i, $chara, $idate);

      #このマスに敵、味方がいないか検索
      $eneno = 1;
      foreach(@ENEMYJIN){
      ($ex,$ey,$eid) = split(/<>/);
        if($j == $ex && $i == $ey){
        if($eneno == 1){$butaibasyo .= "<br>";}
        $butaibasyo .= "<a class=\"enemy\" id=\"$eid\" href=\"javascript:void(0)\">敵$eneno</a>&nbsp\;";
        $idoucant = 0;
        $eneno++;
        }
      }
      $eneno = 1;
      foreach(@MIKATAJIN){
      ($ex,$ey,$eid) = split(/<>/);
        if($j == $ex && $i == $ey && $eid ne ""){
        if($eneno == 1){$butaibasyo .= "<br>";}
        $butaibasyo .= "<a class=\"mikata\" id=\"$eid\" href=\"javascript:void(0)\">味方$eneno</a>&nbsp\;";
        $eneno++;
        }
      }
      #城に攻撃できるかの判定
      if($BM_TIKEI[$i][$j] == 18 || $BM_TIKEI[$i][$j] == 22){
        if($kcon ne $town_cou[$kiti]){
          if($idoucant){
          $sisecan = 1;
          }else{
          $sisecan = 0;
          }
        $idoucant = 0;
          $zsa = abs($kx-$j);
          $zsa2 = abs($ky-$i);
          $zsa3 = $zsa+$zsa2;
          if($zsa3 <= $SOL_AT[$ksub1_ex]){$siroseme = "<TR><TD>$town_name[$kiti]の城を攻撃</TD><TH colspan=5 align=left><form action=\"./battlecm.cgi\" method=\"post\">$inline<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=BATTLE><input type=hidden name=eid value=jyouhekisyugohei><input type=submit id=input value=\"城攻\"></form>$hajyo2</TH></TR>";
          }
        }
      }


      #自分がいるマス、自分がいる隣のマスの時の処理
      if($j == $kx && $i == $ky){
      $genzai = 1;
        if($BM_TIKEI[$i][$j] == 17){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
          ($noiti,$noiti2) = split(/-/,$ikisaki);
          if($noiti eq $kiti){$noiti3="$noiti2";}else{$noiti3="$noiti";}
          if(($town_cou[$kiti] ne "$kcon" && $town_cou[$kiti] ne "" && $town_cou[$kiti] ne "0") && $town_shiro[$kiti] > 0 && ($town_cou[$kiti] eq $town_cou[$noiti3]) ){
          $keikoku = ' onSubmit="return check(\'警告!!\n\n城壁のある敵国の都市から他の敵国の都市に移動しようとしています！\nこのまま出城すると '. $town_class->stop_around_move_time($town_shiro[$kiti], $myear, $BMT_REMAKE) . ' 秒の移動P補充時間と ' . $town_class->stop_around_action_time($town_shiro[$kiti], $myear, $BMT_REMAKE) . ' 秒の行動待機時間が発生します。\nよろしいですか？\')"';
          }
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\"$keikoku>$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"出城\"></TH></form></TR>";
        }elsif($BM_TIKEI[$i][$j] == 16){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"入城\"></TH></form></TR>";
          if($kcon eq $town_cou[$ikisaki]){
          $taikyaku = "<TR><TD>$town_name[$ikisaki]に退却</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=TAIKYAKU><input type=submit id=input value=\"退却\"></TH></form></TR>";
          }
        }elsif( ($BM_TIKEI[$i][$j] == 22 || $BM_TIKEI[$i][$j] == 18) && $kcon eq $town_cou[$kiti]){
        $taikyaku = "<TR><TD>$town_name[$kiti]に退却</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=TAIKYAKU><input type=submit id=input value=\"退却\"></TH></form></TR>";
        }elsif($BM_TIKEI[$i][$j] == 21){
        $taikyaku = "<TR><TD>武器屋に入る</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=BUKIYA><input type=submit id=input value=\"入店\"></TH></form></TR>";
        }

      }elsif($j == $kx-1 && $i == $ky && $idoucant){
      $genzai = 2;
        if($BM_TIKEI[$i][$j] == 17){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
          ($noiti,$noiti2) = split(/-/,$ikisaki);
          if($noiti eq $kiti){$noiti3="$noiti2";}else{$noiti3="$noiti";}
          $zou_ip = int( ($town_shiro[$kiti] / (15+($myear*0.583)) )*60);
          $zou_ip2 = int($zou_ip/2);
          if(($town_cou[$kiti] ne "$kcon" && $town_cou[$kiti] ne "" && $town_cou[$kiti] ne "0") && $town_shiro[$kiti] > 0 && ($town_cou[$kiti] eq $town_cou[$noiti3]) ){
          $keikoku = ' onSubmit="return check(\'警告!!\n\n城壁のある敵国の都市から他の敵国の都市に移動しようとしています！\nこのまま出城すると '.$zou_ip.' 秒の移動P補充時間と '.$zou_ip2.' 秒の行動待機時間が発生します。\nよろしいですか？\')"';
          }
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\"$keikoku>$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"出城\"></TH></form></TR>";
        }elsif($BM_TIKEI[$i][$j] == 16){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"入城\"></TH></form></TR>";
        }
      if($kidoup < $CAN_MOVE[$BM_TIKEI[$i][$j]]){$genzai = 0;}

      }elsif($j == $kx+1 && $i == $ky && $idoucant){
      $genzai = 3;
        if($BM_TIKEI[$i][$j] == 17){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
          ($noiti,$noiti2) = split(/-/,$ikisaki);
          if($noiti eq $kiti){$noiti3="$noiti2";}else{$noiti3="$noiti";}
          $zou_ip = int( ($town_shiro[$kiti] / (15+($myear*0.583)) )*60);
          $zou_ip2 = int($zou_ip/2);
          if(($town_cou[$kiti] ne "$kcon" && $town_cou[$kiti] ne "" && $town_cou[$kiti] ne "0") && $town_shiro[$kiti] > 0 && ($town_cou[$kiti] eq $town_cou[$noiti3]) ){
          $keikoku = ' onSubmit="return check(\'警告!!\n\n城壁のある敵国の都市から他の敵国の都市に移動しようとしています！\nこのまま出城すると '.$zou_ip.' 秒の移動P補充時間と '.$zou_ip2.' 秒の行動待機時間が発生します。\nよろしいですか？\')"';
          }
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\"$keikoku>$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"出城\"></TH></form></TR>";
        }elsif($BM_TIKEI[$i][$j] == 16){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"入城\"></TH></form></TR>";
        }
      if($kidoup < $CAN_MOVE[$BM_TIKEI[$i][$j]]){$genzai = 0;}

      }elsif($j == $kx && $i == $ky+1 && $idoucant){
      $genzai = 4;
        if($BM_TIKEI[$i][$j] == 17){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
          ($noiti,$noiti2) = split(/-/,$ikisaki);
          if($noiti eq $kiti){$noiti3="$noiti2";}else{$noiti3="$noiti";}
          $zou_ip = int( ($town_shiro[$kiti] / (15+($myear*0.583)) )*60);
          $zou_ip2 = int($zou_ip/2);
          if(($town_cou[$kiti] ne "$kcon" && $town_cou[$kiti] ne "" && $town_cou[$kiti] ne "0") && $town_shiro[$kiti] > 0 && ($town_cou[$kiti] eq $town_cou[$noiti3]) ){
          $keikoku = ' onSubmit="return check(\'警告!!\n\n城壁のある敵国の都市から他の敵国の都市に移動しようとしています！\nこのまま出城すると '.$zou_ip.' 秒の移動P補充時間と '.$zou_ip2.' 秒の行動待機時間が発生します。\nよろしいですか？\')"';
          }
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\"$keikoku>$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"出城\"></TH></form></TR>";
        }elsif($BM_TIKEI[$i][$j] == 16){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"入城\"></TH></form></TR>";
        }
      if($kidoup < $CAN_MOVE[$BM_TIKEI[$i][$j]]){$genzai = 0;}

      }elsif($j == $kx && $i == $ky-1 && $idoucant){
      $genzai = 5;
        if($BM_TIKEI[$i][$j] == 17){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
          ($noiti,$noiti2) = split(/-/,$ikisaki);
          if($noiti eq $kiti){$noiti3="$noiti2";}else{$noiti3="$noiti";}
          $zou_ip = int( ($town_shiro[$kiti] / (15+($myear*0.583)) )*60);
          $zou_ip2 = int($zou_ip/2);
          if(($town_cou[$kiti] ne "$kcon" && $town_cou[$kiti] ne "" && $town_cou[$kiti] ne "0") && $town_shiro[$kiti] > 0 && ($town_cou[$kiti] eq $town_cou[$noiti3]) ){
          $keikoku = ' onSubmit="return check(\'警告!!\n\n城壁のある敵国の都市から他の敵国の都市に移動しようとしています！\nこのまま出城すると '.$zou_ip.' 秒の移動P補充時間と '.$zou_ip2.' 秒の行動待機時間が発生します。\nよろしいですか？\')"';
          }
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\"$keikoku>$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"出城\"></TH></form></TR>";
        }elsif($BM_TIKEI[$i][$j] == 16){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO1 .= "<TR><TD>$ikisaki3へ</TD><form action=\"./battlecm.cgi\" method=\"post\">$inline<TH colspan=5 align=left><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SEKISYO><input type=hidden name=sekisyo value=\"$j,$i\"><input type=submit id=input value=\"入城\"></TH></form></TR>";
        }
      if($kidoup < $CAN_MOVE[$BM_TIKEI[$i][$j]]){$genzai = 0;}

      }else{
      $genzai = 0;
      }


      #マス目描画
      if($BM_TIKEI[$i][$j] ne ""){
        if($BM_TIKEI[$i][$j] == 17){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO[$i][$j] = "<span style=\"color:white;\">$ikisaki2</span>";
        }elsif($BM_TIKEI[$i][$j] == 16){
        ($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
        $SEKISYO[$i][$j] = "<span style=\"color:white;\">$ikisaki2</span>";
        }elsif($BM_TIKEI[$i][$j] == 18 || $BM_TIKEI[$i][$j] == 22){
        $jyouheki[18] = "<br><span style=\"color:white;\">$town_name[$kiti]<br>城壁:$town_shiro[$kiti]</span>";
        $jyouheki[22] = "<br><span style=\"color:white;\">$town_name[$kiti]<br>城壁:$town_shiro[$kiti]</span>";
        }
      print "<TH style=\"background-color:$BMCOL[$BM_TIKEI[$i][$j]];\"><span style=\"color:white;\">$BMNAME[$BM_TIKEI[$i][$j]]</span>$jyouheki[$BM_TIKEI[$i][$j]]$SEKISYO[$i][$j]$butaibasyo$GENZAI[$genzai]</TH>";
      $butaibasyo = "";
      $idoucant = 1;
      }else{
      print "<TH style=\"background-color:$BMCOL[0];\">&nbsp;</TH>";
      }
    }
  print "</TR>";
  }

  print "</TBODY></TABLE>";

  if($idate < $kbattletime){
  $nokoris = $kbattletime-$idate;
  $iphojyu = "<span id=\"Idown\">あと$nokoris秒で補充可能です</span>";
    #移動P補充可能時の通知
    if($ksettei2 == 1){
    $Ialert="sound($ksettei3);";
    }elsif($ksettei2 == 2){
    $Ialert="alert( \"移動Pが補充可能になりました。\" );";
    }elsif($ksettei2 == 3){
    $Ialert="sound($ksettei3);alert( \"移動Pが補充可能になりました。\" );";
    }
  $js_set = 1;
  $js_jikan .= "
myICnt = $nokoris;
";
  $koudoujs .= "
  if ( myICnt == 0 ){
  document.getElementById( \"Idown\" ).innerHTML = \"<input type=submit id=input value=補充>\";
  $Ialert
  myICnt--;
  }else if(myICnt > 0){
  myICnt--;
  document.getElementById( \"Idown\" ).innerHTML = \"あと\" + myICnt + \"秒で補充可能です\"\;
  \}";
  }else{
  $js_jikan .= "
myICnt = -1;
";
  $iphojyu = "<input type=submit id=input value=\"補充\">"
  }

  if($idate < $kkoutime){
  $nokoris2 = $kkoutime-$idate;
  $koudoutime = "<b><span id=\"down\">あと$nokoris2秒で行動可能です</span></b>";
    # 行動可能時の通知
    if($ksettei4 == 1){
    $alert="sound($ksettei5);";
    }elsif($ksettei4 == 2){
    $alert="alert( \"行動可能になりました。\" );";
    }elsif($ksettei4 == 3){
    $alert="sound($ksettei5);alert( \"行動可能になりました。\" );";
    }
  $js_set = 1;
  $js_jikan .= "
myCnt = $nokoris2;
";
  $koudoujs .= "
  if ( myCnt == 0 ){
  document.getElementById( \"down\" ).innerHTML = \"\";
  $alert
  myCnt--;
  }else if(myCnt > 0){
  myCnt--;
  document.getElementById( \"down\" ).innerHTML = \"あと\" + myCnt + \"秒で行動可能です\";
  }
";
  }else{
  $js_jikan .= "
myCnt = -1;
";
  }

  if($js_set){
  $hontai = "
$js_jikan
myTim = setInterval ( \"myTimer()\", 1000 );

function myTimer(){
$koudoujs

  if(myCnt == -1 && myICnt == -1 && myJCnt == -1){
  clearInterval(myTim);
  }
}";
  }

  # 通知音再生関係
  if($ksettei2 == 1 || $ksettei2 == 3){
  print "\n<audio id=\"sound-file-$ksettei3\" preload=\"auto\">\n<source src=\"./sound/$ksettei3.mp3\" type=\"audio/mp3\">\n</audio>\n";
  $soundscript = '
function sound(play){
  document.getElementById("sound-file-" + play).play();
}';
  }if($ksettei4 == 1 || $ksettei4 == 3){
    if($ksettei3 != $ksettei5){
    print "\n<audio id=\"sound-file-$ksettei5\" preload=\"auto\">\n<source src=\"./sound/$ksettei5.mp3\" type=\"audio/mp3\">\n</audio>\n";
    }
  }if($ksettei2 == 1 || $ksettei2 == 3 || $ksettei4 == 1 || $ksettei4 == 3){
  $soundscript = '
function sound(play){
  document.getElementById("sound-file-" + play).play();
}';
  }

print <<"EOM";


<!-- 残り時間表示 -->
<script type="text/javascript"><!--
$soundscript

$hontai
// --></script>


<TABLE class="swindow" id="bmcom" style="background-color:$ELE_BG[$country->color_id];">
<TBODY style="background-color:$ELE_C[$country->color_id];">
<TR><TH colspan="8" style="background-color:$ELE_BG[$country->color_id];"><span style="color:$ELE_C[$country->color_id];">BM用コマンド<br>$ksinkomes</span></TH></TR>
<TR><TD>兵士</TD><TH colspan="2">$SOL_TYPE[$ksub1_ex]($SOL_ZOKSEI[$ksub1_ex]) $ksol人</TH><TD>訓練</TD><TH>$kgat</TH></TR>
<TR><TD>状態</TD><TH colspan="2">$jyoutai</TH><TD>士気</TD><TH>$ksiki / $ksiki_max</TH></TR>
<TR><TD>移動ポイント補充</TD><TH>移動P</TH><TH colspan=1>$kidoup / $SOL_MOVE[$ksub1_ex]</TH><TH colspan=3><form action=\"./battlecm.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=IDOUP>$iphojyu</TH></form></TR>
<TR><TD>行動</TD><form action="./battlecm.cgi" method="post"><TD align=left colspan=5>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<select name=mode>
<option value=''>== 　戦闘　 ==</option>
<option value='BATTLE'>戦闘($SOL_AT[$ksub1_ex]マス)</option>
$kyosyu
$hajyo
$houi
<option value=''>== 　支援、妨害系　 ==</option>
$saihen
$hokyusi
$konran
$kahei
</select>
<select name=eid>
<option value=''>== 　敵　 ==</option>

EOM
  $testno = 0;
  foreach(@ENEMYJIN2){
    print "$ENEMYJIN2[$testno]";
  $testno++;
  }
print <<"EOM";

<option value=''>==　味方　==</option>

EOM
  $testno = 0;
  foreach(@MIKATAJIN2){
    print "$MIKATAJIN2[$testno]";
  $testno++;
  }
print <<"EOM";

</select>
<input type=submit id=input value='実行'></form>
</TD></TR>
$taikyaku
$siroseme
$SEKISYO1
<TR><TD>待機時間</TD><TD align=left colspan=5>$koudoutime</TD></TR>
<TR><form action="./mydata.cgi" method="post"><TD>陣形<br><sub>[<a href="./manual.html#jin" target="_blank">陣形について</a>]</sub></TD><th width="60">$jin</th><Td colspan=4>$jinmes</Td></TR>
<TR><td>陣形変更</td><TH colspan=2>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=JINKEI>
<select name=jinkei>
@JINNAME
</select>
</TH><TH colspan=3>$jinhenkou</form></TH></TR>
<TR>
  <TD>BM行動予約</TD>
  <TH colspan="2">
    <form action="./auto_in.cgi" method="post" target="_blank">
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <input type=submit id=input  value=\"表示\">
    </form>
  </TH>
EOM
  require Jikkoku::Model::Chara::AutoModeList;
  my $auto_list_model = Jikkoku::Model::Chara::AutoModeList->new;
  my ($status, $button_mes) = $auto_list_model->get_with_option($kid)->match(
    Some => sub { 'ON', 'OFF' },
    None => sub { 'OFF', 'ON' },
  );
print <<"EOM";
  <th>BM自動モード : $status</th>
  <th>
    <form action="./auto_in.cgi" method="post">
      <input type=hidden name=mode value=SETTEI>
      <input type=hidden name=id value="$kid">
      <input type=hidden name=pass value="$kpass">
      <input type=submit value="$button_mesにする">
    </form>
  </th>
</TR>
<TR><TD>BMを別窓で表示</TD><form action="./newbm.cgi" method="post" target="_blank"><TH colspan=5><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=bm value=\"表示\"></form></TH></TR>
<TR><TD align="right" colspan="6">[<a href="./manual.html#sen" target="_blank">戦闘の説明</a>]</TD></TR>
</TBODY></TABLE>

</div>


EOM

}elsif($ksyuppei && $kindbmm eq "3"){

print <<"EOM";

<TABLE class="rwindow" id="bmcom" style="width:99%;background-color:$ELE_BG[$country->color_id];">
<TBODY style="background-color:$ELE_C[$country->color_id];">
<TR><TH bgcolor=$ELE_BG[$country->color_id] colspan=2><span style="color:$ELE_C[$country->color_id];">バトルマップ</span></TH></TR>
<TR><TD>BMを別窓で表示</TD><form action="./newbm.cgi" method="post" target="_blank"><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=bm value=\"表示\"></form></TH></TR>
</TBODY></TABLE>

EOM

}


#武将データ表示
if(!$ksyuppei || ($ksyuppei && $kindbmm eq "3") || ($ksyuppei && $kindbmm eq "2") ){
print <<"EOM";
<TABLE class="mwindow" id="busyodata" style="background-color:$ELE_BG[$country->color_id];">
<TBODY style="background-color:$ELE_C[$country->color_id];">
<TR><TH colspan=19 style="background-color:$ELE_BG[$country->color_id];" class="inwindow"><span style="color:$ELE_C[$country->color_id];">$kname$rank_mes</span></TH></TR>
<TR>
  <TD rowspan=5 style="width:64px;"><img src=$IMG/$kchara.gif style="width:64px;height:64px;"></TD>
  <TD>武力</TD>
  <TH>@{[ $chara->force ]} (EX:@{[ $chara->ability_exp('force') ]})</TH>
  <TD>知力</TD>
  <TH>@{[ $chara->intellect ]} (EX:@{[ $chara->ability_exp('intellect') ]})</TH>
  <TD>統率力</TD>
  <TH>@{[ $chara->leadership ]} (EX:@{[ $chara->ability_exp('leadership') ]})</TH>
  <TD>人望</TD>
  <TH>@{[ $chara->popular ]} (EX:@{[ $chara->ability_exp('popular') ]})</TH>
  <th bgcolor=$ELE_BG[$country->color_id]></th>
  <TD>武器</TD>
  <TH colspan=3>@{[ $chara->weapon_name ]}</TH>
  <TH colspan=1>@{[ $chara->weapon_power ]}</TH>
  <TD>属性</TD>
  <TH>@{[ $chara->weapon_attr ]}</TH>
  <td>相性</td>
  <th>@{[ $chara->weapon_attr_power ]}</th>
</TR>
<TR>
  <TD>所属</TD>
  <TH>@{[ $country->name ]}</TH>
  <TD>忠誠度</TD>
  <TH>@{[ $chara->loyalty ]}</TH>
  <TD>金</TD>
  <TH>@{[ $chara->money ]}</TH>
  <TD>米</TD>
  <TH>@{[ $chara->rice ]}</TH>
  <th bgcolor=$ELE_BG[$country->color_id]></th>
  <TD>書物</TD>
  <TH colspan=7>@{[ $chara->book_name ]}</TH>
  <TH colspan=1>@{[ $chara->book_power ]}</TH>
</TR>
<TR>
  <TD>部隊</TD>
  <TH>@{[ $unit->name ]}</TH>
  <TD>階級</TD>
  <TH>Lv.$klank $LANK[$klank]</TH>
  <TD>階級値</TD>
  <TH>@{[ $chara->class ]}</TH>
  <TD>貢献値</TD>
  <TH>@{[ $chara->contribute ]}</TH>
  <th bgcolor=$ELE_BG[$country->color_id]></th>
  <TD>防具</TD>
  <TH colspan=7>@{[ $chara->guard_name ]}</TH>
  <TH colspan=1>@{[ $chara->guard_power ]}</TH>
</TR>
<TR>
  <TD>兵種</TD>
  <TH>$SOL_TYPE[$ksub1_ex]</TH>
  <TD>属性</TD>
  <TH>$SOL_ZOKSEI[$ksub1_ex]</TH>
  <TD>兵士</TD><TH>@{[ $chara->soldier_num ]}</TH>
  <TD>訓練</TD>
  <TH colspan=1>@{[ $chara->soldier_training ]}</TH>
  <th bgcolor=$ELE_BG[$country->color_id]></th>
  <TD colspan=1>攻撃力</TD>
  <TH colspan=8>$kkou$kaikmes$katt_add2$katt_add3</TH>
</TR>
<TR>
  <TD colspan=1>士気</TD>
  <TH>$ksiki / $ksiki_max</TH>
  <TD colspan=1>移動P</TD>
  <TH>$kidoup / $SOL_MOVE[$ksub1_ex]</TH>
  <TD colspan=1>リーチ</TD>
  <TH>$SOL_AT[$ksub1_ex]</TH>
  <TD>状態</TD>
  <TH colspan=1>$jyoutai</TH>
  <th bgcolor=$ELE_BG[$country->color_id]></th>
  <TD colspan=1>守備力</TD>
  <TH colspan=8>$kbou$katt_def2$katt_def3</TH>
</TR>
<TR>
<form action="./mydata.cgi" method="post" target="_top">
<TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=ZATU_BBS>
<input type="submit" value="雑談用BBS">
</TH>
</form><form action="./mydata.cgi" method="post" target="_top">
<TH colspan=2>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=MYDATA>
<input type="submit" value="設定＆戦績">
</TH>
</form><form action="./mydata.cgi" method="post" target="_top">
<TH colspan=2>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=MYSKL>
<input type="submit" value="スキル確認">
</TH>
</form><form action="./mydata.cgi" method="post" target="_top">
<TH colspan=2>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=SKL_BUY>
<input type="submit" value="スキル修得">
</TH>
</form>
<form action="./mydata.cgi" method="post" target="_top">
<TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=UNIT_SELECT>
<input type="submit" value="部隊編成">
</TH>
</form><form action="./mydata.cgi" method="post" target="_top">
<TH colspan=3>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=LETTER>
<input type="submit" value="個人宛手紙">
</TH>
</form><form action="./mydata.cgi" method="post" target="_top">
<TH colspan=2>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=BLOG>
<input type="submit" value="戦闘ログ">
</TH>
</form><form action="./mydata.cgi" method="post" target="_top">
<TH colspan=2>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type="hidden" name="mode" value=MYLOG>
<input type="submit" value="行動ログ">
</TH>
</form></TR>
<tr><td colspan="19" align="right">[<a href="./manual.html#ste" target="_blank">武将のステータスの説明</a>] [<a href="./manual.html#jyo" target="_blank">武将の情報について</a>]</td></tr>
</TBODY>
</TABLE>


<!-- 戦闘ログ -->
<TABLE style="width:99%;margin:5px;background-color:$ELE_BG[$cou_ele[$kcon]];">
<TR>
<form action="./blog.cgi" method="post">
<TH id="blog_th" style="background-color:$ELE_BG[$country->color_id];width:33%;border:1px $ELE_C[$country->color_id] solid;"><span style="color:$ELE_C[$country->color_id];">戦闘ログ</span>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="もっと見る">
</TH></form>
</TR>
<TR id="blog"><TD style="width:100%;background-color:$ELE_C[$cou_ele[$kcon]];">
EOM
for (@{ $chara->battle_logger->get(11) }) {
  print qq{<span class="navy">●</span>$_<br>};
}
print <<"EOM";
</TD></TR>
</TABLE>


EOM
}


#コマンド入力
print <<"EOM";

<a id="siji"></a>
<form action="./command.cgi" method="POST" name="com">
  <input type=hidden name=id value=$kid>
  <input type=hidden name=pass value=$kpass>

<TABLE id="com_arr" style="background-color:$ELE_BG[$country->color_id];">
  <TBODY style="background-color:$ELE_C[$country->color_id];">
    <TR>
      <TH colspan="4" style="background-color:$ELE_BG[$country->color_id];">
        <span style="color:$ELE_C[$country->color_id];">コマンド</span>
      </TH>
    </TR>
    <TR><TH colspan="4">$daytime</TH></TR>
    <TR>
      <TD colspan="2" style="height:350px;width:50%;">
        <div id="command-result"
          style="height:350px;width:100%;overflow:scroll;-webkit-overflow-scrolling:touch;">
          <TABLE id="command" class="swindow" style="background-color:$ELE_BG[$cou_ele[$zcon]];">
            <TBODY style="background-color:#FFFFFF;">
              <TR>
                <TH style="background-color:#000000;height:10px;" colspan=4 class="inwindow">
                  <span style="color:#FFFFFF;">コマンド選択</span>
                </TH>
              </TR>
              $com_list
            </TBODY>
          </TABLE>
        </div>
      </TD>
      <TD colspan="2" rowspan="2" style="width:50%;">
        <TABLE style="width:100%;background-color:$ELE_BG[$country->color_id];border-collapse:collapse;">
          <TBODY style="background-color:$ELE_C[$country->color_id];">
            <TR>
              <TD style="text-align:center;">
<select name="mode" size="14">
<option value=$NONE>何もしない
<option value=$KUUHAKU>空白を入れる
<option value=$SAKUJYO>コマンドを削除
<optgroup label="== 内政 ==">
<option value=$NOUGYOU>農業開発(50G)
$add_com7
<option value=$SYOUGYOU>商業発展(50G)
$add_com8
<option value=$TEC>技術開発(50G)
<option value=$SHIRO>城壁強化(50G)
$add_com9
<option value=$SHIRO_TAI>城壁耐久力強化(50G)
<option value=$RICE_GIVE>米施し(50R)
$add_com10
$add_com15
<option value=$JYUNSATU>巡察(100G)
<optgroup label="== 軍事 ==">
<option value=$GET_SOL>徴兵
<option value=$KUNREN>兵士訓練
$add_com11
$add_com12
$add_com13
<option value=$BACK_DEF>城の守備
<option value=$TOWN_DEF2>城の守備(座標指定)(200R)　　　
<option value=$BATTLE>戦争
$add_com16
<optgroup label="== 諜略 ==">
<option value=$GET_MAN>登用(50G)
$add_com17
$add_com14
<optgroup label="== 計略 ==">
<option value=$KENKOKU>建国
<option value=$HANRAN>反乱
$add_com2
$add_com3
$add_com4
$add_com5
$add_com6
<optgroup label="== 鍛錬 ==">
<option value=$TANREN>\能\力強化(500G)
<optgroup label="== 商人 ==">
<option value=$BUY>米売買
<option value=$ARM_BUY>武器購入
<option value=$DEF_BUY>書物購入
<option value=$BOU_BUY>防具購入
<optgroup label="== 移動 ==">
<option value=$MOVE>移動
$add_com
<option value=$SHIKAN>仕官
<option value=$GEYA>下野
</select>
              </TD>
            </TR>
            <TR>
              <TH colspan=2><input type=submit id=input  value="実行">
              </TH>
            </TR>
            <TR>
              <TD colspan=2>
<br>
※各コマンドの説明は<a href="./manual.html#comm" target="_blank">こちら</a>
<BR>※空白を入れるは最初に選択したNoに選択したNoの数だけ空白を入れます。<br>
　(例：No:3～No:7を選択して空白をいれる→No:3の場所に5個空白を挿入する)
<BR>※マウスをドラッグすることやshiftキーを使ってまとめて選択できます。
<BR>※(変更点)ctrlキーを押さなくても複数選択できます。
              </TD>
            </TR>
          </TBODY>
        </TABLE>
      </TD>
    </TR>
  </form>

    <TR>
      <TD colspan="2">
        <form name="selectCommandNumber">
No<select name="start">
    <option value="1" SELECTED>1
EOM
print qq{<option value="$_">$_\n} for 2 .. 48;
print <<"EOM";
</select>
から<select name="interval">
<option value="1" SELECTED>1
EOM
print qq{<option value="$_">$_\n} for 2 .. 24;
print <<"EOM";
</select>
毎に
        <input name="select" type="button" value="選択">
        <input name="unCheckAll" type="button" style="margin:0 0 0 10px;" value="選択全解除">
        <input type="button" id="can-select-command-text"
          style="margin:0 0 0 10px;" value="コマンドリストのテキストを選択可能にする">
        <input type="button" id="cant-select-command-text"
          style="display:none;margin:0 0 0 10px;" value="コマンドリストのテキストを選択不可にする">
        </form>
      </TD>
    </TR>

    <TR>
      <TH id="com_save_title" style="background-color:$ELE_BG[$country->color_id];" colspan="4">
        <span style="color:$ELE_C[$country->color_id];">コマンドリスト保存</span>
        <span style="color:$ELE_C[$country->color_id];">[表示]</span>
        <span style="display:none;color:$ELE_C[$country->color_id];">[非表示]</span>
      </TH>
    </TR>
    <tr id="com_save_row" style="display:none;">
      <form action="./command.cgi" method="POST" id="com_save">
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <td style="width:25%" rowspan="2">
        <select name=mode size=4 onChange="save_limit(this.value)">
          <option value="67">コマンドリスト保存
          <option value="68">保存リストを見る
          <option value="69">保存リスト読み込み
          <option value="70">名前変更
        </select>
      </td>
      <td style="width:25%" rowspan="2">
保存リストの番号を選択:<br>
No<select name="save" size="6">
EOM
  #自分用のディレクトリがなかった時
  if (!opendir(DIR,"./charalog/com_save/$kid")) {
    mkdir("./charalog/com_save/$kid");
  }

  open(IN, "./charalog/com_save/$kid/list.cgi");
  @COM_DATA = <IN>;
  close(IN);
  for ($i=1;$i<=15;$i++){
    if($COM_DATA[$i-1] ne "" && $COM_DATA[$i-1] ne "\n"){
    print "<option value=\"$i\">$i [ $COM_DATA[$i-1] ]";
    }else{
    print "<option value=\"$i\">$i [ - ]";
    }
  }
print <<"EOM";
</select>
</td><td style="width:35%">
保存する位置、読み込む位置を選択:<br>
開始位置:<select name="first" id="first">
<option value="1" SELECTED>1
EOM
  for($i=2;$i<=$MAX_COM;$i++){
    print "<option value=\"$i\">$i";
  }
print <<"EOM";
</select>
終了位置:<select name="second" id="second">
<option value="1" SELECTED>1
EOM
  for($i=2;$i<=$MAX_COM;$i++){
    print "<option value=\"$i\">$i";
  }
print <<"EOM";
</select>
</td><th style="width:15%" rowspan="2">
<input type=submit id=input value="実行">
</th></tr>
<tr id="com_save_row2" style="display:none;"><td style="text-align:center;">
保存リストの名前（全角15文字以内）:<br>
<input type="text" name="name" id="name" value="" size="15">
</td></tr>
<tr id="com_save_row3" style="display:none;"><td colspan="4">※保存リストを読み込んだ際、保存リストより読み込む位置に指定された場所の方が広い場合、保存リストの内容を繰り返して読み込みます。<br>
　(例：保存リストを読み込む位置が開始位置2,終了位置13で、読み込む保存リストの内容が1:徴兵、2:兵士訓練、3:城の守備 の場合→コマンドリストのNO:2からNO:13まで徴兵→兵士訓練→城の守備のループになる。)
</td></tr>
</form>
<TR><TH colspan="4">次のターンまで$next_time分$next_sec秒</TH></TR>
<TR><TH colspan="4">放置削除ターンまで<span style="color:red;">$del_out</span>ターン</TH></TR>

</TBODY>
</TABLE>
</form>


<!-- マップ&行動ログ -->
<TABLE style="width:99%;margin:5px;background-color:$ELE_BG[$cou_ele[$kcon]];">
<TR>
  <TH id="mlog_th" style="width:50%;background-color:$ELE_BG[$country->color_id];width:33%;border:1px $ELE_C[$country->color_id] solid;"><span style="color:$ELE_C[$country->color_id];">マップログ</span></TH>
  <form action="./mylog2.cgi" method="post">
  <TH id="clog_th" style="width:50%;background-color:$ELE_BG[$country->color_id];width:34%;border:1px $ELE_C[$country->color_id] solid;"><span style="color:$ELE_C[$country->color_id];">行動ログ</span>
  <input type=hidden name=id value=$kid>
  <input type=hidden name=pass value=$kpass>
  <input type=submit value="もっと見る">
  </TH></form>
</TR>
<TR id="mlog">
  <TD style="width:50%;background-color:$TD_C1;">
EOM
for (@$map_log) {
  print qq{<span class="navy">●</span>$_<br>};
}
print <<"EOM";
  </TD>
  <TD style="width:50%;background-color:$ELE_C[$cou_ele[$kcon]];">
EOM
for (@{ $chara->command_logger->get(11) }) {
  print qq{<span class="green">●</span>$_<br>};
}
print <<"EOM";
  $ahaha
  </TD>
</TR>
</TABLE>


<!-- 手紙送信 -->
<br>
<a id="letter_"></a>
<HR color=$ELE_BG[$country->color_id] size=2>
<form action="$FILE_MYDATA" method="post">
手紙：<textarea name=message cols=60 rows=2>
</textarea>
  <select name=mes_id>
    <option value="@{[ $country->id ]}">@{[ $country->name ]}へ
    <option value="@{[ $chara->id ]}">@{[ $chara->name ]}へ
    <option value="111">@{[ $town->name ]}の人へ
    <option value="333">@{[ $unit->name ]}部隊の人へ
    $dilect_mes
  </select>
 <input type=hidden name=id value="@{[ $chara->id ]}">
 <input type=hidden name=name value="@{[ $chara->name ]}">
 <input type=hidden name=pass value="@{[ $chara->pass ]}">
 <input type=hidden name=mode value=MES_SEND>
 <input type="submit" id="input" value="送信">
</form>
<HR color=$ELE_BG[$country->color_id] size=2>


<!-- 手紙表示 -->
<TABLE id="tegami"><TBODY>
<TR><TD>

  <TABLE style="border-collapse:separate;border-spacing:0px;">
  <TR><TD id="man_title" style="border:2px #009900 solid;width:50%;padding:5px;background-color:#009900;"><strong style="color:#EEEEEE;">$kname宛て:($MES_MAN件)</strong></TD>
  </TABLE>

  <TABLE id="man" style="background-color:#009900;margin:0 0 5px 0;"><TBODY>
  $man_mes
  </TBODY></TABLE>

  <TABLE style="border-collapse:separate;border-spacing:0px;">
  <TD id="man2_title" style="border:2px #006600 solid;width:50%;padding:5px;background-color:#006600"><strong style="color:#EEEEEE;">$kname宛て密書:($MES_MAN件)</strong></TD></TR>
  </TABLE>

  <TABLE id="man2" style="background-color:#006600;margin:0 0 5px 0;"><TBODY>
  $man_mes2
  </TBODY></TABLE>

</TD><TD>
  <TABLE style="border-collapse:separate;border-spacing:0px;">
  <TR><TD id="cou_title" style="border:2px #000088 solid;width:34%;padding:5px;background-color:#000088"><strong style="color:#EEEEEE;">$xname宛て:($MES_COU件)</strong></TD>
  </TABLE>

  <TABLE id="cou" style="background-color:#000088;margin:0 0 5px 0;"><TBODY>
  $cou_mes
  </TBODY></TABLE>

  <TABLE style="border-collapse:separate;border-spacing:0px;">
  <TD id="unit_title" style="border:2px #AA8833 solid;width:33%;padding:5px;background-color:#AA8833"><strong style="color:#EEEEEE;">@{[ $unit->name ]}部隊宛て:($MES_UNI件)</strong></TD>
  </TABLE>

  <TABLE id="unit" style="background-color:#AA8833;margin:0 0 5px 0;"><TBODY>
  $unit_mes
  </TBODY></TABLE>

  <TABLE style="border-collapse:separate;border-spacing:0px;">
  <TD id="town_title" style="border:2px #880000 solid;width:33%;padding:5px;background-color:#880000"><strong style="color:#EEEEEE;">$znameの人々へ:($MES_ALL件)</strong></TD></TR>
  </TABLE>

  <TABLE id="town" style="background-color:#880000;margin:0 0 5px 0;"><TBODY>
  $all_mes
  </TBODY></TABLE>

</TD></TR>
</TBODY></TABLE>


<TABLE style="width:99%;border:0;"><TBODY><TR><TD style="text-align:right;">
<form action="./log.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input  value="手紙ログ"></form></TD></TR>
</TBODY></TABLE>


<!-- bm関係以外のjs -->
<script type="text/javascript"><!--

/* 手紙の名前のポップアップ部分 */
var num = 0;
\$(document).ready(function(){

$syosin_js

$prf_mes

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

/* 隠したりする部分 */
\$("#inline").click(function () {
  \$("#frame").toggle('blind','',700);
  \$("span#mes").toggle();
});

});

/* コマンドリスト保存表示切り替え */
  var com_save_str = document.getElementById('com_save_title').getElementsByTagName("span")[1];
  var com_save_str2 = document.getElementById('com_save_title').getElementsByTagName("span")[2];
  var com_save_row = document.getElementById('com_save_row');
  var com_save_row2 = document.getElementById('com_save_row2');
  var com_save_row3 = document.getElementById('com_save_row3');
  \$("#com_save_title").click(function () {
    if(com_save_row.style.display == "none"){
    com_save_row.style.display = "table-row";
    com_save_row2.style.display = "table-row";
    com_save_row3.style.display = "table-row";
    com_save_str.style.display = "none";
    com_save_str2.style.display = "inline";
    }else{
    com_save_row.style.display = "none";
    com_save_row2.style.display = "none";
    com_save_row3.style.display = "none";
    com_save_str.style.display = "inline";
    com_save_str2.style.display = "none";
    }
  });

/* コマンドリスと保存フォーム操作 */
  function save_limit(no){
    if(no == 67){
    document.getElementById('first').disabled = false;
    document.getElementById('second').disabled = false;
    document.getElementById('name').disabled = false;
    }else if(no == 68){
    document.getElementById('first').disabled = true;
    document.getElementById('second').disabled = true;
    document.getElementById('name').disabled = true;
    }else if(no == 69){
    document.getElementById('first').disabled = false;
    document.getElementById('second').disabled = false;
    document.getElementById('name').disabled = true;
    }else if(no == 70){
    document.getElementById('first').disabled = true;
    document.getElementById('second').disabled = true;
    document.getElementById('name').disabled = false;
    }else{
    document.getElementById('first').disabled = false;
    document.getElementById('second').disabled = false;
    document.getElementById('name').disabled = false;
    }
  }

/* 通知用 */
function check(MES){
  if(window.confirm(MES)){
    return true;
  }else{
    return false;
  }
}

--></script>

<script>

(function () {
  "use strict";
  var controll = new sangoku.player.mypage.controllCommand();
  controll.registFunctions();
}());

</script>

EOM

printf("%0.3f",Time::HiRes::time - $start_time);

  &FOOTER;
  exit;
}
