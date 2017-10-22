#_/_/_/_/_/_/_/_/_/_/#
#      混乱スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub KONRAN {

	$idate = time();
	&TOWN_DATA_OPEN;	

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	$ksiki -= $MOR_KONRAN;
	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}elsif($ksiki < 0){
		&ERR("式が足りません。");
	}elsif($kskl1 eq "" || $kskl1 eq "0"){
		&ERR("混乱スキルを修得していません。");
	}else{


	if($in{'eid'} eq ""){&ERR("相手武将が選択されていません。");}

	&ENEMY_OPEN;
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);

	if(!$esyuppei){
		&ERR("指定した相手武将は出撃していません。");
	}elsif($kiti ne $eiti){
		&ERR("相手と同じマップ上にいません。");
	}elsif($kcon eq $econ){
		&ERR("味方にはできません。");

		}else{
	
  my $distance = abs(($kx - $ex) + ($ky - $ey));
	if ($distance > 2) {
	  &ERR("相手が混乱を使える範囲にいません。");
	} else {

	my $kkk = $kint * 0.0035;
	$kkk = 0.7 if $kkk > 0.6;
	if ($kkk > rand(1)) {
	my $huya = int($kint * 1.3);
	my $zou = int(rand($huya));
	if($ekoutime eq "" || $ekoutime < $idate){
  	$ekoutime = $idate;
	}
	my $onetime = $ekoutime + $zou;
	my $gentime = $idate + int($BMT_REMAKE*2);
	if ($onetime > $gentime) {
  	$zou -= $onetime - $gentime;
	}
	$ekoutime += $zou;
	my $kex_add = int($zou / 33);
	E_LOG("<font color=yellowgreen>【混乱】</font>$knameに混乱させられました。待機時間+<font color=blue>$zou</font>秒");
	K_LOG("<font color=yellowgreen>【混乱】</font>$enameを混乱させました。待機時間+<font color=red>$zou</font>秒 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");
	E_LOG2("<font color=yellowgreen>【混乱】</font>$knameに混乱させられました。待機時間+<font color=blue>$zou</font>秒");
	K_LOG2("<font color=yellowgreen>【混乱】</font>$enameを混乱させました。待機時間+<font color=red>$zou</font>秒 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.04</font>");


#戦闘場所地名
require './ini_file/bmmaplist.ini';
$battkemapname = "$TIKEI{$kiti}";



	&MAP_LOG("<font color=yellowgreen>【妨害】</font>$enameは$knameに混乱させられました。($battkemapname\)");

        if ($eid ne "") {
          $esenj = "$ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip,";
          ENEMY_INPUT();
        }

	$kbook += 0.04;
	$kcex += $kex_add;
	$kkoutime = $idate+$BMT_REMAKE;
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
  CHARA_MAIN_INPUT();

				}else{
	&K_LOG("<font color=yellowgreen>【妨害】</font>$enameを混乱させようとしましたが失敗しました。");
	&K_LOG2("<font color=yellowgreen>【妨害】</font>$enameを混乱させようとしましたが失敗しました。");
	$kkoutime = $idate+$BMT_REMAKE;
	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
				}	
			}
		}
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$enameを混乱させました。$kkk</h2><p>
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
