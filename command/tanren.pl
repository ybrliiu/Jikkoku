#_/_/_/_/_/_/_/_/#
#      鍛錬      #
#_/_/_/_/_/_/_/_/#

sub TANREN {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	&HEADER;
	$no = $in{'no'} + 1;

	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}

	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align="center" valign="top">
<TABLE border=0 width=100%>
<TR><TH bgcolor="414141" valign="top">
<font color=ffffff> - 能 力 強 化 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD valign="top">
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>能力強化をすることで能力の経験値が2あがります。<BR>能力強化をするには５００G必要です。<BR>経験値が10を超えると能力が上昇します。</font><br><font color=red>※貢献値が全く増えないので注意してください。	（能力強化ばかりすると給料がでなくなります。）</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD valign="top">
どの\能\力\を鍛えますか？
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<select name=num>
<option value=1>武力
<option value=2>知力
<option value=3>統率力
<option value=4>人望
</select>
$no_list
<input type=hidden name=mode value=27>
<input type=submit value=\"鍛える\"></form>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;
