#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

require './ini_file/index.ini';
require 'i-suport.pl';

use lib './lib', './extlib';
use CGI::Carp qw( fatalsToBrowser );
use Jikkoku::Model::Country;
use Jikkoku::Model::Diplomacy;

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($mode eq 'STATUS') { &STATUS; }
elsif($mode eq 'COMMAND') { &COMMAND; }
elsif($mode eq 'MENT') { &MENT; }
elsif($mode eq 'BLOG') { &BLOG; }
elsif($mode eq 'B_DATA') { &B_DATA; }
elsif($mode eq 'C_DATA') { &C_DATA; }
elsif($mode eq 'T_DATA') { &T_DATA; }
elsif($mode eq 'OSIRASE') { &OSRS("$OSIRASEA"); }
else { &ERR("不正なアクセスです。"); }


#_/_/_/_/_/_/_/_/_/_/_/#
#_/  ステータス画面  _/#
#_/_/_/_/_/_/_/_/_/_/_/#

sub STATUS {

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&MAKE_GUEST_LIST;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);

	if(($xcid eq 0)&&($kcon ne 0)){
	$kcon = 0;
	&CHARA_MAIN_INPUT;
	&OSRS("あなたの所属国は滅亡しました。");
	}

#プロフ読み込み
	open(IN, "./charalog/prof/$kid.cgi");
	$prof = <IN>;
	close(IN);

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
	if($unit_id eq $kid){
		$add_com = "<option value=28>集合";
	}

	open(IN,"$MAP_LOG_LIST");
	@S_MOVE = <IN>;
	close(IN);
	$p=0;
	while($p<5){$S_MES .= "<font color=green>●</font>$S_MOVE[$p]<BR>";$p++;}

	&TIME_DATA;

	open(IN,"./charalog/log/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);
	$p=0;
	while($p<5){$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;}

	open(IN,"./charalog/blog/$kid.cgi");
	@BLOG_DATA = <IN>;
	close(IN);
	$p=0;
	while($p<5){$blog_list .= "<font color=navy>●</font>$BLOG_DATA[$p]<BR>";$p++;}

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);
	for($i=0;$i<6;$i++){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
		$no = $i+1;
		if($cid eq ""){
		$com_list .= "$no: - <BR>";
		}else{
		$com_list .= "$no: $cname<BR>";
		}
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

	KILL:for($i=0;$i<$BM_Y;$i++){
		for($j=0;$j<$BM_X;$j++){
			if($BM_TIKEI[$i][$j] == 18){
				foreach(@CL_DATA){
				($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
				($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
				($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);
					if($ex == $j && $ey == $i && $eiti eq $kpos){
					$def_list .= "$ename($esol) ";
					}
				}
			last KILL;
			}
		}
	}

	$next_time = int(($kdate + $TIME_REMAKE - $tt) / 60);
	$next_minute = int($kdate + $TIME_REMAKE - $tt)-($next_time*60);
	if($next_time < 0){
		$next_time = 0;
	}
        if($next_minute < 0){
                $next_minute = 0;
    	}

	$del_out = $DEL_TURN - $ksub2;

	$klank = int($kclass / $LANK);
	if($klank > 100){
		$klank=100;
	}

#迂回阻止度
	$shiro_sosi_p = int(($zshiro/(300+($myear*11.666)))*100);
	if($shiro_sosi_p > 100){
	$shiro_sosi_p = 100;
	$shiro_sosi_p += int ( ( ($zshiro-(300+($myear*11.666) ) )/( (300+($myear*11.666))*3 ) )*100 );
	if($shiro_sosi_p > 200){$shiro_sosi_p = 200;}
	}
	$shiro_sosi_s = $zshiro / (15+($myear*0.583));
	if($shiro_sosi_s > ($BMT_REMAKE*10)/60){
	$shiro_sosi_s = ($BMT_REMAKE*10)/60;
	$shiro_sosi_s += ($zshiro - (300+($myear*11.666)) )/( (15+($myear*0.583)) * 3);
	if($shiro_sosi_s > ($BMT_REMAKE*10)/30){$shiro_sosi_s = ($BMT_REMAKE*10)/30;}
	}
	$shiro_sosi_s = int($shiro_sosi_s*60);
	$shiro_sosi = "$shiro_sosi_p% (足止め効果:$shiro_sosi_s秒)";

#城耐久計算
	$taikyu = $myear*125;
	if($taikyu<1000){
	$taikyu = 1000;
	}elsif($taikyu>9999){
	$taikyu = 9999;
	}

  my $country_model = Jikkoku::Model::Country->new;
  my $country       = $country_model->get_with_option($kcon)->get_or_else( $country_model->neutral );
  my $diplomacy_model = Jikkoku::Model::Diplomacy->new;
  my $diplomacy_list  = $diplomacy_model->get_by_country_id($country->id);

	&HEADER;
print <<"EOM";
<b>指令</b>:$xmes<HR>
<b>[外交状況]</b><br><br>
@{[ map { $_->show_status($country->id, $country_model) . '<br>' } @$diplomacy_list ]}
<HR>
$new_date<BR><BR>
<B>\[$zname\]</B><BR>
支配国:$cou_name[$zcon]<BR>
農民:$znum/$zsub2人 | 民忠:$zpri<BR>
農業:$znou/$znou_max<BR>
商業:$zsyo/$zsyo_max<BR>
技術:$zsub1/9999<BR>
城壁:$zshiro/$zshiro_max<BR>
城壁耐久力:$zdef_att/$taikyu<BR>
迂回阻止度:$shiro_sosi<BR>
相場:$zsouba
<BR>
$znameの守備:$def_list<BR>
Online:$m_list<BR>
<HR>
<B>\[個人データ\]</B><BR><br>
$kname［所属国:$cou_name[$kcon]］\[$uunit_name部隊\]<BR><BR>

武力:$kstr\.$kstr_ex<br>
知力:$kint\.$kint_ex<br>
統率力:$klea\.$klea_ex<br>
人望:$kcha\.$kcha_ex<BR><br>
金:$kgold|米:$krice<br>
貢献:$kcex|階級:$LANK[$klank]|階級値:$kclass<BR>
兵種:$SOL_TYPE[$ksub1_ex]|属性:$SOL_ZOKSEI[$ksub1_ex]|兵士:$ksol人|訓練値:$kgat|士気:$ksiki / $ksiki_max<BR>
武器:$kaname:威力:$karm:属性:$kazoku:相性:+$kaai
<BR>書物:$ksname:威力:$kbook\|防具:$kbname:威力:$kmes<BR>
<br>
忠誠度:$kbank|画像番号:$kchara
<BR>戦勝メッセージ:$kcm
<BR>自己紹介メッセージ:$prof
<HR>

EOM

if($ksyuppei){

print <<"EOM";

<form action="./i-newbm.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=STATUS>
<input type=hidden name=pass value=$kpass>
<input type=submit value="バトルマップを表示">
</form>
<HR>

EOM

}

print <<"EOM";

<form action="./i-command.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=hidden name=pass value=$kpass>
<input type=submit value="会議室">
</form>

<form action="./i-command.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=LETTER>
<input type=hidden name=pass value=$kpass>
<input type=submit value="手紙">
</form>

<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=MENT>
<input type=hidden name=pass value=$kpass>
<input type=submit value="設定＆戦績">
</form>

<form action="./i-command.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=UNIT_SELECT>
<input type=hidden name=pass value=$kpass>
<input type=submit value="部隊編成">
</form>

<hr>

<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=T_DATA>
<input type=hidden name=pass value=$kpass>
<input type=submit value="都市データ">
</form>

<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=C_DATA>
<input type=hidden name=pass value=$kpass>
<input type=submit value="国データ">
</form>

<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=B_DATA>
<input type=hidden name=pass value=$kpass>
<input type=submit value="国の武将データ">
</form>

<HR>

<B>\[コマンドリスト\]</B><BR><br>
$daytime
<BR>
$com_list
<BR>
次のターンまで$next_time分$next_minute秒
<BR>
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=COMMAND>
<input type=hidden name=pass value=$kpass>
<input type=submit value="コマンド入力">
</form>
<HR>
<B>\[全国ログ\]</B><BR><BR>
$S_MES
<HR>
<B>\[戦闘ログ\]</B><BR><BR>
$blog_list
<BR>
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=BLOG>
<input type=submit value="戦闘ログ全表示">
</form>
<HR>
<B>\[過去ログ\]</B><BR><BR>
$log_list
<BR>
<form action="./i-mylog.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="過去ログ全表示">
</TD></TR></form>

<HR>
<form action=\"./status.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"PC版へ移動\"></form>
<HR>
<BR>
EOM
	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/#
#_/  コマンド入力画面  _/#
#_/_/_/_/_/_/_/_/_/_/_/#

	sub COMMAND {

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&MAKE_GUEST_LIST;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);

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
	if($unit_id eq $kid){
		$add_com = "<option value=28>集合";
	}

	&TIME_DATA;

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);
	for($i=0;$i<24;$i++){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
		$no = $i+1;
		if($cid eq ""){
		$com_list .= "$no: - <BR>";
		}else{
		$com_list .= "$no: $cname<BR>";
		}
	}

	$next_time = int(($kdate + $TIME_REMAKE - $tt) / 60);
	$next_minute = int($kdate + $TIME_REMAKE - $tt)-($next_time*60);
	if($next_time < 0){
		$next_time = 0;
	}
        if($next_minute < 0){
                $next_minute = 0;
    	}

	$del_out = $DEL_TURN - $ksub2;

	if($kclass>=5000){
		$add_com7 = "<option value=34>農地開拓(50G)";
		$add_com8 = "<option value=35>市場建設(50G)";
		$add_com9 = "<option value=36>城壁拡張(50G)";
		$add_com10 = "<option value=37>開拓(人望R)";
		$add_com17 = "<option value=62>調査(500G)";
	}

	if($kclass>=6000){
		$add_com11 = "<option value=31>兵士猛訓練(50G)";
	}

	if($kclass>=10000){
		$add_com2 = "<option value=38>農地破壊(200G)";
		$add_com3 = "<option value=40>市場破壊(200G)";
		$add_com4 = "<option value=42>技術衰退(200G)";
		$add_com5 = "<option value=44>城壁劣化(200G)";
		$add_com6 = "<option value=46>流言(200G)";
		$add_com14 = "<option value=48>偵察(500G)";
		$add_com11 = "<option value=31>兵士猛訓練(50G)";
	}

	if($kclass>=15000){
		$add_com15 = "<option value=52>入植(500G&500R)";
	}

	if($kclass>=25000){
		$add_com12 = "<option value=32>兵士特訓(100G)";
	}

	if($kclass>=50000){
		$add_com13 = "<option value=33>兵士猛特訓(200G)";
	}

	if($ksyuppei){
		$add_com16 = "<option value=61>退却";
	}

	&HEADER;
print <<"EOM";
<HR>

<B>\[コマンドリスト\]</B><BR>
$com_list<HR>
<form action="./i-command.cgi" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<B>\[コマンド入力\]</B><BR>$daytime<BR>
No:<select name=no size=4 MULTIPLE>
<option value=all>ALL
EOM
	for($i=0;$i<$MAX_COM;$i++){
		$no = $i+1;
		print "<option value=\"$i\">$no";
	}
print <<"EOM";
</select>
<select name=mode>
<option value="0">何もしない
<option value="64">空白を入れる
<option value="65">コマンド削除
<option value="">== 内政 ==
<option value="1">農業開発(50G)
$add_com7
<option value="2">商業発展(50G)
$add_com8
<option value="29">技術開発(50G)
<option value="3">城壁強化(50G)
$add_com9
<option value="30">城壁耐久力強化(50G)
<option value="8">米施し(50R)
$add_com10
$add_com15
<option value="66">巡察(100G)
<option value="">== 軍事 ==
<option value="9">徴兵
<option value="11">兵士訓練
$add_com11
$add_com12
$add_com13
<option value="53">城の守備
<option value="60">城の守備(座標指定)(200R)
<option value="13">戦争
$add_com16
<option value="">== 諜略 ==
<option value="24">登用(50G)
$add_com17
$add_com14
<option value="">== 計略 ==
<option value="55">建国
<option value="58">反乱
$add_com2
$add_com3
$add_com4
$add_com5
$add_com6
<option value="">== 鍛錬 ==
<option value="26">\能\力強化(500G)
<option value="">== 商人 ==
<option value="14">米売買
<option value="15">武器購入
<option value="16">書物購入
<option value="50">防具購入
<option value="">== 移動 ==
<option value="17">移動
$add_com
<option value="21">仕官
<option value="54">下野
</select><input type=submit value=\"実行\"></form>
次のターンまで$next_time分$next_minute秒<BR>
<HR>
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=STATUS>
<input type=hidden name=pass value=$kpass>
<input type=submit value="スターテス画面に戻る">
</form>

EOM
	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/#
#_/      設定画面     _/#
#_/_/_/_/_/_/_/_/_/_/_/#

	sub MENT {

	require './lib/hs_keisan.pl';

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;
	&HEADER;


	#順位#

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/,$page[0]);

	if($ename =~ "【NPC】"){next;}

	($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
	($esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$ehiki,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$esihaicn,$ekezuricn) = split(/,/,$esub3);

	#攻防力計算
	($eatt_add,$eatt_def) = &HS_KEISAN(0,0,$esub1_ex,$estr,$eint,$elea,$echa,$earm,$ebook,$emes);
	$ekou = int($estr + $earm + $eatt_add);
	$ebou = int($eatt_def + $emes + ($egat / 2));
	$ekoubou = $ekou+$ebou;

	$esentou = $ebouwin + $ekouwin + $ekoulos + $eboulos + $ehiki + $esihai;
	$esensin = $ebouwin + $ekouwin;
			push(@CL_DATA,"$eid<>$esitahei<>$esarehei<>$ebouwin<>$ekouwin<>$ekoulos<>$eboulos<>$ekun<>$enai<>$emei<>$esentou<>$esensin<>$eoujyou<>$e_kei<>$e_tan<>$esihai<>$ekezuri<>$ekou<>$ebou<>$ekoubou<>\n");
		}
	}
	closedir(dirlist);

	@tmp = map {(split /<>/)[1]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesitahei == $esitahei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ktaosij = $j;
		}
		$mesitahei = $esitahei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[2]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesarehei == $esarehei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ksarej = $j;
		}
		$mesarehei = $esarehei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[3]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mebouwin == $ebouwin){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kbwj =$j;
		}
		$mebouwin = $ebouwin;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[4]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mekouwin == $ekouwin){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kkwj =$j;
		}
		$mekouwin = $ekouwin;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[5]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mekoulos == $ekoulos){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kklj =$j;
		}
		$mekoulos = $ekoulos;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[6]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($meboulos == $eboulos){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kblj =$j;
		}
		$meboulos = $eboulos;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[7]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mekun == $ekun){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kkunj =$j;
		}
		$mekun == $ekun;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[8]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($menai == $enai){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$knaij =$j;
		}
		$menai = $enai;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[9]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($memei == $emei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ktyouj =$j;
		}
		$memei = $emei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[10]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesentou == $esentou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ksentouj =$j;
		}
		$mesentou = $esentou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[11]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesensin == $esensin){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ksensinj =$j;
		}
		$mesensin = $esensin;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[12]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou) = split(/<>/);

		if($meoujyou == $eoujyou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$koujyouj =$j;
		}
		$meoujyou = $eoujyou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[13]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei) = split(/<>/);

		if($me_kei == $e_kei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_keij =$j;
		}
		$me_kei = $e_kei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[14]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan) = split(/<>/);

		if($me_tan == $e_tan){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_tanj =$j;
		}
		$me_tan = $e_tan;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[15]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai) = split(/<>/);

		if($me_siha == $esihai){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_sihaj =$j;
		}
		$me_siha = $esihai;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[16]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri) = split(/<>/);

		if($me_kezu == $ekezuri){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_kezuj =$j;
		}
		$me_kezu = $ekezuri;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[17]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$ekou) = split(/<>/);

		if($meatt_add == $ekou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$katj =$j;
		}
		$meatt_add = $ekou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[18]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$ekou,$ebou) = split(/<>/);

		if($mdef == $ebou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kdefj =$j;
		}
		$mdef = $ebou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[19]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$ekou,$ebou,$ekoubou) = split(/<>/);

		if($mkb == $ekoubou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kkbj =$j;
		}
		$mkb = $ekoubou;
		$mj = $j;
		$i++;
	}

