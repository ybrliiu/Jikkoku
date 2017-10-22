#_/_/_/_/_/_/_/_/_/_/#
#     觔斗雲スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub KINTO {

	$idate = time();
	&TOWN_DATA_OPEN;	

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif($kskl8 !~ /3/){
		&ERR("觔斗雲スキルを修得していません。");
	}else{


	if($in{'eid'} eq ""){&ERR("相手武将が選択されていません。");}

	&ENEMY_OPEN;
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);
($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL,$enaiskl,$ekeiskl,$etanskl,$ekinto,$e_jsub1,$e_jsub2) = split(/,/,$esub4);

	if(!$esyuppei){
		&ERR("指定した相手武将は出撃していません。");
	}elsif($kiti ne $eiti){
		&ERR("相手と同じマップ上にいません。");
	}elsif($kcon ne $econ){
		&ERR("敵には使用できません。");

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
	if($zsa3 > 5){
	&ERR("対象が觔斗雲を使える範囲にいません。");

			}else{

	$ksiki -= $MOR_KINTOUN;
	if($ksiki < 0){
		&ERR("士気が足りません。");
	}
	$kkk = $kcha*0.0045;
	if($kkk > 0.9){
	$kkk = 0.9;
	}
	if($kkk > rand(1)){
	$kagojikan = int(($kcha/20)*60);
	$kagojikan2 = int(($kcha/10)*60);
	$kagojikan3 = int(rand($kagojikan-$kagojikan2)+$kagojikan2);
	$ekinto = $idate+$kagojikan3;
		if($eid eq $kid){$kkinto = $idate+$kagojikan3;}
	$kex_add = int($kagojikan3/140);
		if($eid ne $kid){
		&E_LOG("<font color=orange>【觔斗雲】</font>$knameが$enameに觔斗雲を付与しました。<font color=blue>$kagojikan3</font>秒間消費移Pが多い地形での消費移Pが減少します。");
		&E_LOG2("<font color=orange>【觔斗雲】</font>$knameが$enameに觔斗雲を付与しました。<font color=blue>$kagojikan3</font>秒間消費移Pが多い地形での消費移Pが減少します。");
		}
	&K_LOG("<font color=orange>【觔斗雲】</font>$knameが$enameに觔斗雲を付与しました。<font color=red>$kagojikan3</font>秒間消費移Pが多い地形での消費移Pが減少します。 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");
	&K_LOG2("<font color=orange>【觔斗雲】</font>$knameが$enameに觔斗雲を付与しました。<font color=red>$kagojikan3</font>秒間消費移Pが多い地形での消費移Pが減少します。 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");


#戦闘場所地名
require './ini_file/bmmaplist.ini';
$battkemapname = "$TIKEI{$kiti}";



	&MAP_LOG("<font color=orange>【支援】</font>$knameは$enameに支援を行いました。($battkemapname\)");

	if($eid ne ""){
	$esub4 = "$erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL,$enaiskl,$ekeiskl,$etanskl,$ekinto,$e_jsub1,$e_jsub2,";
	&ENEMY_INPUT;
	}
	$kbook += 0.04;
	$kcex += $kex_add;
	$kkoutime = $idate+int($BMT_REMAKE*3/4);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	$ksub4 = "$krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2,";
	&CHARA_MAIN_INPUT;
				}else{
	&K_LOG("<font color=orange>【支援】</font>$enameに觔斗雲を付与しようとしましたが失敗しました。");
	&K_LOG2("<font color=orange>【支援】</font>$enameに觔斗雲を付与しようとしましたが失敗しました。");
	$kkoutime = $idate+int($BMT_REMAKE*3/4);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}	
			}
		}
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$enameに觔斗雲を使用しました。</h2><p>
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
