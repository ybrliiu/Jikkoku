#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#################################################################

require './ini_file/index.ini';
require 'suport.pl';

	&DECODE;

	if($in{'id'} eq ""){&ERR2("フォームの値が不正です。");}

	$in{'eid'} = $in{'id'};
	&ENEMY_OPEN;
	($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);
	&COUNTRY_DATA_OPEN("$econ");
#プロフ読み込み
	open(IN, "./charalog/prof/$eid.cgi");
	$prof = <IN>;
	close(IN);

	if($in{'send'} eq "1"){
	$BACKGROUND = "./image/ballon-back.png";
	$BGCOLOR = "";
	$TEXT = "11pt";
	}elsif($in{'send'} eq "2"){
	$BACKGROUND = "";
	$BGCOLOR = "#FFFFFF";
	$TEXT = "11pt";
	}

	#携帯版i-newbmの時の追加情報
	if($in{'bm_tuika'} eq "1"){
	$in{'id'} = $in{'kid'};
	&CHARA_MAIN_OPEN;

	$zsa = abs($kx-$ex);
	$zsa2 = abs($ky-$ey);
	$zsa3 = $zsa+$zsa2;
	$tuika = "<tr><td><font size=\"+0.5\">・兵士:$SOL_TYPE[$esub1_ex]($SOL_ZOKSEI[$esub1_ex]) $esol人</font></td><td><font size=\"+0.5\">・距離:$zsa3マス</font></td></tr>";

		#携帯版i-newbmの味方の時
		if($in{'bm'} eq "1"){

			if($kcon eq $econ){
			($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL,$enaiskl,$ekeiskl,$etanskl,$ekinto,$e_jsub1,$e_jsub2) = split(/,/,$esub4);

			$idate = time();
				if($eago > $idate){ $ejyoutai .= "<img src=\"./image/img/def_up.gif\"> "; }
				if($eyoudou > $idate){ $ejyoutai .= "<img src=\"./image/img/def_down.gif\"> "; }
				if($esendou > $idate){ $ejyoutai .= "<img src=\"./image/img/att_down.gif\"> "; }
				if($eobu > $idate){ $ejyoutai .= "<img src=\"./image/img/att_up.gif\"> "; }
				if($eagoL > $idate){ $ejyoutai .= "<img src=\"./image/img/def_upL.gif\"> "; }
				if($eyoudouL > $idate){ $ejyoutai .= "<img src=\"./image/img/def_downL.gif\"> "; }
				if($esendouL > $idate){ $ejyoutai .= "<img src=\"./image/img/att_downL.gif\"> "; }
				if($eobuL > $idate){ $ejyoutai .= "<img src=\"./image/img/att_upL.gif\"> "; }
				if($ekinto > $idate){ $ejyoutai .= "<img src='./image/img/kumo.png'> "; }
				if($ekicn > 0){ $ejyoutai .= "<img src=\"./image/img/kei.png\">+$ekicn "; }
				if($eksup > 0){ $ejyoutai .= "<img src=\"./image/img/kousei.png\">+$eksup "; }
				if($emsup > 0){ $ejyoutai .= "<img src=\"./image/img/missyu.png\">+$emsup "; }
			$tuika .= "\n<tr><td><font size=\"+0.5\">・状態:</td><td>$ejyoutai</td></tr>";

			}else{
		 	&ERR("不正なアクセスです。");
			}
		}
	}

	$menuneed=0;
	&HEADER;

	print <<"EOM";

<div style="position:absolute; border:solid 0px #000000; padding:7px; width:95%; height:95%;"><table border="0">
<tr><td rowspan=6 width=5><img src=$IMG/$echara.gif width=\"64\" height=\"64\"></td><td><font size="+0.5">・名前:$ename</td></tr>
<tr><td><font size="+0.5">・所属国:$cou_name[$econ]</td></tr>
<tr><td><font size="+0.5">・武力:$estr</td></tr><tr><td><font size="+0.5">・知力:$eint</td></tr>
<tr><td><font size="+0.5">・統率力:$elea</td></tr><tr><td><font size="+0.5">・人望:$echa</td></tr>
$tuika
<tr><td colspan=2><font size="+0.5">・プロフィール:<br>$prof</td></tr>
</table></div>


	</body></html>

EOM

	exit;
