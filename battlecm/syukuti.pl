#_/_/_/_/_/_/_/_/_/_/#
#     縮地スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub SYUKUTI {

	$idate = time();
	&TOWN_DATA_OPEN;	

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif($kskl8 !~ /1/){
		&ERR("縮地スキルを修得していません。");
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
	if($zsa3 > 4){
	&ERR("対象が縮地を使える範囲にいません。");

			}else{

	$ksiki -= $MOR_SYUKUTI;
	if($ksiki < 0){
		&ERR("士気が足りません。");
	}
	$kkk = $kcha*0.0065;
	if($kkk > 0.9){
	$kkk = 0.9;
	}
	if($kkk > rand(1)){
	$zou = int($kcha/5);
		if($zou > 50){$zou = 50;}
	$ebattletime -= $zou;	if($kid eq $eid){$kbattletime -= $zou;}
	$kex_add = int($zou/25);
		if($eid ne $kid){
		&E_LOG("<font color=orange>【縮地】</font>$knameが$enameに縮地を行いました。　移P補充時間-<font color=blue>$zou</font>秒");
		&E_LOG2("<font color=orange>【縮地】</font>$knameが$enameに縮地を行いました。　移P補充時間-<font color=blue>$zou</font>秒");
		}
	&K_LOG("<font color=orange>【縮地】</font>$knameが$enameに縮地を行いました。　移P補充時間-<font color=red>$zou</font>秒 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");
	&K_LOG2("<font color=orange>【縮地】</font>$knameが$enameに縮地を行いました。　移P補充時間-<font color=red>$zou</font>秒 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");


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
	$kkoutime = $idate+($BMT_REMAKE*3/4);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}else{
	&K_LOG("<font color=orange>【支援】</font>$enameに縮地を行おうとしましたが失敗しました。");
	&K_LOG2("<font color=orange>【支援】</font>$enameに縮地を行おうとしましたが失敗しました。");
	$kkoutime = $idate+($BMT_REMAKE*3/4);
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}	
			}
		}
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$enameに縮地を使用しました。</h2><p>
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
