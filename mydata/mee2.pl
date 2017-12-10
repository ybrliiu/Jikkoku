#_/_/_/_/_/_/_/_/_/#
#      メッセージ ２    #
#_/_/_/_/_/_/_/_/_/#

sub MEE2 {

	if($in{"mes"} eq "死ね" || $in{"mes"} eq ""){&ERR("そのプロフィールにするのは無理です。");}
	elsif(length($in{'mes'}) > 30000) { &ERR("プロフィールは10000文字以内にして下さい"); }
	$mes = $in{'mes'};
	&CHARA_MAIN_OPEN;

#メモ書き込み
	open(IN, "./charalog/prof/$kid.cgi");
	$memo = <IN>;
	close(IN);
	$memo = "$mes";
	open(OUT, "> ./charalog/prof/$kid.cgi");
	print OUT "$memo";
	close(OUT);
	$res_mes = "プロフィールを更新しました。";

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
