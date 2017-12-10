#_/_/_/_/_/_/_/_/_/_/#
#      商業発展      #
#_/_/_/_/_/_/_/_/_/_/#

sub SYOUGYOU {

	$ksub2=0;
	if($kgold<50 && $knaiskl !~ /3/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$zsyoadd = int(($kint+$kbook)/15 + rand(($kint+$kbook)) / 30);
		$nai_basic = $zsyoadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$zsyoadd = int($zsyoadd*1.1);
		}elsif($knaiskl eq "1"){
		$zsyoadd = int($zsyoadd*1.3);
		}elsif($knaiskl =~ /3/){
		$zsyoadd = int($zsyoadd*2.0);
		}
		if($kbookskl == 2){	#書物スキル(商業)
		$zsyoadd += int($nai_basic*1.0);
		}
		$zsyo += $zsyoadd;
		if($knaiskl !~ /3/){		#内政スキル処理
		$kgold -= 50;
		}
		if($zsyo > $zsyo_max){
			$kiroku = $zsyo;
			$zsyo = $zsyo_max;
			$zsyoadd -= $kiroku-$zsyo_max;
		}
		$kcex += int(33 + ($zsyoadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(33 + ($zsyoadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの商業を<font color=red>+$zsyoadd</font>発展させました。貢献値+$pras、書物威力+0.07");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
