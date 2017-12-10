#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

require './ini_file/index.ini';
require 'suport.pl';

#_/_/_/_/_/_/_/_/_/_/_/#
#_/ 手紙ログ   _/#
#_/_/_/_/_/_/_/_/_/_/_/#

	if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
	&DECODE;
	if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&MAKE_GUEST_LIST;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup) = split(/,/,$ksenj);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($kindbmm,$ksettei,$ksettei2,$ksettei3) = split(/,/,$ksz);

	if(($xcid eq 0)&&($kcon ne 0)){
	$kcon = 0;
	&CHARA_MAIN_INPUT;
	&OSRS("あなたの所属国は滅亡しました。");
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


	$dilect_mes = "";$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon,$hunit) = split(/<>/);
		if(50 < $i && 50 < $h && 100 < $j && 50 < $k) { last; }
		if(111 eq "$pid" && $kpos eq $hpos){
			if(100 < $h ) { next; }
		
if($prf_mes !~ /(\".$hid\")/){

		$prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7');><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$hid&send=1></iframe></td></tr></table></div>\"));}num++;});
";

}
			$all_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF><b><span class=$hid\>$hname</span>\@$town_name[$hpos]から</b><BR>「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>\n";
			$h++;
		}elsif($kcon eq "$pid"){
			if(100 < $j ) { next; }
		
if($prf_mes !~ /(\".$hid\")/){

		$prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7');><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$hid&send=1></iframe></td></tr></table></div>\"));}num++;});
";

}
			$cou_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=FFCC33><b>	<span class=$hid\>$hname</span>\@$town_name[$hpos]から$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$j++;
		}elsif($kid eq "$pid"){
			if(100 < $i ) { next; }
		
if($prf_mes !~ /(\".$hid\")/){

		$prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7');><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$hid&send=1></iframe></td></tr></table></div>\"));}num++;});
";

}
			$add_mes = "<b><font color=orange><span class=$hid\>$hname</span>\@$town_name[$hpos]</font>から$pnameへ</b> <BR>";
			$man_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF>$add_mes「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>\n";
			$dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif(333 eq "$pid" && "$hunit" eq "$unit_id" && "$hcon" eq "$kcon"){
			if(100 < $k ) { next; }

		
if($prf_mes !~ /(\".$hid\")/){

		$prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7');><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$hid&send=1></iframe></td></tr></table></div>\"));}num++;});
";

}

			$unit_mes .= "<TR><TD width=100% bgcolor=#000000><font color=orange><b><span class=$hid\>$hname</span>\@$town_name[$hpos]から$pnameへ</b></font><BR><font color=#FFFFFF>  「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$k++;
		}elsif($kid eq "$hid"){
			if(100 < $i ) { next; }
			$man_mes .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=skyblue><b>$knameから$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$i++;
		}
	}
	close(IN);

	$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST2") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon) = split(/<>/);
		if(50 < $i) { last; }
		if($kid eq "$pid"){
		

if($prf_mes !~ /(\".$hid\")/){

		$prf_mes .= "\$(\".$hid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$hcon]]0.7');><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$hid&send=1></iframe></td></tr></table></div>\"));}num++;});
";

}
			$add_mes="";
			$add_sel="";
			$add_form1="";
			$add_form2="";
			if($htime eq "9999"){
			$add_mes = "<B><font color=skyblue><span class=$hid\>$hname</span>が$cou_name[$hcon]への仕官を勧めています。<BR></font></B>";
			$add_sel = "<BR><input type=radio name=sel value=1>承諾する<input type=radio name=sel value=0>断る<input type=submit id=input value=\"返事\">";
			$add_form1="<form action=\"./mydata.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=hcon value=$hcon><input type=hidden name=hid value=$hid><input type=hidden name=hpos value=$hpos><input type=hidden name=mode value=COU_CHANGE>";
			$add_form2="</form>";
			}else{
			$add_mes = "<B><font color=skyblue><span class=$hid\>$hname</span>から$pnameへ</font><BR></B>";
			}
			$man_mes2 .= "$add_form1<TR><TD width=100% bgcolor=#000000><font size=2 color=#FFFFFF>$add_mes「<b>$hmessage</b>」$add_sel</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$hname\"></TD></TR>$add_form2\n";
			$dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif($kid eq "$hid"){
			$man_mes2 .= "<TR><TD width=100% bgcolor=#000000><font size=2 color=skyblue><b>$knameさんから$pnameへ</b></font><BR><font size=2 color=#FFFFFF>  「<b>$hmessage</b>」<BR>$htime</font></TD><TD width=70 bgcolor=#000000><img src=\"$IMG/$hchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$kname\"></TD></TR>";
			$i++;
		}
	}
	close(IN);

	if($xking eq $kid || $xgunshi eq $kid || $xxsub1 eq $kid){
		foreach(@COU_DATA){
			($xvcid,$xvname)=split(/<>/);
			$dilect_mes .= "<option value=\"$xvcid\">$xvnameへ";
		}
	$dilect_mes .= "<option value=\"0\">無所属へ";
	}

	$b_js = 1;
	$zukei = 1;
	$status_css = 1;
	&HEADER;

print <<"EOM";


<div id="zukei">
<form action="./log.cgi" method="post"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<button id="botan" type="submit"><div id="reload"></div></button>
<a href="#top"><div id="botan"><div id="up_arrow"></div></div></a>
<a href="#sita"><div id="botan"><div id="down_arrow"></div></div></a>
</form>
</div>


<center>
<br>
<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"戻る\">
</form>
</center>

<HR color=$ELE_BG[$xele] size=2>

<form action="$FILE_MYDATA" method="post">
手紙：<textarea name=message cols=60 rows=2>
</textarea>
 <select name=mes_id><option value="$xcid">$xnameへ<option value="111">$znameの人へ<option value="333">$uunit_name部隊の人へ$dilect_mes</select>
 <input type=hidden name=id value=$kid>
 <input type=hidden name=name value=$kname>
 <input type=hidden name=pass value=$kpass>
 <input type=hidden name=mode value=MES_SEND>
 <input type=submit id=input value="送信"></form>
<HR color=$ELE_BG[$xele] size=2>


<script type="text/javascript"><!--
var num = 0;

\$(document).ready(function(){

$prf_mes

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

/* 手紙ログの切り替え */
	var kojin = document.getElementById('man');
	var kojin_bg = document.getElementById('man_title');
	var kojin_str = document.getElementById('man_title').getElementsByTagName("strong")[0];
	var missyo = document.getElementById('man2');
	var missyo_bg = document.getElementById('man2_title');
	var missyo_str = document.getElementById('man2_title').getElementsByTagName("strong")[0];
	\$("#man_title").click(function () {
		kojin.style.display = "table";
		missyo.style.display = "none";
		kojin_bg.style.backgroundColor = "#009900";
		missyo_bg.style.backgroundColor = "#000000";
		kojin_str.style.color = "#EEEEEE";
		missyo_str.style.color = "#006600";
	});
	\$("#man2_title").click(function () {
		kojin.style.display = "none";
		missyo.style.display = "table";
		kojin_bg.style.backgroundColor = "#000000";
		missyo_bg.style.backgroundColor = "#006600";
		kojin_str.style.color = "#009900";
		missyo_str.style.color = "#EEEEEE";
	});
	var coun = document.getElementById('cou');
	var coun_bg = document.getElementById('cou_title');
	var coun_str = document.getElementById('cou_title').getElementsByTagName("strong")[0];
	var unit = document.getElementById('unit');
	var unit_bg = document.getElementById('unit_title');
	var unit_str = document.getElementById('unit_title').getElementsByTagName("strong")[0];
	var town = document.getElementById('town');
	var town_bg = document.getElementById('town_title');
	var town_str = document.getElementById('town_title').getElementsByTagName("strong")[0];
	\$("#cou_title").click(function () {
		coun.style.display = "table";
		unit.style.display = "none";
		town.style.display = "none";
		coun_bg.style.backgroundColor = "#000088";
		unit_bg.style.backgroundColor = "#000000";
		town_bg.style.backgroundColor = "#000000";
		coun_str.style.color = "#EEEEEE";
		unit_str.style.color = "#AA8833";
		town_str.style.color = "#880000";
	});
	\$("#unit_title").click(function () {
		coun.style.display = "none";
		unit.style.display = "table";
		town.style.display = "none";
		coun_bg.style.backgroundColor = "#000000";
		unit_bg.style.backgroundColor = "#AA8833";
		town_bg.style.backgroundColor = "#000000";
		coun_str.style.color = "#000088";
		unit_str.style.color = "#EEEEEE";
		town_str.style.color = "#880000";
	});
	\$("#town_title").click(function () {
		coun.style.display = "none";
		unit.style.display = "none";
		town.style.display = "table";
		coun_bg.style.backgroundColor = "#000000";
		unit_bg.style.backgroundColor = "#000000";
		town_bg.style.backgroundColor = "#880000";
		coun_str.style.color = "#000088";
		unit_str.style.color = "#AA8833";
		town_str.style.color = "#EEEEEE";
	});

});
--></script>


<!-- 手紙表示 -->
<TABLE id="tegami"><TBODY>
<TR><TD>
	<TABLE style="border-collapse:separate;border-spacing:0px;">
	<TR><TD id="man_title" style="border:2px #009900 solid;width:50%;padding:5px;border-top-left-radius:5px;background-color:#009900;"><strong style="color:#EEEEEE;">$kname宛て:(100件)</strong></TD>
	<TD id="man2_title" style="border:2px #006600 solid;width:50%;padding:5px;border-top-right-radius:5px;"><strong style="color:#006600;">$kname宛て密書:(100件)</strong></TD></TR>
	</TABLE>		

	<TABLE id="man" style="background-color:#009900;"><TBODY>
	$man_mes
	</TBODY></TABLE>

	<TABLE id="man2" style="background-color:#006600;display:none;"><TBODY>
	$man_mes2
	</TBODY></TABLE>

</TD><TD>
	<TABLE style="border-collapse:separate;border-spacing:0px;">
	<TR><TD id="cou_title" style="border:2px #000088 solid;width:34%;padding:5px;border-top-left-radius:5px;background-color:#000088"><strong style="color:#EEEEEE;">$xname宛て:(100件)</strong></TD>
	<TD id="unit_title" style="border:2px #AA8833 solid;width:33%;padding:5px;"><strong style="color:#AA8833;">$uunit_name部隊宛て:(100件)</strong></TD>
	<TD id="town_title" style="border:2px #880000 solid;width:33%;padding:5px;border-top-right-radius:5px;"><strong style="color:#880000;">$znameの人々へ:(100件)</strong></TD></TR>
	</TABLE>

	<TABLE id="cou" style="background-color:#000088;"><TBODY>
	$cou_mes
	</TBODY></TABLE>

	<TABLE id="unit" style="background-color:#AA8833;display:none;"><TBODY>
	$unit_mes
	</TBODY></TABLE>

	<TABLE id="town" style="background-color:#880000;display:none;"><TBODY>
	$all_mes
	</TBODY></TABLE>

</TD></TR>
</TBODY></TABLE>
</TD></TR>
<center>
<br>
<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"戻る\">
</form></center>

EOM


	&FOOTER;
	exit;
