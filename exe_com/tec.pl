#_/_/_/_/_/_/_/_/_/_/#
#      技術開発      #
#_/_/_/_/_/_/_/_/_/_/#

sub TEC {

	$ksub2=0;
	if($kgold<50 && $knaiskl !~ /4/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$ztecadd = int(($kint+$kbook)/15 + rand(($kint+$kbook)) / 30);
		$nai_basic = $ztecadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$ztecadd = int($ztecadd*1.1);
		}elsif($knaiskl eq "1"){
		$ztecadd = int($ztecadd*1.3);
		}elsif($knaiskl =~ /4/){
		$ztecadd = int($ztecadd*2.2);
		}
		if($kbookskl == 3){	#書物スキル(技術)
		$ztecadd += int($nai_basic*1.1);
		}
		$zsub1 += $ztecadd;
		if($knaiskl !~ /4/){		#内政スキル処理
		$kgold -= 50;
		}
		if($zsub1 > 9999){
			$kiroku = $zsub1;
			$zsub1 = 9999;
			$ztecadd -= $kiroku-9999;
		}
		$kcex += int(33 + ($ztecadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(33 + ($ztecadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの技術を<font color=red>+$ztecadd</font>開発しました。貢献値+$pras、書物威力+0.07");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
