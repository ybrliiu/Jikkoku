#_/_/_/_/_/_/_/_/_/_/#
#      退却      #
#_/_/_/_/_/_/_/_/_/_/#

sub TAIKYAKU {

	$idate = time();

	&CHARA_MAIN_OPEN;

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);

	&COUNTRY_DATA_OPEN("$kcon");
	&TOWN_DATA_OPEN("$kpos");

	$a_hit = 0;$b_hit=0;
	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}else{

	#バトルマップ読み込み
	require "./log_file/map_hash/$kiti.pl";
	
	if($BM_TIKEI[$ky][$kx] == 16){
	$b_hit = 1;
	($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$ky][$kx]{'sekisyo'});
		if($town_cou[$ikisaki] eq $kcon){
			$kpos = $ikisaki;
			$a_hit = 1;
			&TETTAI("$ikisaki2に撤退しました。");	#lib/skl_lib.pl
		}
	$mess = "$ikisaki2に帰還しました。";
	&K_LOG("【退却】$ikisaki2に退却しました。");
	&K_LOG2("【退却】$ikisaki2に退却しました。");
	}elsif($BM_TIKEI[$ky][$kx] == 18 || $BM_TIKEI[$ky][$kx] == 22){
	$b_hit = 1;
		if($town_cou[$kiti] eq $kcon){
			$kpos = "$kiti";
			$iki = "$town_name[$kiti]";
			$a_hit = 1;
			&TETTAI("$ikiに撤退しました。");	#lib/skl_lib.pl
		}
	$mess = "$ikiに帰還しました。";
	&K_LOG("【退却】$ikiに退却しました。");
	&K_LOG2("【退却】$ikiに退却しました。");
	}

	if(!$b_hit){&ERR("退却できる場所の上にいません。");}	
	if(!$a_hit){&ERR("他国の都市です。");}

	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;

	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$mess</h2><p>
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
