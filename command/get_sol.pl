#_/_/_/_/_/_/_/_/#
#      徴兵      #
#_/_/_/_/_/_/_/_/#

sub GET_SOL {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	require 'ini_file/com_list.ini';

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	&HEADER;
	$no = $in{'no'} + 1;

	$get_sol = $klea - $ksol;

	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>";
	}


	if($kstr > $klea && $kstr > $kint && $kstr > $kcha){$osuhei = <<"EOM";
<font color=red>あなたには<a href="#bukan">武官用兵種</a>が向いています。</font>
EOM
}
	elsif($klea > $kstr && $klea > $kint && $klea > $kcha){$osuhei = <<"EOM";
<font color=red>あなたには<a href="#tokan">統率官用兵種</a>が向いています。</font>
EOM
}
	elsif($kint > $kstr && $kint > $klea && $kint > $kcha){$osuhei = <<"EOM";
<font color=red>あなたには<a href="#bunkan">文官用兵種</a>が向いています。</font>
EOM
}
	else{$osuhei = <<"EOM";
<font color=red>あなたには<a href="#jinkan">仁官用兵種</a>が向いています。</font>
EOM
}


	if(($zsub1 > $SOL_TEC[12])&&($kclass > $SOL_LANK[12])){$r = "●衝車の効果：攻城時ターン数+1<br>";}
	if(($zsub1 > $SOL_TEC[68])&&($kclass > $SOL_LANK[68])){$r .= "●攻城兵の効果：攻城時ターン数+1<br>";}
	if(($zsub1 > $SOL_TEC[28])&&($kclass > $SOL_LANK[28])){$r .= "●雲梯の効果：攻城時ターン数+2<br>";}
	if(($zsub1 > $SOL_TEC[29])&&($kclass > $SOL_LANK[29])){$r .= "●投石機の効果：攻城時ターン数+2<br>";}

	if("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/status.cgi"){ 
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 徴 兵 - </font>
</TH></TR>
<TR><TD>
$no_list
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="$img_wid" height="$img_height"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>兵士を徴兵します。<BR>種類の違う兵を雇うと以前まで雇っていた兵は解雇されます。<BR>毎月維持費として兵１人につき米１を消費します。<br>
<br>
<font color=red>※出撃していると失敗します。<br>
ただし出撃中でも、武将の滞在都市と自分の部隊がある都市が同じで、城地形の上に部隊があるときのみ徴兵可能です。<br>
ただしその場合、計数攻撃のカウント、攻撃力上昇、守備力上昇状態はリセットされます。
</font>
<font color=white>※特に記載がなければ、兵攻撃力、兵守備力は対人戦時のものです。</font><br>
</TD></TR></TABLE>
</TD></TR>

<TR><TD valign="top">
<TABLE bgcolor=#222222 cellspacing="3" width="100%"><TR><TD valign="top" bgcolor=#FFFFFF width="50%">
<a name="kou"><h3 style="color:#000000;"><font color="#ff6600">■</font>攻撃力、守備力、与えるダメージについて<font color="#ff6600">■</font></h3></a>
　<b style="color:#000000;background-color:#ff8855">・攻撃力計算式</b><br>
　　・武力＋兵攻撃力＋武器威力＋武器相性＋役職補正<BR>
<br>
　<b style="color:#000000;background-color:#ff8855">・守備力計算式</b><br>
　　・訓練値×0.5＋兵守備力＋防具威力＋役職補正<BR>
<br>
陣形や鼓舞、加護などのスキルの効果は上記の式を元にして決まります。<br>
<br>
　<b style="color:#000000;background-color:#ff8855">・与えるダメージについて</b><br>
　　・自軍が相手の軍に与える事のできる最大ダメージ = (自軍攻撃力-相手守備力)÷10＋1 <BR>
　　・相手の軍が自軍に与える事のできる最大ダメージ = (相手攻撃力-自軍守備力)÷10＋1<BR>
<BR>
どんなに攻撃力が低くても必ず1ダメージは与えられます。<br>
与えるダメージは1〜最大ダメージの間からランダムにきまります。
</TD><TD bgcolor="#FFFFFF" valign="top" width="50%">
<a name="kou"><h3 style="color:#000000;"><font color="#ff6600">■</font>兵士の属性について<font color="#ff6600">■</font></h3></a>
<TABLE cellspacing="1" bgcolor="#222288">
<TBODY bgcolor="#FFFFFF">
<tr><th width="30">属性</th><th>特徴</th></tr>
<tr><th>歩兵</th><td>・全体的にバランスがとれている。<br>・守備力が高め。<br>・自分の近くの味方を敵の攻撃から守れる掩護スキルが使用できる。</td></tr>
<tr><th>騎兵</th><td>・攻撃力が高め。<br>・最大移動Pが多い。<br>・値段が高め。</td></tr>
<tr><th>弓兵</th><td>・リーチが広い。<br>・最大移動Pが少ない。<br>・守備力が極端に低い。</td></tr>
<tr><th>水軍</th><td>・水系地形ですばやく移動できる。<br>・水系地形での戦闘力は高いが、それ以外の場所で戦闘すると攻守-25%される。<br>・必要技術、値段が高い。</td></tr>
<tr><th>機兵</th><td>・特殊なステータス、効果を持つ。<br>・値段が高め。</td></tr>
</tbody>
</table>
</TD></TR></TABLE>
</TD>
</TR>
<br>
<TR><TD valign="top">
<b>$osuhei<br>
何名雇いますか？(※最大$klea人)<br>
<a href="#bukan">武官用兵種</a>/<a href="#tokan">統率官用兵種</a>/<a href="#bunkan">文官用兵種</a>/<a href="#jinkan">仁官用兵種</a>/<a href="#tokusyu">特殊</a></b>
<TABLE bgcolor="$TABLE_C"><TBODY bgcolor="$TD_C3">
<TR><TH bgcolor=#884422 colspan=11><a name=bukan></a>■武官■</TH></TR>
<TR><TH><b>種類</TH><TH>攻撃力</TH><TH>守備力</TH><TH>属性</TH><TH>最大移動P</TH><TH>リーチ</TH><TH>技術</TH><TH>階級値</TH><TH>雇用金</TH><TH>人数</TH><TD></TD></TR>
<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[0]</span>$SOL_TYPE[0]</span></TD><TH>$SOL_ATUP[0]</TH><TH>$SOL_DFUP[0]</TH><TH>$SOL_ZOKSEI[0]</TH><TH>$SOL_MOVE[0]</TH><TH>$SOL_AT[0]</TH><TH>$SOL_TEC[0]</TH><TH>$SOL_LANK[0]</TH><TH>金 $SOL_PRICE[0]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=0>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>
EOM
if(($zsub1 > $SOL_TEC[2])&&($kclass > $SOL_LANK[2])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[2]</span>$SOL_TYPE[2]</span></TD><TH>$SOL_ATUP[2]</TH><TH>$SOL_DFUP[2]</TH><TH>$SOL_ZOKSEI[2]</TH><TH>$SOL_MOVE[2]</TH><TH>$SOL_AT[2]</TH><TH>$SOL_TEC[2]</TH><TH>$SOL_LANK[2]</TH><TH>金 $SOL_PRICE[2]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=2>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[14])&&($kclass > $SOL_LANK[14])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[14]</span>$SOL_TYPE[14]</span></TD><TH>$SOL_ATUP[14]</TH><TH>$SOL_DFUP[14]</TH><TH>$SOL_ZOKSEI[14]</TH><TH>$SOL_MOVE[14]</TH><TH>$SOL_AT[14]</TH><TH>$SOL_TEC[14]</TH><TH>$SOL_LANK[14]</TH><TH>金 $SOL_PRICE[14]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=14>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[31])&&($kclass > $SOL_LANK[31])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[31]</span>$SOL_TYPE[31]</span></TD><TH>$SOL_ATUP[31]</TH><TH>$SOL_DFUP[31]</TH><TH>$SOL_ZOKSEI[31]</TH><TH>$SOL_MOVE[31]</TH><TH>$SOL_AT[31]</TH><TH>$SOL_TEC[31]</TH><TH>$SOL_LANK[31]</TH><TH>金 $SOL_PRICE[31]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=31>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[13])&&($kclass > $SOL_LANK[13])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[13]</span>$SOL_TYPE[13]</span></TD><TH>$SOL_ATUP[13]</TH><TH>$SOL_DFUP[13]</TH><TH>$SOL_ZOKSEI[13]</TH><TH>$SOL_MOVE[13]</TH><TH>$SOL_AT[13]</TH><TH>$SOL_TEC[13]</TH><TH>$SOL_LANK[13]</TH><TH>金 $SOL_PRICE[13]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=13>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[59])&&($kclass > $SOL_LANK[59])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[59]</span>$SOL_TYPE[59]</span></TD><TH>$SOL_ATUP[59]</TH><TH>$SOL_DFUP[59]</TH><TH>$SOL_ZOKSEI[59]</TH><TH>$SOL_MOVE[59]</TH><TH>$SOL_AT[59]</TH><TH>$SOL_TEC[59]</TH><TH>$SOL_LANK[59]</TH><TH>金 $SOL_PRICE[59]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=59>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[60])&&($kclass > $SOL_LANK[60])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[60]</span>$SOL_TYPE[60]</span></TD><TH>$SOL_ATUP[60]</TH><TH>$SOL_DFUP[60]</TH><TH>$SOL_ZOKSEI[60]</TH><TH>$SOL_MOVE[60]</TH><TH>$SOL_AT[60]</TH><TH>$SOL_TEC[60]</TH><TH>$SOL_LANK[60]</TH><TH>金 $SOL_PRICE[60]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=60>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[1])&&($kclass > $SOL_LANK[1])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[1]</span>$SOL_TYPE[1]</span></TD><TH>$SOL_ATUP[1]</TH><TH>$SOL_DFUP[1]</TH><TH>$SOL_ZOKSEI[1]</TH><TH>$SOL_MOVE[1]</TH><TH>$SOL_AT[1]</TH><TH>$SOL_TEC[1]</TH><TH>$SOL_LANK[1]</TH><TH>金 $SOL_PRICE[1]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=1>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[8])&&($kclass > $SOL_LANK[8])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[8]</span>$SOL_TYPE[8]</span></TD><TH>$SOL_ATUP[8]</TH><TH>$SOL_DFUP[8]</TH><TH>$SOL_ZOKSEI[8]</TH><TH>$SOL_MOVE[8]</TH><TH>$SOL_AT[8]</TH><TH>$SOL_TEC[8]</TH><TH>$SOL_LANK[8]</TH><TH>金 $SOL_PRICE[8]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=8>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[4])&&($kclass > $SOL_LANK[4])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[4]</span>$SOL_TYPE[4]</span></TD><TH>$SOL_ATUP[4]</TH><TH>$SOL_DFUP[4]</TH><TH>$SOL_ZOKSEI[4]</TH><TH>$SOL_MOVE[4]</TH><TH>$SOL_AT[4]</TH><TH>$SOL_TEC[4]</TH><TH>$SOL_LANK[4]</TH><TH>金 $SOL_PRICE[4]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=4>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[61])&&($kclass > $SOL_LANK[61])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[61]</span>$SOL_TYPE[61]</span></TD><TH>$SOL_ATUP[61]</TH><TH>$SOL_DFUP[61]</TH><TH>$SOL_ZOKSEI[61]</TH><TH>$SOL_MOVE[61]</TH><TH>$SOL_AT[61]</TH><TH>$SOL_TEC[61]</TH><TH>$SOL_LANK[61]</TH><TH>金 $SOL_PRICE[61]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=61>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[3])&&($kclass > $SOL_LANK[3])){
print <<"EOM";
<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[3]</span>$SOL_TYPE[3]</span></TD><TH>$SOL_ATUP[3]</TH><TH>$SOL_DFUP[3]</TH><TH>$SOL_ZOKSEI[3]</TH><TH>$SOL_MOVE[3]</TH><TH>$SOL_AT[3]</TH><TH>$SOL_TEC[3]</TH><TH>$SOL_LANK[3]</TH><TH>金 $SOL_PRICE[3]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=3>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[47])&&($kclass > $SOL_LANK[47])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[47]</span>$SOL_TYPE[47]</span></TD><TH>$SOL_ATUP[47]</TH><TH>$SOL_DFUP[47]</TH><TH>$SOL_ZOKSEI[47]</TH><TH>$SOL_MOVE[47]</TH><TH>$SOL_AT[47]</TH><TH>$SOL_TEC[47]</TH><TH>$SOL_LANK[47]</TH><TH>金 $SOL_PRICE[47]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=47>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[6])&&($kclass > $SOL_LANK[6])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[6]</span>$SOL_TYPE[6]</span></TD><TH>$SOL_ATUP[6]</TH><TH>$SOL_DFUP[6]</TH><TH>$SOL_ZOKSEI[6]</TH><TH>$SOL_MOVE[6]</TH><TH>$SOL_AT[6]</TH><TH>$SOL_TEC[6]</TH><TH>$SOL_LANK[6]</TH><TH>金 $SOL_PRICE[6]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=6>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[58])&&($kclass > $SOL_LANK[58])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[58]</span>$SOL_TYPE[58]</span></TD><TH>$SOL_ATUP[58]</TH><TH>$SOL_DFUP[58]</TH><TH>$SOL_ZOKSEI[58]</TH><TH>$SOL_MOVE[58]</TH><TH>$SOL_AT[58]</TH><TH>$SOL_TEC[58]</TH><TH>$SOL_LANK[58]</TH><TH>金 $SOL_PRICE[58]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=58>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[22])&&($kclass > $SOL_LANK[22])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[22]</span>$SOL_TYPE[22]</span></TD><TH>$SOL_ATUP[22]</TH><TH>$SOL_DFUP[22]</TH><TH>$SOL_ZOKSEI[22]</TH><TH>$SOL_MOVE[22]</TH><TH>$SOL_AT[22]</TH><TH>$SOL_TEC[22]</TH><TH>$SOL_LANK[22]</TH><TH>金 $SOL_PRICE[22]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=22>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[17])&&($kclass > $SOL_LANK[17])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[17]</span>$SOL_TYPE[17]</span></TD><TH>$SOL_ATUP[17]</TH><TH>$SOL_DFUP[17]</TH><TH>$SOL_ZOKSEI[17]</TH><TH>$SOL_MOVE[17]</TH><TH>$SOL_AT[17]</TH><TH>$SOL_TEC[17]</TH><TH>$SOL_LANK[17]</TH><TH>金 $SOL_PRICE[17]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=17>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[12])&&($kclass > $SOL_LANK[12])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[12]</span>$SOL_TYPE[12]</span></TD><TH>$SOL_ATUP[12]</TH><TH>$SOL_DFUP[12]</TH><TH>$SOL_ZOKSEI[12]</TH><TH>$SOL_MOVE[12]</TH><TH>$SOL_AT[12]</TH><TH>$SOL_TEC[12]</TH><TH>$SOL_LANK[12]</TH><TH>金 $SOL_PRICE[12]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=12>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[48])&&($kclass > $SOL_LANK[48])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[48]</span>$SOL_TYPE[48]</span></TD><TH>$SOL_ATUP[48]</TH><TH>$SOL_DFUP[48]</TH><TH>$SOL_ZOKSEI[48]</TH><TH>$SOL_MOVE[48]</TH><TH>$SOL_AT[48]</TH><TH>$SOL_TEC[48]</TH><TH>$SOL_LANK[48]</TH><TH>金 $SOL_PRICE[48]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=48>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[49])&&($kclass > $SOL_LANK[49])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[49]</span>$SOL_TYPE[49]</span></TD><TH>$SOL_ATUP[49]</TH><TH>$SOL_DFUP[49]</TH><TH>$SOL_ZOKSEI[49]</TH><TH>$SOL_MOVE[49]</TH><TH>$SOL_AT[49]</TH><TH>$SOL_TEC[49]</TH><TH>$SOL_LANK[49]</TH><TH>金 $SOL_PRICE[49]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=49>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[50])&&($kclass > $SOL_LANK[50])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[50]</span>$SOL_TYPE[50]</span></TD><TH>$SOL_ATUP[50]</TH><TH>$SOL_DFUP[50]</TH><TH>$SOL_ZOKSEI[50]</TH><TH>$SOL_MOVE[50]</TH><TH>$SOL_AT[50]</TH><TH>$SOL_TEC[50]</TH><TH>$SOL_LANK[50]</TH><TH>金 $SOL_PRICE[50]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=50>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
print "<TR><TH bgcolor=#884422 colspan=11><a name=tokan></a>■統率官■</TH></TR>";
print "<TR><TH><b>種類</TH><TH>攻撃力</TH><TH>防御力</TH><TH>属性</TH><TH>最大移動P</TH><TH>リーチ</TH><TH>技術</TH><TH>階級値</TH><TH>雇用金</TH><TH>人数</TH><TD></TD></TR>";

