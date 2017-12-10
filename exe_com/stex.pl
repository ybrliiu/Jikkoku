#_/_/_/_/_/_/_/_/_/_/#
#      城壁劣化      #
#_/_/_/_/_/_/_/_/_/_/#

sub STEX {

	if($kclass<10000){
		&K_LOG("$mmonth月:階級値不足で実行できませんでした。");
	}elsif($kgold<200 && $kkeiskl !~ /5/){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}elsif($ksol <= 0){
		&K_LOG("$mmonth月:兵士がいないので実行できませんでした。");
	}elsif(!$ksyuppei){
		&K_LOG("$mmonth月:出撃していません。");
	}elsif($kiti !~ /$cnum/){
		&K_LOG("$mmonth月:指定した都市の城付近もしくは指定した都市との間のマップ上にいないので実行できませんでした。");
	}else{
		$zdef_att_add = int((($kint+$kbook)/17 + rand(($kint+$kbook)) / 34)*($ksol/$klea));
		$nai_basic = $zdef_att_add;
		if($kkeiskl eq "0"){		#計略スキル処理
		$zdef_att_add = int($zdef_att_add*1.1);
		}elsif($kkeiskl eq "1"){
		$zdef_att_add = int($zdef_att_add*1.25);
		}elsif($kkeiskl =~ /5/){
		$zdef_att_add = int($zdef_att_add*1.95);
		}
		if($kbookskl == 5){	#書物スキル(計略)
		$zdef_att_add += int($nai_basic*0.5);
		}
		$zdef_att -= $zdef_att_add;
		if($kkeiskl !~ /5/){		#計略スキル処理
		$kgold -= 200;
		}
		if($zdef_att < 0){
			$kiroku = -1*$zdef_att;
			$zdef_att = 0;
			$zdef_att_add -= $kiroku;
		}
		$kcex += int(35 + ($zdef_att_add/2));
		$kbook += 0.09;
		$pras = int(35 + ($zdef_att_add/2));
		if("$zname" ne ""){
			splice(@TOWN_DATA,$cnum,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}
		&K_LOG("$mmonth月:$znameの城壁耐久力を<font color=red>-$zdef_att_add</font>下げました。貢献値+$pras、書物威力+0.09");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		$k_kei++;
	}

}
1;
