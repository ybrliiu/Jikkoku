#_/_/_/_/_/_/_/_/_/#
#     メモ      #
#_/_/_/_/_/_/_/_/_/#

sub MEMO {

	if(length($in{'message'}) > 3000) { &ERR("メモは1000文字以内にして下さい"); }
	$mee = $in{'message'};
	&CHARA_MAIN_OPEN;


#メモ書き込み
	open(IN, "./charalog/memo/$kid.cgi");
	$memo = <IN>;
	close(IN);
	$memo = "$mee";
	open(OUT, "> ./charalog/memo/$kid.cgi");
	print OUT "$memo";
	close(OUT);


	$res_mes = "メモを保存しました。";

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
<input type=hidden name=aaa value=0>
<input type=hidden name=mode value=$mmode>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;

	exit;

}
1;