if(($zsub1 > $SOL_TEC[15])&&($kclass > $SOL_LANK[15])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[15]</span>$SOL_TYPE[15]</span></TD><TH>$SOL_ATUP[15]</TH><TH>$SOL_DFUP[15]</TH><TH>$SOL_ZOKSEI[15]</TH><TH>$SOL_MOVE[15]</TH><TH>$SOL_AT[15]</TH><TH>$SOL_TEC[15]</TH><TH>$SOL_LANK[15]</TH><TH>金 $SOL_PRICE[15]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=15>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[16])&&($kclass > $SOL_LANK[16])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[16]</span>$SOL_TYPE[16]</span></TD><TH>$SOL_ATUP[16]</TH><TH>$SOL_DFUP[16]</TH><TH>$SOL_ZOKSEI[16]</TH><TH>$SOL_MOVE[16]</TH><TH>$SOL_AT[16]</TH><TH>$SOL_TEC[16]</TH><TH>$SOL_LANK[16]</TH><TH>金 $SOL_PRICE[16]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=16>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[62])&&($kclass > $SOL_LANK[62])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[62]</span>$SOL_TYPE[62]</span></TD><TH>$SOL_ATUP[62]</TH><TH>$SOL_DFUP[62]</TH><TH>$SOL_ZOKSEI[62]</TH><TH>$SOL_MOVE[62]</TH><TH>$SOL_AT[62]</TH><TH>$SOL_TEC[62]</TH><TH>$SOL_LANK[62]</TH><TH>金 $SOL_PRICE[62]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=62>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[18])&&($kclass > $SOL_LANK[18])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[18]</span>$SOL_TYPE[18]</span></TD><TH>$SOL_ATUP[18]</TH><TH>$SOL_DFUP[18]</TH><TH>$SOL_ZOKSEI[18]</TH><TH>$SOL_MOVE[18]</TH><TH>$SOL_AT[18]</TH><TH>$SOL_TEC[18]</TH><TH>$SOL_LANK[18]</TH><TH>金 $SOL_PRICE[18]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=18>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[19])&&($kclass > $SOL_LANK[19])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[19]</span>$SOL_TYPE[19]</span></TD><TH>$SOL_ATUP[19]</TH><TH>$SOL_DFUP[19]</TH><TH>$SOL_ZOKSEI[19]</TH><TH>$SOL_MOVE[19]</TH><TH>$SOL_AT[19]</TH><TH>$SOL_TEC[19]</TH><TH>$SOL_LANK[19]</TH><TH>金 $SOL_PRICE[19]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=19>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[20])&&($kclass > $SOL_LANK[20])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[20]</span>$SOL_TYPE[20]</span></TD><TH>$SOL_ATUP[20]</TH><TH>$SOL_DFUP[20]</TH><TH>$SOL_ZOKSEI[20]</TH><TH>$SOL_MOVE[20]</TH><TH>$SOL_AT[20]</TH><TH>$SOL_TEC[20]</TH><TH>$SOL_LANK[20]</TH><TH>金 $SOL_PRICE[20]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=20>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[63])&&($kclass > $SOL_LANK[63])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[63]</span>$SOL_TYPE[63]</span></TD><TH>$SOL_ATUP[63]</TH><TH>$SOL_DFUP[63]</TH><TH>$SOL_ZOKSEI[63]</TH><TH>$SOL_MOVE[63]</TH><TH>$SOL_AT[63]</TH><TH>$SOL_TEC[63]</TH><TH>$SOL_LANK[63]</TH><TH>金 $SOL_PRICE[63]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=63>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[21])&&($kclass > $SOL_LANK[21])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[21]</span>$SOL_TYPE[21]</span></TD><TH>$SOL_ATUP[21]</TH><TH>$SOL_DFUP[21]</TH><TH>$SOL_ZOKSEI[21]</TH><TH>$SOL_MOVE[21]</TH><TH>$SOL_AT[21]</TH><TH>$SOL_TEC[21]</TH><TH>$SOL_LANK[21]</TH><TH>金 $SOL_PRICE[21]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=21>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[24])&&($kclass > $SOL_LANK[24])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[24]</span>$SOL_TYPE[24]</span></TD><TH>$SOL_ATUP[24]</TH><TH>$SOL_DFUP[24]</TH><TH>$SOL_ZOKSEI[24]</TH><TH>$SOL_MOVE[24]</TH><TH>$SOL_AT[24]</TH><TH>$SOL_TEC[24]</TH><TH>$SOL_LANK[24]</TH><TH>金 $SOL_PRICE[24]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=24>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[11])&&($kclass > $SOL_LANK[11])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[11]</span>$SOL_TYPE[11]</span></TD><TH>$SOL_ATUP[11]</TH><TH>$SOL_DFUP[11]</TH><TH>$SOL_ZOKSEI[11]</TH><TH>$SOL_MOVE[11]</TH><TH>$SOL_AT[11]</TH><TH>$SOL_TEC[11]</TH><TH>$SOL_LANK[11]</TH><TH>金 $SOL_PRICE[11]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=11>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[30])&&($kclass > $SOL_LANK[30])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[30]</span>$SOL_TYPE[30]</span></TD><TH>$SOL_ATUP[30]</TH><TH>$SOL_DFUP[30]</TH><TH>$SOL_ZOKSEI[30]</TH><TH>$SOL_MOVE[30]</TH><TH>$SOL_AT[30]</TH><TH>$SOL_TEC[30]</TH><TH>$SOL_LANK[30]</TH><TH>金 $SOL_PRICE[30]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=30>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[23])&&($kclass > $SOL_LANK[23])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[23]</span>$SOL_TYPE[23]</span></TD><TH>$SOL_ATUP[23]</TH><TH>$SOL_DFUP[23]</TH><TH>$SOL_ZOKSEI[23]</TH><TH>$SOL_MOVE[23]</TH><TH>$SOL_AT[23]</TH><TH>$SOL_TEC[23]</TH><TH>$SOL_LANK[23]</TH><TH>金 $SOL_PRICE[23]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=23>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[64])&&($kclass > $SOL_LANK[64])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[64]</span>$SOL_TYPE[64]</span></TD><TH>$SOL_ATUP[64]</TH><TH>$SOL_DFUP[64]</TH><TH>$SOL_ZOKSEI[64]</TH><TH>$SOL_MOVE[64]</TH><TH>$SOL_AT[64]</TH><TH>$SOL_TEC[64]</TH><TH>$SOL_LANK[64]</TH><TH>金 $SOL_PRICE[64]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=64>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[57])&&($kclass > $SOL_LANK[57])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[57]</span>$SOL_TYPE[57]</span></TD><TH>$SOL_ATUP[57]</TH><TH>$SOL_DFUP[57]</TH><TH>$SOL_ZOKSEI[57]</TH><TH>$SOL_MOVE[57]</TH><TH>$SOL_AT[57]</TH><TH>$SOL_TEC[57]</TH><TH>$SOL_LANK[57]</TH><TH>金 $SOL_PRICE[57]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=57>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}

