#_/_/_/_/_/_/_/_/#
#      城の守備      #
#_/_/_/_/_/_/_/_/#

sub TOWN_DEF2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup) = split(/,/,$ksenj);

	&HEADER;
	$no = $in{'no'} + 1;
	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>";
	}
	
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 城の守備 - </font>
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
<font color=white>都市の城付近に部隊を配置します。<br>コマンド実行時に、このコマンドを入力した都市と違う都市にいる場合、<br>コマンド実行時にいる都市の城付近のコマンドを入力した時の座標に部隊を配置します。</font><BR><font color=red>城の守備をする場合は<font color=blue>地形：城</font> の上に部隊を置いて下さい。</font>
<BR><font color=blue>地形：城</font> <font color=red>の上に部隊がないと城壁に攻撃されます。</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="POST">
<BR>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
部隊を配置する場所を選択して下さい<BR><BR>
$no_list

EOM

	#バトルマップ読み込み
	require "./log_file/map_hash/$kpos.pl";
	

	print "<TR><TD width\=50\%><font color\=AA8866><B>\- $battkemapname \-</B></font><TABLE bgcolor\=\"white\" width\=75\% height\=5 border\=\"0\" cellspacing\=1><TBODY><TR><TD width\=20 bgcolor\=$TD_C2>\-</TD>";

	for($i=1;$i<$BM_X+1;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";

	for($i=0;$i<$BM_Y;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3>$n</td>";
		for($j=0;$j<$BM_X;$j++){

			if($BM_TIKEI[$i][$j] ne ""){
				if($BM_TIKEI[$i][$j] == 17){
				($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
				$SEKISYO[$i][$j] = "<font color=white>$ikisaki2</font>";
				}elsif($BM_TIKEI[$i][$j] == 18 || $BM_TIKEI[$i][$j] == 22){
				$jyouheki[18] = "<br><font color=white>$zname<br>城壁:$zshiro</font>";
				$jyouheki[22] = "<br><font color=white>$zname<br>城壁:$zshiro</font>";
				}
				print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]]><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]</font>$jyouheki[$BM_TIKEI[$i][$j]]$SEKISYO[$i][$j]<br><input type=radio name=zahyou value=$j\,$i></TH>";
			}else{
				print "<TH bgcolor=$BMCOL[0]>&nbsp;</TH>";
			}
		}
		print "</TR>";
	}

print <<"EOM";
</TBODY></TABLE></TD></TR>
</TBODY></TABLE>
</TD></TR>
<input type=hidden name=mode value=12>
<input type=submit value=\"部隊配置\"></form>
</TD></TR></TABLE>
</TD></TR></TABLE>

<TD><TR><TABLE>
<TD><TR><TABLE>
<BR>
<BR>
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
