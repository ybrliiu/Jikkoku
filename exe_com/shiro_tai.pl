#_/_/_/_/_/_/_/_/_/_/#
#  城耐久力開発      #
#_/_/_/_/_/_/_/_/_/_/#

sub SHIRO_TAI {

	$ksub2=0;
	if($kgold<50 && $knaiskl !~ /5/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$zdef_att_add = int(($kint+$kstr+$kprodmg)/15 + rand(($kint+$kstr+$kprodmg)) / 30);
		$nai_basic = $zdef_att_add;
		if($knaiskl eq "0"){		#内政スキル処理
		$zdef_att_add = int($zdef_att_add*1.1);
		}elsif($knaiskl eq "1"){
		$zdef_att_add = int($zdef_att_add*1.3);
		}elsif($knaiskl =~ /5/){
		$zdef_att_add = int($zdef_att_add*1.8);
		}
		if($kbookskl == 4){	#書物スキル(城壁)
		$zdef_att_add += int($nai_basic*0.9);
		}
		$zdef_att += $zdef_att_add;
		if($knaiskl !~ /5/){		#内政スキル処理
		$kgold -= 50;
		}
#城耐久上限計算
	$taikyu = $myear*125;
	if($taikyu<1000){
	$taikyu = 1000;
	}elsif($taikyu>9999){
	$taikyu = 9999;
	}
		if($zdef_att > $taikyu){
			$kiroku = $zdef_att;
			$zdef_att = $taikyu;
			$zdef_att_add -= $kiroku-$taikyu;
		}
		$kcex += int(30 + ($zdef_att_add/2));

		if($kbookskl == 6){	#書物スキル
		$kbook += 0.2;
		}else{
		$kbook += 0.07;
		}

		$pras = int(30 + ($zdef_att_add/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの城壁耐久力を<font color=red>+$zdef_att_add</font>強化しました。貢献値+$pras、書物威力+0.07");
		if($kstr < $kint){$kint_ex++;
		}else{$kstr_ex++;
		}
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$knai++;
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
	}

}
1;
