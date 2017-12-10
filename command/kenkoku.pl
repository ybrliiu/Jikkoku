#_/_/_/_/_/_/_/_/#
#      建国      #
#_/_/_/_/_/_/_/_/#

sub KENKOKU {

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
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 建 国 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>自分がいる都市で建国します。<br>自分が部隊長をしている場合、建国時に部隊に所属している、</font><font color=red>忠誠度100の</font><font color=white>武将全員が自分が建国した国の所属になります。<br>※このコマンドから建国した場合、戦争禁止期間は建国後18ターンまでとなります。<br>※自分と都市の所属が無所属でないと建国できません。<br>※統一後は建国できません。</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$TABLE_C>
<tr bgcolor=$TD_C1><TD width=100>国名</tD><tD bgcolor=$TD_C3><input type="text" name="armname" size="30" value="$in{'cou_name'}"><br>・国家の名称を決めてください。<BR>[全角大文字で１〜１０文字以内]</tD></tr>
<tr><TD bgcolor=$TD_C1>国色</TD><TD bgcolor=$TD_C4>
EOM
	$i=0;
	foreach(@ELE_BG){print "<input type=radio name=ele value=\"$i\"><font color=$ELE_BG[$i]>■</font> \n";$i++;}
	print <<"EOM";
<br>・国の色を決めてください。</TD></tr>
</TABLE>
$no_list
<input type=hidden name=mode value=56>
<input type=submit value=\"決定\"></form>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form></CENTER>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;
