#_/_/_/_/_/_/_/_/_/#
#      メッセージ      #
#_/_/_/_/_/_/_/_/_/#

sub MEE {

	if($in{"mee"} eq "死ね" || $in{"mee"} eq ""){&ERR("そのメッセージにするのは無理です。");}
	elsif(length($in{'mee'}) > 90) { &ERR("メッセージは３０文字以内にして下さい"); }
	$mee = $in{'mee'};
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kpos);

	&TIME_DATA;

	$kcm = "$mee";
	$res_mes = "$knameはメッセージを$meeに設定しました。";

	&CHARA_MAIN_INPUT;

	if("$ENV{'HTTP_REFERER'}" eq "$KEITAI_SURL"){
	$url = "./i-status.cgi";
	$mmode = "MENT";
	}else{
	$url = "./mydata.cgi";
	$mmode = "MYDATA";
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$res_mes</h2><p>
<form action="$url" method="post"><input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=$mmode>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;

	exit;

}
1;
