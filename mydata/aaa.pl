#_/_/_/_/_/_/_/_/_/#
#_/     説 明    _/#
#_/_/_/_/_/_/_/_/_/#

sub AAA {

	&CHARA_MAIN_OPEN;

	if($ksm == 1){ &ERR2("迷路は一年に一回しか入れません。");}

	&TIME_DATA;
	&COUNTRY_DATA_OPEN("$kcon");


# ゲームを開始する時に始まる説明
$P_MES[0] = "<font color=\"white\">-迷路入り口-<BR>財宝や宝が隠されています。<BR>行き止まりにあたると救出費として1000Gとられます。</font><BR><img src=\"$IMG/start.gif\">";
$P_MES[1] = "<img src=\"$IMG/turo.gif\">";
$P_MES[2] = "<img src=\"$IMG/turo.gif\">";
$P_MES[3] = "<img src=\"$IMG/turo.gif\">";
$P_MES[4] = "<img src=\"$IMG/turo.gif\">";
$P_MES[5] = "<img src=\"$IMG/turo.gif\">";
$P_MES[6] = "<img src=\"$IMG/turo.gif\">";
$P_MES[7] = "<img src=\"$IMG/turo.gif\">";
$P_MES[8] = "<img src=\"$IMG/turo.gif\">";
$P_MES[9] = "<img src=\"$IMG/turo.gif\">";
$P_MES[10] = "<img src=\"$IMG/turo.gif\">";
$P_MES[11] = "<img src=\"$IMG/stop.gif\">";
$P_MES[12] = "<img src=\"$IMG/stop.gif\">";
$P_MES[13] = "<img src=\"$IMG/stop.gif\">";
$P_MES[14] = "<img src=\"$IMG/goal.gif\">";
$P_MES[15] = "<img src=\"$IMG/goal.gif\">";


if($in{'aaa'} == 11){
$kgold -=1000;
$txt = "<font color=\"white\">行き止まりです。<BR>救出費用1000Gいただきます。<BR></font>";
&K_LOG("<font color=\"$TD_C12\">【迷路】</font>行き止まりにあたってしまいました。金-1000");
$ksm = 1;
}
elsif($in{'aaa'} == 12){
$txt = "<font color=\"white\">行き止まりです。<BR>救出費用1000Gいただきます。<BR></font>";
$kgold -=1000;
&K_LOG("<font color=\"$TD_C12\">【迷路】</font>行き止まりにあたってしまいました。金-1000");
$ksm = 1;
}
elsif($in{'aaa'} == 13){
$getgold = int(rand(2001));
$kgold += $getgold;
$txt = "<font color=\"white\">宝箱発見！<BR> $getgold\G貰いました！<BR></font>";
&K_LOG("<font color=\"$TD_C12\">【迷路】</font>宝箱を発見しました。金+$getgold");
$ksm = 1;
}
elsif($in{'aaa'} == 14){
$getgold = int(rand(5001));
$kgold += $getgold;
$txt = "<font color=\"white\">宝箱発見！<BR> $getgold\G貰いました！<BR></font>";
&K_LOG("<font color=\"$TD_C12\">【迷路】</font>宝箱を発見しました。金+$getgold");
$ksm = 1;
}
elsif($in{'aaa'} == 15){
$getgold = int(rand(2001));
$kgold += $getgold;
$kcex += 10;
$txt = "<font color=\"white\">宝箱発見！<BR> $getgold G貰い貢献値が10増えました！<BR></font>";
&K_LOG("<font color=\"$TD_C12\">【迷路】</font>宝箱を発見しました。金+$getgold 貢献値+10");
$ksm = 1;
}
	&CHARA_MAIN_INPUT;


	&HEADER;

	print <<"EOM";
<font size=4>　　　＜＜<B>迷路</B>＞＞</font>
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD>
<TR>
<TD height="5">
<TABLE  border="0" bgcolor="#000000">
<TBODY bgcolor=$TALK_BG><TR><TD height="64"></TD></TR><TR><TD bgcolor=$TALK_BG width="64">

EOM



	$new_num = int(rand(16));
	$mae_num = int(rand(16));
	$hidari_num = int(rand(16));
if($new_num == 0){$new_num = 1;}
if($mae_num == 0){$mae_num = 1;}
if($hidari_num == 0){$hidari_num = 1;}
if($in{'aaa'} == 0){
$modo = "<form action=\"$FILE_STATUS\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value=\"街へ戻る\"></form>";
}

if($in{'aaa'} < 11){
print "<form action=\"mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=aaa value=$new_num>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=AAA>
<input type=submit id=input value=\"右へ進む\"></form>";

$hidari = "<form action=\"mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=aaa value=$mae_num>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=AAA>
<input type=submit id=input value=\"左へ進む\"></form>";


$migi = "<form action=\"mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=aaa value=$hidari_num>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=AAA>
<input type=submit id=input value=\"前へ進む\"></form>";

}
elsif($in{'aaa'} > 10){
$momo = "<form action=\"$FILE_STATUS\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value=\"街へ戻る\"></form>";


}

	print <<"EOM";


</TD><TD width="300" height=200 bgcolor=$TALK_BG><font size=3 color=$TALK_FONT>$P_MES[$in{'aaa'}]</font>$txt</TD><TD bgcolor=$TALK_BG width="60">$hidari</TD>

</TR>
<TR><TD colspan=3 bgcolor=$TALK_BG align=center height="60">$migi $momo $modo
</TD>
</TBODY></TABLE>
</TD>
</TR>
</TD>
</TR>
</TBODY></TABLE>
EOM

	&FOOTER;
	exit;
}
1;
