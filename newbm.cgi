#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

require './ini_file/index.ini';
require './ini_file/com_list.ini';
require './lib/skl_lib.pl';
require 'suport.pl';

use CGI::Carp qw/fatalsToBrowser/;
use lib './lib', './extlib';
use Jikkoku::Class::Town;
my $town_class = 'Jikkoku::Class::Town';
use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Model::ExtensiveStateRecord;

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($in{'MOVE'}) { require './battlecm/idou.pl';&IDOU(1);}	#BM移動時
if($mode eq 'STATUS') { &STATUS; }
elsif($mode eq 'OSIRASE') { &OSRS("$OSIRASEA"); }
else { &ERR("不正なアクセスです。"); }


#_/_/_/_/_/_/_/_/_/_/_/#
#_/  バトルマップ  _/#
#_/_/_/_/_/_/_/_/_/_/_/#

sub STATUS {

	$idate = time();
	&CHARA_MAIN_OPEN;
  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara       = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get($kid));
  my $ext_state_rec_model = Jikkoku::Model::ExtensiveStateRecord->new;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&MAKE_GUEST_LIST;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);
	($ksingeki_time,$kanother) = split(/,/,$kskldata);

	if(($xcid eq 0)&&($kcon ne 0)){
	$kcon = 0;
	&CHARA_MAIN_INPUT;
	&OSRS("あなたの所属国は滅亡しました。");
	}

	open(IN,"$LOG_DIR/date_count.cgi") or &ERR('ファイルを開けませんでした。');
	@MONTH_DATA = <IN>;
	close(IN);

	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
	$new_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);

	if($mmonth < 4){
		$bg_c = "#FFFFFF";
	}elsif($mmonth < 7){
		$bg_c = "#FFE0E0";
	}elsif($mmonth < 10){
		$bg_c = "#60AF60";
	}else{
		$bg_c = "#884422";
	}

	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);
	$p=0;
	while($p<20){$S_MES .= "<font color=green>●</font>$S_MOVE[$p]<BR>";$p++;}

	&TIME_DATA;

	open(IN,"./charalog/blog/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);
	$p=0;
	while($p<30){$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;}

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

#階級
	$klank = int($kclass / $LANK);
	if($klank > 100){
		$klank=100;
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




	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$uhit=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg)=split(/<>/);
		if("$uid" eq "$kid"){$uhit=1;last;}
	}
	if(!$uhit){
		$unit_id="";
		$uunit_name="無所属";
	}

#移動スキル表示処理#
	&IDOUSKL_HYOJI;

#ヘッダ前処理&インラインフレーム呼び出し時処理
	if($in{'inline'} eq "1"){
	$inline = "<input type=hidden name=inline value=1>";	#インラインフレームで実行していることを知らせるため
	}
	$b_js = 1;
	$zukei = 1;
	&HEADER;
print <<"EOM";


<script type="text/javascript"><!--
function check(MES){
	if(window.confirm(MES)){
		return true;
	}else{
		return false;
	}
}
--></script>


<div id="zukei">
<form action="./newbm.cgi" method="post">$inline<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS>
<button id="botan" type="submit"><div id="reload"></div></button>
<a href="#top"><div id="botan"><div id="up_arrow"></div></div></a>
<a href="#sita"><div id="botan"><div id="down_arrow"></div></div></a>
</form>
</div>


<table width=100%>
<tr><td width=65% valign="top">

EOM

