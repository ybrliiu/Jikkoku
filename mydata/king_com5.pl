#_/_/_/_/_/_/_/_/_/_/#
#        指令２      #
#_/_/_/_/_/_/_/_/_/_/#

sub KING_COM5 {

	if($in{'mes'} eq ""){&ERR("指令が入力されていません。");}
	if(length($in{'mes'}) > 1000) { &ERR("手紙は、全角500文字以下で入力して下さい。"); }
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	open(IN,"$COUNTRY_MES");
	@C_MES = <IN>;
	close(IN);


	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}

	if($xking eq $kid){
		$add = "君主";
	}elsif($xgunshi eq $kid){
		$add = "軍師";
	}elsif($xxsub1 eq $kid){
		$add = "宰相";
	}

	@NEW_C_MES=();
	foreach(@C_MES){
		($mes,$cno)=split(/<>/);
		if($cno eq $kcon){
			$chit=1;
			push(@NEW_C_MES,"$in{'mes'}($add:$knameより)<>$kcon<>\n");
		}else{
			push(@NEW_C_MES,"$_");
		}
	}

	if(!$chit){
		unshift(@NEW_C_MES,"$in{'mes'}($add:$knameより)<>$kcon<>\n");
	}

	open(OUT,">$COUNTRY_MES");
	print OUT @NEW_C_MES;
	close(OUT);

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>勧誘文を入力しました。</h2><p>
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