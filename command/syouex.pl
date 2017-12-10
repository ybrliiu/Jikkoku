#_/_/_/_/_/_/_/_/#
#      市場破壊      #
#_/_/_/_/_/_/_/_/#

sub SYOUEX {

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

	$get_sol = $klea - $ksol;
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 市場破壊 - </font>
</TH></TR>
EOM
	if("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/status.cgi"){ 

print <<"EOM";

<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
EOM
	}
print <<"EOM";

<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>敵隣接都市の商業値を減らします。<br><font color="red">このコマンドを実行するにはバトルマップにでていて、更に指定した都市の城付近か、<br>指定した都市とその周囲の都市との間のMAP上にいる必要があります。</font><br>また、雇っている兵士数も下げる商業値に影響します。<br>金200必要です。</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
どの町にしますか
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
EOM

	$i=0;
	foreach(@TOWN_DATA){
		$i++;
	}

	foreach(@z){
		if("$_" ne "" && $town_cou[$_] ne $kcon){
			$t_mes .= "<input type=radio name=num value=$_>$town_name[$_]<BR>";
		}
	}
print <<"EOM";
<BR>$znameから市場破壊が可能な街<BR>
$t_mes
$no_list
<input type=hidden name=mode value=41>

<input type=submit value=\"実行\">
<TR><TD width=75%>
<TABLE width=100%><TR><TD width=75%>
<TABLE bgcolor=FF9999 width=75% height=5 border="0" cellspacing=1><TBODY>
<TR><TH colspan= 11 bgcolor=FF9999><font color=FFFFFF>$new_date</TH></TR>
          <TR>
            <TD width=20 bgcolor=$TD_C2>-</TD>
EOM
    for($i=1;$i<11;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<10;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3>$n</td>";
		for($j=0;$j<10;$j++){
				$m_hit=0;$zx=0;
				foreach(@TOWN_DATA){
					($zzname,$zzcon,$zznum,$zznou,$zzsyo,$zzshiro,$zznou_max,$zzsyo_max,$zzshiro_max,$zzpri,$zzx,$zzy)=split(/<>/);
					if("$zzx" eq "$j" && "$zzy" eq "$i"){$m_hit=1;last;}
					$zx++;
				}
				$col="";
				if($m_hit){
					if($zx eq $kpos){
						$col = $ELE_C[$cou_ele[$zzcon]];
					}else{
						$col = $ELE_BG[$cou_ele[$zzcon]];
					}

				$white = "#000000";
				if($col eq "#000000"){
				$white = "white";
				}

					if($zzname eq "開封" || $zzname eq "金陵" || $zzname eq "成都" || $zzname eq "燕京" ){
						print "<TH bgcolor=$col  width=10><font color=\"$white\">$zzname</font><BR><input type=radio name=num value=$zx></TH>";
					}else{
						print "<TH bgcolor=$col width=10><font color=\"$white\">$zzname</font><BR><input type=radio name=num value=$zx></TH>";
					}
				}else{
					print "<TH> </TH>";
				}
		}
		print "</TR>";
	}
print <<"EOM";
</form></TBODY></TABLE>
</TD></TR>

</TD></TR></TABLE>
</TD></TR></TABLE>

<TD><TR><TABLE>
<TD><TR><TABLE>

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