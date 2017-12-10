#_/_/_/_/_/_/_/_/_/#
#行動可能時通知設定 #
#_/_/_/_/_/_/_/_/_/#

sub ALERT2 {

	if($in{'sel'} eq "") { &ERR("入力されていません"); }
	if($in{'sel'} =~ m/[^0-9]/){&ERR("数字以外の文字が含まれています。"); }
	if($in{'sel'} < 0 || $in{'sel'} > 3 ) { &ERR("値が不正です。"); }
	if($in{'sound2'} eq "") { &ERR("入力されていません"); }
	if($in{'sound2'} =~ m/[^0-9]/){&ERR("数字以外の文字が含まれています。"); }
	if($in{'sound2'} < 1 || $in{'sound2'} > 7 ) { &ERR("値が不正です。"); }

	$sel = $in{'sel'}+0;
	&CHARA_MAIN_OPEN;

	$ksettei4 = $sel;
	$ksettei5 = $in{'sound2'};
	if($ksettei4==0){
	$mes="通知しない";
	}elsif($ksettei4==1){
	$mes="通知音を鳴らす";
	}elsif($ksettei4==2){
	$mes="アラートを出す";
	}else{
	$mes="通知音とアラートを出す";
	}
	$res_mes = "行動可能になった時の通知設定を$mes（通知音$ksettei5番）に設定しました。";

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
