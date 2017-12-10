#_/_/_/_/_/_/_/_/_/_/#
#        開拓        #
#_/_/_/_/_/_/_/_/_/_/#

sub NYUSYOKU {

	$ksub2=0;
	if($kclass<5000){
		&K_LOG("$mmonth月:今の階級値でこのコマンドは実行できないよ〜");
	}elsif($krice<$kcha && $knaiskl !~ /7/){
		&K_LOG("$mmonth月:米で実行できませんでした。");
	}else{
		$zsub2_add = int(($kcha+$kbook)/2 + rand(($kcha+$kbook)) / 2);
		$nai_basic = $zsub2_add;
		if($knaiskl eq "0"){		#内政スキル処理
		$zsub2_add = int($zsub2_add*1.1);
		}elsif($knaiskl eq "1"){
		$zsub2_add = int($zsub2_add*1.3);
		}elsif($knaiskl =~ /7/){
		$zsub2_add = int($zsub2_add*2.2);
		}
		if($kbookskl == 7){	#書物スキル(論語)
		$zsub2_add += int($nai_basic*0.9);
		}
		$zsub2 += $zsub2_add;
		if($zsub2 > 200000){
			$kiroku = $zsub2;
			$zsub2 = 200000;
			$zsub2_add -= $kiroku-200000;
		}
		if($knaiskl !~ /7/){		#内政スキル処理
		$krice -= $kcha;
		}
		$kcex += int(33 + ($zsub2_add/16));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(33 + ($zsub2_add/16));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの農民最大値が<font color=red>+$zsub2_add人</font>増えました。貢献値+$pras、書物威力+0.07");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
