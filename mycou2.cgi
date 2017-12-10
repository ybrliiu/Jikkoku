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
require 'suport.pl';
require './lib/hs_keisan.pl';

if($MENTE) { &ERR("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
&TOP;

#_/_/_/_/_/_/_/_/_/#
#_/    TOP画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub TOP {

	&CHARA_MAIN_OPEN;
	open(IN,"./charalog/log/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);

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


	$list = "<TR><TD></TD><TH>名前</TH><TH>ステータス</TH><TH>兵種／兵士数</TH><TH>攻守値</TH><TH>装備</TH><TH>金／米</TH><TH>階級／階級値</TH><TH>滞在都市</TH><TH>コマンド</TH><TH>更新時間</TH></TR>";
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
				$syutugeki = "<br>【出撃中】";
				}else{
				$syutugeki = "";
				}				
				open(IN,"./charalog/command/$eid.cgi");
				@COM_DATA = <IN>;
				close(IN);
				for($i=0;$i<$MAX_COM;$i +=1){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
					$no = $i+1;
					if($cid eq ""){
					$com_list .= "$no: - <BR>";
					}else{
					$com_list .= "$no:$cname<BR>";
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

		#攻防力計算
		($eatt_add,$eatt_def) = &HS_KEISAN(0,0,$esub1_ex,$estr,$eint,$elea,$echa,$earm,$ebook,$emes);
		$ekou = int($estr + $earm + $eatt_add);
		$ebou = int($eatt_def + $emes + ($egat / 2));

	$balllist .= "\$(\".$eid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$econ]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$eid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";
	$busylink ="<span class=\"$eid\">$ename</span>";
			$list .= "<TR><TD><img src=$IMG/$echara.gif width=64 height=64></TD><TH>$busylink$syutugeki</TH><TD>武力：$estr<BR>知力：$eint<BR>統率力：$elea<BR>人望：$echa</TD><TD align=center>$SOL_TYPE[$esub1_ex]（$SOL_ZOKSEI[$esub1_ex]）<BR>$esol人</TD><TD>攻撃力:$ekou<br>守備力:$ebou</TD><TD>武器：$eaname（$eazoku）：威力：$earm（+$eaai）<BR>書物：$esname：威力：$ebook<BR>防具：$ebname：威力：$emes</TD><TD>金：$egold<BR>米：$erice</TD><TD>階級：Lv.$elank $LANK[$elank]<BR>階級値：$eclass</TD><TD>$town_name[$epos]</TD><TD>$com_list</TD><TD>$acmin分$acsec秒</TD></TR>";
		}
	}

	$b_js = 1;
	&HEADER;
	print <<"EOM";

<script type="text/javascript"><!--
var num = 0;

\$(document).ready(function(){

$balllist

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

});
--></script>

<TABLE WIDTH="100%" height=100%><tr><td align=center>
<B>$xname武将（$po人）</b>：
<TABLE border=0 cellspacing=1 bgcolor=$TABLE_C class="kaku">
    <TBODY bgcolor=FFFFFF>
$list
</TBODY></TABLE>
<center>
<BR>
<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"街へ戻る\">
</form>
</center>
</TD></TR>
</TBODY></TABLE>

EOM
printf("%0.3f",Time::HiRes::time - $start_time);

	&FOOTER;
	exit;

}
