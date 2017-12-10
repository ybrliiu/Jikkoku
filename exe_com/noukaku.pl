#_/_/_/_/_/_/_/_/_/_/#
#      農地開拓      #
#_/_/_/_/_/_/_/_/_/_/#

sub NOUKAKU {

	$ksub2=0;
	if($kclass<5000){
		&K_LOG("$mmonth月:今の階級値ではこのコマンドは実行できません！！");
	}elsif($kgold<50 && $knaiskl !~ /2/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$znou_maxadd = int(($kint+$kbook)/15 + rand(($kint+$kbook)) / 30);
		$nai_basic = $znou_maxadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$znou_maxadd = int($znou_maxadd*1.1);
		}elsif($knaiskl eq "1"){
		$znou_maxadd = int($znou_maxadd*1.3);
		}elsif($knaiskl =~ /2/){
		$znou_maxadd = int($znou_maxadd*2.0);
		}
		if($kbookskl == 1){	#書物スキル(農書)
		$znou_maxadd += int($nai_basic*1.0);
		}
		$znou_max += $znou_maxadd;
		if($znou_max > 9999){
			$kiroku = $znou_max;
			$znou_max = 9999;
			$znou_maxadd -= $kiroku-9999;
		}
		if($knaiskl !~ /2/){		#内政スキル処理
		$kgold -= 50;
		}
		$kcex += int(33 + ($znou_maxadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(33 + ($znou_maxadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの農業最大値を<font color=red>+$znou_maxadd</font>しました。貢献値+$pras、書物威力+0.07");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
