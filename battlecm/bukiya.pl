#_/_/_/_/_/_/_/_/_/_/#
#      BM上の武器屋   #
#_/_/_/_/_/_/_/_/_/_/#

sub BUKIYA {

	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN($kcon);


	#バトルマップ読み込み
	require "./log_file/map_hash/$kiti.pl";
	$shopname = "$battkemapnameの";

#武器屋の場所特定
	$armhit = 0;
	if($BM_TIKEI[$ky][$kx] == 21){
	$armshop = $BM_TIKEI->[$ky][$kx]{'bukiya'};
	$armhit = 1;
	}
	if(!$armhit){&ERR("不正な処理です。");}

#武器データ読み込み
	open(IN,"$ARM_LIST");
	@ARM_DATA = <IN>;
	close(IN);
	if($kazoku eq "機"){$zokG = ($kaai/4.5);}else{$zokG = ($kaai/3);}
	$armval = int(($karm+$zokG) * 2333);

#武器屋のメッセージ
	#泉州-福州間
	$ARMSHOPMES[1] = "<font color=\"white\">おお、いらっしゃい。こんな辺鄙なところによく来たねぇ。<BR>ここでは米が全て、農業が全てーそんなあなたにぴったりな農具を売っているよ。<BR>間違っても武器にするんじゃないよ。<BR>現在$knameが装備している<font color=\"blue\">$kaname</font>は金<font color=red>$armval</font>で下取るよ。<BR>是非手にとって見ておくれ。<BR>";
	$SHOPCOLOR[1] = "#3CB371";
	#開封
	$ARMSHOPMES[2] = "<font color=\"white\">やあいらっしゃい。<BR>ここでは金が全て、商業が全てーそんな君にぴったりな武器を売っているぜ！<BR>銭の力を敵に思い知らせてやれ！<BR>現在$knameが装備している<font color=\"blue\">$kaname</font>は金<font color=red>$armval</font>で下取るよ。<BR>是非手にとって見ておくれ。<BR>";
	$SHOPCOLOR[2] = "#FF7F50";
	#幽州-燕京間(槍騎兵と干将)
	$ARMSHOPMES[3] = "<font color=\"white\">いらっしゃい。<BR>ここではとても珍しい武器を売っているよ。<BR>値段は高めだがいい武器があるよ。<BR>現在$knameが装備している<font color=\"blue\">$kaname</font>は金<font color=red>$armval</font>で下取るよ。<BR>是非手にとって見ておくれ。<BR>";
	$SHOPCOLOR[3] = "#4D33AE";

	&HEADER;

	print <<"EOM";
<TABLE bgcolor=$SHOPCOLOR[$armshop] width=100% height=100%><TR><TD align=center>
<TABLE bgcolor=$SHOPCOLOR[$armshop] width=100%>
<TR><TH bgcolor=414141>
<font color=red> - $shopname武器屋 - </font>
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
<TABEL bgcolor=#000000 border="2"><TR><TD bgcolor=#414141>
$ARMSHOPMES[$armshop]
※武器についての詳細は<a href="./manual.html#soubi" target="_blank">ここ</a>をみてください。<br>
</font>
</TD></TR></TABLE>
</TD></TR>

<TR><TD valign="top">
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$TABLE_C>
EOM

	open(IN,"$ARM_LIST") or &ERR('ファイルを開けませんでした。');
	@ARM_DATA = <IN>;
	close(IN);

	$list = "<TR><TD bgcolor=$TD_C1>選択</TD><TD bgcolor=$TD_C2>名称</TD><TD align=right bgcolor=$TD_C3>値段</TD><TD bgcolor=$TD_C2 align=center>威力</TD><TD bgcolor=$TD_C10 align=center>属性</TD><TD bgcolor=$TD_C10 align=center>相性</TD><TD bgcolor=$TD_C3 align=center>説明</TD><TD bgcolor=$TD_C3 align=center>スキル</TD><TD bgcolor=$TD_C2>必要技術</TD><TD bgcolor=$TD_C2>必要階級</TD></TR>";
	$s_i=0;
	foreach(@ARM_DATA){
		($armname,$armval,$armdmg,$armwei,$armele,$armsta,$armclass,$armtownid,$armsetumei,$armskl,$armsklsetumei) = split(/<>/);
		if($armtownid == $armshop){
			$armkaikyu = $armsta * 5;
			if($armkaikyu > 25000){$armkaikyu = 25000;}
			if($kvsub2 eq 0){$armval = int($armval / 10);}

			$list .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=$s_i></TD><TD bgcolor=$TD_C2>$armname</TD><TD align=right bgcolor=$TD_C3>金 $armval</TD><TD bgcolor=$TD_C2 align=center>$armdmg</TD><TD bgcolor=$TD_C10 align=center>$armwei</TD><TD bgcolor=$TD_C10 align=center>+$armele</TD><TD bgcolor=$TD_C2>$armsetumei</TD><TD align=right bgcolor=$TD_C2>$armsklsetumei</TD><TD align=right bgcolor=$TD_C2>$armsta</TD><TD align=right bgcolor=$TD_C2>$armkaikyu</TD></TR>";
		}
		$s_i++;
	}


print <<"EOM";
$list
</TABLE><BR>
No:<select name=no size=6 MULTIPLE>
<option value="all">ALL
EOM
	for($i=0;$i<$MAX_COM;$i++){
		$no = $i+1;
		if($i eq "0"){
			print "<option value=\"$i\" SELECTED>$no";
		}else{
			print "<option value=\"$i\">$no";
		}
	}

print <<"EOM";
</select>

<input type=hidden name=mode value=22>
<input type=submit id=input value=\"購入\"></form>


<form action="$BACK" method="post">
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