if($ksyuppei){

  #掩護データ
  for my $ext_state (@{ $chara->extensive_states->get_give_effect_states_with_result }) {
    warn $ext_state->name;
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

	$idate = time();
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


	$GENZAI[0] = "";
	$GENZAI[1] = "<br><font color=red>（現在地）</font>";
	$GENZAI[2] = "<br><form action=\"./newbm.cgi\" method=\"post\">$inline<input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=2><input type=hidden name=MOVE value=1><input type=submit id=input value=\"移動\"></form>";
	$GENZAI[3] = "<br><form action=\"./newbm.cgi\" method=\"post\">$inline<input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=3><input type=hidden name=MOVE value=1><input type=submit id=input value=\"移動\"></form>";
	$GENZAI[4] = "<br><form action=\"./newbm.cgi\" method=\"post\">$inline<input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=4><input type=hidden name=MOVE value=1><input type=submit id=input value=\"移動\"></form>";
	$GENZAI[5] = "<br><form action=\"./newbm.cgi\" method=\"post\">$inline<input type=hidden name=mode value=STATUS><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=zahyou value=5><input type=hidden name=MOVE value=1><input type=submit id=input value=\"移動\"></form>";

	$idoucant = 1;


	#敵味方座標検索

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

	$mikatajin = 0;
	$enemyjin = 0;

	foreach(@CL_DATA){
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

	($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

	($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);

	($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL) = split(/,/,$esub4);

		if($kiti eq $eiti){
			if($kid eq $eid){
				$hex = $ex+1;
				$hey = $ey+1;
				$engo = $ENGO_I{"$eid"};
				$MIKATAJIN2[$mikatajin] = "<option value=$eid>($hex,$hey) $ename\[$cou_name[$econ]\] $esol人 0マス $engo</option>";
				$mikatajin++;
			}elsif($kcon eq $econ){
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

	if($esingeki_time-$idate <= 1200 && $esingeki_time-$idate > 790 && $ksinko){ $ejyoutai .= "<img src=\"./image/img/singeki_up.png\"> "; }
	elsif(($esingeki_time-$idate <= 790 && $esingeki_time-$idate > 590 && $ksinko) || ($esingeki_time-$idate <= 1200 && $esingeki_time-$idate > 590 && !$ksinko)){ $ejyoutai .= "<img src=\"./image/img/singeki_down.png\"> "; }

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
				$busyoprf .= "\$(\"#$eid\").hover(function () {\$(this).append(\$(\"<div id=sballon><table style='border:solid 2px $ELE_BG[$cou_ele[$econ]]; padding:7px;'><tr><td rowspan=4><img src=$IMG/$echara.gif style='width:64px;height:64px;'></td><td>($hex,$hey) $ename</td></tr><tr><td>・所属国:$cou_name[$econ]\</td></tr><tr><td>・兵士:$SOL_TYPE[$esub1_ex]($SOL_ZOKSEI[$esub1_ex]) $esol人</td></tr><tr><td>・距離:$zsa3マス</td></tr><tr><td>・武力:$estr</td><td>・知力:$eint</td></tr><tr><td>・統率力:$elea</td><td>・人望:$echa</td></tr><tr><td>・状態:</td><td>$ejyoutai</td></tr></table></div>\"));}, function () {\$(this).find(\"div:last\").remove();});\n";
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
				$busyoprf .= "\$(\"#$eid\").hover(function () {\$(this).append(\$(\"<div id=sballon><table style='border:solid 2px $ELE_BG[$cou_ele[$econ]]; padding:7px;'><tr><td rowspan=4><img src=$IMG/$echara.gif style='width:64px;height:64px;'></td><td>($hex,$hey) $ename</td></tr><tr><td>・所属国:$cou_name[$econ]\</td></tr><tr><td>・兵士:$SOL_TYPE[$esub1_ex]($SOL_ZOKSEI[$esub1_ex]) $esol人</td></tr><tr><td>・距離:$zsa3マス</td></tr><tr><td>・武力:$estr</td><td>・知力:$eint</td></tr><tr><td>・統率力:$elea</td><td>・人望:$echa</td></tr><tr><td>・状態:</td><td>$ejyoutai</td></tr></table></div>\"));}, function () {\$(this).find(\"div:last\").remove();});\n";
				$enemyjin++;
			}
		}
	}


print "\n\n<script type=\"text/javascript\"><!--
\$(document).ready(function(){

$busyoprf

});
--></script>\n\n";


	#バトルマップ読み込み
	require "./log_file/map_hash/$kiti.pl";


	$bmcolspan = $BM_X + 1;

	print "<table width\=100\%><tr><td align=left><font color\=AA8866><B>\- $battkemapname\マップ \-</B></font></td></tr></table><TABLE bgcolor\=$bg_c width\=100\% height\=5 border\=\"0\" cellspacing\=1 class=\"mwindow\"><TBODY><TR><TH colspan\= $bmcolspan bgcolor\=442200 class=\"inwindow\"><font color=FFFFFF>$new_date</TH></TR><TR><TD width\=20 bgcolor\=$TD_C2>\-</TD>";

	for($i=1;$i<$BM_X+1;$i++){
		print "<TD width=35 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";

	for($i=0;$i<$BM_Y;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3 width=5>$n</td>";
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
					$zou_ip = int( ($town_shiro[$kiti] / (15+($myear*0.583)) )*60);
					$zou_ip2 = int($zou_ip/2);
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
				}elsif( ($BM_TIKEI[$i][$j] == 18|| $BM_TIKEI[$i][$j] == 22) && $kcon eq $town_cou[$kiti]){
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
				$SEKISYO[$i][$j] = "<font color=white>$ikisaki2</font>";
				}elsif($BM_TIKEI[$i][$j] == 16){
				($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
				$SEKISYO[$i][$j] = "<font color=white>$ikisaki2</font>";
				}elsif($BM_TIKEI[$i][$j] == 18|| $BM_TIKEI[$i][$j] == 22){
				$jyouheki[18] = "<br><font color=white>$town_name[$kiti]<br>城壁:$town_shiro[$kiti]</font>";
				$jyouheki[22] = "<br><font color=white>$town_name[$kiti]<br>城壁:$town_shiro[$kiti]</font>";
				}
			print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"35\" height=\"35\" align=center valign=middle><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]</font>$jyouheki[$BM_TIKEI[$i][$j]]$SEKISYO[$i][$j]$butaibasyo$GENZAI[$genzai]</TH>";
			$butaibasyo = "";
			$idoucant = 1;
			}else{
			print "<TH bgcolor=$BMCOL[0] width=\"35\" height=\"35\" align=center valign=middle>&nbsp;</TH>";
			}
		}
	print "</TR>";
	}

	print "</TBODY></TABLE>\n</td>";

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
	$Ialert;
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


<td width=35%>
<TABLE width=100% height=100% bgcolor=$ELE_BG[$xele] cellspacing=2 class="mwindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele] colspan=8><font color=$ELE_C[$xele]>BM用コマンド<br>$ksinkomes</font></TH></TR>
<TR><TD>兵士</TD><TH colspan="2">$SOL_TYPE[$ksub1_ex]($SOL_ZOKSEI[$ksub1_ex]) $ksol人</TH><TD>訓練</TD><TH>$kgat</TH></TR>
<TR><TD>状態</TD><TH colspan="2">$jyoutai</TH><TD>士気</TD><TH>$ksiki / $ksiki_max</TH></TR>
<TR><TD width="90">移P補充</TD><TH>移動P</TH><TH colspan=2>$kidoup / $SOL_MOVE[$ksub1_ex]</TH><TH colspan=3><form action=\"./battlecm.cgi\" method=\"post\">$inline<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=IDOUP>$iphojyu</TH></form></TR>
<TR><TD>行動</TD><form action="./battlecm.cgi" method="post"><TD align=left colspan=5>
$inline
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
$inline
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
<TR><TD align="right" colspan="6">[<a href="./manual.html#sen" target="_blank">戦闘の説明</a>]</TD></TR>
</TBODY></TABLE>

</td></tr>

EOM

}

print <<"EOM";


<tr><td colspan="2" width=100%>
<center>
<TABLE width=100% bgcolor=$ELE_BG[$xele] cellspacing=1 class="mwindow" style="margin:3px"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=19 bgcolor=$ELE_BG[$xele] class="inwindow"><font color=$ELE_C[$xele]>$kname$rank_mes</font></TH></TR>
<TR><TD rowspan=5 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr.$kstr_ex</TH><TD>知力</TD><TH>$kint.$kint_ex</TH><TD>統率力</TD><TH>$klea.$klea_ex</TH><TD>人望</TD><TH>$kcha.$kcha_ex</TH><th bgcolor=$ELE_BG[$xele]></th><TD>武器</TD><TH colspan=3>$kaname</TH><TH colspan=1>$karm</TH><TD>属性</TD><TH>$kazoku</TH><TD>相性</TD><TH>+$kaai</TH></TR>
<TR><TD>所属</TD><TH>$cou_name[$kcon]</TH><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>忠誠度</TD><TH>$kbank</TH><th bgcolor=$ELE_BG[$xele]></th><TD>書物</TD><TH colspan=7>$ksname</TH><TH colspan=1>$kbook</TH></TR>
<TR><TD>部隊</TD><TH>$uunit_name</TH><TD>階級</TD><TH>Lv.$klank $LANK[$klank]</TH><TD>貢献値</TD><TH>$kcex</TH><TD>階級値</TD><TH>$kclass</TH><th bgcolor=$ELE_BG[$xele]></th><TD>防具</TD><TH colspan=7>$kbname</TH><TH colspan=1>$kmes</TH></TR>
<TR><TD>兵種</TD><TH>$SOL_TYPE[$ksub1_ex]</TH><TD>属性</TD><TH>$SOL_ZOKSEI[$ksub1_ex]</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH colspan=1>$kgat</TH><th bgcolor=$ELE_BG[$xele]></th><TD colspan=1>攻撃力</TD><TH colspan=8>$kkou$kaikmes$katt_add2$katt_add3</TH></TR>
<TR><TD>士気</TD><TH>$ksiki / $ksiki_max</TH><TD>移動P</TD><TH>$kidoup / $SOL_MOVE[$ksub1_ex]</TH><TD>リーチ</TD><TH>$SOL_AT[$ksub1_ex]</TD><TD>状態</TD><TH>$jyoutai</TH><th bgcolor=$ELE_BG[$xele]></th><TD>守備力</TD><TH colspan=8>$kbou$katt_def2$katt_def3</TH></TR>
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
</center>
</TABLE>
</td></tr>


<!-- ログ切り替え部分 -->
<script type="text/javascript"><!--
\$(document).ready(function(){
	\$("#map").click(function () {
		var mlog = document.getElementById('maplog');
		mlog.style.display = "table-row";
		mlog = document.getElementById('blog');
		mlog.style.display = "none";
		mlog = document.getElementById('map');
		mlog.style.backgroundColor = "$TD_C1"
		mlog = document.getElementById('battle');
		mlog.style.backgroundColor = "$TABLE_C"
	});
	\$("#battle").click(function () {
		var mlog = document.getElementById('maplog');
		mlog.style.display = "none";
		mlog = document.getElementById('blog');
		mlog.style.display = "table-row";
		mlog = document.getElementById('battle');
		mlog.style.backgroundColor = "#FFFFFF"
		mlog = document.getElementById('map');
		mlog.style.backgroundColor = "$TABLE_C"
	});
});
--></script>


<tr><td colspan=2>
<center>
<TABLE class="mwindow" style="width:100%;background-color:$TABLE_C;margin:3px">
<TR><TD id="map" style="background-color:$TABLE_C;text-align:center;width:50%;">- マップログ -</TD>
<TD id="battle" style="background-color:#FFFFFF;text-align:center;width:50%;">- 戦闘ログ -</TD></TR>
<TR id="maplog" style="display:none;"><TD colspan="2" style="background-color:$TD_C1;"><div style="height:200px;width:100%;overflow:scroll;font-size:$ksettei;-webkit-overflow-scrolling:touch;">$S_MES</div></TD></TR>
<TR id="blog"><TD colspan="2" style="background-color:#FFFFFF;"><div style="height:200px;width:100%;overflow:scroll;font-size:$ksettei;-webkit-overflow-scrolling:touch;">$log_list</div></TD></TR>
</center>
</TABLE>

</td></tr></table>

<center>
<br>
<input type="button" value="閉じる" onClick="window.close();">
</center>
EOM

	&FOOTER;
	exit;
}
