#_/_/_/_/_/_/_/_/_/_/#
#        指令２      #
#_/_/_/_/_/_/_/_/_/_/#

sub KING_COM2 {

	if($in{'mes'} eq ""){&ERR("指令が入力されていません。");}
	if(length($in{'mes'}) > 3000) { &ERR("手紙は、全角1000文字以下で入力して下さい。"); }
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}

	if($xking eq $kid){
		$add = "君主";
	}elsif($xgunshi eq $kid){
		$add = "軍師";
	}elsif($xxsub1 eq $kid){
		$add = "宰相";
	}

	$xmes = "$in{'mes'}($add:$knameより)";
	&COUNTRY_DATA_INPUT;

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>指令を入力しました。</h2><p>
<form action=\"./mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=KING_COM>
<input type=submit id=input value=\"指令部に戻る\"></form>
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