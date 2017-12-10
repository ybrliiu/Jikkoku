#_/_/_/_/_/_/_/_/_/_/#
#      農業開発      #
#_/_/_/_/_/_/_/_/_/_/#

sub NOUGYOU {

	$ksub2=0;
	if($kgold<50 && $knaiskl !~ /2/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
		}else{
		$znouadd = int(($kint+$kbook)/15 + rand(($kint+$kbook)) / 30);
		$nai_basic = $znouadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$znouadd = int($znouadd*1.1);
		}elsif($knaiskl eq "1"){
		$znouadd = int($znouadd*1.3);
		}elsif($knaiskl =~ /2/){
		$znouadd = int($znouadd*2.0);
		}
		if($kbookskl == 1){	#書物スキル(農書)
		$znouadd += int($nai_basic*1.0);
		}
		$znou += $znouadd;
		if($knaiskl !~ /2/){		#内政スキル処理
		$kgold -= 50;
		}
		if($znou > $znou_max){
			$kiroku = $znou;
			$znou = $znou_max;
			$znouadd -= $kiroku-$znou_max;
		}
		$kcex += int(33 + ($znouadd/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(33 + ($znouadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの農業を<font color=red>+$znouadd</font>開発しました。貢献値+$pras、書物威力+0.07");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
