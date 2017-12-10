#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       会議室書き込み     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub LETTER{

	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	&HOST_NAME;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");

	#部隊
	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);
	$uhit=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$uid" eq "$kid"){$uhit=1;last;}
	}
	if(!$uhit){
		$unit_id="";
		$uunit_name="無所属";
	}

	$dilect_mes = "";$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon,$hunit) = split(/<>/);
		if($MES_MAN < $i && $MES_ALL < $h && $MES_COU < $j && $MES_UNI < $k) { last; }
		if(111 eq "$pid" && $kpos eq $hpos){
			if($MES_ALL < $h ) { next; }
			$all_mes .= "<br><br><b><a href=\"./menu.cgi?id=$hid&send=2\">$hname</a>\@$town_name[$hpos]から</b><BR>「<b>$hmessage</b>」<BR>$htime\n";
			$h++;
		}elsif($kcon eq "$pid"){
			if($MES_COU < $j ) { next; }
			$cou_mes .= "<br><br><font color=FFCC33><b>	<a href=\"./menu.cgi?id=$hid&send=2\">$hname</a>\@$town_name[$hpos]から$pnameへ</b></font><BR>  「<b>$hmessage</b>」<BR>$htime";
			$j++;
		}elsif($kid eq "$pid"){
			if($MES_MAN < $i ) { next; }
			$add_mes = "<br><br><b><font color=orange><a href=\"./menu.cgi?id=$hid&send=2\">$hname</a>\@$town_name[$hpos]</font>から$pnameへ</b> <BR>";
			$man_mes .= "$add_mes「<b>$hmessage</b>」<BR>$htime\n";
			$dilect_mes .= "<br><option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif(333 eq "$pid" && "$hunit" eq "$unit_id" && "$hcon" eq "$kcon"){
			if($MES_UNI < $k ) { next; }
			$unit_mes .= "<br><br><font color=orange><b><a href=\"./menu.cgi?id=$hid&send=2\">$hname</a>\@$town_name[$hpos]から$pnameへ</b></font><BR>  「<b>$hmessage</b>」<BR>$htime";
			$k++;
		}elsif($kid eq "$hid"){
			if($MES_MAN < $i ) { next; }
			$man_mes .= "<br><br><font color=skyblue><b>$knameから$pnameへ</b></font><BR>  「<b>$hmessage</b>」<BR>$htime";
			$i++;
		}
	}
	close(IN);

	$m_hit=0;$i=1;$h=1;$j=1;$k=1;
	open(IN,"$MESSAGE_LIST2") or &ERR('ファイルを開けませんでした。');
	while (<IN>){
		my ($pid,$hid,$hpos,$hname,$hmessage,$pname,$htime,$hchara,$hcon) = split(/<>/);
		if($MES_MAN < $i) { last; }
		if($kid eq "$pid"){
			$add_mes="";
			$add_sel="";
			$add_form1="";
			$add_form2="";
			if($htime eq "9999"){
			$add_mes = "<br><br><B><font color=skyblue><a href=\"./menu.cgi?id=$hid&send=2\">$hname</a>が$cou_name[$hcon]国への仕官を勧めています。</font><BR>$htime</B>";
			$add_sel = "<BR><input type=radio name=sel value=1>承諾する<input type=radio name=sel value=0>断る<input type=submit value=\"返事\">";
			$add_form1="<form action=\"./mydata.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=hcon value=$hcon><input type=hidden name=hid value=$hid><input type=hidden name=hpos value=$hpos><input type=hidden name=mode value=COU_CHANGE>";
			$add_form2="</form>";
			}else{
			$add_mes = "<br><br><B><font color=skyblue><a href=\"./menu.cgi?id=$hid&send=2\">$hname</a>から$pnameへ</font><BR></B>";
			}
			$man_mes2 .= "$add_form1$add_mes「<b>$hmessage</b>」$add_sel<BR>$htime$add_form2\n";
			$dilect_mes .= "<option value=\"$hid\">$hnameさんへ";
			$i++;
		}elsif($kid eq "$hid"){
			$man_mes2 .= "<br><br><font color=skyblue><b>$knameさんから$pnameへ</b></font><BR><font >  「<b>$hmessage</b>」</font>";
			$i++;
		}
	}
	close(IN);

	if($xking eq $kid || $xgunshi eq $kid || $xxsub1 eq $kid){
		foreach(@COU_DATA){
			($xvcid,$xvname)=split(/<>/);
			$dilect_mes .= "<option value=\"$xvcid\">$xvnameへ";
		}
	}

	&HEADER;
	print <<"EOM";

$S_MES
<form action=\"./i-command.cgi\" method="post">
手紙：<textarea name=message cols=60 rows=2>
</textarea>
 <select name=mes_id><option value="$xcid">$xname国へ<option value="111">$znameの人へ<option value="333">$uunit_name部隊の人へ$dilect_mes</select>
 <input type=hidden name=id value=$kid>
 <input type=hidden name=name value=$kname>
 <input type=hidden name=pass value=$kpass>
 <input type=hidden name=mode value=IMES_SEND>
 <input type=submit value="送信"></form>
<hr>
<a href="#kuni">国宛</a>｜<a href="#man">個宛</a>｜<a href="#unit">部隊宛</a>｜<a href="#tosi">都市宛</a>｜<a href="#touyou">密書(登用)</a>
<a name="kuni"></a>
<hr>
	$xname国宛て:($MES_COU件)
	$cou_mes
<a name="man"></a>
<hr>
	$kname宛て:($MES_MAN件)
	$man_mes
<a name="unit"></a>
<hr>
	$uunit_name部隊宛て:($MES_UNI件)
	$unit_mes
<a name="tosi"></a>
<hr>
	$znameの人々へ:($MES_ALL件)
	$all_mes
<a name="touyou"></a>
<hr>
	$kname宛て密書:($MES_MAN件)
	$man_mes2


<form action=\"i-status.cgi\" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=STATUS>
<input type=hidden name=pass value=$kpass>
<input type=submit value="街へ戻る"></form></CENTER>
EOM
	&FOOTER;
	exit;
	
}
1;