print "<TR><TH bgcolor=#884422 colspan=11><a name=bunkan></a>■文官■</TH></TR>";
print "<TR><TH><b>種類</TH><TH>攻撃力</TH><TH>防御力</TH><TH>属性</TH><TH>最大移動P</TH><TH>リーチ</TH><TH>技術</TH><TH>階級値</TH><TH>雇用金</TH><TH>人数</TH><TD></TD></TR>";

if(($zsub1 >= $SOL_TEC[5])&&($kclass >= $SOL_LANK[5])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[5]</span>$SOL_TYPE[5]</span></TD><TH>$SOL_ATUP[5]</TH><TH>$SOL_DFUP[5]</TH><TH>$SOL_ZOKSEI[5]</TH><TH>$SOL_MOVE[5]</TH><TH>$SOL_AT[5]</TH><TH>$SOL_TEC[5]</TH><TH>$SOL_LANK[5]</TH><TH>金 $SOL_PRICE[5]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=5>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[45])&&($kclass > $SOL_LANK[45])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[45]</span>$SOL_TYPE[45]</span></TD><TH>$SOL_ATUP[45]</TH><TH>$SOL_DFUP[45]</TH><TH>$SOL_ZOKSEI[45]</TH><TH>$SOL_MOVE[45]</TH><TH>$SOL_AT[45]</TH><TH>$SOL_TEC[45]</TH><TH>$SOL_LANK[45]</TH><TH>金 $SOL_PRICE[45]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=45>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[34])&&($kclass > $SOL_LANK[34])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[34]</span>$SOL_TYPE[34]</span></TD><TH>$SOL_ATUP[34]</TH><TH>$SOL_DFUP[34]</TH><TH>$SOL_ZOKSEI[34]</TH><TH>$SOL_MOVE[34]</TH><TH>$SOL_AT[34]</TH><TH>$SOL_TEC[34]</TH><TH>$SOL_LANK[34]</TH><TH>金 $SOL_PRICE[34]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=34>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[35])&&($kclass > $SOL_LANK[35])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[35]</span>$SOL_TYPE[35]</span></TD><TH>$SOL_ATUP[35]</TH><TH>$SOL_DFUP[35]</TH><TH>$SOL_ZOKSEI[35]</TH><TH>$SOL_MOVE[35]</TH><TH>$SOL_AT[35]</TH><TH>$SOL_TEC[35]</TH><TH>$SOL_LANK[35]</TH><TH>金 $SOL_PRICE[35]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=35>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[65])&&($kclass > $SOL_LANK[65])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[65]</span>$SOL_TYPE[65]</span></TD><TH>$SOL_ATUP[65]</TH><TH>$SOL_DFUP[65]</TH><TH>$SOL_ZOKSEI[65]</TH><TH>$SOL_MOVE[65]</TH><TH>$SOL_AT[65]</TH><TH>$SOL_TEC[65]</TH><TH>$SOL_LANK[65]</TH><TH>金 $SOL_PRICE[65]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=65>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[7])&&($kclass > $SOL_LANK[7])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[7]</span>$SOL_TYPE[7]</span></TD><TH>$SOL_ATUP[7]</TH><TH>$SOL_DFUP[7]</TH><TH>$SOL_ZOKSEI[7]</TH><TH>$SOL_MOVE[7]</TH><TH>$SOL_AT[7]</TH><TH>$SOL_TEC[7]</TH><TH>$SOL_LANK[7]</TH><TH>金 $SOL_PRICE[7]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=7>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[9])&&($kclass > $SOL_LANK[9])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[9]</span>$SOL_TYPE[9]</span></TD><TH>$SOL_ATUP[9]</TH><TH>$SOL_DFUP[9]</TH><TH>$SOL_ZOKSEI[9]</TH><TH>$SOL_MOVE[9]</TH><TH>$SOL_AT[9]</TH><TH>$SOL_TEC[9]</TH><TH>$SOL_LANK[9]</TH><TH>金 $SOL_PRICE[9]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=9>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[37])&&($kclass > $SOL_LANK[37])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[37]</span>$SOL_TYPE[37]</span></TD><TH>$SOL_ATUP[37]</TH><TH>$SOL_DFUP[37]</TH><TH>$SOL_ZOKSEI[37]</TH><TH>$SOL_MOVE[37]</TH><TH>$SOL_AT[37]</TH><TH>$SOL_TEC[37]</TH><TH>$SOL_LANK[37]</TH><TH>金 $SOL_PRICE[37]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=37>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[67])&&($kclass > $SOL_LANK[67])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[67]</span>$SOL_TYPE[67]</span></TD><TH>$SOL_ATUP[67]</TH><TH>$SOL_DFUP[67]</TH><TH>$SOL_ZOKSEI[67]</TH><TH>$SOL_MOVE[67]</TH><TH>$SOL_AT[67]</TH><TH>$SOL_TEC[67]</TH><TH>$SOL_LANK[67]</TH><TH>金 $SOL_PRICE[67]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=67>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[32])&&($kclass > $SOL_LANK[32])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[32]</span>$SOL_TYPE[32]</span></TD><TH>$SOL_ATUP[32]</TH><TH>$SOL_DFUP[32]</TH><TH>$SOL_ZOKSEI[32]</TH><TH>$SOL_MOVE[32]</TH><TH>$SOL_AT[32]</TH><TH>$SOL_TEC[32]</TH><TH>$SOL_LANK[32]</TH><TH>金 $SOL_PRICE[32]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=32>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[33])&&($kclass > $SOL_LANK[33])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[33]</span>$SOL_TYPE[33]</span></TD><TH>$SOL_ATUP[33]</TH><TH>$SOL_DFUP[33]</TH><TH>$SOL_ZOKSEI[33]</TH><TH>$SOL_MOVE[33]</TH><TH>$SOL_AT[33]</TH><TH>$SOL_TEC[33]</TH><TH>$SOL_LANK[33]</TH><TH>金 $SOL_PRICE[33]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=33>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[36])&&($kclass > $SOL_LANK[36])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[36]</span>$SOL_TYPE[36]</span></TD><TH>$SOL_ATUP[36]</TH><TH>$SOL_DFUP[36]</TH><TH>$SOL_ZOKSEI[36]</TH><TH>$SOL_MOVE[36]</TH><TH>$SOL_AT[36]</TH><TH>$SOL_TEC[36]</TH><TH>$SOL_LANK[36]</TH><TH>金 $SOL_PRICE[36]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=36>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[10])&&($kclass > $SOL_LANK[10])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[10]</span>$SOL_TYPE[10]</span></TD><TH>$SOL_ATUP[10]</TH><TH>$SOL_DFUP[10]</TH><TH>$SOL_ZOKSEI[10]</TH><TH>$SOL_MOVE[10]</TH><TH>$SOL_AT[10]</TH><TH>$SOL_TEC[10]</TH><TH>$SOL_LANK[10]</TH><TH>金 $SOL_PRICE[10]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=10>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[66])&&($kclass > $SOL_LANK[66])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[66]</span>$SOL_TYPE[66]</span></TD><TH>$SOL_ATUP[66]</TH><TH>$SOL_DFUP[66]</TH><TH>$SOL_ZOKSEI[66]</TH><TH>$SOL_MOVE[66]</TH><TH>$SOL_AT[66]</TH><TH>$SOL_TEC[66]</TH><TH>$SOL_LANK[66]</TH><TH>金 $SOL_PRICE[66]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=66>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[68])&&($kclass > $SOL_LANK[68])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[68]</span>$SOL_TYPE[68]</span></TD><TH>$SOL_ATUP[68]</TH><TH>$SOL_DFUP[68]</TH><TH>$SOL_ZOKSEI[68]</TH><TH>$SOL_MOVE[68]</TH><TH>$SOL_AT[68]</TH><TH>$SOL_TEC[68]</TH><TH>$SOL_LANK[68]</TH><TH>金 $SOL_PRICE[68]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=68>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[28])&&($kclass > $SOL_LANK[28])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[28]</span>$SOL_TYPE[28]</span></TD><TH>$SOL_ATUP[28]</TH><TH>$SOL_DFUP[28]</TH><TH>$SOL_ZOKSEI[28]</TH><TH>$SOL_MOVE[28]</TH><TH>$SOL_AT[28]</TH><TH>$SOL_TEC[28]</TH><TH>$SOL_LANK[28]</TH><TH>金 $SOL_PRICE[28]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=28>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[29])&&($kclass > $SOL_LANK[29])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[29]</span>$SOL_TYPE[29]</span></TD><TH>$SOL_ATUP[29]</TH><TH>$SOL_DFUP[29]</TH><TH>$SOL_ZOKSEI[29]</TH><TH>$SOL_MOVE[29]</TH><TH>$SOL_AT[29]</TH><TH>$SOL_TEC[29]</TH><TH>$SOL_LANK[29]</TH><TH>金 $SOL_PRICE[29]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=29>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}

