#_/_/_/_/_/_/_/_/#
#    自動移動    #
#_/_/_/_/_/_/_/_/#

sub AUTO_MOVE {

	use Encode;

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if ($in{'opt1'} eq "" || $in{'opt1'} =~ m/[^0-9]/ || $in{'opt1'} > 1) { &ERR("オプション1の値が異常です。"); }
	if ($in{'opt2'} eq "" || $in{'opt2'} =~ m/[^0-9]/ || $in{'opt2'} > 1) { &ERR("オプション2の値が異常です。"); }
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	if($in{'start'} eq ""){
		if($kiti !~ /-/){
		$in{'start'} = "$kpos";
		}else{
		$in{'start'} = "$kiti";
		}
	}

	#BM地名一覧
	require "./ini_file/bmmaplist.ini";

	&HEADER;
	$no = $in{'no'} + 1;
	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>";
	}

	print <<"EOM";

	<script type="text/javascript">
	function sendData() {

		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			var result = document.getElementById('result');
			if(xhr.readyState == 4 && xhr.status == 200){
			result.innerHTML = xhr.responseText;
			}else{
			result.innerHTML = "移動可能な都市を読み込み中...";
			}
		}
;
		var s_param = 'id=' + document.move.id.value;
                s_param += '&pass=' + document.move.pass.value;
                s_param += '&no=' + document.move.no.value;
                s_param += '&start=' + document.move.start.value;
                s_param += '&opt1=' + document.move.opt1.value;
                s_param += '&opt2=' + document.move.opt2.value;
                s_param += '&mode=' + 10;
	
		xhr.open('POST','auto_com.cgi',true);
		xhr.setRequestHeader('content-type','application/x-www-form-urlencoded;charset=UTF-8');
		xhr.send(s_param);
	}
	</script>

<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 自動移動 - </font>
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
<font color=white>出発都市に指定された都市から、目標都市に指定された<strong>隣接都市</strong>まで、自動でBM上を移動します。<br>
<br>
<strong>【注意事項】</strong><br>
・隣接都市までしか移動しません。隣接していない都市に移動したい場合は、2つ分コマンドを入れて対応してください。<br>
例)敦煌から成都に行きたい場合は、no:1に敦煌から鳳翔へ移動を入力、no:2に鳳翔から成都へ移動を入力<br>
・自動移動する際のルートは決まっています。<strong>そのルート上にいなければ、自動移動はしません。</strong><br>
・自動移動する際のルートは、出発都市の地形:城及びその周囲から目標都市の地形:城まで(目標都市が他国都市の場合、その手前まで)です。<br>
・ルートは毒をできるだけ避けて通る、最短距離です。<br>
・自動移動する際のルートを見たい場合は<a href="./auto_com.cgi?id=$kid&pass=$kpass&mode=11" target="_blank">こちら</a><br>
・ルート上に敵の武将がいた場合、戦闘するか何もしないか前の画面で設定できます。<br>
・自動移動の最短実行時間は20秒です。ですので騎兵など移動Pの多い兵種は自動移動の際は十分に力を発揮できない可能性があります。<br>
・また、デバッグする必要がある量が非常に多すぎてちゃんとデバッグできていないので、バグがある可能性もあります。申し訳ないですが、ご理解ください。</font><br>
</TD></TR></TABLE>
</TD></TR>
<TABLE id="result" style="width:100%;">
<TR><TD bgcolor="#FFFFFF">
<form action="./auto_com.cgi" method="POST" name="move">
出発する都市を選んでください。<BR>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=opt1 value=$in{'opt1'}>
<input type=hidden name=opt2 value=$in{'opt2'}>

<select name="start" onChange="sendData();">
EOM
	foreach my $key (sort keys(%TIKEI)) {
	    if($TIKEI{$key} =~ /の城付近/){
	    $TIKEI{$key} =~ s/の城付近//g;
		if($in{'start'} eq "$key"){
	        print "<option value=\"$key\" SELECTED>出発都市:$TIKEI{$key}";
		}else{
	        print "<option value=\"$key\">出発都市:$TIKEI{$key}";
		}
	    }
	}
print <<"EOM";
</select>

<BR>移動先の都市を選んでください。(隣接している都市のみ可)<BR>
<select name="target">
EOM

$dir="./log_file/map_road";
opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		$file =~ s/.pl//g;
		($toshi1,$toshi2) = split(/-/,$file);
		if($toshi1 eq $in{'start'}){
	        print "<option value=\"$toshi2\">目標都市:$town_name[$toshi2]";
		}
	}
closedir(dirlist);

print <<"EOM";
</select>

<br>
<br>

$no_list

<input type=hidden name=mode value=9>
<input type=submit value=\"決定\"></form>

</TD></TR>
<TR><TD style="width:100%;">
<TABLE style="width:80%;background-color:#990000;border:0;" cellspacing=1><TBODY>
          <TR>
            <TD style="width:5px;background-color:$TD_C2;">-</TD>
EOM
    for($i=1;$i<11;$i++){
		print "<TD style=\"width:5px;background-color:$TD_C1;\">$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<11;$i++){
		$n = $i+1;
		print "<TR><TD style=\"width:5px;background-color:$TD_C3;\">$n</td>";
		for($j=0;$j<10;$j++){
				$m_hit=0;$zx=0;
				foreach(@TOWN_DATA){
					($zzname,$zzcon,$zznum,$zznou,$zzsyo,$zzshiro,$zznou_max,$zzsyo_max,$zzshiro_max,$zzpri,$zzx,$zzy)=split(/<>/);
					if("$zzx" eq "$j" && "$zzy" eq "$i"){$m_hit=1;last;}
					$zx++;
				}
				$col="";
				if($m_hit){
					if($zx eq $in{'start'}){
						$col = $ELE_C[$cou_ele[$zzcon]];
					}else{
						$col = $ELE_BG[$cou_ele[$zzcon]];
					}

				$white = "#000000";
				if($col eq "#000000"){
				$white = "white";
				}

					$word = "$cou_name[$zzcon]";
					if(length(Encode::decode_utf8($word)) > 3){
					$word = Encode::encode_utf8(substr(Encode::decode_utf8($word),0,3));
					$word = "【$word..】";
					}else{
					$word = "【$word】";
					}
					print "<TH style=\"background-color:$col;width:20px\"><span id=\"tooltip\"><span>$zzname【$cou_name[$zzcon]】</span><p style=\"display:inline;color:$white;\">$zzname</p><br>$word</span></TH>";
				}else{
					print "<TH style=\"width:20px;\"> </TH>";
				}
		}
		print "</TR>";
	}
print <<"EOM";
<form action="auto_in.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

</TBODY></TABLE>
</TD></TR>
</TABLE>
</TD></TR></TABLE>
</TD></TR></TABLE>

<TD><TR><TABLE>

<form action="auto_in.cgi" method="post">
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