#終了#


#メモ読み込み
	open(IN, "./charalog/memo/$kid.cgi");
	$memo = <IN>;
	close(IN);

#プロフ読み込み
	open(IN, "./charalog/prof/$kid.cgi");
	$prof = <IN>;
	close(IN);

#タグ
	$memo =~ s/<br>/\n/g;

	$prof =~ s/<br>/\n/g;
	if($prof =~ /<font color=\"red\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"red\">/<red>/g;
	$prof =~ s/<\/font>/<\/red>/g;
	}if($prof =~ /<font color=\"blue\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"blue\">/<blue>/g;
	$prof =~ s/<\/font>/<\/blue>/g;
	}if($prof =~ /<font color=\"#00FF00\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"#00FF00\">/<green>/g;
	$prof =~ s/<\/font>/<\/green>/g;
	}if($prof =~ /<font color=\"#000000\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"#000000\">/<black>/g;
	$prof =~ s/<\/font>/<\/black>/g;
	}if($prof =~ /<a href\=\"/ && $prof =~ /\" target=\"_blank\"/ && $prof =~ /<\/a\>/){
	$prof =~ s/<a href\=\"/<a>/g;
	$prof =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($kcm =~ /<font color=\"red\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"red\">/<red>/g;
	$kcm =~ s/<\/font>/<\/red>/g;
	}if($kcm =~ /<font color=\"blue\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"blue\">/<blue>/g;
	$kcm =~ s/<\/font>/<\/blue>/g;
	}if($kcm =~ /<font color=\"#00FF00\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"#00FF00\">/<green>/g;
	$kcm =~ s/<\/font>/<\/green>/g;
	}if($kcm =~ /<font color=\"#000000\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"#000000\">/<black>/g;
	$kcm =~ s/<\/font>/<\/black>/g;
	}if($kcm =~ /<a href\=\"/ && $kcm =~ /\" target=\"_blank\"/ && $kcm =~ /<\/a\>/){
	$kcm =~ s/<a href\=\"/<a>/g;
	$kcm =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($kaname =~ /<font color=\"red\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"red\">/<red>/g;
	$kaname =~ s/<\/font>/<\/red>/g;
	}if($kaname =~ /<font color=\"blue\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"blue\">/<blue>/g;
	$kaname =~ s/<\/font>/<\/blue>/g;
	}if($kaname =~ /<font color=\"#00FF00\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"#00FF00\">/<green>/g;
	$kaname =~ s/<\/font>/<\/green>/g;
	}if($kaname =~ /<font color=\"#000000\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"#000000\">/<black>/g;
	$kaname =~ s/<\/font>/<\/black>/g;
	}if($kaname =~ /<a href\=\"/ && $kaname =~ /\" target=\"_blank\"/ && $kaname =~ /<\/a\>/){
	$kaname =~ s/<a href\=\"/<a>/g;
	$kaname =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($kbname =~ /<font color=\"red\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"red\">/<red>/g;
	$kbname =~ s/<\/font>/<\/red>/g;
	}if($kbname =~ /<font color=\"blue\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"blue\">/<blue>/g;
	$kbname =~ s/<\/font>/<\/blue>/g;
	}if($kbname =~ /<font color=\"#00FF00\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"#00FF00\">/<green>/g;
	$kbname =~ s/<\/font>/<\/green>/g;
	}if($kbname =~ /<font color=\"#000000\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"#000000\">/<black>/g;
	$kbname =~ s/<\/font>/<\/black>/g;
	}if($kbname =~ /<a href\=\"/ && $kbname =~ /\" target=\"_blank\"/ && $kbname =~ /<\/a\>/){
	$kbname =~ s/<a href\=\"/<a>/g;
	$kbname =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($ksname =~ /<font color=\"red\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"red\">/<red>/g;
	$ksname =~ s/<\/font>/<\/red>/g;
	}if($ksname =~ /<font color=\"blue\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"blue\">/<blue>/g;
	$ksname =~ s/<\/font>/<\/blue>/g;
	}if($ksname =~ /<font color=\"#00FF00\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"#00FF00\">/<green>/g;
	$ksname =~ s/<\/font>/<\/green>/g;
	}if($ksname =~ /<font color=\"#000000\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"#000000\">/<black>/g;
	$ksname =~ s/<\/font>/<\/black>/g;
	}if($ksname =~ /<a href\=\"/ && $ksname =~ /\" target=\"_blank\"/ && $ksname =~ /<\/a\>/){
	$ksname =~ s/<a href\=\"/<a>/g;
	$ksname =~ s/\" target=\"_blank\"/<aa>/g;
	}


	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);

	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);
	
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);

	($karm2,$kaname2,$kazoku2,$kaai2) = split(/,/,$ksub5);

	$buki1 = "<option value=\"0\">名称:$kaname 威力:$karm 属性:$kazoku 相性:+$kaai【装備中】";
	if(($karm eq "")&&($kaname eq "")&&($kazoku eq "")&&($kaai eq "")){
	$buki1 = "<option value=\"0\">------【武器なし】-----";
	}
	$buki2 = "<option value=\"1\">名称:$kaname2 威力:$karm2 属性:$kazoku2 相性:+$kaai2";
	if(($karm2 eq "")&&($kaname2 eq "")&&($kazoku2 eq "")&&($kaai2 eq "")){
	$buki2 = "<option value=\"1\">------【武器なし】-----";
	}

	#移動P補充可能時通知設定
	if($ksettei2==1){$sel1="SELECTED";}elsif($ksettei2==2){$sel2="SELECTED";}elsif($ksettei2==3){$sel3="SELECTED";}
	#行動可能時通知設定
	if($ksettei4==1){$sel_1="SELECTED";}elsif($ksettei4==2){$sel_2="SELECTED";}elsif($ksettei4==3){$sel_3="SELECTED";}
	#BM表示設定
	if($kindbmm==1){$ind1="SELECTED";}elsif($kindbmm==2){$ind2="SELECTED";}elsif($kindbmm==3){$ind3="SELECTED";}

	#陣形読み込み#
	open(IN,"./log_file/jinkei.cgi") or &ERR2("陣形データ読み込み失敗");
	@JINKEI = <IN>;
	close(IN);
	
	$i = 0;
	if($kjinkei eq ""){$kjinkei=0;}
	foreach(@JINKEI){
	($jinname,$jinaup,$jindup,$jinaup2,$jindup2,$jinaup3,$jindup3,$jin_tokui,$jinchange,$jinclas,$jinsetumei,$jinsub,$jinsub2)=split(/<>/);
		if($kjinkei eq $i){
		$jin = "$jinname";
		$mes ="$jinsetumei陣形を整えるのにかかる時間は$jinchange秒。";
		$sel ="SELECTED";
			}else{
				$sel ="";
		}
		if($jinclas <= $kclass && $jinsub2 eq ""){
		$JINNAME[$i] = "<option value=\"$i\" $sel>$jinname";
			}
	$i++;
	}

	$ksentou = $kbouwin + $kkouwin + $kkoulos + $kboulos + $khiki + $ksihai;
	$ksensin = $kbouwin + $kkouwin;

	#攻防力計算
	($katt_add,$katt_def) = &HS_KEISAN(0,0,$ksub1_ex,$kstr,$kint,$klea,$kcha,$karm,$kbook,$kmes);
	$kkou = int($kstr + $karm + $katt_add);
	$kbou = int($katt_def + $kmes + ($kgat / 2));
	$kkoubou = $kkou+$kbou;

	$ihihi = int(rand(30));
	if($ihihi eq "1"){
	$ahaha = "<TABLE cellspacing=1 bgcolor=#000000><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=#000000 colspan=2><form action=\"./modoru.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=image src=image/img/3578.png></form></TABLE>";

	}

	print <<"EOM";
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 設定＆戦績 - </font>
</TH></TR>
</TABLE>

<TABLE border=0 bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>
<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>

<HR color="#000000">

<TABLE border="0">
<TABLE cellspacing="1" bgcolor=$ELE_BG[$xele] class="mwindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=10 bgcolor=$ELE_BG[$xele] class="inwindow"><font color=$ELE_C[$xele]>- 設定 -</font></TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>マイページでのBM表示設定</TD><TH colspan=7>
<select name=sel>
<option value="0">移動しやすいタイプ 表示
<option value="1" $ind1>移動しやすいタイプ 非表示
<option value="2" $ind2>通常 表示する
<option value="3" $ind3>通常 表示しない
</select>
</TH><TH>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=INDBM>
<input type=submit id=input value="設定">
</form></TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>文字サイズ設定</TD><TH colspan=7>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=SIZECHANGE>
<select name=size>

EOM
for($i=1;$i<=40;$i++){
		if($i == $ksettei){
			print "<option value=\"$i\" SELECTED>$i";
		}else{
			print "<option value=\"$i\">$i";
		}
	}
print <<"EOM";

</TH><TH>
<input type=submit id=input value="決定">
</form></TH></TR>
<form action="./auto_in.cgi" method="post"><TR><TD colspan=2>BM上での行動予約(BM自動モード)</TD><TH colspan=8>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=submit id=input value=表示>
</form></TH></TR>
<form action="./mydata.cgi" method="post" name="base"><TR><TD colspan=2>移動P補充可能になった時の通知設定<br><font size="1">※携帯版では通知音を再生できません。</font></TD><TH colspan=4>
<select name=sel>
<option value="0">通知しない
<option value="1" $sel1>通知音を鳴らす
<option value="2" $sel2>アラートを出す
<option value="3" $sel3>通知音とアラートを出す
</select>
</TH><td style="width:70px;">
通知音設定
</td><TH style="width:10px;">
<select name="sound">
EOM
for($i=1;$i<=7;$i++){
	if($ksettei3 == $i){
	print "<option value=\"$i\" SELECTED>$i番\n";
	}else{
	print "<option value=\"$i\">$i番\n";
	}
}
print <<"EOM";
</select>
</TH><TH style="width:10px;">
<input type="button" onClick="play(document.base.sound.selectedIndex)" value="再生">
</TH><TH>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=\"ALERT\">
<input type=submit id=input value=設定>
</form></TH></TR>
<form action="./mydata.cgi" method="post" name="base2"><TR><TD colspan=2>行動可能になった時の通知設定<br><font size="1">※携帯版では通知音を再生できません。</font></TD><TH colspan=4>
<select name=sel>
<option value="0">通知しない
<option value="1" $sel_1>通知音を鳴らす
<option value="2" $sel_2>アラートを出す
<option value="3" $sel_3>通知音とアラートを出す
</select>
</TH><td style="width:70px;">
通知音設定
</td><TH style="width:10px;">
<select name="sound2">
EOM
for($i=1;$i<=7;$i++){
	if($ksettei5 == $i){
	print "<option value=\"$i\" SELECTED>$i番\n";
	}else{
	print "<option value=\"$i\">$i番\n";
	}
}
print <<"EOM";
</select>
</TH><TH style="width:10px;">
<input type="button" onClick="play(document.base2.sound2.selectedIndex)" value="再生">
</TH><TH>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=\"ALERT2\">
<input type=submit id=input value=設定>
</form></TH></TR>
<TR><form action="./mydata.cgi" method="post"><TD colspan=1>陣形<br><font size="1">[<a href="./manual.html#jin" target="_blank">陣形について</a>]</font></TD>
<th width=70>$jin</th>
<TH colspan=6>$mes</TH>
<th>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=JINKEI>
<select name=jinkei>
@JINNAME
</select>
</TH><TH>
<input type=submit id=input value="変更"></form>
</TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>忠誠度<br><font size="1">※<font color=red>非常に重要です。</font>簒奪、建国に影響します。詳しくは<a href="./manual.html#jyo" target="_blank">こちら</a></font></TD><TH colspan=7>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=CYUUSEI>
<input type=text name=cyuu size=5 value=\"$kbank\">
</TH><TH>
<input type=submit id=input value="忠誠">
</form></TH></TR>
<TR><form action="./mydata.cgi" method="post"><TD colspan=2>キャラ画像<br> <font size="1"><a href="$AICON_URL" target="_blank">アイコン一覧</a></font></TD><TH colspan=7>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=GAZOU>
<input type=text name=gazou size=5 value=\"$kchara\">
</TH><TH>
<input type=submit id=input value="変更"></form>
</TH></TR>
<TR><form action="./mydata.cgi" method="post"><TD colspan=1 rowspan=3>装備品名変更<br><font size="1">※全角１５文字まで</font></TD><th>武器</th><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=BOUNAME>
<input type=text name=armname size=30 value=\"$kaname\">
</TH><TH rowspan=3>
<input type=submit id=input value="変更">
</TH></TR>
<TR><th>防具</th><TH colspan=7>
<input type=text name=bouname size=30 value=\"$kbname\">
</TH></TR>
<TR><th>書物</th><TH colspan=7>
<input type=text name=proname size=30 value=\"$ksname\">
</TH></TR></form>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>装備武器変更<br><font size="1">※武器は最大2個まで所持できます。</font></TD><TH colspan=7>
<input type=hidden name=id value="$kid">
<input type=hidden name=pass value="$kpass">
<input type=hidden name=mode value=S_B_H>
<select name="buki" size=1>
$buki1
$buki2
</select>
</TH><TH>
<input type=submit id=input value="変更">
</form>
</TH>
</TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>戦闘勝利時のコメント<br><font size="1">※全角３０文字まで</font></TD><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MEE>
<input type=text name=mee size=46 value=\"$kcm\">
</TH><TH>
<input type=submit id=input value="決定"></form>
</TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>プロフィール<br><font size="1">※全角5000文字まで</font></TD><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MEE2>
<textarea name=mes cols=50 rows=10>
$prof
</textarea>
</TH><TH>
<input type=submit id=input value="決定">
</form>
</TH>
</TR>
</TBODY></TABLE>

</td><td>
<br>
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>- メモ -</font></TH></TR>
<form action="./i-command.cgi" method="post"><TR><TH>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MEMO>
<textarea name="message" cols="35" rows="10">
$memo
</textarea><BR>
<input type=submit value="保存"></form>
</TH></TR>
</TBODY></TABLE>
</TH>
</TD></TR>
</TABLE>

</td></tr>
</table>
<BR>

<TABLE border="0" bgcolor="#ffffff">
<tr><td>

<TABLE cellspacing="1" bgcolor=$ELE_BG[$xele] width="350"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele] colspan=2><font color=$ELE_C[$xele]>- 戦績 -</font></TH></TR>
<TR><TH>部門</TH><TH>数値</TH><TH>順位</TH></TR>
<TR><TD>攻撃力</TD><TH>$kkou</TH><TH>$katj位</TH></TR>
<TR><TD>守備力</TD><TH>$kbou</TH><TH>$kdefj位</TH></TR>
<TR><TD>攻撃力+守備力</TD><TH>$kkoubou</TH><TH>$kkbj位</TH></TR>
<TR><TD>戦闘回数</TD><TH>$ksentou 回</TH><TH>$ksentouj位</TH></TR>
<TR><TD>戦勝回数</TD><TH>$ksensin 回</TH><TH>$ksensinj位</TH></TR>
<TR><TD>侵攻勝利回数</TD><TH>$kkouwin 回</TH><TH>$kkwj位</TH></TR>
<TR><TD>侵攻敗北回数</TD><TH>$kkoulos 回</TH><TH>$kklj位</TH></TR>
<TR><TD>防衛勝利回数</TD><TH>$kbouwin 回</TH><TH>$kbwj位</TH></TR>
<TR><TD>防衛敗北回数</TD><TH>$kboulos 回</TH><TH>$kblj位</TH></TR>
<TR><TD>倒した兵数</TD><TH>$ksitahei 人</TH><TH>$ktaosij位</TH></TR>
<TR><TD>倒された兵数</TD><TH>$ksarehei 人</TH><TH>$ksarej位</TH></TR>
<TR><TD>都市支配回数</TD><TH>$ksihai 回</TH><TH>$k_sihaj位</TH></TR>
<TR><TD>攻城回数</TD><TH>$koujyou 回</TH><TH>$koujyouj位</TH></TR>
<TR><TD>城壁削り数</TD><TH>$kkezuri</TH><TH>$k_kezuj位</TH></TR>
<TR><TD>訓練回数</TD><TH>$kkun 回</TH><TH>$kkunj位</TH></TR>
<TR><TD>徴兵回数</TD><TH>$kmei 回</TH><TH>$ktyouj位</TH></TR>
<TR><TD>内政回数</TD><TH>$knai 回</TH><TH>$knaij位</TH></TR>
<TR><TD>計略回数</TD><TH>$k_kei 回</TH><TH>$k_keij位</TH></TR>
<TR><TD>能力強化回数</TD><TH>$k_tan 回</TH><TH>$k_tanj位</TH></TR>
</TBODY></TABLE>
</TH>
</TD><TD>$ahaha</TD></TR>
</TABLE>