print "<TR><TH bgcolor=#884422 colspan=11><a name=jinkan></a>■仁官■</TH></TR>";
print "<TR><TH><b>種類</TH><TH>攻撃力</TH><TH>防御力</TH><TH>属性</TH><TH>最大移動P</TH><TH>リーチ</TH><TH>技術</TH><TH>階級値</TH><TH>雇用金</TH><TH>人数</TH><TD></TD></TR>";

if(($zsub1 >= $SOL_TEC[40])&&($kclass >= $SOL_LANK[40])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[40]</span>$SOL_TYPE[40]</span></TD><TH>$SOL_ATUP[40]</TH><TH>$SOL_DFUP[40]</TH><TH>$SOL_ZOKSEI[40]</TH><TH>$SOL_MOVE[40]</TH><TH>$SOL_AT[40]</TH><TH>$SOL_TEC[40]</TH><TH>$SOL_LANK[40]</TH><TH>金 $SOL_PRICE[40]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=40>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[25])&&($kclass > $SOL_LANK[25])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[25]</span>$SOL_TYPE[25]</span></TD><TH>$SOL_ATUP[25]</TH><TH>$SOL_DFUP[25]</TH><TH>$SOL_ZOKSEI[25]</TH><TH>$SOL_MOVE[25]</TH><TH>$SOL_AT[25]</TH><TH>$SOL_TEC[25]</TH><TH>$SOL_LANK[25]</TH><TH>金 $SOL_PRICE[25]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=25>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[71])&&($kclass > $SOL_LANK[71])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[71]</span>$SOL_TYPE[71]</span></TD><TH>$SOL_ATUP[71]</TH><TH>$SOL_DFUP[71]</TH><TH>$SOL_ZOKSEI[71]</TH><TH>$SOL_MOVE[71]</TH><TH>$SOL_AT[71]</TH><TH>$SOL_TEC[71]</TH><TH>$SOL_LANK[71]</TH><TH>金 $SOL_PRICE[71]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=71>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[26])&&($kclass > $SOL_LANK[26])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[26]</span>$SOL_TYPE[26]</span></TD><TH>$SOL_ATUP[26]</TH><TH>$SOL_DFUP[26]</TH><TH>$SOL_ZOKSEI[26]</TH><TH>$SOL_MOVE[26]</TH><TH>$SOL_AT[26]</TH><TH>$SOL_TEC[26]</TH><TH>$SOL_LANK[26]</TH><TH>金 $SOL_PRICE[26]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=26>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[27])&&($kclass > $SOL_LANK[27])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[27]</span>$SOL_TYPE[27]</span></TD><TH>$SOL_ATUP[27]</TH><TH>$SOL_DFUP[27]</TH><TH>$SOL_ZOKSEI[27]</TH><TH>$SOL_MOVE[27]</TH><TH>$SOL_AT[27]</TH><TH>$SOL_TEC[27]</TH><TH>$SOL_LANK[27]</TH><TH>金 $SOL_PRICE[27]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=27>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[69])&&($kclass > $SOL_LANK[69])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[69]</span>$SOL_TYPE[69]</span></TD><TH>$SOL_ATUP[69]</TH><TH>$SOL_DFUP[69]</TH><TH>$SOL_ZOKSEI[69]</TH><TH>$SOL_MOVE[69]</TH><TH>$SOL_AT[69]</TH><TH>$SOL_TEC[69]</TH><TH>$SOL_LANK[69]</TH><TH>金 $SOL_PRICE[69]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=69>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[39])&&($kclass > $SOL_LANK[39])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[39]</span>$SOL_TYPE[39]</span></TD><TH>$SOL_ATUP[39]</TH><TH>$SOL_DFUP[39]</TH><TH>$SOL_ZOKSEI[39]</TH><TH>$SOL_MOVE[39]</TH><TH>$SOL_AT[39]</TH><TH>$SOL_TEC[39]</TH><TH>$SOL_LANK[39]</TH><TH>金 $SOL_PRICE[39]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=39>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[42])&&($kclass > $SOL_LANK[42])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[42]</span>$SOL_TYPE[42]</span></TD><TH>$SOL_ATUP[42]</TH><TH>$SOL_DFUP[42]</TH><TH>$SOL_ZOKSEI[42]</TH><TH>$SOL_MOVE[42]</TH><TH>$SOL_AT[42]</TH><TH>$SOL_TEC[42]</TH><TH>$SOL_LANK[42]</TH><TH>金 $SOL_PRICE[42]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=42>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[44])&&($kclass > $SOL_LANK[44])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[44]</span>$SOL_TYPE[44]</span></TD><TH>$SOL_ATUP[44]</TH><TH>$SOL_DFUP[44]</TH><TH>$SOL_ZOKSEI[44]</TH><TH>$SOL_MOVE[44]</TH><TH>$SOL_AT[44]</TH><TH>$SOL_TEC[44]</TH><TH>$SOL_LANK[44]</TH><TH>金 $SOL_PRICE[44]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=44>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[38])&&($kclass > $SOL_LANK[38])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[38]</span>$SOL_TYPE[38]</span></TD><TH>$SOL_ATUP[38]</TH><TH>$SOL_DFUP[38]</TH><TH>$SOL_ZOKSEI[38]</TH><TH>$SOL_MOVE[38]</TH><TH>$SOL_AT[38]</TH><TH>$SOL_TEC[38]</TH><TH>$SOL_LANK[38]</TH><TH>金 $SOL_PRICE[38]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=38>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[72])&&($kclass > $SOL_LANK[72])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[72]</span>$SOL_TYPE[72]</span></TD><TH>$SOL_ATUP[72]</TH><TH>$SOL_DFUP[72]</TH><TH>$SOL_ZOKSEI[72]</TH><TH>$SOL_MOVE[72]</TH><TH>$SOL_AT[72]</TH><TH>$SOL_TEC[72]</TH><TH>$SOL_LANK[72]</TH><TH>金 $SOL_PRICE[72]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=72>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[41])&&($kclass > $SOL_LANK[41])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[41]</span>$SOL_TYPE[41]</span></TD><TH>$SOL_ATUP[41]</TH><TH>$SOL_DFUP[41]</TH><TH>$SOL_ZOKSEI[41]</TH><TH>$SOL_MOVE[41]</TH><TH>$SOL_AT[41]</TH><TH>$SOL_TEC[41]</TH><TH>$SOL_LANK[41]</TH><TH>金 $SOL_PRICE[41]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=41>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[43])&&($kclass > $SOL_LANK[43])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[43]</span>$SOL_TYPE[43]</span></TD><TH>$SOL_ATUP[43]</TH><TH>$SOL_DFUP[43]</TH><TH>$SOL_ZOKSEI[43]</TH><TH>$SOL_MOVE[43]</TH><TH>$SOL_AT[43]</TH><TH>$SOL_TEC[43]</TH><TH>$SOL_LANK[43]</TH><TH>金 $SOL_PRICE[43]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=43>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[70])&&($kclass > $SOL_LANK[70])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[70]</span>$SOL_TYPE[70]</span></TD><TH>$SOL_ATUP[70]</TH><TH>$SOL_DFUP[70]</TH><TH>$SOL_ZOKSEI[70]</TH><TH>$SOL_MOVE[70]</TH><TH>$SOL_AT[70]</TH><TH>$SOL_TEC[70]</TH><TH>$SOL_LANK[70]</TH><TH>金 $SOL_PRICE[70]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=70>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[51])&&($kclass > $SOL_LANK[51])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[51]</span>$SOL_TYPE[51]</span></TD><TH>$SOL_ATUP[51]</TH><TH>$SOL_DFUP[51]</TH><TH>$SOL_ZOKSEI[51]</TH><TH>$SOL_MOVE[51]</TH><TH>$SOL_AT[51]</TH><TH>$SOL_TEC[51]</TH><TH>$SOL_LANK[51]</TH><TH>金 $SOL_PRICE[51]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=51>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[52])&&($kclass > $SOL_LANK[52])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[52]</span>$SOL_TYPE[52]</span></TD><TH>$SOL_ATUP[52]</TH><TH>$SOL_DFUP[52]</TH><TH>$SOL_ZOKSEI[52]</TH><TH>$SOL_MOVE[52]</TH><TH>$SOL_AT[52]</TH><TH>$SOL_TEC[52]</TH><TH>$SOL_LANK[52]</TH><TH>金 $SOL_PRICE[52]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=52>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[53])&&($kclass > $SOL_LANK[53])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[53]</span>$SOL_TYPE[53]</span></TD><TH>$SOL_ATUP[53]</TH><TH>$SOL_DFUP[53]</TH><TH>$SOL_ZOKSEI[53]</TH><TH>$SOL_MOVE[53]</TH><TH>$SOL_AT[53]</TH><TH>$SOL_TEC[53]</TH><TH>$SOL_LANK[53]</TH><TH>金 $SOL_PRICE[53]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=53>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[54])&&($kclass > $SOL_LANK[54])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[54]</span>$SOL_TYPE[54]</span></TD><TH>$SOL_ATUP[54]</TH><TH>$SOL_DFUP[54]</TH><TH>$SOL_ZOKSEI[54]</TH><TH>$SOL_MOVE[54]</TH><TH>$SOL_AT[54]</TH><TH>$SOL_TEC[54]</TH><TH>$SOL_LANK[54]</TH><TH>金 $SOL_PRICE[54]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=54>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[55])&&($kclass > $SOL_LANK[55])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[55]</span>$SOL_TYPE[55]</span></TD><TH>$SOL_ATUP[55]</TH><TH>$SOL_DFUP[55]</TH><TH>$SOL_ZOKSEI[55]</TH><TH>$SOL_MOVE[55]</TH><TH>$SOL_AT[55]</TH><TH>$SOL_TEC[55]</TH><TH>$SOL_LANK[55]</TH><TH>金 $SOL_PRICE[55]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=55>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
if(($zsub1 > $SOL_TEC[56])&&($kclass > $SOL_LANK[56])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[56]</span>$SOL_TYPE[56]</span></TD><TH>$SOL_ATUP[56]</TH><TH>$SOL_DFUP[56]</TH><TH>$SOL_ZOKSEI[56]</TH><TH>$SOL_MOVE[56]</TH><TH>$SOL_AT[56]</TH><TH>$SOL_TEC[56]</TH><TH>$SOL_LANK[56]</TH><TH>金 $SOL_PRICE[56]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=56>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}

