#_/_/_/_/_/_/_/_/#
#    自動移動ajax#
#_/_/_/_/_/_/_/_/#

sub AUTO_MOVE3 {

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

	if($in{'option'} eq "0"){
	$select = " SELECTED";
	}elsif($in{'option'} eq "1"){
	$select2 = " SELECTED";
	}

	#BM地名一覧
	require "./ini_file/bmmaplist.ini";

	$no = $in{'no'} + 1;
	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>";
	}

	print <<"EOM";



<TABLE border=0 width=100% height=100%>
<TR><TD bgcolor="#FFFFFF" id="result">
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
<form action="./auto_in.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form>

EOM

	exit;

}
1;
