#_/_/_/_/_/_/_/_/#
#      防具      #
#_/_/_/_/_/_/_/_/#

sub BOU_BUY {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&TIME_DATA;

	$bouval2 = int($kmes * 2333);

	&HEADER;
	$no = $in{'no'} + 1;

	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}

	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 防具屋 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>いらっしゃい。<BR>ここでは防具を売ってるよ。<BR>現在$knameが装備している$kbnameは金<font color=red>$bouval2</font>で下取るよ。<BR>是非手にとって見ておくれ。<BR>
※防具についての詳細は<a href="./manual.html#soubi" target="_blank">ここ</a>をみてください。<br>
</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$TD_C6>
EOM

	open(IN,"$BOU_LIST") or &ERR('ファイルを開けませんでした。');
	@BOU_DATA = <IN>;
	close(IN);

	$list = "<TR><TD bgcolor=$TD_C5>選択</TD><TD bgcolor=$TD_C5>名称</TD><TD bgcolor=$TD_C5>値段</TD><TD bgcolor=$TD_C5>威力</TD><TD bgcolor=$TD_C5 align=center>スキル</TD><TD bgcolor=$TD_C5>必要技術</TD><TD bgcolor=$TD_C5>必要階級</TD></TR>";
	$s_i=0;
	foreach(@BOU_DATA){
		($bouname,$bouval,$boudmg,$bouwei,$bouele,$bousta,$bouclass,$boutownid,$bousetumei,$bouskl,$bousklsetumei) = split(/<>/);
		if($kvsub2 eq 0){$bouval = int($bouval / 10);}
		$boukaikyu = $bousta*5;
		if($boukaikyu > 25000){$boukaikyu = 25000;}

		if(($boutownid eq 0)&&($zsub1 >= $bousta)){
			$list .= "<TR><TD bgcolor=$TD_C5><input type=radio name=select value=$s_i></TD><TD bgcolor=$TD_C5>$bouname</TD><TD align=right bgcolor=$TD_C5>金 $bouval</TD><TD align=center bgcolor=$TD_C5>$boudmg</TD><TD align=right bgcolor=$TD_C5>$bousklsetumei</TD><TD align=right bgcolor=$TD_C5>$bousta</TD><TD align=right bgcolor=$TD_C5>$boukaikyu</TD></TR>";
		}
		$s_i++;
	}


print <<"EOM";
$list
</TABLE>
$no_list
<input type=hidden name=mode value=51>
<input type=submit value=\"購入\"></form>


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
