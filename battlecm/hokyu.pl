#_/_/_/_/_/_/_/_/_/_/#
#      補給スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub HOKYU {

	$idate = time();
	&TOWN_DATA_OPEN;	

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif($ksien eq "" || $ksien eq "0"){
		&ERR("補給スキルを修得していません。");
	}else{


	if($in{'eid'} eq ""){&ERR("相手武将が選択されていません。");}
  ENEMY_OPEN();
  ($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
  ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);

	$ksiki -= $MOR_HOKYU;
	if($ksiki < 0){
		&ERR("士気が足りません。");
	}elsif(!$esyuppei){
		&ERR("指定した相手武将は出撃していません。");
	}elsif($kiti ne $eiti){
		&ERR("相手と同じマップ上にいません。");
	}elsif($kcon ne $econ){
		&ERR("敵に補給はできません。");
	}elsif($kid eq $eid){
		&ERR("自分に補給はできません。");
	}elsif($ksol < int($klea/2) ){
		&ERR("補給スキルは自分の兵士が統率力の50%以上いる時にしか使用できません。");
	}else{


	$zsa = $kx-$ex;
	if($zsa < 0){
	$zsa = $zsa*-1;
	}
	$zsa2 = $ky-$ey;
	if($zsa2 < 0){
	$zsa2 = $zsa2*-1;
	}
	$zsa3 = $zsa+$zsa2;
	if($zsa3 > 1){
	&ERR("相手が補給できる範囲にいません。");

			}else{

	if($esol >= $elea){
	&ERR("相手の兵士数が最大なので補給できません。");
	}
	$hokyusol = int(($kint+$klea)/5);
	$hokyusol1 = int(rand($hokyusol));
	if($hokyusol1 <= 0){
	$hokyusol1 = 1;
	}
	$zsol = $esol + $hokyusol1;
	if($zsol > $elea){
	$hsol = $zsol - $elea;
	$hokyusol1 -= $hsol;
	}
	$tsol = $ksol - $hokyusol1;
	if($tsol <= 0){
	$solsa = 0 - $ksol;
	$hokyusol1 -= $solsa;
	$ksol = 0;
	}
	$ksol -= $hokyusol1;
	$esol += $hokyusol1;
	$esiharai = 0;
	if($ksub1_ex ne $esub1_ex){
	$egat -= $hokyusol1;
	$esiharai = $hokyusol1*$SOL_PRICE[$esub1_ex];
	$egold -= $esiharai;
	}
	$kex_add = int(($SOL_PRICE[$ksub1_ex]*$hokyusol1)/250);
	&E_LOG("<font color=orange>【支援】</font>$knameから増援が来ました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$hokyusol1\) 金-<font color=red>$esiharai</font>");
	&K_LOG("<font color=orange>【支援】</font>$enameに兵士を補給しました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$hokyusol1\) 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.02</font>");
	&E_LOG2("<font color=orange>【支援】</font>$knameから増援が来ました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$hokyusol1\) 金-<font color=red>$esiharai</font>");
	&K_LOG2("<font color=orange>【支援】</font>$enameに兵士を補給しました。$ename $SOL_TYPE[$esub1_ex]\ \($SOL_ZOKSEI[$esub1_ex]\) $esol人 ↑\(+$hokyusol1\) 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.02</font>");


#戦闘場所地名
require './ini_file/bmmaplist.ini';
$battkemapname = "$TIKEI{$kiti}";


	&MAP_LOG("<font color=orange>【支援】</font>$knameは$enameに支援を行いました。($battkemapname\)");

	if($eid ne ""){
	  &ENEMY_INPUT;
	}
	$kbook += 0.02;
	$kcex += $kex_add;
	$kkoutime = $idate+$BMT_REMAKE;
	if($ksol <= 0){
	$ksol = 0;
	$ksyuppei = 0;
	$kiti = "";
	$kx = "";
	$ky = "";
	$kkicn = 0;
	$kksup = 0;
	$kmsup = 0;
	$ksakup = 0;
	$konmip = 0;
	&K_LOG("【撤退】部隊の兵士がいないので撤退しました。");
	&K_LOG2("【撤退】部隊の兵士がいないので撤退しました。");
	}
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
			}
		}
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$enameに兵士を補給しました。</h2><p>
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
