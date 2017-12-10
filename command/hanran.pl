#_/_/_/_/_/_/_/_/#
#      反乱     #
#_/_/_/_/_/_/_/_/#

sub HANRAN {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	&HEADER;
	$no = $in{'no'} + 1;
	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>";
	}
	
	if(($ksg eq "1")||($ksg eq "2")){
		$rentou =  "<input type=radio name=sub value=1><font color=blue>連闘で攻め込む</font><BR>兵が残っていれば２回連続で戦闘します。<BR>";
	}

	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 反 乱 - </font>
</TH></TR>
EOM
	if("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/status.cgi"){ 

print <<"EOM";

<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
EOM
	}
print <<"EOM";

<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>反乱を起こします。<BR>自国都市での反乱、または無所属からの反乱が可能です。<BR>反乱を起こすと、今いる都市の地形：城の上に部隊が配置されます。<BR>また、待機時間が反乱を起こした直後のみ通常の10倍になります。<BR>既に出撃している場合は、所属国からはなれて無所属になるだけです。<BR>このコマンドを実行し、成功したら、</font><font color=red>無所属になり、ブラックリストに登録されます。</font><font color=white><BR>※金10000と米10000消費します。</font></font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="POST">
$rentou
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
$no_list
<input type=hidden name=num value=$kpos>
<input type=hidden name=mode value=59>
<input type=submit value=\"反乱を起こす\"></form>
</TD></TR><TR><TD>
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
