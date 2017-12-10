#_/_/_/_/_/_/_/_/_/#
#      武器変更      #
#_/_/_/_/_/_/_/_/_/#

sub S_B_H {

	if($in{'buki'} eq "") { &ERR("入力されていません"); }
	if($in{'buki'} =~ m/[^0-9]/){&ERR("数字以外の文字が含まれています。"); }
	if($in{'buki'} < 0 || $in{'buki'} > 1 ) { &ERR("不正な値です。"); }
	if($in{'buki'} eq "0"){&ERR("装備中の武器です。"); }
	if($in{'buki'} eq "1"){

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kpos);
	&TIME_DATA;

	($karm2,$kaname2,$kazoku2,$kaai2,$karmskl2) = split(/,/,$ksub5);

	$karm3 = $karm;
	$kaname3 = "$kaname";
	$kazoku3 = "$kazoku";
	$kaai3 = $kaai;
	$karmskl3 = $khohei;

	$karm = $karm2;
	$kaname = "$kaname2";
	$kazoku = "$kazoku2";
	$kaai = $kaai2;
	$khohei = "$karmskl2";

	$karm2 = $karm3;
	$kaname2 = "$kaname3";
	$kazoku2 = "$kazoku3";
	$kaai2 = $kaai3;
	$karmskl2 = $karmskl3;

	$ksub5 = "$karm2,$kaname2,$kazoku2,$kaai2,$karmskl2,";

	$res_mes = "変更しました。";

	&CHARA_MAIN_INPUT;
	&HEADER;

	if("$ENV{'HTTP_REFERER'}" eq "$KEITAI_SURL"){
	$url = "./i-status.cgi";
	$mmode = "MENT";
	}else{
	$url = "./mydata.cgi";
	$mmode = "MYDATA";
	}

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
}
1;