print "<TR><TH bgcolor=#884422 colspan=11><a name=tokusyu></a>■特殊■</TH></TR>";
print "<TR><TH><b>種類</TH><TH>攻撃力</TH><TH>防御力</TH><TH>属性</TH><TH>最大移動P</TH><TH>リーチ</TH><TH>技術</TH><TH>階級値</TH><TH>雇用金</TH><TH>人数</TH><TD></TD></TR>";

if(($zsub1 >= $SOL_TEC[46])&&($kclass >= $SOL_LANK[46])){
print <<"EOM";

<TR><TH><span id="tooltip"><span>$SOL_SETUMEI[46]</span>$SOL_TYPE[46]</span></TD><TH>$SOL_ATUP[46]</TH><TH>$SOL_DFUP[46]</TH><TH>$SOL_ZOKSEI[46]</TH><TH>$SOL_MOVE[46]</TH><TH>$SOL_AT[46]</TH><TH>$SOL_TEC[46]</TH><TH>$SOL_LANK[46]</TH><TH>金 $SOL_PRICE[46]</TH><form action="$COMMAND" method="POST"><TD>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=46>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></TD></form></TR>

EOM
}
print <<"EOM";

</TABLE>
	$r
<br>
※兵士の名前にカーソルを合わせると解説が表示されます。
<br>
<br>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM
	}else{
print <<"EOM";
<h3>- 徴 兵 - </h3>
[$kname]<BR>
金:$kgold<BR>
米:$krice<BR>
兵士:$ksol<BR>
訓練:$kgat<BR>
<p>
何名雇いますか？(※最大$klea人)<BR>
<b><a href="#bukan">武官用兵種</a>/<a href="#tokan">統率官用兵種</a>/<a href="#bunkan">文官用兵種</a>/<a href="#jinkan">仁官用兵種</a>/<a href="#tokusyu">特殊</a></b><BR>
<br>
種類:攻撃力:守備力:属性:移P:リーチ:技術:階級値:雇用金:人数<BR><BR>
<a name=bukan></a>■武官■<br>
$SOL_TYPE[0]:$SOL_ATUP[0]:$SOL_DFUP[0]:$SOL_ZOKSEI[0]:$SOL_MOVE[0]:$SOL_AT[0]:$SOL_TEC[0]:$SOL_LANK[0]:金 $SOL_PRICE[0]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=0>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>
EOM
if(($zsub1 > $SOL_TEC[2])&&($kclass > $SOL_LANK[2])){
print <<"EOM";

$SOL_TYPE[2]:$SOL_ATUP[2]:$SOL_DFUP[2]:$SOL_ZOKSEI[2]:$SOL_MOVE[2]:$SOL_AT[2]:$SOL_TEC[2]:$SOL_LANK[2]:金 $SOL_PRICE[2]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=2>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[14])&&($kclass > $SOL_LANK[14])){
print <<"EOM";

$SOL_TYPE[14]:$SOL_ATUP[14]:$SOL_DFUP[14]:$SOL_ZOKSEI[14]:$SOL_MOVE[14]:$SOL_AT[14]:$SOL_TEC[14]:$SOL_LANK[14]:金 $SOL_PRICE[14]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=14>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[31])&&($kclass > $SOL_LANK[31])){
print <<"EOM";

$SOL_TYPE[31]:$SOL_ATUP[31]:$SOL_DFUP[31]:$SOL_ZOKSEI[31]:$SOL_MOVE[31]:$SOL_AT[31]:$SOL_TEC[31]:$SOL_LANK[31]:金 $SOL_PRICE[31]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=31>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[13])&&($kclass > $SOL_LANK[13])){
print <<"EOM";

$SOL_TYPE[13]:$SOL_ATUP[13]:$SOL_DFUP[13]:$SOL_ZOKSEI[13]:$SOL_MOVE[13]:$SOL_AT[13]:$SOL_TEC[13]:$SOL_LANK[13]:金 $SOL_PRICE[13]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=13>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[59])&&($kclass > $SOL_LANK[59])){
print <<"EOM";

$SOL_TYPE[59]:$SOL_ATUP[59]:$SOL_DFUP[59]:$SOL_ZOKSEI[59]:$SOL_MOVE[59]:$SOL_AT[59]:$SOL_TEC[59]:$SOL_LANK[59]:金 $SOL_PRICE[59]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=59>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[60])&&($kclass > $SOL_LANK[60])){
print <<"EOM";

$SOL_TYPE[60]:$SOL_ATUP[60]:$SOL_DFUP[60]:$SOL_ZOKSEI[60]:$SOL_MOVE[60]:$SOL_AT[60]:$SOL_TEC[60]:$SOL_LANK[60]:金 $SOL_PRICE[60]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=60>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[1])&&($kclass > $SOL_LANK[1])){
print <<"EOM";

$SOL_TYPE[1]:$SOL_ATUP[1]:$SOL_DFUP[1]:$SOL_ZOKSEI[1]:$SOL_MOVE[1]:$SOL_AT[1]:$SOL_TEC[1]:$SOL_LANK[1]:金 $SOL_PRICE[1]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=1>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[8])&&($kclass > $SOL_LANK[8])){
print <<"EOM";

$SOL_TYPE[8]:$SOL_ATUP[8]:$SOL_DFUP[8]:$SOL_ZOKSEI[8]:$SOL_MOVE[8]:$SOL_AT[8]:$SOL_TEC[8]:$SOL_LANK[8]:金 $SOL_PRICE[8]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=8>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[4])&&($kclass > $SOL_LANK[4])){
print <<"EOM";

$SOL_TYPE[4]:$SOL_ATUP[4]:$SOL_DFUP[4]:$SOL_ZOKSEI[4]:$SOL_MOVE[4]:$SOL_AT[4]:$SOL_TEC[4]:$SOL_LANK[4]:金 $SOL_PRICE[4]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=4>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[61])&&($kclass > $SOL_LANK[61])){
print <<"EOM";

$SOL_TYPE[61]:$SOL_ATUP[61]:$SOL_DFUP[61]:$SOL_ZOKSEI[61]:$SOL_MOVE[61]:$SOL_AT[61]:$SOL_TEC[61]:$SOL_LANK[61]:金 $SOL_PRICE[61]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=61>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[3])&&($kclass > $SOL_LANK[3])){
print <<"EOM";

$SOL_TYPE[3]:$SOL_ATUP[3]:$SOL_DFUP[3]:$SOL_ZOKSEI[3]:$SOL_MOVE[3]:$SOL_AT[3]:$SOL_TEC[3]:$SOL_LANK[3]:金 $SOL_PRICE[3]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=3>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[47])&&($kclass > $SOL_LANK[47])){
print <<"EOM";

$SOL_TYPE[47]:$SOL_ATUP[47]:$SOL_DFUP[47]:$SOL_ZOKSEI[47]:$SOL_MOVE[47]:$SOL_AT[47]:$SOL_TEC[47]:$SOL_LANK[47]:金 $SOL_PRICE[47]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=47>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[6])&&($kclass > $SOL_LANK[6])){
print <<"EOM";

$SOL_TYPE[6]:$SOL_ATUP[6]:$SOL_DFUP[6]:$SOL_ZOKSEI[6]:$SOL_MOVE[6]:$SOL_AT[6]:$SOL_TEC[6]:$SOL_LANK[6]:金 $SOL_PRICE[6]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=6>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[58])&&($kclass > $SOL_LANK[58])){
print <<"EOM";

$SOL_TYPE[58]:$SOL_ATUP[58]:$SOL_DFUP[58]:$SOL_ZOKSEI[58]:$SOL_MOVE[58]:$SOL_AT[58]:$SOL_TEC[58]:$SOL_LANK[58]:金 $SOL_PRICE[58]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=58>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[22])&&($kclass > $SOL_LANK[22])){
print <<"EOM";

$SOL_TYPE[22]:$SOL_ATUP[22]:$SOL_DFUP[22]:$SOL_ZOKSEI[22]:$SOL_MOVE[22]:$SOL_AT[22]:$SOL_TEC[22]:$SOL_LANK[22]:金 $SOL_PRICE[22]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=22>
<input type=hidden name=mode value=$GET_SOL2>
</TD><TD><input type=submit value=\"雇う\"></form>

EOM
}if(($zsub1 > $SOL_TEC[17])&&($kclass > $SOL_LANK[17])){
print <<"EOM";

$SOL_TYPE[17]:$SOL_ATUP[17]:$SOL_DFUP[17]:$SOL_ZOKSEI[17]:$SOL_MOVE[17]:$SOL_AT[17]:$SOL_TEC[17]:$SOL_LANK[17]:金 $SOL_PRICE[17]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=17>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}

