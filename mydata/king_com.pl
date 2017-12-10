#_/_/_/_/_/_/_/_/#
#      司令部      #
#_/_/_/_/_/_/_/_/#

sub KING_COM {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}

	if($xgunshi ne ""){
		open(IN,"./charalog/main/$xgunshi\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[0],$tpass[0],$tname[0],$tchara[0]) = split(/<>/,$E_DATA[0]);
		$ximg[0] = "<img src=$IMG/$tchara[0].gif>";
	}
	if($xdai ne ""){
		open(IN,"./charalog/main/$xdai\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[1],$tpass[1],$tname[1],$tchara[1]) = split(/<>/,$E_DATA[0]);
		$ximg[1] = "<img src=$IMG/$tchara[1].gif>";
	}
	if($xuma ne ""){
		open(IN,"./charalog/main/$xuma\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[2],$tpass[2],$tname[2],$tchara[2]) = split(/<>/,$E_DATA[0]);
		$ximg[2] = "<img src=$IMG/$tchara[2].gif>";
	}
	if($xgoei ne ""){
		open(IN,"./charalog/main/$xgoei\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[3],$tpass[3],$tname[3],$tchara[3]) = split(/<>/,$E_DATA[0]);
		$ximg[3] = "<img src=$IMG/$tchara[3].gif>";
	}
	if($xyumi ne ""){
		open(IN,"./charalog/main/$xyumi\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[4],$tpass[4],$tname[4],$tchara[4]) = split(/<>/,$E_DATA[0]);
		$ximg[4] = "<img src=$IMG/$tchara[4].gif>";
	}
	if($xhei ne ""){
		open(IN,"./charalog/main/$xhei\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[5],$tpass[5],$tname[5],$tchara[5]) = split(/<>/,$E_DATA[0]);
		$ximg[5] = "<img src=$IMG/$tchara[5].gif>";
	}
	if($xxsub1 ne ""){
		open(IN,"./charalog/main/$xxsub1\.cgi");
		@E_DATA = <IN>;
		close(IN);
		($tid[6],$tpass[6],$tname[6],$tchara[6]) = split(/<>/,$E_DATA[0]);
		$ximg[6] = "<img src=$IMG/$tchara[6].gif>";
	}

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);

	$list = "<option value=>";
	foreach(@CL_DATA) {
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg) = split(/<>/);
		if(($kid ne $eid && $xking ne $eid)  && $kcon eq $econ){
			$list .= "<option value=$eid>$ename";
			$tlist .= "<option value=$eid>$ename (忠誠度：$ebank)";
		}
	}

	$xmes =~ s/<br>/\n/g;
	if($xmes =~ /<font color=\"red\">/ && $xmes =~ /\<\/font\>/){
	$xmes =~ s/<font color=\"red\">/<red>/g;
	$xmes =~ s/<\/font>/<\/red>/g;
	}if($xmes =~ /<font color=\"blue\">/ && $xmes =~ /\<\/font\>/){
	$xmes =~ s/<font color=\"blue\">/<blue>/g;
	$xmes =~ s/<\/font>/<\/blue>/g;
	}if($xmes =~ /<font color=\"green\">/ && $xmes =~ /\<\/font\>/){
	$xmes =~ s/<font color=\"#00FF00\">/<green>/g;
	$xmes =~ s/<\/font>/<\/green>/g;
	}if($xmes =~ /<font color=\"#000000\">/ && $xmes =~ /\<\/font\>/){
	$xmes =~ s/<font color=\"#000000\">/<black>/g;
	$xmes =~ s/<\/font>/<\/black>/g;
	}if($xmes =~ /<a href\=\"/ && $xmes =~ /\" target=\"_blank\"/ && $xmes =~ /<\/a\>/){
	$xmes =~ s/<a href\=\"/<a>/g;
	$xmes =~ s/\" target=\"_blank\"/<aa>/g;
	}

	&TIME_DATA;

	&HEADER;
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 司令部 - </font>
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
<font color=white>君主、軍師、宰相専用のコマンドです。</font><br>
<font color=white>※役職補正は上位の役職のものが優先されます。</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>

<TABLE bgcolor=$TABLE_C width="100%"><TBODY bgcolor=$TD_C4>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>解雇</TH><TD colspan=2>国の武将を解雇します。（君主か宰相でなければ実行できません。）</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM4><input type=hidden name=type value=5><input type=submit id=input value=\"解雇\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>指令</TH><TD colspan=3 align=center><textarea name=mes cols=75 rows=10>
$xmes</textarea></TD><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM2><input type=submit id=input value=\"実行\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>簒奪</TH><TD colspan=2>君主の位を奪い取ります。（軍師か宰相でなければ実行できません。また、国民の平均忠誠度が40以下でないと実行できません。）</TD><TD><input type=\"checkbox\" name=\"connamechange\" value=\"yes\">国名を変更する</TD><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM8><input type=submit id=input value=\"実行\"></TH></TR></form>
<form><TR><TH>忠誠度閲覧</TH><TD colspan=2>所属武将の忠誠値を閲覧します。</TD><TD><select name=sel>$tlist</select></TD><TH></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>軍師任命</TH><TH>$tname[0]</TH><TD>役職任命、指令、他国への手紙、会議室と国法の管理などが可能になります。<BR>戦闘時に攻撃力が＋10されます。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=0><input type=submit id=input value=\"任命\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>宰相任命</TH><TH>$tname[6]</TH><TD>役職任命、指令、他国への手紙、会議室と国法の管理などが可能になります。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=6><input type=submit id=input value=\"任命\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>大将軍任命</TH><TH>$tname[1]</TH><TD>戦闘時に攻撃力が＋20されます。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=1><input type=submit id=input value=\"任命\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>騎兵将軍任命</TH><TH>$tname[2]</TH><TD>戦闘時に攻撃力が＋15されます。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=2><input type=submit id=input value=\"任命\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>護衛将軍任命</TH><TH>$tname[3]</TH><TD>戦闘時に守備力が+10されます。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=3><input type=submit id=input value=\"任命\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>弓将軍任命</TH><TH>$tname[4]</TH><TD>戦闘時に攻撃力が＋10されます。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=4><input type=submit id=input value=\"任命\"></TH></TR></form>
<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>将軍任命</TH><TH>$tname[5]</TH><TD>戦闘時に攻撃力が＋10されます。</TD><TH><select name=sel>$list</select></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM3><input type=hidden name=type value=5><input type=submit id=input value=\"任命\"></TH></TR></form>

<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>新規入国者へ<BR>の勧誘文</TH><TH colspan=3><input type=text name=mes size=70></TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM5><input type=submit id=input value=\"実行\"></TH></TR></form>

<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>外交関連操作<br>(宣戦布告等)</TH><TD colspan=3>宣戦布告や領土割譲など、外交関連の操作が行えます。国宛で通知が来たときもこちらでご確認下さい。</TD><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=HUKOKU><input type=submit id=input value=\"実行\"></TH></TR></form>

<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>声明</TH><TD colspan=3><center><input type=text name=sei size=70><HR color=$TABLE_C size=2>全国宛で声明を出します。全国にお知らせする時に使って下さい。</center>
</TD><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM6><input type=submit id=input value=\"実行\"></TH></TR></form>

<form action=\"./mydata.cgi\" method=\"post\"><TR><TH>国色変更</TH><TH colspan=3>

EOM
	$i=0;
	foreach(@ELE_BG){print "<input type=radio name=color value=\"$i\"><font color=$ELE_BG[$i]>■</font> \n";$i++;}
	print <<"EOM";


</TH><TH><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM7><input type=submit id=input value=\"変更\"></TH></TR></form>
</TBODY></TABLE>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;
