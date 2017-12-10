#_/_/_/_/_/_/_/_/_/#
#文字サイズ変更 #
#_/_/_/_/_/_/_/_/_/#

sub SIZECHANGE {

	if($in{'size'} eq "") { &ERR("フォームが入力されていません"); }
	if($in{'size'} > 40 || $in{'size'} < 1) { &ERR("文字サイズは40pt以下1pt以上にして下さい"); }

	&CHARA_MAIN_OPEN;

	&TIME_DATA;

	$ksettei = "$in{'size'}\pt";

	$res_mes = "文字サイズを$ksetteiに設定しました。";

	$ksz = "$kindbmm,$ksettei,$ksettei2,$ksettei3,$ksettei4,$ksettei5,";
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