if(($zsub1 > $SOL_TEC[12])&&($kclass > $SOL_LANK[12])){
print <<"EOM";

$SOL_TYPE[12]:$SOL_ATUP[12]:$SOL_DFUP[12]:$SOL_ZOKSEI[12]:$SOL_MOVE[12]:$SOL_AT[12]:$SOL_TEC[12]:$SOL_LANK[12]:金 $SOL_PRICE[12]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=12>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[48])&&($kclass > $SOL_LANK[48])){
print <<"EOM";

$SOL_TYPE[48]:$SOL_ATUP[48]:$SOL_DFUP[48]:$SOL_ZOKSEI[48]:$SOL_MOVE[48]:$SOL_AT[48]:$SOL_TEC[48]:$SOL_LANK[48]:金 $SOL_PRICE[48]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=48>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[49])&&($kclass > $SOL_LANK[49])){
print <<"EOM";

$SOL_TYPE[49]:$SOL_ATUP[49]:$SOL_DFUP[49]:$SOL_ZOKSEI[49]:$SOL_MOVE[49]:$SOL_AT[49]:$SOL_TEC[49]:$SOL_LANK[49]:金 $SOL_PRICE[49]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=49>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[50])&&($kclass > $SOL_LANK[50])){
print <<"EOM";

$SOL_TYPE[50]:$SOL_ATUP[50]:$SOL_DFUP[50]:$SOL_ZOKSEI[50]:$SOL_MOVE[50]:$SOL_AT[50]:$SOL_TEC[50]:$SOL_LANK[50]:金 $SOL_PRICE[50]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=50>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
print "<br><a name=tokan></a>■統率官■<br>";
if(($zsub1 > $SOL_TEC[15])&&($kclass > $SOL_LANK[15])){
print <<"EOM";

$SOL_TYPE[15]:$SOL_ATUP[15]:$SOL_DFUP[15]:$SOL_ZOKSEI[15]:$SOL_MOVE[15]:$SOL_AT[15]:$SOL_TEC[15]:$SOL_LANK[15]:金 $SOL_PRICE[15]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=15>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[16])&&($kclass > $SOL_LANK[16])){
print <<"EOM";

$SOL_TYPE[16]:$SOL_ATUP[16]:$SOL_DFUP[16]:$SOL_ZOKSEI[16]:$SOL_MOVE[16]:$SOL_AT[16]:$SOL_TEC[16]:$SOL_LANK[16]:金 $SOL_PRICE[16]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=16>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[62])&&($kclass > $SOL_LANK[62])){
print <<"EOM";

$SOL_TYPE[62]:$SOL_ATUP[62]:$SOL_DFUP[62]:$SOL_ZOKSEI[62]:$SOL_MOVE[62]:$SOL_AT[62]:$SOL_TEC[62]:$SOL_LANK[62]:金 $SOL_PRICE[62]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=62>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[18])&&($kclass > $SOL_LANK[18])){
print <<"EOM";

$SOL_TYPE[18]:$SOL_ATUP[18]:$SOL_DFUP[18]:$SOL_ZOKSEI[18]:$SOL_MOVE[18]:$SOL_AT[18]:$SOL_TEC[18]:$SOL_LANK[18]:金 $SOL_PRICE[18]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=18>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[19])&&($kclass > $SOL_LANK[19])){
print <<"EOM";

$SOL_TYPE[19]:$SOL_ATUP[19]:$SOL_DFUP[19]:$SOL_ZOKSEI[19]:$SOL_MOVE[19]:$SOL_AT[19]:$SOL_TEC[19]:$SOL_LANK[19]:金 $SOL_PRICE[19]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=19>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[20])&&($kclass > $SOL_LANK[20])){
print <<"EOM";

$SOL_TYPE[20]:$SOL_ATUP[20]:$SOL_DFUP[20]:$SOL_ZOKSEI[20]:$SOL_MOVE[20]:$SOL_AT[20]:$SOL_TEC[20]:$SOL_LANK[20]:金 $SOL_PRICE[20]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=20>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[63])&&($kclass > $SOL_LANK[63])){
print <<"EOM";

$SOL_TYPE[63]:$SOL_ATUP[63]:$SOL_DFUP[63]:$SOL_ZOKSEI[63]:$SOL_MOVE[63]:$SOL_AT[63]:$SOL_TEC[63]:$SOL_LANK[63]:金 $SOL_PRICE[63]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=63>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[21])&&($kclass > $SOL_LANK[21])){
print <<"EOM";

$SOL_TYPE[21]:$SOL_ATUP[21]:$SOL_DFUP[21]:$SOL_ZOKSEI[21]:$SOL_MOVE[21]:$SOL_AT[21]:$SOL_TEC[21]:$SOL_LANK[21]:金 $SOL_PRICE[21]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=21>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[24])&&($kclass > $SOL_LANK[24])){
print <<"EOM";

$SOL_TYPE[24]:$SOL_ATUP[24]:$SOL_DFUP[24]:$SOL_ZOKSEI[24]:$SOL_MOVE[24]:$SOL_AT[24]:$SOL_TEC[24]:$SOL_LANK[24]:金 $SOL_PRICE[24]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=24>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[11])&&($kclass > $SOL_LANK[11])){
print <<"EOM";

$SOL_TYPE[11]:$SOL_ATUP[11]:$SOL_DFUP[11]:$SOL_ZOKSEI[11]:$SOL_MOVE[11]:$SOL_AT[11]:$SOL_TEC[11]:$SOL_LANK[11]:金 $SOL_PRICE[11]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=11>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[30])&&($kclass > $SOL_LANK[30])){
print <<"EOM";

$SOL_TYPE[30]:$SOL_ATUP[30]:$SOL_DFUP[30]:$SOL_ZOKSEI[30]:$SOL_MOVE[30]:$SOL_AT[30]:$SOL_TEC[30]:$SOL_LANK[30]:金 $SOL_PRICE[30]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=30>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[23])&&($kclass > $SOL_LANK[23])){
print <<"EOM";

$SOL_TYPE[23]:$SOL_ATUP[23]:$SOL_DFUP[23]:$SOL_ZOKSEI[23]:$SOL_MOVE[23]:$SOL_AT[23]:$SOL_TEC[23]:$SOL_LANK[23]:金 $SOL_PRICE[23]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=23>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[64])&&($kclass > $SOL_LANK[64])){
print <<"EOM";

$SOL_TYPE[64]:$SOL_ATUP[64]:$SOL_DFUP[64]:$SOL_ZOKSEI[64]:$SOL_MOVE[64]:$SOL_AT[64]:$SOL_TEC[64]:$SOL_LANK[64]:金 $SOL_PRICE[64]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=64>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[57])&&($kclass > $SOL_LANK[57])){
print <<"EOM";

$SOL_TYPE[57]:$SOL_ATUP[57]:$SOL_DFUP[57]:$SOL_ZOKSEI[57]:$SOL_MOVE[57]:$SOL_AT[57]:$SOL_TEC[57]:$SOL_LANK[57]:金 $SOL_PRICE[57]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=57>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
print "<br><a name=bunkan></a>■文官■<br>";
if(($zsub1 >= $SOL_TEC[5])&&($kclass >= $SOL_LANK[5])){
print <<"EOM";

$SOL_TYPE[5]:$SOL_ATUP[5]:$SOL_DFUP[5]:$SOL_ZOKSEI[5]:$SOL_MOVE[5]:$SOL_AT[5]:$SOL_TEC[5]:$SOL_LANK[5]:金 $SOL_PRICE[5]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=5>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[45])&&($kclass > $SOL_LANK[45])){
print <<"EOM";

$SOL_TYPE[45]:$SOL_ATUP[45]:$SOL_DFUP[45]:$SOL_ZOKSEI[45]:$SOL_MOVE[45]:$SOL_AT[45]:$SOL_TEC[45]:$SOL_LANK[45]:金 $SOL_PRICE[45]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=45>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[34])&&($kclass > $SOL_LANK[34])){
print <<"EOM";

$SOL_TYPE[34]:$SOL_ATUP[34]:$SOL_DFUP[34]:$SOL_ZOKSEI[34]:$SOL_MOVE[34]:$SOL_AT[34]:$SOL_TEC[34]:$SOL_LANK[34]:金 $SOL_PRICE[34]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=34>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[35])&&($kclass > $SOL_LANK[35])){
print <<"EOM";

$SOL_TYPE[35]:$SOL_ATUP[35]:$SOL_DFUP[35]:$SOL_ZOKSEI[35]:$SOL_MOVE[35]:$SOL_AT[35]:$SOL_TEC[35]:$SOL_LANK[35]:金 $SOL_PRICE[35]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=35>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[65])&&($kclass > $SOL_LANK[65])){
print <<"EOM";

$SOL_TYPE[65]:$SOL_ATUP[65]:$SOL_DFUP[65]:$SOL_ZOKSEI[65]:$SOL_MOVE[65]:$SOL_AT[65]:$SOL_TEC[65]:$SOL_LANK[65]:金 $SOL_PRICE[65]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=65>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[7])&&($kclass > $SOL_LANK[7])){
print <<"EOM";

$SOL_TYPE[7]:$SOL_ATUP[7]:$SOL_DFUP[7]:$SOL_ZOKSEI[7]:$SOL_MOVE[7]:$SOL_AT[7]:$SOL_TEC[7]:$SOL_LANK[7]:金 $SOL_PRICE[7]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=7>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[9])&&($kclass > $SOL_LANK[9])){
print <<"EOM";

$SOL_TYPE[9]:$SOL_ATUP[9]:$SOL_DFUP[9]:$SOL_ZOKSEI[9]:$SOL_MOVE[9]:$SOL_AT[9]:$SOL_TEC[9]:$SOL_LANK[9]:金 $SOL_PRICE[9]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=9>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[37])&&($kclass > $SOL_LANK[37])){
print <<"EOM";

$SOL_TYPE[37]:$SOL_ATUP[37]:$SOL_DFUP[37]:$SOL_ZOKSEI[37]:$SOL_MOVE[37]:$SOL_AT[37]:$SOL_TEC[37]:$SOL_LANK[37]:金 $SOL_PRICE[37]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=37>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[67])&&($kclass > $SOL_LANK[67])){
print <<"EOM";

$SOL_TYPE[67]:$SOL_ATUP[67]:$SOL_DFUP[67]:$SOL_ZOKSEI[67]:$SOL_MOVE[67]:$SOL_AT[67]:$SOL_TEC[67]:$SOL_LANK[67]:金 $SOL_PRICE[67]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=67>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[32])&&($kclass > $SOL_LANK[32])){
print <<"EOM";

$SOL_TYPE[32]:$SOL_ATUP[32]:$SOL_DFUP[32]:$SOL_ZOKSEI[32]:$SOL_MOVE[32]:$SOL_AT[32]:$SOL_TEC[32]:$SOL_LANK[32]:金 $SOL_PRICE[32]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=32>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[33])&&($kclass > $SOL_LANK[33])){
print <<"EOM";

$SOL_TYPE[33]:$SOL_ATUP[33]:$SOL_DFUP[33]:$SOL_ZOKSEI[33]:$SOL_MOVE[33]:$SOL_AT[33]:$SOL_TEC[33]:$SOL_LANK[33]:金 $SOL_PRICE[33]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=33>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[36])&&($kclass > $SOL_LANK[36])){
print <<"EOM";

$SOL_TYPE[36]:$SOL_ATUP[36]:$SOL_DFUP[36]:$SOL_ZOKSEI[36]:$SOL_MOVE[36]:$SOL_AT[36]:$SOL_TEC[36]:$SOL_LANK[36]:金 $SOL_PRICE[36]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=36>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[10])&&($kclass > $SOL_LANK[10])){
print <<"EOM";

$SOL_TYPE[10]:$SOL_ATUP[10]:$SOL_DFUP[10]:$SOL_ZOKSEI[10]:$SOL_MOVE[10]:$SOL_AT[10]:$SOL_TEC[10]:$SOL_LANK[10]:金 $SOL_PRICE[10]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=10>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[66])&&($kclass > $SOL_LANK[66])){
print <<"EOM";

$SOL_TYPE[66]:$SOL_ATUP[66]:$SOL_DFUP[66]:$SOL_ZOKSEI[66]:$SOL_MOVE[66]:$SOL_AT[66]:$SOL_TEC[66]:$SOL_LANK[66]:金 $SOL_PRICE[66]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=66>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[68])&&($kclass > $SOL_LANK[68])){
print <<"EOM";

$SOL_TYPE[68]:$SOL_ATUP[68]:$SOL_DFUP[68]:$SOL_ZOKSEI[68]:$SOL_MOVE[68]:$SOL_AT[68]:$SOL_TEC[68]:$SOL_LANK[68]:金 $SOL_PRICE[68]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=68>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[28])&&($kclass > $SOL_LANK[28])){
print <<"EOM";

$SOL_TYPE[28]:$SOL_ATUP[28]:$SOL_DFUP[28]:$SOL_ZOKSEI[28]:$SOL_MOVE[28]:$SOL_AT[28]:$SOL_TEC[28]:$SOL_LANK[28]:金 $SOL_PRICE[28]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=28>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[29])&&($kclass > $SOL_LANK[29])){
print <<"EOM";

$SOL_TYPE[29]:$SOL_ATUP[29]:$SOL_DFUP[29]:$SOL_ZOKSEI[29]:$SOL_MOVE[29]:$SOL_AT[29]:$SOL_TEC[29]:$SOL_LANK[29]:金 $SOL_PRICE[29]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=29>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
print "<br><a name=jinkan></a>■仁官■<br>";
if(($zsub1 >= $SOL_TEC[40])&&($kclass >= $SOL_LANK[40])){
print <<"EOM";

$SOL_TYPE[40]:$SOL_ATUP[40]:$SOL_DFUP[40]:$SOL_ZOKSEI[40]:$SOL_MOVE[40]:$SOL_AT[40]:$SOL_TEC[40]:$SOL_LANK[40]:金 $SOL_PRICE[40]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=40>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[25])&&($kclass > $SOL_LANK[25])){
print <<"EOM";

$SOL_TYPE[25]:$SOL_ATUP[25]:$SOL_DFUP[25]:$SOL_ZOKSEI[25]:$SOL_MOVE[25]:$SOL_AT[25]:$SOL_TEC[25]:$SOL_LANK[25]:金 $SOL_PRICE[25]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=25>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[71])&&($kclass > $SOL_LANK[71])){
print <<"EOM";

$SOL_TYPE[71]:$SOL_ATUP[71]:$SOL_DFUP[71]:$SOL_ZOKSEI[71]:$SOL_MOVE[71]:$SOL_AT[71]:$SOL_TEC[71]:$SOL_LANK[71]:金 $SOL_PRICE[71]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=71>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[26])&&($kclass > $SOL_LANK[26])){
print <<"EOM";

$SOL_TYPE[26]:$SOL_ATUP[26]:$SOL_DFUP[26]:$SOL_ZOKSEI[26]:$SOL_MOVE[26]:$SOL_AT[26]:$SOL_TEC[26]:$SOL_LANK[26]:金 $SOL_PRICE[26]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=26>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[27])&&($kclass > $SOL_LANK[27])){
print <<"EOM";

$SOL_TYPE[27]:$SOL_ATUP[27]:$SOL_DFUP[27]:$SOL_ZOKSEI[27]:$SOL_MOVE[27]:$SOL_AT[27]:$SOL_TEC[27]:$SOL_LANK[27]:金 $SOL_PRICE[27]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=27>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[69])&&($kclass > $SOL_LANK[69])){
print <<"EOM";

$SOL_TYPE[69]:$SOL_ATUP[69]:$SOL_DFUP[69]:$SOL_ZOKSEI[69]:$SOL_MOVE[69]:$SOL_AT[69]:$SOL_TEC[69]:$SOL_LANK[69]:金 $SOL_PRICE[69]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=69>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[39])&&($kclass > $SOL_LANK[39])){
print <<"EOM";

$SOL_TYPE[39]:$SOL_ATUP[39]:$SOL_DFUP[39]:$SOL_ZOKSEI[39]:$SOL_MOVE[39]:$SOL_AT[39]:$SOL_TEC[39]:$SOL_LANK[39]:金 $SOL_PRICE[39]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=39>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[42])&&($kclass > $SOL_LANK[42])){
print <<"EOM";

$SOL_TYPE[42]:$SOL_ATUP[42]:$SOL_DFUP[42]:$SOL_ZOKSEI[42]:$SOL_MOVE[42]:$SOL_AT[42]:$SOL_TEC[42]:$SOL_LANK[42]:金 $SOL_PRICE[42]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=42>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[44])&&($kclass > $SOL_LANK[44])){
print <<"EOM";

$SOL_TYPE[44]:$SOL_ATUP[44]:$SOL_DFUP[44]:$SOL_ZOKSEI[44]:$SOL_MOVE[44]:$SOL_AT[44]:$SOL_TEC[44]:$SOL_LANK[44]:金 $SOL_PRICE[44]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=44>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[38])&&($kclass > $SOL_LANK[38])){
print <<"EOM";

$SOL_TYPE[38]:$SOL_ATUP[38]:$SOL_DFUP[38]:$SOL_ZOKSEI[38]:$SOL_MOVE[38]:$SOL_AT[38]:$SOL_TEC[38]:$SOL_LANK[38]:金 $SOL_PRICE[38]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=38>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[72])&&($kclass > $SOL_LANK[72])){
print <<"EOM";

$SOL_TYPE[72]:$SOL_ATUP[72]:$SOL_DFUP[72]:$SOL_ZOKSEI[72]:$SOL_MOVE[72]:$SOL_AT[72]:$SOL_TEC[72]:$SOL_LANK[72]:金 $SOL_PRICE[72]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=72>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[41])&&($kclass > $SOL_LANK[41])){
print <<"EOM";

$SOL_TYPE[41]:$SOL_ATUP[41]:$SOL_DFUP[41]:$SOL_ZOKSEI[41]:$SOL_MOVE[41]:$SOL_AT[41]:$SOL_TEC[41]:$SOL_LANK[41]:金 $SOL_PRICE[41]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=41>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[43])&&($kclass > $SOL_LANK[43])){
print <<"EOM";

$SOL_TYPE[43]:$SOL_ATUP[43]:$SOL_DFUP[43]:$SOL_ZOKSEI[43]:$SOL_MOVE[43]:$SOL_AT[43]:$SOL_TEC[43]:$SOL_LANK[43]:金 $SOL_PRICE[43]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=43>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[70])&&($kclass > $SOL_LANK[70])){
print <<"EOM";

$SOL_TYPE[70]:$SOL_ATUP[70]:$SOL_DFUP[70]:$SOL_ZOKSEI[70]:$SOL_MOVE[70]:$SOL_AT[70]:$SOL_TEC[70]:$SOL_LANK[70]:金 $SOL_PRICE[70]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=70>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[51])&&($kclass > $SOL_LANK[51])){
print <<"EOM";

$SOL_TYPE[51]:$SOL_ATUP[51]:$SOL_DFUP[51]:$SOL_ZOKSEI[51]:$SOL_MOVE[51]:$SOL_AT[51]:$SOL_TEC[51]:$SOL_LANK[51]:金 $SOL_PRICE[51]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=51>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[52])&&($kclass > $SOL_LANK[52])){
print <<"EOM";

$SOL_TYPE[52]:$SOL_ATUP[52]:$SOL_DFUP[52]:$SOL_ZOKSEI[52]:$SOL_MOVE[52]:$SOL_AT[52]:$SOL_TEC[52]:$SOL_LANK[52]:金 $SOL_PRICE[52]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=52>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[53])&&($kclass > $SOL_LANK[53])){
print <<"EOM";

$SOL_TYPE[53]:$SOL_ATUP[53]:$SOL_DFUP[53]:$SOL_ZOKSEI[53]:$SOL_MOVE[53]:$SOL_AT[53]:$SOL_TEC[53]:$SOL_LANK[53]:金 $SOL_PRICE[53]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=53>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[54])&&($kclass > $SOL_LANK[54])){
print <<"EOM";

$SOL_TYPE[54]:$SOL_ATUP[54]:$SOL_DFUP[54]:$SOL_ZOKSEI[54]:$SOL_MOVE[54]:$SOL_AT[54]:$SOL_TEC[54]:$SOL_LANK[54]:金 $SOL_PRICE[54]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=54>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[55])&&($kclass > $SOL_LANK[55])){
print <<"EOM";

$SOL_TYPE[55]:$SOL_ATUP[55]:$SOL_DFUP[55]:$SOL_ZOKSEI[55]:$SOL_MOVE[55]:$SOL_AT[55]:$SOL_TEC[55]:$SOL_LANK[55]:金 $SOL_PRICE[55]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=55>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
if(($zsub1 > $SOL_TEC[56])&&($kclass > $SOL_LANK[56])){
print <<"EOM";

$SOL_TYPE[56]:$SOL_ATUP[56]:$SOL_DFUP[56]:$SOL_ZOKSEI[56]:$SOL_MOVE[56]:$SOL_AT[56]:$SOL_TEC[56]:$SOL_LANK[56]:金 $SOL_PRICE[56]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=56>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}
print "<br><a name=tokusyu></a>■特殊■<br>";
if(($zsub1 >= $SOL_TEC[46])&&($kclass >= $SOL_LANK[46])){
print <<"EOM";

$SOL_TYPE[46]:$SOL_ATUP[46]:$SOL_DFUP[46]:$SOL_ZOKSEI[46]:$SOL_MOVE[46]:$SOL_AT[46]:$SOL_TEC[46]:$SOL_LANK[46]:金 $SOL_PRICE[46]<form action="$COMMAND" method="POST">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<input type=text name=num value=$get_sol size=4>人
$no_list
<input type=hidden name=type value=46>
<input type=hidden name=mode value=$GET_SOL2>
<input type=submit value=\"雇う\"></form>

EOM
}

print <<"EOM";
	$r
<BR>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

EOM
	}
	&FOOTER;

	exit;

}
1;
