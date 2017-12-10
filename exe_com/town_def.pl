#_/_/_/_/_/_/_/_/_/_/#
# 城の守備（座標指定）  #
#_/_/_/_/_/_/_/_/_/_/#

sub TOWN_DEF {

	$ksub2=0;
	if($ksol <= 0 || $ksol eq ""){
		&K_LOG("$mmonth月:兵０では守備につけません。");
	}elsif($ksyuppei){
		$kcex += 25;
		$krice -= 200;
		$klea_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		&K_LOG("$mmonth月:【コマンド失敗】既に出撃しています。統率力経験値+1 貢献値+25");
	}else{

		#バトルマップ読み込み
		do "./log_file/map_hash/$kpos.pl";
		$last_hit = 0;
		for($i=0;$i<$BM_Y;$i++){
			for($j=0;$j<$BM_X;$j++){
				if($csub == $j && $cnum == $i && $BM_TIKEI[$i][$j] ne ""){
				$last_hit = 1;
				last;
				}
			}
			if($last_hit){
			last;
			}
		}

	if(($BM_X <= $csub)||($BM_Y <= $cnum)){
		&K_LOG("$mmonth月:$znameの城付近MAPにその座標は存在しません。");
	}elsif(!$last_hit){
		&K_LOG("$mmonth月:その座標には守備につけません。");	
	}else{
		$lkx = $csub+1;
		$lky = $cnum+1;
		$kcex += 30;
		$krice -= 200;
		&K_LOG("$mmonth月:$znameの城付近 座標($lkx,$lky) の守備につきました。");
		&K_LOG2("$mmonth月:$znameの城付近 座標($lkx,$lky) の守備につきました。");
		$klea_ex++;
		$ksyuppei = 1;
		$kiti = "$kpos";
		$kx = $csub;
		$ky = $cnum;
		$idate = time();
		$kkoutime = $idate+$BMT_REMAKE;
		#移動スキル ./lib/skl_lib.pl
		&IDOUSKL;
		&IDOUSKL2;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		}
	}

}
1;
