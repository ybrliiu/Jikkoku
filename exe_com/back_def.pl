#_/_/_/_/_/_/_/_/_/_/#
#      城の守備       #
#_/_/_/_/_/_/_/_/_/_/#

sub BACK_DEF {

	$ksub2=0;
	if($ksol <= 0 || $ksol eq ""){
		&K_LOG("$mmonth月:兵０では守備につけません。");
	}elsif($ksyuppei){
		$kcex += 25;
		$kstr_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		&K_LOG("$mmonth月:【コマンド失敗】既に出撃しています。武力経験値+1 貢献値+25");
	}else{

		#バトルマップ読み込み
		do "./log_file/map_hash/$kpos.pl";
		$last_hit = 0;
		for($i=0;$i<$BM_Y;$i++){
			for($j=0;$j<$BM_X;$j++){
				if($BM_TIKEI[$i][$j] == 18 || $BM_TIKEI[$i][$j] == 22){
				$shirox = $j;
				$shiroy = $i;
				last;
				$last_hit = 1;
				}
			}
			if($last_hit){
			last;
			}
		}

		$kcex += 30;
		&K_LOG("$mmonth月:$znameの城の守備につきました。");
		&K_LOG2("$mmonth月:$znameの城の守備につきました。");
		$ksyuppei = 1;
		$kiti = "$kpos";
		$kx = $shirox;
		$ky = $shiroy;
		$idate = time();
		$kkoutime = $idate+$BMT_REMAKE;
		#移動スキル ./lib/skl_lib.pl
		&IDOUSKL;
		&IDOUSKL2;
		$kstr_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;
