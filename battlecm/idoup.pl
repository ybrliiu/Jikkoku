#_/_/_/_/_/_/_/_/_/_/#
#      移動P補充      #
#_/_/_/_/_/_/_/_/_/_/#

sub IDOUP {

	$idate = time();

	&CHARA_MAIN_OPEN;
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($ksol <= 0){
		&ERR("兵士がいません。");
	}elsif($idate < $kbattletime){
		$nokori = $kbattletime-$idate;
		&ERR("あと $nokori秒 移動ポイントは補充できません。");
	}else{

	#移動スキル lib/skl_lib.pl
	&IDOUSKL;
	&IDOUSKL2;

	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;

	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>移動ポイントを補充しました。</h2><p>
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
