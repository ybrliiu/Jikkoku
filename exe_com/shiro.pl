#_/_/_/_/_/_/_/_/_/_/#
#      城壁強化      #
#_/_/_/_/_/_/_/_/_/_/#

sub SHIRO {

	$ksub2=0;
	if($kgold<50 && $knaiskl !~ /5/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$zshiroadd = int(($kint+$klea+$kbook)/15 + rand(($kint+$klea+$kbook)) / 30);
		$nai_basic = $zshiroadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$zshiroadd = int($zshiroadd*1.1);
		}elsif($knaiskl eq "1"){
		$zshiroadd = int($zshiroadd*1.3);
		}elsif($knaiskl =~ /5/){
		$zshiroadd = int($zshiroadd*1.8);
		}
		if($kbookskl == 4){	#書物スキル(城壁)
		$zshiroadd += int($nai_basic*0.9);
		}
		$zshiro += $zshiroadd;
		if($knaiskl !~ /5/){		#内政スキル処理
		$kgold -= 50;
		}
		if($zshiro > $zshiro_max){
			$kiroku = $zshiro;
			$zshiro = $zshiro_max;
			$zshiroadd -= $kiroku-$zshiro_max;
		}
		$kcex += int(30 + ($zshiroadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(30 + ($zshiroadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの城壁を<font color=red>+$zshiroadd</font>強化しました。貢献値+$pras、書物威力+0.07");
		if($klea < $kint){$kint_ex++;
		}else{$klea_ex++;
		}
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
