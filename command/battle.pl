#_/_/_/_/_/_/_/_/#
#      戦争      #
#_/_/_/_/_/_/_/_/#

sub BATTLE {

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

	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 戦 争 - </font>
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
<font color=white>他国の都市へ向け、バトルマップに出ます。<br>
例えば、AからBに出兵すると　A-B間のマップに出ます。<br>
自分の部隊が配置されるのは自分がいる都市の関所(入)です。<br></font>
<font color=red>※他国と戦争するには、国の幹部の人が司令部から宣戦布告をしないとできません。</font><br>
<font color=red>※兵士０の場合は実行できません。また、既に出撃しているとコマンドは失敗します。</font><br>
<font color=red>※関所の上に部隊を配置すると、敵が通れないため関所の守備にもなります。</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD bgcolor="#FFFFFF">
<form action="$COMMAND" method="POST">
何処へ攻め込みますか？<BR>
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>

EOM

	$i=0;
	foreach(@TOWN_DATA){
		($zxname,$zxcon,$zxnum,$zxnou,$zxsyo)=split(/<>/);
		$i++;
	}

	foreach(@z){
		if("$_" ne ""){
			$t_mes .= "<input type=radio name=num value=$_>$town_name[$_]<BR>";
		}
	}
print <<"EOM";

<BR>$znameから出兵\可\能\な街<BR>
$t_mes

$no_list

</TD></TR>
<TR><TD width=80% bgcolor="#FFFFFF">
<TABLE bgcolor=990000 width=90% height=5 border="0" cellspacing=1><TBODY>
<TR><TH colspan= 11 bgcolor=990000><font color=FFFFFF>$new_date</TH></TR>
          <TR>
            <TD width=\"10\" bgcolor=$TD_C2>-</TD>
EOM
    for($i=1;$i<11;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<10;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3 width=\"10\">$n</td>";
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

					print "<TH bgcolor=$col width=\"20\"><font color=\"$white\">$zzname<BR>【$cou_name[$zzcon]】</font><BR><input type=radio name=num value=$zx></TH>";
				}else{
					print "<TH width=\"20\"> </TH>";
				}
		}
		print "</TR>";
	}
print <<"EOM";
<input type=hidden name=mode value=18>
<input type=submit value=\"攻め込む\"></form>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

</TBODY></TABLE>
</TD></TR>
</TD></TR></TABLE>
</TD></TR></TABLE>

<TD><TR><TABLE>

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
