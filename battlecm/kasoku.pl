#_/_/_/_/_/_/_/_/_/_/#
#     加速スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub KASOKU {

	$idate = time();
	&TOWN_DATA_OPEN;	

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif($kskl8 !~ /2/){
		&ERR("加速スキルを修得していません。");
	}else{


	if($in{'eid'} eq ""){&ERR("相手武将が選択されていません。");}

	&ENEMY_OPEN;
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);

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
	&ERR("対象が加速を使える範囲にいません。");

			}else{

	$ksiki -= $MOR_KASOKU;
	if($ksiki < 0){
		&ERR("士気が足りません。");
	}
	$kkk = $kcha*0.0055;
	if($kkk > 0.95){
	$kkk = 0.95;
	}
	if($kkk > rand(1)){
	$zou = int($kcha/30);
		if($zou > 10){$zou = 10;}
	$eidoup += $zou;if($eidoup > 50){$eidoup = 50;}
	if($kid eq $eid){$kidoup += $zou;if($kidoup > 50){$kidoup = 50;}}
	$kex_add = int($zou/2);
		if($eid ne $kid){
		&E_LOG("<font color=orange>【加速】</font>$knameが$enameに加速を行いました。　移P+<font color=blue>$zou</font>");
		&E_LOG2("<font color=orange>【加速】</font>$knameが$enameに加速を行いました。　移P+<font color=blue>$zou</font>");
		}
	&K_LOG("<font color=orange>【加速】</font>$knameが$enameに加速を行いました。　移P+<font color=red>$zou</font> 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");
	&K_LOG2("<font color=orange>【加速】</font>$knameが$enameに加速を行いました。　移P+<font color=red>$zou</font> 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");


#戦闘場所地名
require './ini_file/bmmaplist.ini';
$battkemapname = "$TIKEI{$kiti}";



	&MAP_LOG("<font color=orange>【支援】</font>$knameは$enameに支援を行いました。($battkemapname\)");

	if($eid ne ""){
	$esenj = "$ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip,";
	&ENEMY_INPUT;
	}
	$kbook += 0.04;
	$kcex += $kex_add;
	$kkoutime = $idate+($BMT_REMAKE*2/3);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}else{
	&K_LOG("<font color=orange>【支援】</font>$enameに加速を行おうとしましたが失敗しました。");
	&K_LOG2("<font color=orange>【支援】</font>$enameに加速を行おうとしましたが失敗しました。");
	$kkoutime = $idate+($BMT_REMAKE*2/3);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}	
			}
		}
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$enameに加速を使用しました。</h2><p>
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
