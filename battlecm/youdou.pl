#_/_/_/_/_/_/_/_/_/_/#
#      陽動スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub YOUDOU {

	$idate = time();
	&TOWN_DATA_OPEN;	

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);


	$ksiki -= $MOR_S;
	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif(($ksien ne "4")&&($ksien ne "5")&&($ksien ne "6")&&($ksien ne "7")&&($ksien ne "8")&&($ksien ne "9")){
		&ERR("陽動【小】を修得していません。");
	}elsif($ksiki < 0){
		&ERR("士気が足りません。");
	}else{


	if($in{'eid'} eq ""){&ERR("相手武将が選択されていません。");}

	&ENEMY_OPEN;
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);
($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL,$enaiskl,$ekeiskl,$etanskl,$ekinto,$e_jsub1,$e_jsub2) = split(/,/,$esub4);


	if(!$esyuppei){
		&ERR("指定した相手武将は出撃していません。");
	}elsif($kiti ne $eiti){
		&ERR("相手と同じマップ上にいません。");
	}elsif($kcon eq $econ){
		&ERR("味方にはできません。");

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
	if($zsa3 > 3){
	&ERR("相手が陽動【小】を使える範囲にいません。");

			}else{


	$kagoseikou = $kint/180;
	if($kagoseikou > 0.8){$kagoseikou = 0.8;}

		if($kagoseikou > rand(1)){

	$kagojikan = int(($kint/30)*60);
	$kagojikan2 = int(($kint/10)*60);
	$kagojikan3 = int(rand($kagojikan-$kagojikan2)+$kagojikan2);
	$eyoudou = $idate+$kagojikan3;
	$kex_add = int($kagojikan3/140);
	
  my $enemy_log = "<font color=yellowgreen>【妨害】</font>$knameが陽動【小】を行いました。<font color=red>$kagojikan3</font>秒間自軍の攻撃力が減少します。";
	&E_LOG($enemy_log);
	&E_LOG2($enemy_log);

  my $my_log = "<font color=yellowgreen>【妨害】</font>$enameに陽動【小】を行いました。<font color=red>$kagojikan3</font>秒間$enameの部隊の攻撃力が減少します。 士気-<font color=red>$MOR_S</font> 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.02</font>";
	&K_LOG($my_log);
	&K_LOG2($my_log);


#戦闘場所地名
require './ini_file/bmmaplist.ini';
$battkemapname = "$TIKEI{$kiti}";


	&MAP_LOG("<font color=yellowgreen>【妨害】</font>$knameは$enameに妨害行動を行いました。($battkemapname\)");

	if($eid ne ""){
	$esub4 = "$erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL,$enaiskl,$ekeiskl,$etanskl,$ekinto,$e_jsub1,$e_jsub2,";
	&ENEMY_INPUT;
	}
	$kbook += 0.02;
	$kcex += $kex_add;
	$kkoutime = $idate+int($BMT_REMAKE/2);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}else{
	&K_LOG("<font color=yellowgreen>【妨害】</font>$enameに陽動【小】を行おうとしましたが失敗しました。");
	&K_LOG2("<font color=yellowgreen>【妨害】</font>$enameに陽動【小】を行おうとしましたが失敗しました。");
	$kkoutime = $idate+int($BMT_REMAKE/2);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}
			}
		}
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$enameに陽動【小】を行いました。</h2><p>
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
