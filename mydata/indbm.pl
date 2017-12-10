#_/_/_/_/_/_/_/_/_/#
#      BM表示設定      #
#_/_/_/_/_/_/_/_/_/#

sub INDBM {

	if($in{'sel'} eq "") { &ERR("入力されていません"); }
	if ($in{'sel'} =~ m/[^0-9]/){&ERR("数字以外の文字が含まれています。"); }
	if($in{'sel'} < 0 || $in{'sel'} > 3 ) { &ERR("値が不正です。"); }

	$sel = $in{'sel'}+0;
	&CHARA_MAIN_OPEN;

	$kindbmm = $sel;
	if($kindbmm==0){
	$mes="移動しやすいタイプ 表示";
	}elsif($kindbmm==1){
	$mes="移動しやすいタイプ 非表示";
	}elsif($kindbmm==2){
	$mes="通常 表示する";
	}else{
	$mes="通常 表示しない";
	}
	$res_mes = "$knameはマイページでのBM表示設定を$mesに設定しました。";

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
