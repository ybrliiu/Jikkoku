#_/_/_/_/_/_/_/_/_/#
#  　装備品名前変更    #
#_/_/_/_/_/_/_/_/_/#

sub BOUNAME {

	&CHARA_MAIN_OPEN;

	if(($karm eq "")&&($kaname eq "")&&($kazoku eq "")&&($kaai eq "")){ &ERR("武器を装備していないので装備品に名前を付けられません。"); }
	elsif((length($in{'bouname'}) > 45)||(length($in{'armname'}) > 45)||(length($in{'proname'}) > 45)) { &ERR("装備品の名前は１５文字以内にして下さい"); }


	$gazou = $in{'bouname'};
	$arm = $in{'armname'};
	$pro = $in{'proname'};
	&COUNTRY_DATA_OPEN($kpos);

	&TIME_DATA;

	$kbname = $gazou;
	$kaname = $arm;
	$ksname = $pro;
	$res_mes = "武器の名前を$armに、防具の名前を$gazouに、書物の名前を$proに設定しました。";

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