#_/_/_/_/_/_/_/_/_/_/#
#      入植      #
#_/_/_/_/_/_/_/_/_/_/#

sub KAITAKU {

	$ksub2=0;
	if(($krice<500||$kgold<500) && $knaiskl !~ /8/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}elsif($kclass<15000){
		&K_LOG("$mmonth月:今の階級値でこのコマンドは実行できません。");
	}else{
		$znouadd = int(($kcha+$kbook) + rand($kcha+$kbook));
		$nai_basic = $znouadd;
		if($knaiskl eq "0"){		#内政スキル処理
		$znouadd = int($znouadd*1.1);
		}elsif($knaiskl eq "1"){
		$znouadd = int($znouadd*1.3);
		}elsif($knaiskl =~ /8/){
		$znouadd = int($znouadd*2.2);
		}
		if($kbookskl == 7){	#書物スキル(論語)
		$znouadd += int($nai_basic*0.9);
		}
		$znum += $znouadd;
		if($knaiskl !~ /8/){		#内政スキル処理
		$krice -= 500;
		$kgold -= 500;
		}
		if($znum > $zsub2){
			$kiroku = $znum;
			$znum = $zsub2;
			$znouadd -= $kiroku-$zsub2;
		}
		$kcex += int(35 + ($znouadd/33));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.09;
		}

		$pras = int(35 + ($znouadd/33));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの農民が<font color=red>+$znouadd</font>人増えました。貢献値+$pras、書物威力+0.09");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
