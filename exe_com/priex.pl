#_/_/_/_/_/_/_/_/_/_/#
#      流言      #
#_/_/_/_/_/_/_/_/_/_/#

sub PRIEX {

	if($kclass<10000){
		&K_LOG("$mmonth月:階級値不足で実行できませんでした。");
	}elsif($kgold<200 && $kkeiskl !~ /6/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}elsif($ksol <= 0){
		&K_LOG("$mmonth月:兵士がいないので実行できませんでした。");
	}elsif(!$ksyuppei){
		&K_LOG("$mmonth月:出撃していません。");
	}elsif($kiti !~ /$cnum/){
		&K_LOG("$mmonth月:指定した都市の城付近もしくは指定した都市との間のマップ上にいないので実行できませんでした。");
	}else{
		$zpriadd = int(((($kint/2)+$kcha+$kbook)/17 + rand((($kint/2)+$kcha+$kbook)) / 34)*($ksol/$klea));
		$nai_basic = $zpriadd;
		if($kkeiskl eq "0"){		#計略スキル処理
		$zpriadd = int($zpriadd*1.1);
		}elsif($kkeiskl eq "1"){
		$zpriadd = int($zpriadd*1.25);
		}elsif($kkeiskl =~ /6/){
		$zpriadd = int($zpriadd*1.9);
		}
		if($kbookskl == 5){	#書物スキル(計略)
		$zpriadd += int($nai_basic*0.5);
		}
		$zpri -= $zpriadd;
		if($kkeiskl !~ /6/){		#計略スキル処理
		$kgold -= 200;
		}
		if($zpri < 0){
			$kiroku = -1*$zpri;
			$zpri = 0;
			$zpriadd -= $kiroku;
		}
		$kcex += int(35 + ($zpriadd/2));
		$kbook += 0.09;
		$pras = int(35 + ($zpriadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$cnum,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの民忠を<font color=red>-$zpriadd</font>下げました。貢献値+$pras、書物威力+0.09");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$k_kei++;
	}

}
1;
