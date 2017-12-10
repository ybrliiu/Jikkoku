#_/_/_/_/_/_/_/_/_/_/#
#      集合          #
#_/_/_/_/_/_/_/_/_/_/#

sub SYUUGOU {

	if(!$auto_syu){
	$ksub2=0;
	}
	$uhit=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$uid" eq "$kid" && $unit_id eq $kid){$uhit=1;$spos=$upos;last;}
	}
	if(!$uhit){
		&K_LOG("$mmonth月:隊長しか実行できません。");
	}else{

		foreach(@UNI_DATA){
			($unit_id,$uunit_name,$ucon,$ureader,$uid)=split(/<>/);
			if($unit_id eq $kid && $uid ne $unit_id){
				$in{'eid'} = "$uid";
				&ENEMY_OPEN;
								
				$epos = $spos;
				if($eid ne ""){
					if($auto_syu){
					&E_LOG("$mmonth月:$uunit_name部隊は隊長の命令により$town_name[$spos]に自動集合させられました。");
					}else{
					&E_LOG("$mmonth月:$uunit_name部隊は隊長の命令により$town_name[$spos]に集合させられました。");
					}
					&ENEMY_INPUT;
				}
			}elsif($unit_id eq $kid && $uid eq $unit_id){
				$unit_name = $uunit_name;
			}
		}
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		if($auto_syu){
		$krice -=500;
		&K_LOG("$mmonth月:$unit_name部隊を$town_name[$spos]に自動集合させました。米-<font color=red>500</font>");
		}else{
		$klea_ex++;
		$kcex+=30;
		&K_LOG("$mmonth月:$unit_name部隊を$town_name[$spos]に集合させました。");
		}
	}

}
1;
