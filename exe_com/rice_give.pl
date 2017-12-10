#_/_/_/_/_/_/_/_/_/_/#
#      米 施 し      #
#_/_/_/_/_/_/_/_/_/_/#

sub RICE_GIVE {

	$ksub2=0;
	if($krice<50 && $knaiskl !~ /6/){
		&K_LOG("$mmonth月:米不足で実行できませんでした。");
	}else{
		$zpriadd = int(($kcha+$kbook)/15 + rand(($kcha+$kbook)) / 30);
		$nai_basic = $zpriadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$zpriadd = int($zpriadd*1.1);
		}elsif($knaiskl eq "1"){
		$zpriadd = int($zpriadd*1.3);
		}elsif($knaiskl =~ /6/){
		$zpriadd = int($zpriadd*2.2);
		}
		if($kbookskl == 7){	#書物スキル(論語)
		$zpriadd += int($nai_basic*0.9);
		}
		$zpri += $zpriadd;
		if($knaiskl !~ /6/){		#内政スキル処理
		$krice -= 50;
		}
		if($zpri > 100){
			$kiroku = $zpri;
			$zpri = 100;
			$zpriadd -= $kiroku-100;
		}
		$kcex += int(33 + ($zpriadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(33 + ($zpriadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの民忠が<font color=red>+$zpriadd</font>上がりました。貢献値+$pras、書物威力+0.07");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
