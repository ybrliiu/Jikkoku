################
#  臨時軍師機能 #
################

sub KARI_GUNSHI{

	&CHARA_MAIN_OPEN;

	if($kcon eq "" || $kcon eq "0"){
	&ERR("無所属の武将は実行できません");
	}

	&COUNTRY_DATA_OPEN($kcon);

	$no_jyoso = 0;
	open(IN,"./charalog/main/$xking.cgi") || $no_jyoso++;
	@S_DATA = <IN>;
	close(IN);
	($sid,$spass,$sname,$schara,$sstr,$sint,$slea,$scha,$ssol,$sgat,$scon) = split(/<>/,$S_DATA[0]);
	if($sid ne "" && $scon ne $kcon){$no_jyoso++;}
	open(IN,"./charalog/main/$xgunshi.cgi") || $no_jyoso++;
	@S_DATA = <IN>;
	close(IN);
	($sid,$spass,$sname,$schara,$sstr,$sint,$slea,$scha,$ssol,$sgat,$scon) = split(/<>/,$S_DATA[0]);
	if($sid ne "" && $scon ne $kcon){$no_jyoso++;}
	open(IN,"./charalog/main/$xxsub1.cgi") || $no_jyoso++;
	@S_DATA = <IN>;
	close(IN);
	($sid,$spass,$sname,$schara,$sstr,$sint,$slea,$scha,$ssol,$sgat,$scon) = split(/<>/,$S_DATA[0]);
	if($sid ne "" && $scon ne $kcon){$no_jyoso++;}

	if($no_jyoso != 3){
	&ERR("君主、軍師、宰相いずれかの方が健在です。");
	}

	$xgunshi = "$kid";	
	
$xsub = "$xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1,$xxsub2,";	
&COUNTRY_DATA_INPUT;

&HEADER;

print <<"EOM";
<CENTER><hr size=0><h2>臨時で軍師に就任しました。</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
</CENTER>
EOM

&FOOTER;

exit;

}
1;
