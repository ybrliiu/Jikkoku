#_/_/_/_/_/_/_/_/_/_/#
#     戦争   （出兵）  #
#_/_/_/_/_/_/_/_/_/_/#

sub BATTLE {

	&COUNTRY_DATA_OPEN("$kcon");


	#バトルマップ読み込み
	do "./log_file/map_hash/$kpos.pl";
	$shit = 0;
	for($i=0;$i<$BM_Y;$i++){
		for($j=0;$j<$BM_X;$j++){
			if($BM_TIKEI[$i][$j] == 17){
			($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
				if($ikisaki2 eq "$z5name"){
				&K_LOG("$mmonth月:$ikisaki2へ向けて出城しました。");
				&K_LOG2("$mmonth月:$ikisaki2へ向けて出城しました。");
				$kiti = "$ikisaki";
				$maeiti = "$kpos";
				&MAP_LOG("$mmonth月:$xnameの$knameは$ikisaki2へ向けて出城しました！");
				$shit = 1;
				last;
				}
			}
		}
	}
	if(!$shit){&K_LOG("フォームに不正な値が含まれています。");}


	#バトルマップ読み込み
	do "./log_file/map_hash/$kiti.pl";
	$ahit = 0;
	for($i=0;$i<$BM_Y;$i++){
		for($j=0;$j<$BM_X;$j++){
			if($BM_TIKEI[$i][$j] == 16){
			($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
				if("$maeiti" eq "$ikisaki"){
				$kcex += 30;
				$kstr_ex++;
				$ksyuppei = 1;
				$kx = $j;
				$ky = $i;
				$idate = time();
				$kkoutime = $idate+$BMT_REMAKE;
				#移動スキル ./lib/skl_lib.pl
				&IDOUSKL;
				&IDOUSKL2;
				$ahit = 1;
				last;
				}
			}
		}
	}
	if(!$ahit){&K_LOG("バトルマップデータに異常があります。");}

}
1;
