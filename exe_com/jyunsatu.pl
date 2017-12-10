#_/_/_/_/_/_/_/_/_/_/#
#     巡察      #
#_/_/_/_/_/_/_/_/_/_/#

sub JYUNSATU {

	$ksub2=0;
	if($kgold<100){
		&K_LOG("$mmonth月:金不足で実行できませんでした。");
	}else{
		if(($kint > $kstr)&&($kint > $kcha)&&($kint > $klea)){
		$kint_ex++;
		$jyun_var = $kint;
		}elsif(($klea > $kstr)&&($klea > $kcha)&&($klea > $kint)){
		$klea_ex++;
		$jyun_var = $klea;
		}elsif(($kcha > $kstr)&&($kcha > $klea)&&($kcha > $kint)){
		$kcha_ex++;
		$jyun_var = $kcha;
		}else{
		$kstr_ex++;
		$jyun_var = $kstr;
		}
		$zpriadd = int(($jyun_var)/30 + rand(($jyun_var)) / 60);
		$zpri += $zpriadd;
		if($zpri > 100){
			$kiroku = $zpri;
			$zpri = 100;
			$zpriadd -= $kiroku-100;
		}
		$kgold -= 100;
		$kcex += int(30 + ($zpriadd/2));
		$pras = int(30 + ($zpriadd/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの民忠が<font color=red>+$zpriadd</font>上がりました。貢献値+$pras");
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
