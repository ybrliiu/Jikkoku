#_/_/_/_/_/_/_/_/_/_/#
#      城壁拡張      #
#_/_/_/_/_/_/_/_/_/_/#

sub SHIROKAKU {

	$ksub2=0;
	if($kclass<5000){
		&K_LOG("$mmonth月:階級値不足で実行できませんでした〜");
	}elsif($kgold<50 && $knaiskl !~ /5/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$zshiro_maxadd = int(($kint+$klea+$kbook)/15 + rand(($kint+$klea+$kbook)) / 30);
		$nai_basic = $zshiro_maxadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$zshiro_maxadd = int($zshiro_maxadd*1.1);
		}elsif($knaiskl eq "1"){
		$zshiro_maxadd = int($zshiro_maxadd*1.3);
		}elsif($knaiskl =~ /5/){
		$zshiro_maxadd = int($zshiro_maxadd*1.8);
		}
		if($kbookskl == 4){	#書物スキル(城壁)
		$zshiro_maxadd += int($nai_basic*0.9);
		}
		$zshiro_max += $zshiro_maxadd;
		if($zshiro_max > 9999){
			$kiroku = $zshiro_max;
			$zshiro_max = 9999;
			$zshiro_maxadd -= $kiroku-9999;
		}
		if($knaiskl !~ /5/){		#内政スキル処理
		$kgold -= 50;
		}
		$kcex += int(30 + ($zshiro_maxadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(30 + ($zshiro_maxadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの城壁を<font color=red>+$zshiro_maxadd</font>拡張しました。貢献値+$pras、書物威力+0.07");
		if($klea < $kint && $kstr < $kint){
		$kint_ex++;
		}elsif($kint < $klea && $kstr < $klea){
		$klea_ex++;
		}else{
		$kstr_ex++;
		}
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
