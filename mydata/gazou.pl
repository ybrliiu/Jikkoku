#_/_/_/_/_/_/_/_/_/#
#      画像変更      #
#_/_/_/_/_/_/_/_/_/#

sub GAZOU {

	if($in{'gazou'} eq "") { &ERR("入力されていません"); }
	if ($in{'gazou'} =~ m/[^0-9]/){&ERR("数字以外の文字が含まれています。"); }
	if($in{'gazou'} < 0 || $in{'gazou'} > $CHARA_IMAGE ) { &ERR("0〜$CHARA_IMAGEの間で入力してください。"); }


	$gazou = $in{'gazou'}+0;
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kpos);

	&TIME_DATA;

	$kchara = $gazou;
	$res_mes = "$knameは画像を$gazou番に設定しました。";

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