<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

</TD></TR></TABLE>


EOM

	&FOOTER;

	exit;
}

#戦闘ログ画面#

sub BLOG {

	&CHARA_MAIN_OPEN;

	open(IN,"./charalog/blog/$kid.cgi");
	@BLOG_DATA = <IN>;
	close(IN);
	$p=0;
	while($p<=100){$blog_list .= "<font color=navy>●</font>$BLOG_DATA[$p]<BR>";$p++;}


	&HEADER;
	print <<"EOM";
[戦闘ログ](100件)<br>
<br>
$blog_list
<form action=\"i-status.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit value=\"街へ戻る\"></form>
EOM

	&FOOTER;
	exit;

}



#国の武将データ#

sub B_DATA{

	&CHARA_MAIN_OPEN;
	open(IN,"./charalog/log/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);
	&TIME_DATA;

	$p=0;
	foreach(@LOG_DATA){
		$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;
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


	$list = "<b>｜名前｜ステータス｜兵種／兵士数｜金／米｜階級／階級値｜装備｜滞在都市｜コマンド｜更新時間｜</b><br><br>";
	$po=0;

	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

($esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei) = split(/,/,$esub3);

($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);
			if($kcon eq $econ){
			$po +=1;
			$com_list = "";
			if($kcon eq $econ){
				if($esyuppei){
				$syutugeki = "【出撃中】";
				}else{
				$syutugeki = "";
				}				
				open(IN,"./charalog/command/$eid.cgi");
				@COM_DATA = <IN>;
				close(IN);
				for($i=0;$i<1;$i +=1){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
					$no = $i+1;
					if($cid eq ""){
					$com_list .= "$no: - ";
					}else{
					$com_list .= "$no:$cname";
					}
					if($i>=3){last;}
				}
			}

	$elank = int($eclass / $LANK);
	if($elank > 100){
		$elank=100;
	}

	$next_time = int(($edate + $TIME_REMAKE - $tt)/60);
	$nexttime33 = int($edate + $TIME_REMAKE - $tt)-($next_time*60);
        	if($next_time < 0){
                $next_time = 0;
    	 }
        	if($nexttime33 < 0){
                $nexttime33 = 0;
    	 }
                $acmin = $min + $next_time + 0 * ($TIME_REMAKE/60);
		$acs = $sec;
                $achour = $hour;
                $acday = $mday;

		$acsec = $acs + $nexttime33;

                while($acsec >= 60){
                        $acmin++;
                        $acsec = $acsec - 60;
                }

                while($acmin >= 60){
                        $achour++;
                        $acmin = $acmin - 60;
                }


			$list .= "｜<a href=\"./menu.cgi?id=$eid&send=2\">$ename</a>$syutugeki｜武力：$estr 知力：$eint 統率力：$elea 人望：$echa｜$SOL_TYPE[$esub1_ex]（$SOL_ZOKSEI[$esub1_ex]）：$esol人｜金：$egold 米：$erice｜階級：$LANK[$elank] 階級値：$eclass｜武器：$eaname（$eazoku）：威力：$earm（+$eaai） 書物：$esname：威力：$ebook 防具：$ebname：威力：$emes｜$town_name[$epos]｜$com_list｜$acmin分$acsec秒｜<br><br>";
		}
	}


	&HEADER;
	print <<"EOM";
<B>$xname武将（$po人）</b>：
<br>
<br>
<br>
$list
<BR>
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

EOM

	&FOOTER;
	exit;

}


#国データ#

sub C_DATA{


	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);


	if($xking ne ""){
		open(IN,"./charalog/main/$xking\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($kingid,$kingpass,$king_name,$king_chara,$kingstr,$kingint,$kinglea,$kingcha,$kingsol,$kinggat,$kingcon,$kinggold,$kingrice,$kingcex,$kingclass,$kingarm,$kingbook,$kingbank,$kingsub1,$kingsub2,$kingpos,$kingmes,$kinghost,$kingdate,$kingmail,$kingos,$kingcm,$kingst,$kingsz,$kingsg,$kingyumi,$kingiba,$kinghohei,$kingskingnj,$kingsm,$kingbnamking,$kinganame,$kingsname,$kingazoku,$kingaai,$kingsub3,$kingsub4,$kingsub5) = split(/<>/,$E_DATA[0]);
	}
	if($xgunshi ne ""){
		open(IN,"./charalog/main/$xgunshi\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[0],$tpass[0],$tname[0],$tchara[0],$tstr[0],$tint[0],$tlea[0],$tcha[0],$tsol[0],$tgat[0],$tcon[0],$tgold[0],$trice[0],$tcex[0],$tclass[0],$tarm[0],$tbook[0],$tbank[0],$tsub1[0],$tsub2[0],$tpos[0],$tmes[0],$thost[0],$tdate[0],$tmail[0],$tos[0],$tcm[0],$tst[0],$tsz[0],$tsg[0],$tyumi[0],$tiba[0],$thohei[0],$tstnj[0],$tsm[0],$tbnamt[0],$taname[0],$tsname[0],$tazoku[0],$taai[0],$tsub3[0],$tsub4[0],$tsub5[0]) = split(/<>/,$E_DATA[0]);
		$ximg[0] = "<img src=$IMG/$tchara[0].gif width=64 height=64>";
	}
	if($xdai ne ""){
		open(IN,"./charalog/main/$xdai\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[1],$tpass[1],$tname[1],$tchara[1],$tstr[1],$tint[1],$tlea[1],$tcha[1],$tsol[1],$tgat[1],$tcon[1],$tgold[1],$trice[1],$tcex[1],$tclass[1],$tarm[1],$tbook[1],$tbank[1],$tsub1[1],$tsub2[1],$tpos[1],$tmes[1],$thost[1],$tdate[1],$tmail[1],$tos[1],$tcm[1],$tst[1],$tsz[1],$tsg[1],$tyumi[1],$tiba[1],$thohei[1],$tstnj[1],$tsm[1],$tbnamt[1],$taname[1],$tsname[1],$tazoku[1],$taai[1],$tsub3[1],$tsub4[1],$tsub5[1]) = split(/<>/,$E_DATA[0]);
		$ximg[1] = "<img src=$IMG/$tchara[1].gif width=64 height=64>";
	}
	if($xuma ne ""){
		open(IN,"./charalog/main/$xuma\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[2],$tpass[2],$tname[2],$tchara[2],$tstr[2],$tint[2],$tlea[2],$tcha[2],$tsol[2],$tgat[2],$tcon[2],$tgold[2],$trice[2],$tcex[2],$tclass[2],$tarm[2],$tbook[2],$tbank[2],$tsub1[2],$tsub2[2],$tpos[2],$tmes[2],$thost[2],$tdate[2],$tmail[2],$tos[2],$tcm[2],$tst[2],$tsz[2],$tsg[2],$tyumi[2],$tiba[2],$thohei[2],$tstnj[2],$tsm[2],$tbnamt[2],$taname[2],$tsname[2],$tazoku[2],$taai[2],$tsub3[2],$tsub4[2],$tsub5[2]) = split(/<>/,$E_DATA[0]);
		$ximg[2] = "<img src=$IMG/$tchara[2].gif width=64 height=64>";
	}
	if($xgoei ne ""){
		open(IN,"./charalog/main/$xgoei\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[3],$tpass[3],$tname[3],$tchara[3],$tstr[3],$tint[3],$tlea[3],$tcha[3],$tsol[3],$tgat[3],$tcon[3],$tgold[3],$trice[3],$tcex[3],$tclass[3],$tarm[3],$tbook[3],$tbank[3],$tsub1[3],$tsub2[3],$tpos[3],$tmes[3],$thost[3],$tdate[3],$tmail[3],$tos[3],$tcm[3],$tst[3],$tsz[3],$tsg[3],$tyumi[3],$tiba[3],$thohei[3],$tstnj[3],$tsm[3],$tbnamt[3],$taname[3],$tsname[3],$tazoku[3],$taai[3],$tsub3[3],$tsub4[3],$tsub5[3]) = split(/<>/,$E_DATA[0]);
		$ximg[3] = "<img src=$IMG/$tchara[3].gif width=64 height=64>";
	}
	if($xyumi ne ""){
		open(IN,"./charalog/main/$xyumi\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[4],$tpass[4],$tname[4],$tchara[4],$tstr[4],$tint[4],$tlea[4],$tcha[4],$tsol[4],$tgat[4],$tcon[4],$tgold[4],$trice[4],$tcex[4],$tclass[4],$tarm[4],$tbook[4],$tbank[4],$tsub1[4],$tsub2[4],$tpos[4],$tmes[4],$thost[4],$tdate[4],$tmail[4],$tos[4],$tcm[4],$tst[4],$tsz[4],$tsg[4],$tyumi[4],$tiba[4],$thohei[4],$tstnj[4],$tsm[4],$tbnamt[4],$taname[4],$tsname[4],$tazoku[4],$taai[4],$tsub3[4],$tsub4[4],$tsub5[4]) = split(/<>/,$E_DATA[0]);
		$ximg[4] = "<img src=$IMG/$tchara[4].gif width=64 height=64>";
	}
	if($xhei ne ""){
		open(IN,"./charalog/main/$xhei\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[5],$tpass[5],$tname[5],$tchara[5],$tstr[5],$tint[5],$tlea[5],$tcha[5],$tsol[5],$tgat[5],$tcon[5],$tgold[5],$trice[5],$tcex[5],$tclass[5],$tarm[5],$tbook[5],$tbank[5],$tsub1[5],$tsub2[5],$tpos[5],$tmes[5],$thost[5],$tdate[5],$tmail[5],$tos[5],$tcm[5],$tst[5],$tsz[5],$tsg[5],$tyumi[5],$tiba[5],$thohei[5],$tstnj[5],$tsm[5],$tbnamt[5],$taname[5],$tsname[5],$tazoku[5],$taai[5],$tsub3[5],$tsub4[5],$tsub5[5]) = split(/<>/,$E_DATA[0]);
		$ximg[5] = "<img src=$IMG/$tchara[5].gif width=64 height=64>";
	}
	if($xxsub1 ne ""){
		open(IN,"./charalog/main/$xxsub1\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[6],$tpass[6],$tname[6],$tchara[6],$tstr[6],$tint[6],$tlea[6],$tcha[6],$tsol[6],$tgat[6],$tcon[6],$tgold[6],$trice[6],$tcex[6],$tclass[6],$tarm[6],$tbook[6],$tbank[6],$tsub1[6],$tsub2[6],$tpos[6],$tmes[6],$thost[6],$tdate[6],$tmail[6],$tos[6],$tcm[6],$tst[6],$tsz[6],$tsg[6],$tyumi[6],$tiba[6],$thohei[6],$tstnj[6],$tsm[6],$tbnamt[6],$taname[6],$tsname[6],$tazoku[6],$taai[6],$tsub3[6],$tsub4[6],$tsub5[6]) = split(/<>/,$E_DATA[0]);
		$ximg[6] = "<img src=$IMG/$tchara[6].gif width=64 height=64>";
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

	$t_list = "<b>｜都市｜農民｜農業｜商業｜技術力｜城｜城壁耐久力｜迂回阻止度｜民忠｜相場｜滞在武将｜城の守備｜</b><br><br>";

	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg) = split(/<>/);



		if($econ eq $kcon){
			$list[$epos] .= "$ename ";
		$num[$epos]++;
		}
	}

#城耐久計算
	open(IN,"$LOG_DIR/date_count.cgi") or &ERR('ファイルを開けませんでした。');
	@MONTH_DATA = <IN>;
	close(IN);
	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
	$new_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
	$taikyu = $myear*125;
	if($taikyu<1000){
	$taikyu = 1000;
	}elsif($taikyu>9999){
	$taikyu = 9999;
	}

	$zc=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con,$z2num,$z2nou,$z2syo,$z2shiro,$z2nou_max,$z2syo_max,$z2shiro_max,$z2pri,$z2x,$z2y,$z2souba,$z2def_att,$z2sub1,$z2sub2)=split(/<>/);

		if($z2con eq $kcon){
		#バトルマップ読み込み
		require "./log_file/map_hash/$zc.pl";

			KILL:for($i=0;$i<$BM_Y;$i++){
				for($j=0;$j<$BM_X;$j++){
					if($BM_TIKEI[$i][$j] == 18){
						foreach(@CL_DATA){
						($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
						($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
						($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);
							if($ex == $j && $ey == $i && $eiti eq $zc){
							$def_list[$zc] .= "$ename($esol) ";
							}
						}
					last KILL;
					}
				}
			}

		#迂回阻止度
		$shiro_sosi_p = int(($z2shiro/(300+($myear*11.666)))*100);
		if($shiro_sosi_p > 100){
		$shiro_sosi_p = 100;
		$shiro_sosi_p += int ( ( ($z2shiro-(300+($myear*11.666) ) )/( (300+($myear*11.666))*3 ) )*100 );
		if($shiro_sosi_p > 200){$shiro_sosi_p = 200;}
		}
		$shiro_sosi_s = $z2shiro / (15+($myear*0.583));
		if($shiro_sosi_s > ($BMT_REMAKE*10)/60){
		$shiro_sosi_s = ($BMT_REMAKE*10)/60;
		$shiro_sosi_s += ($z2shiro - (300+($myear*11.666)) )/( (15+($myear*0.583)) * 3);
		if($shiro_sosi_s > ($BMT_REMAKE*10)/30){$shiro_sosi_s = ($BMT_REMAKE*10)/30;}
		}
		$shiro_sosi_s = int($shiro_sosi_s*60);
		$shiro_sosi = "$shiro_sosi_p%($shiro_sosi_s秒)";

		$t_list .= "｜$z2name｜農民:$z2num/$z2sub2｜農業:$z2nou/$z2nou_max｜商業:$z2syo/$z2syo_max｜技術:$z2sub1/9999｜城壁:$z2shiro/$z2shiro_max｜城壁耐久力:$z2def_att/$taikyu｜迂回阻止度:$shiro_sosi｜民忠:$z2pri｜相場:$z2souba｜滞在武将:$list[$zc]｜城の守備:$def_list[$zc]｜<br><br>";
		}
		$zc++;
	}

	&HEADER;
	print <<"EOM";
$balllist
<B>$xname都市データ</b>：<br><br>
$t_list
<BR>
<br>
<br>
<B>$xname役職データ</b>：<br><br>
<b>役職：名前</b><br><br>
君主：<a href=\"./menu.cgi?id=$kingid&send=2\">$king_name</a><br><br>
軍師：<a href=\"./menu.cgi?id=$tid[0]&send=2\">$tname[0]</a><br><br>
宰相 ：<a href=\"./menu.cgi?id=$tid[6]&send=2\">$tname[6]</a><br><br>
大将軍 ：<a href=\"./menu.cgi?id=$tid[1]&send=2\">$tname[1]</a><br><br>
騎馬将軍 ：<a href=\"./menu.cgi?id=$tid[2]&send=2\">$tname[2]</a><br><br>
護衛将軍 ：<a href=\"./menu.cgi?id=$tid[3]&send=2\">$tname[3]</a><br><br>
弓将軍 ：<a href=\"./menu.cgi?id=$tid[4]&send=2\">$tname[4]</a><br><br>
将軍 ：<a href=\"./menu.cgi?id=$tid[5]&send=2\">$tname[5]</a><br><br>
<br>
<br>
<BR>
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

EOM

	&FOOTER;
	exit;

}


#都市データ#

sub T_DATA{

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);

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

	$list = "<b>｜名前｜武力｜知力｜統率力｜人望｜兵士数｜国名｜コマンド｜</b><br><br>";
	$num=0;
	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
		if($epos eq $kpos){
			$num++;
			$com_list = "";
			if($kcon eq $econ){
				open(IN,"./charalog/command/$eid.cgi");
				@COM_DATA = <IN>;
				close(IN);
				for($i=0;$i<1;$i++){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
					$no = $i+1;
					if($cid eq ""){
					$com_list .= "$no: - ";
					}else{
					$com_list .= "$no:$cname";
					}
					if($i>=3){last;}
				}
			}
			if($num < 100){

			$list .= "｜<a href=\"./menu.cgi?id=$eid&send=2\">$ename</a>｜武力：$estr｜知力：$eint｜統率力：$elea｜人望：$echa｜兵数：$esol｜所属：$cou_name[$econ]｜コマンド：$com_list｜<br><br>";
			}
		}
	}

	&HEADER;
	print <<"EOM";
<b>$zname滞在者（$num人）</b>：<br><br>
$list
<BR>
<form action="./i-status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>


EOM

	&FOOTER;
	exit;


}
