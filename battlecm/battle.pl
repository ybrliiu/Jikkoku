#_/_/_/_/_/_/_/_/_/_/#
#      戦闘          #
#_/_/_/_/_/_/_/_/_/_/#

use lib'./lib';
use Jikkoku::Model::Unite;
use Jikkoku::Model::Diplomacy;
use Jikkoku::Model::GameDate;

use constant {
  NONE => 0,
  WIN  => 1,
  LOSE => 2,
  DRAW => 3,
};

sub BATTLE {

  &TIME_DATA;
  ($ksingeki_time,$kanother) = split(/,/,$kskldata);

#バトルマップ読み込み
  do "./log_file/map_hash/$kiti.pl";

#年月表示#

  $month_read = "$LOG_DIR/date_count.cgi";
  open(IN,"$month_read") or &ERR2("Can\'t file open!:month_read");
  @MONTH_DATA = <IN>;
  close(IN);
  ($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
  $old_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
  $wyear=$F_YEAR+$myear;

#相手武将データオープン#

  if($in{'eid'} eq ""){&ERR("相手武将が選択されていません。");}
  if($in{'eid'} eq "jyouhekisyugohei"){
  $d_hit = 0;
  }else{
  $d_hit = 1;
  }

  if($d_hit){

  &ENEMY_OPEN;

  if($esol <= 0){
    &ERR("兵士0人では戦闘できません。");
  }elsif(!$esyuppei){
    &ERR("指定した相手武将は出撃していません。");
  }elsif($kiti ne $eiti){
    &ERR("相手と同じマップ上にいません。$eid,$eiti,$kid,$kiti");
  }elsif($kcon eq $econ){
    &ERR("同士打ちはできません。");
  }
  $last_battle=0;
  $ebukinasi = 0;
  if(!$engohit){
    $zsa = abs($kx-$ex);
    $zsa2 = abs($ky-$ey);
    $zsa3 = $zsa+$zsa2;
  }else{
    $zsa3 = $engosa;
  }
  if($zsa3 > $SOL_AT[$ksub1_ex]){
    &ERR("攻撃が敵に届きません。");
  }
  if(($earm eq "")&&($eaname eq "")&&($eazoku eq "")&&($eaai eq "")){$ebukinasi = 1;}


  #相手武将が城壁の時#

  }else{

  $tikeishiro = 0;
  for($i=0;$i<$BM_Y;$i++){
    for($j=0;$j<$BM_X;$j++){
      if($BM_TIKEI[$i][$j] == 18 || $BM_TIKEI[$i][$j] == 22){
      $fx = $j;
      $fy = $i;
      $tikeishiro = 1;
      last;
      }
    }
    if($tikeishiro){last;}
  }


  #城の上に相手武将いるか検索#

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

  $tekiiru = 0;

  foreach(@CL_DATA){
  ($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

  ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

  ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);

    if($kiti eq $eiti){
      if($kcon ne $econ){
      if($ex == $fx && $ey == $fy){
      $tekiiru = 1;
      last;
      }
      }
    }
  }

  if($tekiiru){&ERR("城の上に敵の武将がいます。");}
  if(!$tikeishiro){&ERR("フォームに不正な値が含まれています。");}
  if($zcon eq $kcon){&ERR("自国の城です。");}
  $zsa = abs($kx-$fx);
  $zsa2 = abs($ky-$fy);
  $zsa3 = $zsa+$zsa2;
  if($zsa3 > $SOL_AT[$ksub1_ex]){&ERR("攻撃が城壁に届きません。");}

  $ename = "城壁";
  $econ = $zcon;
  $eiti = $kiti;
  $koujyou++;
  $eran = int(rand(8));
  if($eran eq "0"){$ecm = "こ、殺さないでくれ・・・！";}
  elsif($eran eq "1"){$ecm = "死ぬ・・・。マジで、死ぬ・・・";}
  elsif($eran eq "2"){$ecm = "あ〜ぁ、城壁崩れてきたじゃねぇか・・・。";}
  elsif($eran eq "3"){$ecm = "ちょっと城壁修復してくるわ";}
  elsif($eran eq "4"){$ecm = "$knameよ、根性が足りんぞ！";}
  elsif($eran eq "5"){$ecm = "$znameはオラ達が守るベ！";}
  elsif($eran eq "6"){$ecm = "熱い戦いだったな！";}
  else{$ecm = "守りきったぞ！";}
  $esol = $zshiro;
  $estr = int($zdef_att*0.055)+20;
  $egat = int($zdef_att*0.13)+40;
  $ejinkei=0;
  $esakup=0;
  $earm=0;
  $emes=0;
  $eint=0;
  $elea=0;
  $echa=0;
  $ehohei="";
  $ebookskl="";
  $ebouskl="";
  $eksup=0;
  $emsup=0;
  $est="";
  $last_battle=1;
  if(($zshiro >= 8000)&&($zsub1 >= 8000)&&($znum >= 80000)&&($znou >= 8000)&&($zsyo >= 8000)&&($zdef_att >= 8000)){
  $esub1_ex=4;
  $koukenherasi=1;
  }elsif(($zshiro >= 4000)&&($zsub1 >= 4000)&&($znum >= 40000)&&($znou >= 4000)&&($zsyo >= 4000)&&($zdef_att >= 4000)){
  $esub1_ex=4;
  $koukenherasi=1;
  }elsif(($zshiro >= 1000)&&($znum >= 10000)&&($znou >= 1000)&&($zsyo >= 1000)&&($zsub1 >= 1000)&&($zdef_att >= 1000)){
  $esub1_ex=8;
  $koukenherasi=1;
  }elsif(($zshiro > 500)&&($znum > 5000)&&($znou > 500)&&($zsyo > 500)&&($zsub1 > 500)&&($zdef_att > 500)){
  $esub1_ex=1;
  $koukenherasi=1;
  }else{$esub1_ex="0";}

  }
  if($econ eq "" || $econ eq "0"){$cou_name[$econ] = "無所属";}


#侵攻防衛判定#
  if($kiti =~ /-/){
    @kitilist=split(/-/,$kiti);
    $kiti_1=$kitilist[0];
    $kiti_2=$kitilist[1];
    if($town_cou[$kiti_1] != $kcon || $town_cou[$kiti_2] != $kcon){
    $ksinko=1;
    $ksinkomes="侵攻";
    }else{
    $ksinko=0;
    $ksinkomes="防衛";
    }
    if($town_cou[$kiti_1] != $econ || $town_cou[$kiti_2] != $econ){
    $esinko=1;
    $esinkomes="侵攻";
    }else{
    $esinko=0;
    $esinkomes="防衛";
    }
  }else{
    if($town_cou[$kiti] == $kcon){
    $ksinko=0;
    $ksinkomes="防衛";
    }else{
    $ksinko=1;
    $ksinkomes="侵攻";
    }
    if($town_cou[$kiti] == $econ){
    $esinko=0;
    $esinkomes="防衛";
    }else{
    $esinko=1;
    $esinkomes="侵攻";
    }
  }


#宣戦布告確認#

  my $now_game_date   = Jikkoku::Model::GameDate->new->get;
  my $diplomacy_model = Jikkoku::Model::Diplomacy->new;
  my $can_attack = $diplomacy_model->can_attack( $kcon, $econ, $now_game_date );
  $can_attack = 1 if $econ eq '' || $econ == 0 || $esinko || $kcon == 0;
  ERR('宣戦布告をしていないか、まだ開戦時間ではありません。<br>'
    . '※ 他国と戦争するには、国の幹部の人が司令部から宣戦布告をしないとできません。') unless $can_attack;


#戦闘禁止期間#

  open(IN,"$COUNTRY_LIST");
  @COU_DATA = <IN>;
  close(IN);
  @NEW_COU_DATA=();
  $zvhit=0;
  foreach(@COU_DATA){
    ($xvcid,$xvname,$xvele,$xvmark,$xvking,$xvmes,$xvsub,$xvpri)=split(/<>/);
      ($xvgunshi,$xvdai,$xvuma,$xvgoei,$xvyumi,$xvhei,$xvxsub1,$xvxsub2)= split(/,/,$xvsub);
    if($xvcid eq $econ){$zvhit=1;last;}
  }
  if ($zvhit && $xvmark < $BATTLE_STOP) {
    &ERR("$mmonth月:$xvnameにはまだ攻められません。（@{[ $BATTLE_STOP - $xvmark ]}ターン）");
  } else {
    &COUNTRY_DATA_OPEN("$kcon");
    if ($xmark < $BATTLE_STOP && $kcon ne 0) {
      &ERR("$mmonth月:$xnameはまだ攻められません。（@{[ $BATTLE_STOP - $xmark ]}ターン）");
    } else {


#役職補正、表示（自分）#

  $katt_add2 = 0;
  $katt_def2 = 0;
  if($xking eq "$kid"){
    $rank_mes = "【君主】";
    $katt_add2 = 10;
    $katt_def2 = 10;
  }elsif($xgunshi eq "$kid"){
    $rank_mes = "【軍師】";
    $katt_add2 = 10;
  }elsif($xdai eq "$kid"){
    $rank_mes = "【大将軍】";
    $katt_add2 = 20;
  }elsif($xuma eq "$kid"){
    $rank_mes = "【騎馬将軍】";
    $katt_add2 = 15;
  }elsif($xgoei eq "$kid"){
    $rank_mes = "【護衛将軍】";
    $katt_def2 = 10;
  }elsif($xyumi eq "$kid"){
    $rank_mes = "【弓将軍】";
    $katt_add2 = 10;
  }elsif($xhei eq "$kid"){
    $rank_mes = "【将軍】";
    $katt_add2 = 10;
  }elsif($xxsub1 eq "$kid"){
    $rank_mes = "【宰相】";
  }


#役職補正、表示（相手）#

  if(!$last_battle){


  $eatt_add2 = 0;
  $eatt_def2 = 0;
  if($xvking eq "$eid"){
    $erank_mes = "【君主】";
    $eatt_add2 = 10;
    $eatt_def2 = 10;
  }elsif($xvgunshi eq "$eid"){
    $erank_mes = "【軍師】";
    $eatt_add2 = 10;
  }elsif($xvdai eq "$eid"){
    $erank_mes = "【大将軍】";
    $eatt_add2 = 20;
  }elsif($xvuma eq "$eid"){
    $erank_mes = "【騎馬将軍】";
    $eatt_add2 = 15;
  }elsif($xvgoei eq "$eid"){
    $erank_mes = "【護衛将軍】";
    $eatt_def2 = 10;
  }elsif($xvyumi eq "$eid"){
    $erank_mes = "【弓将軍】";
    $eatt_add2 = 10;
  }elsif($xvhei eq "$eid"){
    $erank_mes = "【将軍】";
    $eatt_add2 = 10;
  }elsif($xvxsub1 eq "$eid"){
    $erank_mes = "【宰相】";
  }

  }


#武器なし#

  $bukinasi = 0;
  if(($karm eq "")&&($kaname eq "")&&($kazoku eq "")&&($kaai eq "")){$bukinasi = 1;}

#ログ#

  if($engohit){&E_LOG("<font color=#FF69B4>【掩護】</font>$mmonth月:$mae_nameの掩護に入りました！");&E_LOG2("<b><font color=#FF69B4>【掩護】</font>$mmonth月:$mae_nameの掩護に入りました！</b>");}
  &K_LOG("<font color=red>【戦闘】</font>$mmonth月:$xnameの$kname$rank_mesは$cou_name[$econ]の$ename$erank_mesと$battkemapnameで戦闘しました！");
  &E_LOG("<font color=red>【戦闘】</font>$mmonth月:$xnameの$kname$rank_mesは$cou_name[$econ]の$ename$erank_mesと$battkemapnameで戦闘しました！");
  &K_LOG2("<b>$mmonth月:$xnameの$kname$rank_mesは$cou_name[$econ]の$ename$erank_mesと$battkemapnameで戦闘しました！</b>");
  &E_LOG2("<b>$mmonth月:$xnameの$kname$rank_mesは$cou_name[$econ]の$ename$erank_mesと$battkemapnameで戦闘しました！</b>");

#反撃不可能処理#

  if($zsa3 > $SOL_AT[$esub1_ex] && !$last_battle){
    $riitibusoku = 1;
    &K_LOG2("<font color=red>【反撃不可】</font>$knameの部隊が射程圏内に入ってないので$enameは反撃できない！");
    &E_LOG2("<font color=blue>【反撃不可】</font>$knameの部隊が射程圏内に入ってないので$enameは反撃できない！");    
  }else{
    $riitibusoku = 0;
  }

#乱戦処理#

  if($zsa3 <= 1 && !$last_battle){
    $turnpuras = 1;
    &K_LOG2("<font color=red>【乱戦】</font>$knameの部隊と$enameの部隊の間の距離が近かった為乱戦になりました。ターン数+1");
    &E_LOG2("<font color=red>【乱戦】</font>$knameの部隊と$enameの部隊の間の距離が近かった為乱戦になりました。ターン数+1");
  }else{
    $turnpuras = 0;
  }

#待機時間と移動時間#

  $kkoutime = $idate+$BMT_REMAKE;
  if($kbattletime < $idate+$BMT_REMAKE){
    #移動スキル lib/skl_lib.pl
    &IDOUSKL2;
  }
  $kidoup = 0;


#兵種計算#

  require './lib/hs_keisan.pl';
  ($katt_add,$katt_def) = &HS_KEISAN(1,$last_battle,$ksub1_ex,$kstr,$kint,$klea,$kcha,$karm,$kbook,$kmes);
  ($eatt_add,$eatt_def) = &HS_KEISAN(0,$last_battle,$esub1_ex,$estr,$eint,$elea,$echa,$earm,$ebook,$emes);


#武器有利属性#
    $bukiyuri{"歩"} = "弓";
    $bukiyuri{"弓"} = "騎";
    $bukiyuri{"騎"} = "歩";
    $bukiyuri{"水"} = "機";
    $bukiyuri2{"弓"} = "弓騎";
    $bukiyuri2{"歩"} = "弓騎";


#自分武器相性#

    if($SOL_ZOKSEI[$ksub1_ex] eq "$kazoku" && (($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri{"$kazoku"})||($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri2{"$kazoku"}))){
      $kai = int($kaai);
      if($SOL_ZOKSEI[$ksub1_ex] eq "水" && $kazoku eq "水" && $SOL_ZOKSEI[$esub1_ex] eq "機"){
        $kai = int($kaai*2);
      }
      $kaai+=0.45;
      $kaaiwin=1;
      &K_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$kai</font>上昇しました！!");
      &E_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$kai</font>上昇してしまいました。。");
    }elsif(($kazoku eq "騎" && $SOL_ZOKSEI[$ksub1_ex] eq "弓騎") && (($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri{"$kazoku"}) || ($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri2{"$kazoku"}))){
      $kai = int($kaai);
      $kaai+=0.45;
      $kaaiwin=1;
      &K_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$kai</font>上昇しました！!");
      &E_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$kai</font>上昇してしまいました。。");
    }elsif(($kazoku eq "弓" && $SOL_ZOKSEI[$ksub1_ex] eq "弓騎") && (($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri{"$kazoku"}) || ($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri2{"$kazoku"}))){
      $kai = int($kaai);
      $kaai+=0.45;
      $kaaiwin=1;
      &K_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$kai</font>上昇しました！!");
      &E_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$kai</font>上昇してしまいました。。");
    }elsif(($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri{"$kazoku"})||($SOL_ZOKSEI[$esub1_ex] eq $bukiyuri2{"$kazoku"})){
      $kai = int($kaai / 2);
      $kaai+=0.45;
      $kaaiwin=1;
      &K_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$kai</font>上昇しました！!");
      &E_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$kai</font>上昇してしまいました。。");
    }elsif($SOL_ZOKSEI[$ksub1_ex] eq "機" && $kazoku eq "機"){
      $kai = int($kaai);
      $kaai+=0.45;
      $kaaiwin=1;
      &K_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$kai</font>上昇しました！!");
      &E_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$kai</font>上昇してしまいました。。");
    }elsif($SOL_ZOKSEI[$ksub1_ex] eq "水" && $kazoku eq "水"){
      $kai = int($kaai);
      $kaai+=0.45;
      $kaaiwin=1;
      &K_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$kai</font>上昇しました！!");
      &E_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$kai</font>上昇してしまいました。。");
    }else{
      $kai = 0;
      $kaaiwin=0;
    }

#相手武器相性#

    if($SOL_ZOKSEI[$esub1_ex] eq "$eazoku" && (($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri{"$eazoku"})||($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri2{"$eazoku"}))){
      $eai = int($eaai);
      if($SOL_ZOKSEI[$esub1_ex] eq "水" && $eazoku eq "水" && $SOL_ZOKSEI[$ksub1_ex] eq "機"){
        $eai = int($eaai*2);
      }
      $eaai+=0.45;
      $eaaiwin=1;
      &E_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$eai</font>上昇しました！!");
      &K_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$eai</font>上昇してしまいました。。");
    }elsif(($eazoku eq "騎" && $SOL_ZOKSEI[$esub1_ex] eq "弓騎") && (($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri{"$eazoku"}) || ($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri2{"$eazoku"}))){
      $eai = int($eaai);
      $eaai+=0.45;
      $eaaiwin=1;
      &E_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$eai</font>上昇しました！!");
      &K_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$eai</font>上昇してしまいました。。");
    }elsif(($eazoku eq "弓" && $SOL_ZOKSEI[$esub1_ex] eq "弓騎") && (($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri{"$eazoku"}) || ($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri2{"$eazoku"}))){
      $eai = int($eaai);
      $eaai+=0.45;
      $eaaiwin=1;
      &E_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$eai</font>上昇しました！!");
      &K_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$eai</font>上昇してしまいました。。");
    }elsif(($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri{"$eazoku"})||($SOL_ZOKSEI[$ksub1_ex] eq $bukiyuri2{"$eazoku"})){
      $eai = int($eaai / 2);
      $eaai+=0.45;
      $eaaiwin=1;
      &E_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$eai</font>上昇しました！!");
      &K_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$eai</font>上昇してしまいました。。");
    }elsif($SOL_ZOKSEI[$esub1_ex] eq "機" && $eazoku eq "機"){
      $eai = int($eaai);
      $eaai+=0.45;
      $eaaiwin=1;
      &E_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$eai</font>上昇しました！!");
      &K_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$eai</font>上昇してしまいました。。");
    }elsif($SOL_ZOKSEI[$esub1_ex] eq "水" && $eazoku eq "水"){
      $eai = int($eaai);
      $eaai+=0.45;
      $eaaiwin=1;
      &E_LOG2("<font color=red>【武器相性】</font>自軍の攻撃力が<font color=red>$eai</font>上昇しました！!");
      &K_LOG2("<font color=blue>【武器相性】</font>敵軍の攻撃力が<font color=blue>$eai</font>上昇してしまいました。。");
    }else{
      $eai = 0;
      $eaaiwin=0;
    }

#戦闘#
    $kkou = int($kstr + $karm + $katt_add + $katt_add2 + $kai);
    $ekou = int($estr + $earm + $eatt_add + $eatt_add2 + $eai);
    $kbou = int($katt_def + $katt_def2 + $kmes + int($kgat / 2));
    $ebou = int($eatt_def + $eatt_def2 + $emes + int($egat / 2));

  #状態処理(自分)#
  if($kago > $idate){ $kagoup = int($kbou*0.07)+5;
    if($kbou < 0){ $kagoup = 5; }
  &K_LOG2("<font color=red>【加護【小】】</font>自軍の防御力が<font color=red>$kagoup</font>上昇しました！!");
  &E_LOG2("<font color=blue>【加護【小】】</font>敵軍の防御力が<font color=blue>$kagoup</font>上昇しました！!");
  }if($kyoudou > $idate){ $kyoudown = int($kkou*0.07);
  &K_LOG2("<font color=blue>【陽動【小】】</font>自軍の攻撃力が<font color=blue>$kyoudown</font>低下しました！!");
  &E_LOG2("<font color=red>【陽動【小】】</font>敵軍の攻撃力が<font color=red>$kyoudown</font>低下しました！!");
  }if($ksendou > $idate){ $ksendown = int($kbou*0.07)+5;
    if($kbou < 0){ $ksendown = 5; }
  &K_LOG2("<font color=blue>【扇動【小】】</font>自軍の防御力が<font color=blue>$ksendown</font>低下しました！!");
  &E_LOG2("<font color=red>【扇動【小】】</font>敵軍の防御力が<font color=red>$ksendown</font>低下しました！!");
  }if($kobu > $idate){ $kobup = int($kkou*0.07);
  &K_LOG2("<font color=red>【鼓舞【小】】</font>自軍の攻撃力が<font color=red>$kobup</font>上昇しました！!");
  &E_LOG2("<font color=blue>【鼓舞【小】】</font>敵軍の攻撃力が<font color=blue>$kobup</font>上昇しました！!");
  }if($kagoL > $idate){ $kagoupL = int($kbou*0.15)+10;
    if($kbou < 0){ $kagoupL = 10; }
  &K_LOG2("<font color=red>【加護【大】】</font>自軍の防御力が<font color=red>$kagoupL</font>上昇しました！!");
  &E_LOG2("<font color=blue>【加護【大】】</font>敵軍の防御力が<font color=blue>$kagoupL</font>上昇しました！!");
  }if($kyoudouL > $idate){ $kyoudownL = int($kkou*0.15);
  &K_LOG2("<font color=blue>【陽動【大】】</font>自軍の攻撃力が<font color=blue>$kyoudownL</font>低下しました！!");
  &E_LOG2("<font color=red>【陽動【大】】</font>敵軍の攻撃力が<font color=red>$kyoudownL</font>低下しました！!");
  }if($ksendouL > $idate){ $ksendownL = int($kbou*0.15)+10;
    if($kbou < 0){ $ksendownL = 10; }
  &K_LOG2("<font color=blue>【扇動【大】】</font>自軍の防御力が<font color=blue>$ksendownL</font>低下しました！!");
  &E_LOG2("<font color=red>【扇動【大】】</font>敵軍の防御力が<font color=red>$ksendownL</font>低下しました！!");
  }if($kobuL > $idate){ $kobupL = int($kkou*0.15);
  &K_LOG2("<font color=red>【鼓舞【大】】</font>自軍の攻撃力が<font color=red>$kobupL</font>上昇しました！!");
  &E_LOG2("<font color=blue>【鼓舞【大】】</font>敵軍の攻撃力が<font color=blue>$kobupL</font>上昇しました！!");
  }

  #状態処理(相手)#
  if($eago > $idate){ $eagoup = int($ebou*0.07)+5;
    if($ebou < 0){ $eagoup = 5; }
  &E_LOG2("<font color=red>【加護【小】】</font>自軍の防御力が<font color=red>$eagoup</font>上昇しました！!");
  &K_LOG2("<font color=blue>【加護【小】】</font>敵軍の防御力が<font color=blue>$eagoup</font>上昇しました！!");
  }if($eyoudou > $idate){ $eyoudown = int($ekou*0.07);
  &E_LOG2("<font color=blue>【陽動【小】】</font>自軍の攻撃力が<font color=blue>$eyoudown</font>低下しました！!");
  &K_LOG2("<font color=red>【陽動【小】】</font>敵軍の攻撃力が<font color=red>$eyoudown</font>低下しました！!");
  }if($esendou > $idate){ $esendown = int($ebou*0.07)+5;
    if($ebou < 0){ $esendown = 5; }
  &E_LOG2("<font color=blue>【扇動【小】】</font>自軍の防御力が<font color=blue>$esendown</font>低下しました！!");
  &K_LOG2("<font color=red>【扇動【小】】</font>敵軍の防御力が<font color=red>$esendown</font>低下しました！!");
  }if($eobu > $idate){ $eobup = int($ekou*0.07);
  &E_LOG2("<font color=red>【鼓舞【小】】</font>自軍の攻撃力が<font color=red>$eobup</font>上昇しました！!");
  &K_LOG2("<font color=blue>【鼓舞【小】】</font>敵軍の攻撃力が<font color=blue>$eobup</font>上昇しました！!");
  }if($eagoL > $idate){ $eagoupL = int($ebou*0.15)+10;
    if($ebou < 0){ $eagoupL = 10; }
  &E_LOG2("<font color=red>【加護【大】】</font>自軍の防御力が<font color=red>$eagoupL</font>上昇しました！!");
  &K_LOG2("<font color=blue>【加護【大】】</font>敵軍の防御力が<font color=blue>$eagoupL</font>上昇しました！!");
  }if($eyoudouL > $idate){ $eyoudownL = int($ekou*0.15);
  &E_LOG2("<font color=blue>【陽動【大】】</font>自軍の攻撃力が<font color=blue>$eyoudownL</font>低下しました！!");
  &K_LOG2("<font color=red>【陽動【大】】</font>敵軍の攻撃力が<font color=red>$eyoudownL</font>低下しました！!");
  }if($esendouL > $idate){ $esendownL = int($ebou*0.15)+10;
    if($ebou < 0){ $esendownL = 10; }
  &E_LOG2("<font color=blue>【扇動【大】】</font>自軍の防御力が<font color=blue>$esendownL</font>低下しました！!");
  &K_LOG2("<font color=red>【扇動【大】】</font>敵軍の防御力が<font color=red>$esendownL</font>低下しました！!");
  }if($eobuL > $idate){ $eobupL = int($ekou*0.15);
  &E_LOG2("<font color=red>【鼓舞【大】】</font>自軍の攻撃力が<font color=red>$eobupL</font>上昇しました！!");
  &K_LOG2("<font color=blue>【鼓舞【大】】</font>敵軍の攻撃力が<font color=blue>$eobupL</font>上昇しました！!");
  }

  #強襲処理#
  if($mode2 eq "KYOSYU" && $kskl4 =~ /4/){
    if($last_battle){&ERR("攻城に強襲は使用できません。");}
    if($ksiki < $MOR_KYOSYU){&ERR("士気が足りないので強襲は使用できません。");}
  $kyosyupar = (int($kstr/50)+3)/100;
  $kyosyuup = int($kkou*$kyosyupar);
  $kyosyuub = int($kbou*$kyosyupar);
    if($kbou < 0){ $kyosyuub = 0; }
  $eyosyuup = int($ekou*$kyosyupar);
  $eyosyuub = int($ebou*$kyosyupar);
    if($ebou < 0){ $eyosyuub = 0; }
  $kyosyuf = 1;
  $ksiki -= $MOR_KYOSYU;
  $kyosyuparH = $kyosyupar*100;
  &K_LOG2("<font color=red>【強襲】</font>$knameが強襲を仕掛けました。自軍の攻守が<font color=red>$kyosyuparH</font>%上昇、相手の攻守が<font color=red>$kyosyuparH</font>%低下しました！!");
  &E_LOG2("<font color=blue>【強襲】</font>$knameが強襲を仕掛けました。自軍の攻守が<font color=red>$kyosyuparH</font>%低下、相手の攻守が<font color=red>$kyosyuparH</font>%上昇しました。。");
  }

  #波状攻撃処理#
  if($mode2 eq "HAJYO" && $kskl7 =~ /4/){
    if($ksiki < $MOR_HAJYO){&ERR("士気が足りないので波状攻撃は使用できません。");}
  $kkoutime -= $BMT_REMAKE/3;
  $khajyo = 1;
  $ksiki -= $MOR_HAJYO;
  &K_LOG2("<font color=red>【波状攻撃】</font>$knameは波状攻撃モードで戦闘を仕掛けました！$knameの行動待機時間が短縮されています！");
  &E_LOG2("<font color=blue>【波状攻撃】</font>$knameは波状攻撃モードで戦闘を仕掛けました！$knameの行動待機時間が短縮されています！");
  }

  #包囲戦処理#
  if($mode2 eq "HOUI" && $kskl5 =~ /3/ && $esol <= 30){
  if($last_battle){&ERR("攻城に包囲は使用できません。");}
  if($ksiki < $MOR_HOUI){&ERR("士気が足りないので包囲は使用できません。");}
    if($ksol > $esol){
    $houiup = int(($ksol-$esol)*1.5);
    }else{
    $houiup = 0;
    }
  $ksiki -= $MOR_HOUI;
  &K_LOG2("<font color=red>【包囲】</font>$knameが$enameを包囲しました。$knameの攻撃力が<font color=red>+$houiup</font>されました！");
  &E_LOG2("<font color=blue>【包囲】</font>$enameは$knameに包囲されました。$knameの攻撃力が<font color=red>+$houiup</font>されました。。");
  }


  #陣形処理#
  open(IN,"./log_file/jinkei.cgi") or &ERR2("陣形データ読み込み失敗");
  @JINKEI = <IN>;
  close(IN);
  $i = 0;
  if($kjinkei eq ""){$kjinkei=0;}
  if($ejinkei eq ""){$ejinkei=0;}
  foreach(@JINKEI){
  ($jinname,$jinaup,$jindup,$jinaup2,$jindup2,$jinaup3,$jindup3,$jin_tokui,$jinchange,$jinclas,$jinsetumei,$jinsub,$jinsub2)=split(/<>/);
    if($kjinkei eq $i){
      $kjinname = $jinname;
      $kjinaup = $jinaup;
      $kjinaup2 = $jinaup2;
      $kjinaup3 = $jinaup3;
      $kjindup = $jindup;
      $kjindup2 = $jindup2;
      $kjindup3 = $jindup3;
      $kjin_tokui = "$jin_tokui";
    }if($ejinkei eq $i){
      $ejinname = $jinname;
      $ejinaup = $jinaup;
      $ejinaup2 = $jinaup2;
      $ejinaup3 = $jinaup3;
      $ejindup = $jindup;
      $ejindup2 = $jindup2;
      $ejindup3 = $jindup3;
      $ejin_tokui = "$jin_tokui";
    }
  $i++;
  }
  
    #陣形攻守補正
  if($idate < $ksakup){  #陣形変更中の処理（攻守-10%）#
  $kjinhenkdn = int($kkou*0.1);
  $kjinhenbdn = int($kbou*0.1);
    if($kbou < 0){ $kjinhenbdn = 0; }
  $nokjinh = 1;
  &K_LOG2("<font color=red>【陣形整え中...】</font>$knameは陣形を整えている途中なので攻撃力が<font color=red>-$kjinhenkdn</font>、守備力が<font color=red>-$kjinhenbdn</font>されました。。");
  &E_LOG2("<font color=blue>【陣形整え中...】</font>$knameは陣形を整えている途中なので攻撃力が<font color=red>-$kjinhenkdn</font>、守備力が<font color=red>-$kjinhenbdn</font>されました。");
  }else{
  $nokjinh = 0;
  }if($idate < $esakup){
  $ejinhenkdn = int($ekou*0.1);
  $ejinhenbdn = int($ebou*0.1);
    if($ebou < 0){ $ejinhenbdn = 0; }
  $noejinh = 1;
  &K_LOG2("<font color=blue>【陣形整え中...】</font>$enameは陣形を整えている途中なので攻撃力が<font color=red>-$ejinhenkdn</font>、守備力が<font color=red>-$ejinhenbdn</font>されました。");
  &E_LOG2("<font color=red>【陣形整え中...】</font>$enameは陣形を整えている途中なので攻撃力が<font color=red>-$ejinhenkdn</font>、守備力が<font color=red>-$ejinhenbdn</font>されました。。");
  }else{
  $noejinh = 0;
  }        #-----#

if(!$nokjinh){        #通常時陣形処理#
  if($kjin_tokui =~ /$ejinname/){
  $kjinkup = int($kkou*$kjinaup2)+$kjinaup3;
  $kjinbup = int($kbou*$kjindup2)+$kjindup3;
  }else{
  $kjinkup = int($kkou*$kjinaup)+$kjinaup3;
  $kjinbup = int($kbou*$kjindup)+$kjindup3;
  }
}
if($kbou < 0){ $kjinbup = $kjindup3; }

if(!$noejinh){
  if($ejin_tokui =~ /$kjinname/){
  $ejinkup = int($ekou*$ejinaup2)+$ejinaup3;
  $ejinbup = int($ebou*$ejindup2)+$ejindup3;
  }else{
  $ejinkup = int($ekou*$ejinaup)+$ejinaup3;
  $ejinbup = int($ebou*$ejindup)+$ejindup3;
  }
}
if($ebou < 0){ $ejinbup = $ejindup3; }  #-----#

    #特殊陣形処理
  if($kjinkei == 9 && !$nokjinh){  #彎月陣#
    if($ksol <= $esol/4){
    $kjinkup = $esol-$ksol;
      if($kjinkup > 80){$kjinkup = 80;}
    $kjinbup = 0;
    }else{
    $kjinkup = 0;
    $kjinbup = 0;
    }
  }elsif($kjinkei == 10 && !$nokjinh){  #鶴翼陣#
    if($ksol >= $esol*4){
    $kjinkup = $ksol-$esol;
      if($kjinkup > 80){$kjinkup = 80;}
    $kjinbup = 0;
    }else{
    $kjinkup = 0;
    $kjinbup = 0;
    }
  }elsif($kjinkei == 11 && !$nokjinh){  #玄襄陣#
  $kjinkup = 0;
  $kjinbup = 0;
  $ejinkdn = int($ekou*0.15);
  $ejinbdn = int($ebou*0.15);
  if($ebou < 0){ $ejinbdn = 0; }
  }

  if($ejinkei == 9){
    if($esol <= $ksol/4 && !$noejinh){
    $ejinkup = $ksol-$esol;
      if($ejinkup > 80){$ejinkup = 80;}
    $ejinbup = 0;
    }else{
    $ejinkup = 0;
    $ejinbup = 0;
    }
  }elsif($ejinkei == 10 && !$noejinh){
    if($esol >= $ksol*4){
    $ejinkup = $esol-$ksol;
      if($ejinkup > 80){$ejinkup = 80;}
    $ejinbup = 0;
    }else{
    $ejinkup = 0;
    $ejinbup = 0;
    }
  }elsif($ejinkei == 11 && !$noejinh){
  $ejinkup = 0;
  $ejinbup = 0;
  $kjinkdn = int($kkou*0.15);
  $kjinbdn = int($kbou*0.15);
  if($kbou < 0){ $kjinbdn = 0; }
  }



  #水軍　水系地形以外の時攻守-25%#
  if($SOL_ZOKSEI[$ksub1_ex] eq "水"){
    if($BM_TIKEI[$ky][$kx]!=5 && $BM_TIKEI[$ky][$kx]!=8 && $BM_TIKEI[$ky][$kx]!=9 && $BM_TIKEI[$ky][$kx]!=10 && $BM_TIKEI[$ky][$kx]!=22){
    $kkousui = int($kkou*0.25);
    $kbousui = int($kbou*0.25);
    if($kbou < 0){ $kbousui = 0; }
    &K_LOG2("<font color=#00BFFF>【水軍不適応地形】</font>$knameの攻撃力が<font color=red>-$kkousui</font>、守備力が<font color=red>-$kbousui</font>されました。。");
    &E_LOG2("<font color=#00BFFF>【水軍不適応地形】</font>$knameの攻撃力が<font color=red>-$kkousui</font>、守備力が<font color=red>-$kbousui</font>されました！");
    }
    
  }if($SOL_ZOKSEI[$esub1_ex] eq "水"){
    if($BM_TIKEI[$ey][$ex]!=5 && $BM_TIKEI[$ey][$ex]!=8 && $BM_TIKEI[$ey][$ex]!=9 && $BM_TIKEI[$ey][$ex]!=10 && $BM_TIKEI[$ey][$ex]!=22){
    $ekousui = int($ekou*0.25);
    $ebousui = int($ebou*0.25);
    if($ebou < 0){ $ebousui = 0; }
    &K_LOG2("<font color=#00BFFF>【水軍不適応地形】</font>$enameの攻撃力が<font color=red>-$ekousui</font>、守備力が<font color=red>-$ebousui</font>されました。。");
    &E_LOG2("<font color=#00BFFF>【水軍不適応地形】</font>$enameの攻撃力が<font color=red>-$ekousui</font>、守備力が<font color=red>-$ebousui</font>されました！。");
    }
  }


    #侵攻スキル
    if(($kskl7 =~ /3/ || $kskl7 =~ /4/) && $kstr >= 130 && $ksinko){
    my $kaplus=5;
    if($kskl7 =~ /3/ && $kskl7 =~ /4/){ $kaplus=10; }
    my $ksinko_at = int($kkou*($kaplus/100));
    my $ksinko_bo = int($kbou*($kaplus/100));
    $kjinkup += $ksinko_at;
    $kjinbup += $ksinko_bo;
    &K_LOG2("<font color=red>【侵攻スキル】</font>$knameの攻撃力が<font color=red>+$ksinko_at</font>、守備力が+<font color=red>$ksinko_bo</font>されました！");
    &E_LOG2("<font color=blue>【侵攻スキル】</font>$knameの攻撃力が<font color=red>+$ksinko_at</font>、守備力が+<font color=red>$ksinko_bo</font>されました！");
    }
    if(($eskl7 =~ /3/ || $eskl7 =~ /4/) && $estr >= 130 && $esinko){
    my $eaplus=5;
    if($eskl7 =~ /3/ && $eskl7 =~ /4/){ $eaplus=10; }
    my $esinko_at = int($ekou*($eaplus/100));
    my $esinko_bo = int($ebou*($eaplus/100));
    $ejinkup += $esinko_at;
    $ejinbup += $esinko_bo;
    &K_LOG2("<font color=blue>【侵攻スキル】</font>$enameの攻撃力が<font color=red>+$esinko_at</font>、守備力が+<font color=red>$esinko_bo</font>されました！");
    &E_LOG2("<font color=red>【侵攻スキル】</font>$enameの攻撃力が<font color=red>+$esinko_at</font>、守備力が+<font color=red>$esinko_bo</font>されました！");
    }


    #進撃
    if($kskl7 =~ /2/ && $kstr >= 115){
      if($ksingeki_time - $idate <= 1200 && $ksingeki_time - $idate > 790 && $ksinko){
        my $plus = int $kkou * 0.25;
        $kjinkup += $plus;
        &K_LOG2("<font color=red>【進撃】</font>$knameの攻撃力が25%上昇しています！攻撃力<font color=red>+$plus</font>");
        &E_LOG2("<font color=blue>【進撃】</font>$knameの攻撃力が25%上昇しています！攻撃力<font color=red>+$plus</font>");
      }elsif(($ksingeki_time-$idate <= 790 && $ksingeki_time-$idate > 590 && $ksinko) || ($ksingeki_time-$idate <= 1200 && $ksingeki_time-$idate > 590 && !$ksinko)){
        my $minus = int $kbou * 0.5;
        $kjinbup -= $minus;
        &K_LOG2("<font color=red>【進撃】</font>$knameの守備力が50%低下しています！守備力<font color=red>-$minus</font>");
        &E_LOG2("<font color=blue>【進撃】</font>$knameの守備力が50%低下しています！守備力<font color=red>-$minus</font>");
      }
    }
    if($eskl7 =~ /2/ && $estr >= 115){
      if($esingeki_time-$idate <= 1200 && $esingeki_time-$idate > 790 && $esinko){
        my $plus = int $ekou * 0.25;
        $ejinkup += $plus;
        &K_LOG2("<font color=blue>【進撃】</font>$enameの攻撃力が25%上昇しています！攻撃力<font color=red>+$plus</font>");
        &E_LOG2("<font color=red>【進撃】</font>$enameの攻撃力が25%上昇しています！攻撃力<font color=red>+$plus</font>");
      }elsif(($esingeki_time-$idate <= 790 && $esingeki_time-$idate > 590 && $esinko) || ($esingeki_time-$idate <= 1200 && $esingeki_time-$idate > 590 && !$esinko)){
        my $minus = int $ebou * 0.5;
        $ejinbup -= $minus;
        &K_LOG2("<font color=blue>【進撃】</font>$enameの守備力が50%低下しています！守備力<font color=red>-$minus</font>");
        &E_LOG2("<font color=red>【進撃】</font>$enameの守備力が50%低下しています！守備力<font color=red>-$minus</font>");
      }
    }



    #陣形、状態処理で上昇するステ
      $kkou += $kobup+$kobupL-$kyoudown-$kyoudownL+$kjinkup-$kjinkdn-$kjinhenkdn+$kyosyuup+$houiup-$kkousui;
      $ekou += $eobup+$eobupL-$eyoudown-$eyoudownL+$ejinkup-$ejinkdn-$ejinhenkdn-$eyosyuup-$ekousui;
      $kbou += $kagoup+$kagoupL-$ksendown-$ksendownL+$kjinbup-$kjinbdn-$kjinhenbdn+$kyosyuub-$kbousui;
      $ebou += $eagoup+$eagoupL-$esendown-$esendownL+$ejinbup-$ejinbdn-$ejinhenbdn-$eyosyuub-$ebousui;



    #攻勢、密集処理#
      if($kksup>0){
      $kkou+=$kksup;  
    &K_LOG2("<font color=red>【攻撃力補正】</font>$knameの攻撃力が<font color=red>+$kksup</font>されています。");
    &E_LOG2("<font color=blue>【攻撃力補正】</font>$knameの攻撃力<font color=red>+$kksup</font>されています。");
      }if($eksup>0){
      $ekou+=$eksup;
    &K_LOG2("<font color=blue>【攻撃力補正】</font>$enameの攻撃力が<font color=red>+$eksup</font>されています。");
    &E_LOG2("<font color=red>【攻撃力補正】</font>$enameの攻撃力が<font color=red>+$eksup</font>されています。");
      }if($kmsup>0){
      $kbou+=$kmsup;
    &K_LOG2("<font color=red>【守備力補正】</font>$knameの守備力が<font color=red>+$kmsup</font>されました。");
    &E_LOG2("<font color=blue>【守備力補正】</font>$knameの守備力が<font color=red>+$kmsup</font>されました。");
      }if($emsup>0){
      $ebou+=$emsup;
    &K_LOG2("<font color=blue>【守備力補正】</font>$enameの守備力が<font color=red>+$emsup</font>されました。");
    &E_LOG2("<font color=red>【守備力補正】</font>$enameの守備力が<font color=red>+$emsup</font>されました。");
      }
    #-----#


      #武器スキル-槍騎兵強化
      if($khohei eq "7" && $ksub1_ex eq "11"){
      $kkou+=10;
      &K_LOG2("<font color=red>【槊】</font>$kanameの効果により$knameの槍騎兵の攻撃力が+10されました！");
      &E_LOG2("<font color=blue>【槊】</font>$kanameの効果により$knameの槍騎兵の攻撃力が+10されました！");
      }
      if($ehohei eq "7" && $esub1_ex eq "11"){
      $ekou+=10;
      &K_LOG2("<font color=blue>【槊】</font>$kanameの効果により$enameの槍騎兵の攻撃力が+10されました！");
      &E_LOG2("<font color=red>【槊】</font>$kanameの効果により$enameの槍騎兵の攻撃力が+10されました！");
      }
      #-攻城弩
      if($khohei eq "8" && $last_battle){
      $kkou+=80;
      $kbou+=40;
      &K_LOG2("<font color=red>【攻城弩】</font>$kanameの効果により$knameの攻撃力が+80、守備力が+40、ターン数が+1されました！");
      }


      #防具スキル-ステアップ系
      if($kbouskl == 1 && $SOL_ZOKSEI[$ksub1_ex] eq "歩"){
      $kbou+=30;
      &K_LOG2("<font color=red>【歩人甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の守備力が+30されました！");
      &E_LOG2("<font color=blue>【歩人甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の守備力が+30されました！");
      }elsif($kbouskl == 2 && $SOL_ZOKSEI[$ksub1_ex] eq "騎"){
      $kbou+=20;
      &K_LOG2("<font color=red>【馬甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の守備力が+20されました！");
      &E_LOG2("<font color=blue>【馬甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の守備力が+20されました！");
      }elsif($kbouskl == 3 && $SOL_ZOKSEI[$ksub1_ex] eq "騎"){
      $kbou+=10;
      &K_LOG2("<font color=red>【挂甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の守備力が+10されました！");
      &E_LOG2("<font color=blue>【挂甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の守備力が+10されました！");
      }elsif($kbouskl == 4 && $SOL_ZOKSEI[$ksub1_ex] eq "弓"){
      $kkou+=20;
      &K_LOG2("<font color=red>【軽布甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の攻撃力が+20されました！");
      &E_LOG2("<font color=blue>【軽布甲】</font>$knameの$SOL_TYPE[$ksub1_ex]の攻撃力が+20されました！");
      }
      if($ebouskl == 1 && $SOL_ZOKSEI[$esub1_ex] eq "歩"){
      $ebou+=30;
      &K_LOG2("<font color=blue>【歩人甲】</font>$enameの$SOL_TYPE[$esub1_ex]の守備力が+30されました！");
      &E_LOG2("<font color=red>【歩人甲】</font>$enameの$SOL_TYPE[$esub1_ex]の守備力が+30されました！");
      }elsif($ebouskl == 2 && $SOL_ZOKSEI[$esub1_ex] eq "騎"){
      $ebou+=20;
      &K_LOG2("<font color=blue>【馬甲】</font>$enameの$SOL_TYPE[$esub1_ex]の守備力が+20されました！");
      &E_LOG2("<font color=red>【馬甲】</font>$enameの$SOL_TYPE[$esub1_ex]の守備力が+20されました！");
      }elsif($ebouskl == 3 && $SOL_ZOKSEI[$esub1_ex] eq "騎"){
      $ebou+=10;
      &K_LOG2("<font color=blue>【挂甲】</font>$enameの$SOL_TYPE[$esub1_ex]の守備力が+10されました！");
      &E_LOG2("<font color=red>【挂甲】</font>$enameの$SOL_TYPE[$esub1_ex]の守備力が+10されました！");
      }elsif($ebouskl == 4 && $SOL_ZOKSEI[$esub1_ex] eq "弓"){
      $ekou+=20;
      &K_LOG2("<font color=blue>【軽布甲】</font>$enameの$SOL_TYPE[$esub1_ex]の攻撃力が+20されました！");
      &E_LOG2("<font color=red>【軽布甲】</font>$enameの$SOL_TYPE[$esub1_ex]の攻撃力が+20されました！");
      }


      #侵攻強化
      if($kskl7 =~ /1/ && $kstr >= 100 && $ksinko){
      $kkou+=15;
      &K_LOG2("<font color=red>【侵攻強化】</font>$knameの攻撃力が+15されました！");
      &E_LOG2("<font color=blue>【侵攻強化】</font>$knameの攻撃力が+15されました！");
      }
      if($eskl7 =~ /1/ && $estr >= 100 && $esinko){
      $ekou+=15;
      &K_LOG2("<font color=blue>【侵攻強化】</font>$enameの攻撃力が+15されました！");
      &E_LOG2("<font color=red>【侵攻強化】</font>$enameの攻撃力が+15されました！");
      }


      #ターン数処理
                        $counter=1;
                        if((($ksub1_ex eq "12")||($ksub1_ex eq "68"))&&($last_battle)){
      $counter++;
      &K_LOG2("<font color=red>【</font>攻城１【小】<font color=red>】</font>$SOL_TYPE[$ksub1_ex]の効果でターン数が+1されました！");
      }elsif(($ksub1_ex eq "29" || $ksub1_ex eq "28") && $last_battle){
      $counter += 2;
      &K_LOG2("<font color=red>【</font>攻城１【大】<font color=red>】</font>$SOL_TYPE[$ksub1_ex]の効果でターン数が+2されました！");
      }
      if($koujyou2 eq "2" && $last_battle){
      $counter += 3;
      &K_LOG2("<font color=red>【</font>攻城２【大】<font color=red>】</font>ターン数が+3されました！");
      }elsif($koujyou2 eq "1" && $last_battle){
      $counter+=2;
      &K_LOG2("<font color=red>【</font>攻城２【中】<font color=red>】</font>ターン数が+2されました！");
      }elsif($koujyou2 eq "0" && $last_battle){
      $counter++;
      &K_LOG2("<font color=red>【</font>攻城２【小】<font color=red>】</font>ターン数が+1されました！");
      }
      if($khohei eq "8" && $last_battle){
      $counter++;
      }
      if($kjinkei == 7 && $zsa3 <= 1 && !$last_battle){$counter++;}  #罘変陣ターン数増加処理#
      if($ejinkei == 7 && $zsa3 <= 1){$counter++;}  #罘変陣ターン数増加処理#
      if($turnpuras){$counter++;}


      #戦闘処理
      &K_LOG2("\[$ksinkomes\]【$kname \[$kjinname\] （攻:$kkou 守:$kbou）】| \[$esinkomes\]【$ename \[$ejinname\] （攻:$ekou 守:$ebou）】");
      &E_LOG2("\[$ksinkomes\]【$kname \[$kjinname\] （攻:$kkou 守:$kbou）】| \[$esinkomes\]【$ename \[$ejinname\] （攻:$ekou 守:$ebou）】");
      $katt = int(($kkou - $ebou)/10);
      $eatt = int(($ekou - $kbou)/10);
      $bkatt = $katt+2;
      $beatt = $eatt+2;
      if($katt < 0){$katt = 0;}
      if($eatt < 0){$eatt = 0;}
      $kex_add = 0;
      $eex_add = 0;
      $katt +=2;
      $eatt +=2;
      $kkasaisirusi=0;
      $ekasaisirusi=0;
      my $battle_result = NONE;

      for (my $count = 0; $count < $counter; $count++) {
        my $kdmg = 0;
        my $edmg = 0;
        $wsol = $esol;
        $wsol2 = $ksol;

        #自分攻撃#
        $kdmg = int(rand($katt));
        if($kdmg <= 0){$kdmg=1;}

        #相手攻撃#
        $edmg = int(rand($eatt));
        if($edmg <= 0){$edmg = 1;}
        $edmg = 0 if $riitibusoku;

        #強襲処理#
        if($kyosyuf){
        $kyosyudmg=int(rand(7))+1;
        $esol -=$kyosyudmg;
        &K_LOG2("<font color=red>【強襲】</font>強襲により$enameの兵が数人倒されました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kyosyudmg\)");
        &E_LOG2("<font color=blue>【強襲】</font>強襲により$enameの兵が数人倒されました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kyosyudmg\)");
        $kyosyuf=0;
        }

        #増援（自分）
        if($ksz eq "2" || $ksz eq "1"){
        $kzou = $kint / 1000;
        if($kzou > 0.33){$kzou = 0.33;}
        if(rand(1) < $kzou){
        $kzouc=int(rand(5));
        if($kzouc <= 0){$kzouc = 1;}
        $ksol +=$kzouc;
        &K_LOG2("<font color=#993399>【増援】</font>$knameに増援が到着しました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↑\(+$kzouc\)");
        &E_LOG2("<font color=#336699>【増援】</font>$knameに増援が到着しました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↑\(+$kzouc\)");
        }
        }

        #増援（相手）
        if($esz eq "2" || $esz eq "1"){
        $ezou = $eint / 1000;
        if($ezou > 0.33){$ezou = 0.33;}
        if(rand(1) < $ezou){
        $ezouc=int(rand(5));
        if($ezouc <= 0){$ezouc = 1;}
        $esol +=$ezouc;
        &K_LOG2("<font color=#336699>【増援】</font>$enameに増援が到着しました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$ezouc\)");
        &E_LOG2("<font color=#993399>【増援】</font>$enameに増援が到着しました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$ezouc\)");
        }
        }        

        #犠牲攻撃（自分）
        if(($kskl4 =~ /3/)&&($ksol > 1)){
        $kgi = $kstr / 1000;
        if($kgi > 0.33){$kgi = 0.33;}
        if(rand(1) < $kgi){
        $kgic=int(rand(9))+1;
        $kgif = $ksol-$kgic;
        if($kgif < 1){$kgic += $kgif-1;}
        $kkgic = int($kgic*3);
        if($ename eq "城壁"){  $kkgic = int($kgic*10);}
        $ksol -=$kgic;
        $esol -=$kkgic;
        &K_LOG2("<font color=#2F4F4F>【犠牲攻撃】</font>$knameは自軍の兵士を犠牲にし、犠牲攻撃を仕掛けました！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$kgic\) | $ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkgic\)");
        &E_LOG2("<font color=#696969>【犠牲攻撃】</font>$knameは自軍の兵士を犠牲にし、犠牲攻撃を仕掛けました！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$kgic\) | $ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkgic\)");
        }
        }

        #犠牲攻撃（相手）
        if(($eskl4 =~ /3/)&&($esol > 1)&&(!$riitibusoku)){
        $egi = $estr / 1000;
        if($egi > 0.33){$egi = 0.33;}
        if(rand(1) < $egi){
        $egic=int(rand(9))+1;
        $egif = $esol-$egic;
        if($egif < 1){$egic += $egif-1;}
        $eegic = int($egic*3);
        $esol -=$egic;
        $ksol -=$eegic;
        &K_LOG2("<font color=#696969>【犠牲攻撃】</font>$enameは自軍の兵士を犠牲にし、犠牲攻撃を仕掛けました！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$egic\) | $kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eegic\)");
        &E_LOG2("<font color=#2F4F4F>【犠牲攻撃】</font>$enameは自軍の兵士を犠牲にし、犠牲攻撃を仕掛けました！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$egic\) | $kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eegic\)");
        }
        }

        #突撃（自分）
        if(($kskl5 =~ /0/)&&($zsa3 <= 1)){
        $ttgka = $klea / 900;
        if($ttgka > 0.35){$ttgka = 0.35;}
        if(rand(1) < $ttgka){
        $kttgkc=int(rand(6))+1;
        $esol -=$kttgkc;
        &K_LOG2("<font color=red>【突撃】</font>$knameの部隊は敵部隊に突撃しました！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kttgkc\)");
        &E_LOG2("<font color=blue>【突撃】</font>$knameの部隊は敵部隊に突撃しました！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kttgkc\)");
        }
        }        

        #突撃(相手)
        if(($eskl5 =~ /0/)&&($zsa3 <= 1)){
        $etgka = $elea / 900;
        if($etgka > 0.35){$etgka = 0.35;}
        if(rand(1) < $etgka){
        $ettgkc=int(rand(6))+1;
        $ksol -=$ettgkc;
        &K_LOG2("<font color=blue>【突撃】</font>$enameの部隊は敵部隊に突撃しました！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ettgkc\)");
        &E_LOG2("<font color=red>【突撃】</font>$enameの部隊は敵部隊に突撃しました！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ettgkc\)");
        }
        }

        #時間攻撃(自分)
        if($ksz eq "2"){
        $ktaa = $kint / 1000;
        if($ktaa > 0.33){$ktaa = 0.33;}
        if(rand(1) < $ktaa){
        $ktac=$count;
        if($ktac <= 0){$ktac=1;}
        $esol -=$ktac;
        &K_LOG2("<font color=red>【時間攻撃】</font>$knameがタイムアタックを発動しました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$ktac\)");
        &E_LOG2("<font color=blue>【時間攻撃】</font>$knameがタイムアタックを発動しました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$ktac\)");
        }
        }
      
        #時間攻撃（相手）
        if(($esz eq "2")&&(!$riitibusoku)){
        $etaa = $eint / 1000;
        if($etaa > 0.33){$etaa = 0.33;}
        if(rand(1) < $etaa){
        $etac=$count;
        if($etac <= 0){$etac=1;}
        $ksol -=$etac;
        &K_LOG2("<font color=blue>【時間攻撃】</font>$enameがタイムアタックを発動しました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$etac\)");
        &E_LOG2("<font color=red>【時間攻撃】</font>$enameがタイムアタックを発動しました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$etac\)");
        }
        }

        #計数攻撃(自分)
        if($kskl4 =~ /0/){
        $kkei = $kstr/900;
        if($kkei > 0.35){$kkei = 0.35;}
        if(rand(1) < $kkei){
        $kkeic=$kkicn+3;
        $esol -=$kkeic;
        &K_LOG2("<font color=red>【計数攻撃】</font>$knameが計数攻撃を仕掛けました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkeic\)");
        &E_LOG2("<font color=blue>【計数攻撃】</font>$knameが計数攻撃を仕掛けました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkeic\)");
          if($kkicn < 15){
          $kkicn++;
          }
        }
        }

        #計数攻撃(相手)
        if(($eskl4 =~ /0/)&&(!$riitibusoku)){
        $ekei = $estr/900;
        if($ekei > 0.35){$ekei = 0.35;}
        if(rand(1) < $ekei){
        $ekeic=$ekicn+3;
        $ksol -=$ekeic;
        &K_LOG2("<font color=blue>【計数攻撃】</font>$enameが計数攻撃を仕掛けました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ekeic\)");
        &E_LOG2("<font color=red>【計数攻撃】</font>$enameが計数攻撃を仕掛けました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ekeic\)");
          if($ekicn < 15){
          $ekicn++;
          }
        }
        }
        
        #破壊攻撃(自分)
        if($kskl4 =~ /1/){
        $khakaik = $kstr/3300;
        if($khakaik > 0.1){$khakaik = 0.1;}
        if(rand(1) < $khakaik){
        $esol -=15;
        &K_LOG2("<font color=red>【破壊攻撃】</font>$knameが破壊攻撃を行いました。$enameの部隊は甚大な被害を受けました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-15\)");
        &E_LOG2("<font color=blue>【破壊攻撃】</font>$knameが破壊攻撃を行いました。$enameの部隊は甚大な被害を受けました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-15\)");
        }
        }

        #破壊攻撃(相手)
        if(($eskl4 =~ /1/)&&(!$riitibusoku)){
        $ehakaik = $estr/3300;
        if($ehakaik > 0.1){$ehakaik = 0.1;}
        if(rand(1) < $ehakaik){
        $ksol -=15;
        &K_LOG2("<font color=blue>【破壊攻撃】</font>$enameが破壊攻撃を行いました。$knameの部隊は甚大な被害を受けました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-15\)");
        &E_LOG2("<font color=red>【破壊攻撃】</font>$enameが破壊攻撃を行いました。$knameの部隊は甚大な被害を受けました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-15\)");
        }
        }
      

        #攻勢(自分)
        if($kskl5 =~ /1/){
        $kkousei = $klea/1200;
          if($last_battle){$kkousei = $klea/2400;}
        if($kkousei > 0.3){$kkousei = 0.3;}
        if(rand(1) < $kkousei){
          if($kksup < 50){
          $kksup+=10;
            if($bkatt < 2){
            $bkatt++;
              if($bkatt >= 2){$kdmg++;}
            }else{
            $kdmg++;
            }
          }
        $kkouseidmg=int(rand(4))+1;
        $esol-=$kkouseidmg;
        &K_LOG2("<font color=red>【攻勢】</font>$knameが攻勢を仕掛けました。$knameの攻撃力が<font color=red>+10</font>されました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkouseidmg\)");
        &E_LOG2("<font color=blue>【攻勢】</font>$knameが攻勢を仕掛けました。$knameの攻撃力が<font color=red>+10</font>されました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkouseidmg\)");
        }
        }        

        #攻勢(相手)
        if(($eskl5 =~ /1/)&&(!$riitibusoku)){
        $ekousei = $elea/1200;
        if($ekousei > 0.3){$ekousei = 0.3;}
        if(rand(1) < $ekousei){
          if($eksup < 50){
          $eksup+=10;
            if($beatt < 2){
            $beatt++;
              if($beatt >= 2){$edmg++;}
            }else{
            $edmg++;
            }
          }
        $ekouseidmg=int(rand(4))+1;
        $ksol-=$ekouseidmg;
        &K_LOG2("<font color=blue>【攻勢】</font>$enameが攻勢を仕掛けました。$enameの攻撃力が<font color=red>+10</font>されました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ekouseidmg\)");
        &E_LOG2("<font color=red>【攻勢】</font>$enameが攻勢を仕掛けました。$enameの攻撃力が<font color=red>+10</font>されました。$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ekouseidmg\)");
        }        
        }

        #密集(自分)
        if(($kskl5 =~ /2/)&&($kmsup < 50)){
        $kmissyu = $klea/1200;
          if($last_battle){$kmissyu = $klea/2400;}
        if($kmissyu > 0.3){$kmissyu = 0.3;}
        if(rand(1) < $kmissyu){
        $kmsup+=10;
        $edmg-=1;
        if($edmg <= 0){$edmg=1;}
        &K_LOG2("<font color=red>【密集】</font>$knameの部隊が密集しました。$knameの守備力が<font color=red>+10</font>されました。");
        &E_LOG2("<font color=blue>【密集】</font>$knameの部隊が密集しました。$knameの守備力が<font color=red>+10</font>されました。");
        }
        }

        #密集(相手)
        if(($eskl5 =~ /2/)&&($emsup < 50)&&(!$riitibusoku)){
        $emissyu = $elea/1200;
        if($emissyu > 0.3){$emissyu = 0.3;}
        if(rand(1) < $emissyu){
        $emsup+=10;
        $kdmg-=1;
        if($kdmg <= 0){$kdmg=1;}
        &K_LOG2("<font color=blue>【密集】</font>$enameの部隊が密集しました。$enameの守備力が<font color=red>+10</font>されました。");
        &E_LOG2("<font color=red>【密集】</font>$enameの部隊が密集しました。$enameの守備力が<font color=red>+10</font>されました。");
        }
        }  

        #会心攻撃(自分)
        if($kskl4 =~ /2/){
        $kkaisin = $kstr/1000;
        if($kkaisin > 0.33){$kkaisin = 0.33;}
        if(rand(1) < $kkaisin){
        $kkaisinlog=1;
        $kaisin_dmg=$kdmg;
        $kdmg=int($kdmg*1.5);
        &K_LOG2("<font color=red>【会心攻撃】</font>$knameが会心攻撃を仕掛けました。$knameの与えるダメージが1.5倍になります。");
        &E_LOG2("<font color=blue>【会心攻撃】</font>$knameが会心攻撃を仕掛けました。$knameの与えるダメージが1.5倍になります。");
        }
        }        

        #会心攻撃(相手)
        if(($eskl4 =~ /2/)&&(!$riitibusoku)){
        $ekaisin = $estr/1000;
        if($ekaisin > 0.33){$ekaisin = 0.33;}
        if(rand(1) < $ekaisin){
        $ekaisinlog=1;
        $eaisin_dmg=$edmg;
        $edmg=int($edmg*1.5);
        &K_LOG2("<font color=blue>【会心攻撃】</font>$enameが会心攻撃を仕掛けました。$enameの与えるダメージが1.5倍になります。");
        &E_LOG2("<font color=red>【会心攻撃】</font>$enameが会心攻撃を仕掛けました。$enameの与えるダメージが1.5倍になります。");
        }
        }

        #離間（自分）
        if($kskl1 == 3){
        $ttgka = $kint / 1000;
        if($ttgka > 0.27){$ttgka = 0.27;}
        if(rand(1) < $ttgka){
        $kttgkc=int(rand(6))+1;
        $esol -=$kttgkc;
        $ksol +=$kttgkc;
        &K_LOG2("<font color=red>【離間】</font>$knameは$enameの部隊に離間工作を仕掛けました！");
        &K_LOG2("<font color=red>【離間】</font>$enameの兵士が数人$knameに寝返りました！　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kttgkc\) |$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↑\(+$kttgkc\)");
        &E_LOG2("<font color=blue>【離間】</font>$knameは$enameの部隊に離間工作を仕掛けました！");
        &E_LOG2("<font color=blue>【離間】</font>$enameの兵士が数人$knameに寝返りました！　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kttgkc\) |$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↑\(+$kttgkc\)");
        }
        }

        #離間（相手）
        if($eskl1 == 3 && !$riitibusoku){
        $ttgka = $eint / 1000;
        if($ttgka > 0.27){$ttgka = 0.27;}
        if(rand(1) < $ttgka){
        $kttgkc=int(rand(6))+1;
        $esol +=$kttgkc;
        $ksol -=$kttgkc;
        &K_LOG2("<font color=blue>【離間】</font>$enameは$knameの部隊に離間工作を仕掛けました！");
        &K_LOG2("<font color=blue>【離間】</font>$knameの兵士が数人$enameに寝返りました！　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$kttgkc\) |$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$kttgkc\)");
        &E_LOG2("<font color=red>【離間】</font>$enameは$knameの部隊に離間工作を仕掛けました！");
        &E_LOG2("<font color=red>【離間】</font>$knameの兵士が数人$enameに寝返りました！　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$kttgkc\) |$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$kttgkc\)");
        }
        }

        #猛攻(自分)
        if($kskl7 =~ /3/){
        $kkousei = $kstr/900;
          if($last_battle){$kkousei = $kstr/1800;}
        if($kkousei > 0.33){$kkousei = 0.33;}
        if(rand(1) < $kkousei){
          if($kksup < 50){
          $kksup+=20;
            if($bkatt < 2){
            $bkatt+=2;
              if($bkatt >= 2){$kdmg+=2;}
            }else{
            $kdmg+=2;
            }
          }elsif($kksup >= 50 && $kksup < 60){
          $kksup=60;
            if($bkatt < 2){
            $bkatt++;
              if($bkatt >= 2){$kdmg++;}
            }else{
            $kdmg++;
            }
          }
        $kkouseidmg=int(rand(8))+1;
        $esol-=$kkouseidmg;
        &K_LOG2("<font color=red>【猛攻】</font>$knameは$enameの部隊を激しく攻め立てています！$knameの攻撃力が<font color=red>+20</font>されました！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkouseidmg\)");
        &E_LOG2("<font color=blue>【猛攻】</font>$knameは$enameの部隊を激しく攻め立てています！$knameの攻撃力が<font color=red>+20</font>されました！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$kkouseidmg\)");
        }
        }

        #猛攻(相手)
        if(($eskl7 =~ /3/)&&(!$riitibusoku)){
        $ekousei = $estr/900;
        if($ekousei > 0.33){$ekousei = 0.33;}
        if(rand(1) < $ekousei){
          if($eksup < 50){
          $eksup+=20;
            if($beatt < 2){
            $beatt+=2;
              if($beatt >= 2){$edmg+=2;}
            }else{
            $edmg+=2;
            }
          }elsif($eksup >= 50 && $eksup < 60){
          $eksup=60;
            if($beatt < 2){
            $beatt++;
              if($beatt >= 2){$edmg++;}
            }else{
            $edmg++;
            }
          }
        $ekouseidmg=int(rand(8))+1;
        $ksol-=$ekouseidmg;
        &K_LOG2("<font color=blue>【猛攻】</font>$enameは$knameの部隊を激しく攻め立てています！$enameの攻撃力が<font color=red>+20</font>されました！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ekouseidmg\)");
        &E_LOG2("<font color=red>【猛攻】</font>$enameは$knameの部隊を激しく攻め立てています！$enameの攻撃力が<font color=red>+20</font>されました！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ekouseidmg\)");
        }        
        }

        #波状攻撃（自分）
        if($khajyo){
        $kakuritu = $kstr/1000;
        if($kakuritu > 0.3){$kakuritu=0.3;}
        if(rand(1) < $kakuritu){
        $plus=(int(rand(5))+1)*2;
        $esol-=$plus;
        &K_LOG2("<font color=red>【波状攻撃】</font>$knameは波状攻撃を仕掛けた！$enameの部隊は損害を受けました。　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$plus\)");
        &E_LOG2("<font color=blue>【波状攻撃】</font>$knameは波状攻撃を仕掛けた！$enameの部隊は損害を受けました。　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$plus\)");
        }
        }


        #回避スキル（自分）
        if($kskl8 =~ /4/){
        $kakuritu = $kcha/900;
        if($kakuritu > 0.33){$kakuritu=0.33;}
        if(rand(1) < $kakuritu){
        $kaihi_dmg=$edmg;
        $edmg=0;
        $k_kaihi=1;
        &K_LOG2("<font color=red>【回避】</font>$knameの部隊は$enameからの攻撃を完全に回避した！！");
        &E_LOG2("<font color=blue>【回避】</font>$knameの部隊は$enameからの攻撃を完全に回避した！！");
        }
        }

        #回避スキル（相手）
        if($eskl8 =~ /4/){
        $eakuritu = $echa/900;
        if($eakuritu > 0.33){$eakuritu=0.33;}
        if(rand(1) < $kakuritu){
        $eaihi_dmg=$kdmg;
        $kdmg=0;
        $e_kaihi=1;
        &K_LOG2("<font color=blue>【回避】</font>$enameの部隊は$knameからの攻撃を完全に回避した！！");
        &E_LOG2("<font color=red>【回避】</font>$enameの部隊は$knameからの攻撃を完全に回避した！！");
        }
        }


        #武器スキル：米俵（自分）
        if($khohei eq "1" && $krice>=500){
        if(rand(1) < 0.15){
          if(rand(1) < 0.2){
          $komedawara=10;
          $esol -=$komedawara;
          $krice-=500;
          &K_LOG2("<font color=red>【米俵】</font>$knameは$enameに米俵を投げつけた！ -<font color=red>500</font>R");
          &K_LOG2("<font color=red>【米俵】</font>米俵は空高く舞い上がった・・・！");
          &K_LOG2("<font color=red>【米俵】</font>米俵は$enameの部隊に直撃した！　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$komedawara\)");
          &E_LOG2("<font color=blue>【米俵】</font>$knameは$enameに米俵を投げつけた！");
          &E_LOG2("<font color=blue>【米俵】</font>米俵は空高く舞い上がった・・・！");
          &E_LOG2("<font color=blue>【米俵】</font>米俵は$enameの部隊に直撃した！　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$komedawara\)");
          }else{
          $komedawara=3;
          $esol -=$komedawara;
          $krice-=500;
          &K_LOG2("<font color=red>【米俵】</font>$knameは$enameに米俵を投げつけた！ -<font color=red>500</font>R　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$komedawara\)");
          &E_LOG2("<font color=blue>【米俵】</font>$knameは$enameに米俵を投げつけた！$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$komedawara\)");
          }
        }
        }      

        #武器スキル：米俵（相手）
        if(($ehohei eq "1")&&(!$riitibusoku)&&($erice>=500)){
        if(rand(1) < 0.15){
          if(rand(1) < 0.2){
          $eomedawara=10;
          $ksol -=$eomedawara;
          $erice-=500;
          &K_LOG2("<font color=blue>【米俵】</font>$enameは$knameに米俵を投げつけた！");
          &K_LOG2("<font color=blue>【米俵】</font>米俵は空高く舞い上がった・・・！");
          &K_LOG2("<font color=blue>【米俵】</font>米俵は$knameの部隊に直撃した！　$SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eomedawara\)");
          &E_LOG2("<font color=red>【米俵】</font>$enameは$knameに米俵を投げつけた！ -<font color=red>500</font>R");
          &E_LOG2("<font color=red>【米俵】</font>米俵は空高く舞い上がった・・・！");
          &E_LOG2("<font color=red>【米俵】</font>米俵は$knameの部隊に直撃した！　$SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eomedawara\)");
          }else{
          $eomedawara=3;
          $ksol -=$eomedawara;
          $erice-=500;
          &K_LOG2("<font color=blue>【米俵】</font>$enameは$knameに米俵を投げつけた！$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eomedawara\)");
          &E_LOG2("<font color=red>【米俵】</font>$enameは$knameに米俵を投げつけた！ -<font color=red>500</font>R　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eomedawara\)");
          }
        }
        }


        #武器スキル：短陌（自分）
        if($khohei eq "2" && $kgold >= 500){
        if(rand(1) < 0.15){
        $komedawara=int(rand(10))+1;
        $esol -=$komedawara;
        $kgold-=500;
        &K_LOG2("<font color=red>【短陌】</font>$knameは短陌を取り出し、$enameに銅銭を投げまくる！ -<font color=red>500</font>G");
        &K_LOG2("<font color=red>【短陌】</font>銅銭は<font color=red>$komedawara</font>個ヒットした！　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$komedawara\)");
        &E_LOG2("<font color=blue>【短陌】</font>$knameは短陌を取り出し、$enameに銅銭を投げまくる！");
        &E_LOG2("<font color=blue>【短陌】</font>銅銭は<font color=red>$komedawara</font>個ヒットした！　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$komedawara\)");
        }
        }        

        #武器スキル：短陌（相手）
        if($ehohei eq "2" && !$riitibusoku && $egold>=500){
        if(rand(1) < 0.15){
        $eomedawara=int(rand(10))+1;
        $ksol -=$eomedawara;
        $egold-=500;
        &K_LOG2("<font color=blue>【短陌】</font>$enameは短陌を取り出し、$knameに銅銭を投げまくる！");
        &K_LOG2("<font color=blue>【短陌】</font>銅銭は<font color=red>$eomedawara</font>個ヒットした！　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eomedawara\)");
        &E_LOG2("<font color=red>【短陌】</font>$enameは短陌を取り出し、$knameに銅銭を投げまくる！ -<font color=red>500</font>G");
        &E_LOG2("<font color=red>【短陌】</font>銅銭は<font color=red>$eomedawara</font>個ヒットした！　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$eomedawara\)");
        }
        }


        #武器スキル：龜文（自分）
        if ( $khohei eq "3" ) {
          if ( rand(1) < 0.12 ) {
            $ki_dmg  = $edmg;
            $edmg    = 1;
            $k_kibun = 1;
            &K_LOG2("<font color=red>【龜文】</font>干将の亀裂模様が輝き始めた…！ $knameの被ダメージが減少します。");
            &E_LOG2("<font color=blue>【龜文】</font>干将の亀裂模様が輝き始めた…！ $knameの被ダメージが減少します。");
          }
        }

        #武器スキル：龜文（相手）
        if ( $ehohei eq "3" ) {
          if ( rand(1) < 0.12 ) {
            $ei_dmg  = $kdmg;
            $kdmg    = 1;
            $e_kibun = 1;
            &K_LOG2("<font color=blue>【龜文】</font>干将の亀裂模様が輝き始めた…！ $enameの被ダメージが減少します。");
            &E_LOG2("<font color=red>【龜文】</font>干将の亀裂模様が輝き始めた…！ $enameの被ダメージが減少します。");
          }
        }


        #武器スキル：漫理（自分）
        if($khohei eq "3"){
        if(rand(1) < 0.12){
        $e_manr=(int(rand(3))+1)*3;
        $esol-=$e_manr;
        &K_LOG2("<font color=red>【漫理】</font>莫耶の水波模様が輝き始めた…！ $enameの部隊は損害を受けました。　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$e_manr\)");
        &E_LOG2("<font color=blue>【漫理】</font>莫耶の水波模様が輝き始めた…！ $enameの部隊は損害を受けました。　$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↓\(-$e_manr\)");
        }
        }

        #武器スキル：漫理（相手）
        if($ehohei eq "3"){
        if(rand(1) < 0.12){
        $k_manr=(int(rand(3))+1)*3;
        $ksol-=$k_manr;
        &K_LOG2("<font color=red>【漫理】</font>莫耶の水波模様が輝き始めた…！ $knameの部隊は損害を受けました。　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$k_manr\)");
        &E_LOG2("<font color=blue>【漫理】</font>莫耶の水波模様が輝き始めた…！ $knameの部隊は損害を受けました。　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$k_manr\)");
        }
        }

        #落石(城壁専用スキル)
        if($last_battle){
          $etgka = do {
            if ($SOL_AT[$ksub1_ex] eq '機' && $SOL_TYPE[$ksub1_ex] ne '光学兵' && $last_battle) {
              0.025 + ($zdef_att / 6666)
            } else {
              0.05 + ($zdef_att / 3333)
            }
          };
          if($etgka > 0.3){$etgka = 0.3;}
          if(rand(1) < $etgka){
            $ettgkc=int(rand(5))+1;
            $ksol -=$ettgkc;
            &K_LOG2("<font color=blue>【落石】</font>$znameの城壁守備隊は城壁の上から岩石を投げ落とした！　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ettgkc\)");
            &E_LOG2("<font color=red>【落石】</font>$znameの城壁守備隊は城壁の上から岩石を投げ落とした！　$kname $SOL_TYPE[$ksub1_ex]\ \($SOL_ZOKSEI[$ksub1_ex]\) $ksol人 ↓\(-$ettgkc\)");
          }
        }

        # スキルによる戦闘結果
        $esol = 0 if $esol < 0;
        $ksol = 0 if $ksol < 0;
        $battle_result = battle_result($ksol, $esol);
        $kex_add += ($wsol - $esol);
        $eex_add += ($wsol2 - $ksol);
        last if $battle_result != NONE;

        $esol -= $kdmg;
        $esol = 0 if $esol < 0;
        $ksol -= $edmg;
        $ksol = 0 if $ksol < 0;

        K_LOG2(qq{ターン<font color="red">$count</font>:$kname $SOL_TYPE[$ksub1_ex] ($SOL_ZOKSEI[$ksub1_ex]) $ksol人 ↓(-$edmg) |$ename $SOL_TYPE[$esub1_ex] ($SOL_ZOKSEI[$esub1_ex]) $esol人 ↓(-$kdmg)});
        E_LOG2(qq{ターン<font color="red">$count</font>:$kname $SOL_TYPE[$ksub1_ex] ($SOL_ZOKSEI[$ksub1_ex]) $ksol人 ↓(-$edmg) |$ename $SOL_TYPE[$esub1_ex] ($SOL_ZOKSEI[$esub1_ex]) $esol人 ↓(-$kdmg)});

        $battle_result = battle_result($ksol, $esol);
        $kex_add += ($wsol - $esol);
        $eex_add += ($wsol2 - $ksol);
        last if $battle_result != NONE;

        if ($k_kibun) {    #龜文発動時のダメージ戻す
          $k_kibun = 0;
          $edmg    = $ki_dmg;
        }
        if ($e_kibun) {
          $e_kibun = 0;
          $kdmg    = $ei_dmg;
        }
        if ($k_kaihi) {    #回避発動時のダメージ戻す
          $k_kaihi = 0;
          $edmg    = $kaihi_dmg;
        }
        if ($e_kaihi) {
          $e_kaihi = 0;
          $kdmg    = $eaihi_dmg;
        }
        if ($kkaisinlog) {    #会心攻撃発動時最大ダメージ元に戻す#
          $kkaisinlog = 0;
          $kdmg       = $kaisin_dmg;
        }
        if ($ekaisinlog) {
          $ekaisinlog = 0;
          $edmg       = $eaisin_dmg;
        }

      }


      # 戦闘後処理
      if ($last_battle) {
        $kkezuri += $kex_add;
      } else {
        $ksitahei += $kex_add;
      }
      $ksarehei += $eex_add;
      $esitahei += $eex_add;
      $esarehei += $kex_add;
      $kabe = int($kex_add*0.6);
      $eex_add = int(( ( (($SOL_PRICE[$ksub1_ex]/2)-5) +10)*$eex_add)/100);
      $kex_add = int(( ( (($SOL_PRICE[$esub1_ex]/2)-5) +10)*$kex_add)/100);
      $kex_addherasu = int($kex_add/2);
      if($koukenherasi){
        $kex_add = $kex_addherasu;
        $koukenherasi = 0;
      }

      # 引き分け
      if ($ksol > 0 && $esol > 0) {

        $eex_add += 1;
        $kex_add += 1;
        $ecex += $eex_add;
        $kcex += $kex_add;
        $khiki++;
        $ehiki++;
        &K_LOG("$knameと$enameは引き分けた。<font color=red>$kex_add</font>の貢献を得ました。");
        &E_LOG("$enameと$knameは引き分けた。<font color=blue>$eex_add</font>の貢献を得ました。");
        &K_LOG2("$knameと$enameは引き分けた。<font color=red>$kex_add</font>の貢献を得ました。");
        &E_LOG2("$enameと$knameは引き分けた。<font color=blue>$eex_add</font>の貢献を得ました。");
        &MAP_LOG("<font color=green>【引き分け】</font>$knameと$enameの戦闘は決着がつきませんでした。($battkemapname)");

        if ($kaaiwin) { $kaaimes = "、武器相性が+0.45"; }
        if ($eaaiwin) { $eaaimes = "、武器相性が+0.45"; }
        if ($ksinko) {
          &MY_ARMUP_1;
        }
        else {
          &MY_BOUUP_1;
        }
        if ($esinko) {
          &YOU_ARMUP_1;
        }
        else {
          &YOU_BOUUP_1;
        }

      } elsif ($battle_result == WIN) {

        $ksub2_ex++;
        $kspbns = int(rand(11)); #撃破時SPボーナス確率

        if ($last_battle) {
          warn "is win";
          conquer_town($diplomacy_model);
        } else {

          $kex_add += 30;
          $eex_add += 5;
          $kcex += $kex_add;
          $ecex += $eex_add;

          &K_LOG("$knameは$enameを倒した！<font color=blue>$kex_add</font>の貢献を得ました。");
          &E_LOG("$enameは$knameに敗北した。。<font color=red>$eex_add</font>の貢献を得ました。");
          &K_LOG2("$knameは$enameを倒した！<font color=blue>$kex_add</font>の貢献を得ました。");
          &E_LOG2("$enameは$knameに敗北した。。<font color=red>$eex_add</font>の貢献を得ました。");
          &MAP_LOG("<font color=blue>【勝利】</font>$knameは$enameを倒しました！($battkemapname)");
          &K_LOG("$kname『<font color=blue>$kcm</font>』");
          &E_LOG("$kname『<font color=blue>$kcm</font>』");
          &K_LOG2("$kname『<font color=blue>$kcm</font>』");
          &E_LOG2("$kname『<font color=blue>$kcm</font>』");
          &MAP_LOG("$kname『<font color=blue>$kcm</font>』");

          if($kspbns == 1){  #撃破時SPボーナス
          $ksg++;
          &K_LOG("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
          &K_LOG2("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
          }

          if ($kaaiwin) {
            my_arm_attr_up();
          }
          if ($ksinko) {
            $kkouwin++;
            &MY_ARMUP_2;
          }
          else {
            $kbouwin++;
            &MY_BOUUP_2;
          }

          if ($eaaiwin) { $eaaimes = "、武器相性が+0.45"; }
          if ($esinko) {
            $ekoulos++;
            $earm += 0.15;
            &E_LOG2("【<font color=red>成長</font>】  武器の威力が+0.15$eaaimesされました。");
          }
          else {
            $eboulos++;
            $emes += 0.15;
            &E_LOG2("【<font color=red>成長</font>】防具の威力が+0.15$eaaimesされました。");
          }

          &E_TETTAI();  #>lib/skl_lib.pl
        }


      } elsif ($battle_result == LOSE) {

        $espbns = int(rand(11));  #撃破時SPボーナス確率
        $eex_add += 30;
        $kex_add += 5;
        $ecex += $eex_add;
        $kcex += $kex_add;
        $esub2_ex++;

        &K_LOG("$knameは$enameに敗北した。。<font color=red>$kex_add</font>の貢献を得ました。");
        &E_LOG("$enameは$knameを倒した！<font color=blue>$eex_add</font>の貢献を得ました。");
        &K_LOG2("$knameは$enameに敗北した。。<font color=red>$kex_add</font>の貢献を得ました。");
        &E_LOG2("$enameは$knameを倒した！<font color=blue>$eex_add</font>の貢献を得ました。");

        &MAP_LOG("<font color=#ff0000>【敗北】</font>$knameは$enameに敗北しました。($battkemapname)");
        &K_LOG("$ename『<font color=red>$ecm</font>』");
        &E_LOG("$ename『<font color=red>$ecm</font>』");
        &K_LOG2("$ename『<font color=red>$ecm</font>』");
        &E_LOG2("$ename『<font color=red>$ecm</font>』");
        &MAP_LOG("$ename『<font color=red>$ecm</font>』");

        if ( $espbns == 1 ) {    #撃破時SPボーナス
          $esg++;
          &E_LOG("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
          &E_LOG2("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
        }

        if ($eaaiwin) {
          you_arm_attr_up();
        }
        if ($esinko) {
          $ekouwin++;
          &YOU_ARMUP_2;
        }
        else {
          $ebouwin++;
          &YOU_BOUUP_2;
        }

        if ($kaaiwin) { $kaaimes = "、相性が+0.45"; }
        if ($ksinko) {
          $kkoulos++;
          $karm += 0.15;
          &K_LOG2("【<font color=red>成長</font>】武器の威力が+0.15$kaaimesされました。");
        }
        else {
          $kboulos++;
          $kmes += 0.15;
          &K_LOG2("【<font color=red>成長</font>】防具の威力が+0.15$kaaimesされました。");
        }

        $losmes = 1;       # 城壁に敗北時都市データ書き込む時にバグるので
        $kariiti = $kiti;  #
        &TETTAI();         # >lib/skl_lib.pl
        $kiti = $kariiti;  #

      } elsif ($battle_result == DRAW) {

        $kspbns = int(rand(11)); #撃破時SPボーナス確率
        $espbns = int(rand(11));  #撃破時SPボーナス確率

        if ($last_battle) {
          conquer_town($diplomacy_model);
        } else {

          $kex_add += 30;
          $eex_add += 30;
          $kcex += $kex_add;
          $ecex += $eex_add;
          $ksub2_ex++;
          $esub2_ex++;

          &K_LOG("$knameは$enameと相討ちしました。。<font color=blue>$kex_add</font>の貢献を得ました。");
          &E_LOG("$enameは$knameと相討ちしました。。<font color=red>$eex_add</font>の貢献を得ました。");
          &K_LOG2("$knameは$enameと相討ちしました。。<font color=blue>$kex_add</font>の貢献を得ました。");
          &E_LOG2("$enameは$knameと相討ちしました。。<font color=red>$eex_add</font>の貢献を得ました。");
          &MAP_LOG(qq{<span class="green">【相討ち】</span>$knameは$enameと相討ちしました。。($battkemapname)});

          if ( $kspbns == 1 ) {    #撃破時SPボーナス
            $ksg++;
            &K_LOG("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
            &K_LOG2("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
          }
          if ( $espbns == 1 ) {    #撃破時SPボーナス
            $esg++;
            &E_LOG("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
            &E_LOG2("<font color=red>【撃破ボーナス】</font>SPが<font color=red>+1</font>されました！");
          }

          if ($kaaiwin) {
            my_arm_attr_up();
          }
          if ($eaaiwin) {
            you_arm_attr_up();
          }

          if ($ksinko) {
            $kkouwin++;
            &MY_ARMUP_2;
          }
          else {
            $kbouwin++;
            &MY_BOUUP_2;
          }
          if ($esinko) {
            $ekouwin++;
            &YOU_ARMUP_2;
          }
          else {
            $ebouwin++;
            &YOU_BOUUP_2;
          }

          $losmes = 1;       # 城壁に敗北時都市データ書き込む時にバグるので
          $kariiti = $kiti;  #
          &TETTAI();         # >lib/skl_lib.pl
          $kiti = $kariiti;  #
          &E_TETTAI();       # >lib/skl_lib.pl
        }

      }

#相手データ書き込み#

      if (!$last_battle) {
        if ($eid ne "") {
          if ($ebukinasi eq "1") { $earm = ""; }
          ENEMY_INPUT();
        }
      } else {
        $zshiro = $esol;
        $zdef_att -= $kabe;
        if ($zdef_att < 0) {
          $zdef_att = 0;
        }

        if("$zname" ne ""){
          splice(@TOWN_DATA, $kiti, 1, "$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");

          &SAVE_DATA($TOWN_LIST, @TOWN_DATA);

          #統一ログ(最大都市数行ったとき)
          my $is_unite = Jikkoku::Model::Unite->is_unite;
          if ($town_get[$kcon] == 20 && !$is_unite) {
            
            MAP_LOG2("<font color=#FFFF00>【統一】</font>\[$old_date\]大陸は$cou_name[$kcon]によって統一されました！");
            MAP_LOG("<font color=#FFFF00>【統一】</font>\[$old_date\]大陸は$cou_name[$kcon]によって統一されました！");

            # 統一したことを記録
            Jikkoku::Model::Unite->unite;

            #統一の歴史など自動で更新
            require './lib/rekisi_kiroku.pl';
            REKISI_KIROKU($KI, $kcon);
          }

        }
      }


    #自分データ書き込み#
    if ( $bukinasi eq "1" ) { $karm = ""; }
    if ($losmes)            { $kiti = ""; }
    CHARA_MAIN_INPUT();

    #終了〜#

    }

  }

  &HEADER;

  print <<"EOM";
<CENTER><hr size=0><h2>$enameと戦闘しました。</h2><p>
<form action="$BACK" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="OK">
</form>
</CENTER>
EOM
  &FOOTER;

  exit;

}

sub battle_result {
  use v5.14;
  use warnings;
  my ($ksol, $esol) = @_;
  if ($ksol <= 0 && $esol <= 0) {
    DRAW;
  }
  elsif ($ksol <= 0) {
    LOSE;
  }
  elsif ($esol <= 0) {
    WIN;
  }
  else {
    NONE;
  }
}

sub conquer_town {
  my $diplomacy_model = shift;

  if ($town_get[$econ] <= 1) {
  
    my @new_country = grep {
      my ($xcid, $xname, $xele, $xmark, $xking, $xmes, $xsub, $xpri) = split(/<>/, $_);
      $econ ne $xcid;
    } @COU_DATA;
    
    open(my $out, '>', $COUNTRY_LIST);
    $out->print(@new_country);
    $out->close;
    
    MAP_LOG2("<font color=red>【滅亡】</font>\[$old_date\]$cou_name[$zcon]は滅亡しました。。");
    MAP_LOG("<font color=red>【滅亡】</font>\[$old_date\]$cou_name[$zcon]は滅亡しました。。");

    #布告リスト処理#
    $diplomacy_model->delete_by_country_id($econ);
    $diplomacy_model->save;
  }

  $zcon = $kcon;
  $town_get[$kcon]++;
  $znou = int($znou*0.7);
  $znou_max = int($znou_max*0.95);
  $zsyo = int($zsyo*0.7);
  $zsyo_max = int($zsyo_max*0.95);
  $znum = int($znum*0.7);
  $zsub1 = int($zsub1*0.7);
  $zsub2 = int($zsub2*0.95);
  $zshiro_max = int($zshiro_max*0.95);
  $zdef_att = 0;
  $zpri = int($zpri*0.7);
  $kex_add += 30;
  $kcex += $kex_add;
  $kpos = "$kiti";
  $kx = $fx;
  $ky = $fy;
  $ksihai++;
  &K_LOG("<font color=blue>$zname</font>を手に入れた！<font color=red>$kex_add</font>の貢献値を得ました！");
  &K_LOG2("<font color=blue>$zname</font>を手に入れた！<font color=red>$kex_add</font>の貢献値を得ました！");
  &MAP_LOG2("<font color=blue>【支配】</font>\[$old_date\]$cou_name[$kcon]の$knameは$znameを支配しました。");
  &MAP_LOG("<font color=blue>【支配】</font>\[$old_date\]$cou_name[$kcon]の$knameは$znameを支配しました。");

  if ( $kspbns == 1 ) {    #撃破時SPボーナス
    $ksg++;
    &K_LOG("<font color=red>【支配ボーナス】</font>SPが<font color=red>+1</font>されました！");
    &K_LOG2("<font color=red>【支配ボーナス】</font>SPが<font color=red>+1</font>されました！");
  }

  if ($kaaiwin) {
    my_arm_attr_up();
  }
  if ($ksinko) {
    &MY_ARMUP_2;
  }
}

#装備品成長関連#
sub MY_BOUUP_1{
  if($kmes >= 150){$kmes += 0.04;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.04$kaaimesされました。");}
  elsif($kmes >= 125){$kmes += 0.05;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.05$kaaimesされました。");}
  elsif($kmes >= 100){$kmes += 0.06;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.06$kaaimesされました。");}
  elsif($kmes >= 75){$kmes += 0.075;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.075$kaaimesされました。");}
  elsif($kmes >= 50){$kmes += 0.1;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.1$kaaimesされました。");}
  elsif($kmes >= 25){$kmes += 0.125;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.125$kaaimesされました。");}
  else{$kmes += 0.15;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.15$kaaimesされました。");}
}

sub MY_BOUUP_2{
  if($kmes >= 150){$kmes += 0.2;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.2$kaaimesされました。");}
  elsif($kmes >= 125){$kmes += 0.3;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.3$kaaimesされました。");}
  elsif($kmes >= 100){$kmes += 0.4;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.4$kaaimesされました。");}
  elsif($kmes >= 75){$kmes += 0.5;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.5$kaaimesされました。");}
  elsif($kmes >= 50){$kmes += 0.6;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.6$kaaimesされました。");}
  elsif($kmes >= 25){$kmes += 0.75;&K_LOG2("【<font color=red>成長</font>】防具の威力が+0.75$kaaimesされました。");}
  else{$kmes += 1;&K_LOG2("【<font color=red>成長</font>】防具の威力が+1.0$kaaimesされました。");}

}

sub MY_ARMUP_1{
  if($karm >= 150){$karm += 0.04;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.04$kaaimesされました。");}
  elsif($karm >= 125){$karm += 0.05;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.05$kaaimesされました。");}
  elsif($karm >= 100){$karm += 0.06;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.06$kaaimesされました。");}
  elsif($karm >= 75){$karm += 0.075;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.075$kaaimesされました。");}
  elsif($karm >= 50){$karm += 0.1;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.1$kaaimesされました。");}
  elsif($karm >= 25){$karm += 0.125;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.125$kaaimesされました。");}
  else{$karm += 0.15;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.15$kaaimesされました。");}
}

sub MY_ARMUP_2{
  if($karm >= 150){$karm += 0.2;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.2$kaaimesされました。");}
  elsif($karm >= 125){$karm += 0.3;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.3$kaaimesされました。");}
  elsif($karm >= 100){$karm += 0.4;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.4$kaaimesされました。");}
  elsif($karm >= 75){$karm += 0.5;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.5$kaaimesされました。");}
  elsif($karm >= 50){$karm += 0.6;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.6$kaaimesされました。");}
  elsif($karm >= 25){$karm += 0.75;&K_LOG2("【<font color=red>成長</font>】武器の威力が+0.75$kaaimesされました。");}
  else{$karm += 1;&K_LOG2("【<font color=red>成長</font>】武器の威力が+1.0$kaaimesされました。");}
}

sub my_arm_attr_up {
  if    ( $kaai >= 150 ) { $kaai += 0.15; $kaaimes = "、武器相性が+0.6"; }
  elsif ( $kaai >= 125 ) { $kaai += 0.45; $kaaimes = "、武器相性が+0.9"; }
  elsif ( $kaai >= 100 ) { $kaai += 0.75; $kaaimes = "、武器相性が+1.2"; }
  elsif ( $kaai >= 75 )  { $kaai += 1.05; $kaaimes = "、武器相性が+1.5"; }
  elsif ( $kaai >= 50 )  { $kaai += 1.35; $kaaimes = "、武器相性が+1.8"; }
  elsif ( $kaai >= 25 )  { $kaai += 1.8;  $kaaimes = "、武器相性が+2.25"; }
  else                   { $kaai += 2.55; $kaaimes = "、武器相性が+3.0"; }
}

sub YOU_BOUUP_1{
  if($emes >= 150){$emes += 0.04;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.04$eaaimesされました。");}
  elsif($emes >= 125){$emes += 0.05;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.05$eaaimesされました。");}
  elsif($emes >= 100){$emes += 0.06;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.06$eaaimesされました。");}
  elsif($emes >= 75){$emes += 0.075;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.075$eaaimesされました。");}
  elsif($emes >= 50){$emes += 0.1;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.1$eaaimesされました。");}
  elsif($emes >= 25){$emes += 0.125;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.125$eaaimesされました。");}
  else{$emes += 0.15;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.15$eaaimesされました。");}
}

sub YOU_BOUUP_2{
  if($emes >= 150){$emes += 0.2;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.2$eaaimesされました。");}
  elsif($emes >= 125){$emes += 0.3;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.3$eaaimesされました。");}
  elsif($emes >= 100){$emes += 0.4;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.4$eaaimesされました。");}
  elsif($emes >= 75){$emes += 0.5;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.5$eaaimesされました。");}
  elsif($emes >= 50){$emes += 0.6;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.6$eaaimesされました。");}
  elsif($emes >= 25){$emes += 0.75;&E_LOG2("【<font color=red>成長</font>】防具の威力が+0.75$eaaimesされました。");}
  else{$emes += 1;&E_LOG2("【<font color=red>成長</font>】防具の威力が+1.0$eaaimesされました。");}
}

sub YOU_ARMUP_1{
  if($earm >= 150){$earm += 0.04;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.04$eaaimesされました。");}
  elsif($earm >= 125){$earm += 0.05;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.05$eaaimesされました。");}
  elsif($earm >= 100){$earm += 0.06;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.06$eaaimesされました。");}
  elsif($earm >= 75){$earm += 0.075;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.075$eaaimesされました。");}
  elsif($earm >= 50){$earm += 0.1;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.1$eaaimesされました。");}
  elsif($earm >= 25){$earm += 0.125;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.125$eaaimesされました。");}
  else{$earm += 0.15;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.15$eaaimesされました。");}

}

sub YOU_ARMUP_2{
  if($earm >= 150){$earm += 0.2;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.2$eaaimesされました。");}
  elsif($earm >= 125){$earm += 0.3;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.3$eaaimesされました。");}
  elsif($earm >= 100){$earm += 0.4;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.4$eaaimesされました。");}
  elsif($earm >= 75){$earm += 0.5;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.5$eaaimesされました。");}
  elsif($earm >= 50){$earm += 0.6;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.6$eaaimesされました。");}
  elsif($earm >= 25){$earm += 0.75;&E_LOG2("【<font color=red>成長</font>】武器の威力が+0.75$eaaimesされました。");}
  else{$earm += 1;&E_LOG2("【<font color=red>成長</font>】武器の威力が+1.0$eaaimesされました。");}

}

sub you_arm_attr_up {
  if    ( $eaai >= 150 ) { $eaai += 0.15; $eaaimes = "、武器相性が+0.6"; }
  elsif ( $eaai >= 125 ) { $eaai += 0.45; $eaaimes = "、武器相性が+0.9"; }
  elsif ( $eaai >= 100 ) { $eaai += 0.75; $eaaimes = "、武器相性が+1.2"; }
  elsif ( $eaai >= 75 )  { $eaai += 1.05; $eaaimes = "、武器相性が+1.5"; }
  elsif ( $eaai >= 50 )  { $eaai += 1.35; $eaaimes = "、武器相性が+1.8"; }
  elsif ( $eaai >= 25 )  { $eaai += 1.8;  $eaaimes = "、武器相性が+2.25"; }
  else                   { $eaai += 2.55; $eaaimes = "、武器相性が+3.0"; }
}

1;

__END__
