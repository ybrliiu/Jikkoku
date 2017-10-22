#_/_/_/_/_/_/_/_/_/_/#
#      陣形再編      #
#_/_/_/_/_/_/_/_/_/_/#

sub SAIHEN {

	$idate = time();

	&CHARA_MAIN_OPEN;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	$ksiki -= $MOR_SAIHEN;
	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif($kskl5 !~ /4/){
		&ERR("陣形再編を修得していません。");
	}elsif($idate >= $ksakup){
		&ERR("既に陣形を整えています。");
	}elsif($ksiki < 0){
		&ERR("士気が足りません。");
	}else{


#戦闘場所地名
require './ini_file/bmmaplist.ini';
$battkemapname = "$TIKEI{$kiti}";

	$ksakup = int($idate+(($ksakup-$idate)*0.25));
	$kkoutime = $idate+int($BMT_REMAKE/2);
	&K_LOG("【陣形再編】陣形を再編しました。");
	&K_LOG2("【陣形再編】陣形を再編しました。");
	&MAP_LOG("<font color=#FF7F50>【陣形再編】</font>$knameは陣形再編を行いました。($battkemapname\)");


	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;

	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>陣形を整えました。</h2><p>
<form action="$BACK" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="OK">
</form>
</CENTER>
EOM
	&FOOTER;

	exit;

}
1;
