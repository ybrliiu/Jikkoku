#_/_/_/_/_/_/_/_/_/_/#
#      技術衰退      #
#_/_/_/_/_/_/_/_/_/_/#

sub TECEX {

	if($kclass<10000){
		&K_LOG("$mmonth月:階級値不足で実行できませんでした。");
	}elsif($kgold<200 && $kkeiskl !~ /4/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}elsif($ksol <= 0){
		&K_LOG("$mmonth月:兵士がいないので実行できませんでした。");
	}elsif(!$ksyuppei){
		&K_LOG("$mmonth月:出撃していません。");
	}elsif($kiti !~ /$cnum/){
		&K_LOG("$mmonth月:指定した都市の城付近もしくは指定した都市との間のマップ上にいないので実行できませんでした。");
	}else{
		$ztecadd = int((($kint+$kbook)/17 + rand(($kint+$kbook)) / 34)*($ksol/$klea));
		$nai_basic = $ztecadd;
		if($kkeiskl eq "0"){		#計略スキル処理
		$ztecadd = int($ztecadd*1.1);
		}elsif($kkeiskl eq "1"){
		$ztecadd = int($ztecadd*1.25);
		}elsif($kkeiskl =~ /4/){
		$ztecadd = int($ztecadd*1.95);
		}
		if($kbookskl == 5){	#書物スキル(計略)
		$ztecadd += int($nai_basic*0.5);
		}
		$zsub1 -= $ztecadd;
		if($kkeiskl !~ /4/){		#計略スキル処理
		$kgold -= 200;
		}
		if($zsub1 < 0){
			$kiroku = -1*$zsub1;
			$zsub1 = 0;
			$ztecadd -= $kiroku;
		}
		$kcex += int(35 + ($ztecadd/2));
		$kbook += 0.09;
		$pras = int(35 + ($ztecadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$cnum,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの技術を<font color=red>-$ztecadd</font>下げました。貢献値+$pras、書物威力+0.09");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$k_kei++;
	}

}
1;
