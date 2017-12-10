#_/_/_/_/_/_/_/_/_/#
#      メッセージ      #
#_/_/_/_/_/_/_/_/_/#

sub KING_COM6 {

	if($in{"sei"} eq "死ね" || $in{"sei"} eq ""){&ERR("声明が入力されてないみたいです。");}
	elsif(length($in{'sei'}) > 240) { &ERR("声明は80文字以内にして下さい"); }
	$mee = $in{'sei'};
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}

	if($xking eq "$kid"){
		$rank_mes = "君主";
	}elsif($xgunshi eq "$kid"){
		$rank_mes = "軍師";
	}elsif($xxsub1 eq "$kid"){
		$rank_mes = "宰相";
	}elsif($xdai eq "$kid"){
		$rank_mes = "大将軍";
	}elsif($xuma eq "$kid"){
		$rank_mes = "騎馬将軍";
	}elsif($xgoei eq "$kid"){
		$rank_mes = "護衛将軍";
	}elsif($xyumi eq "$kid"){
		$rank_mes = "弓将軍";
	}elsif($xhei eq "$kid"){
		$rank_mes = "将軍";
	}

	$seimei = $mee;
	&MAP_LOG("<font color=#008080><b>【声明】</b></font>$seimei（$cou_name[$kcon]$rank_mes：$knameより）");
	&MAP_LOG2("<font color=#008080><b>【声明】</b></font>$seimei（$cou_name[$kcon]$rank_mes：$knameより）");


	$res_mes = "声明を出しました。";

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$res_mes</h2><p>
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
