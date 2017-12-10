#_/_/_/_/_/_/_/_/_/_/#
#      退却      #
#_/_/_/_/_/_/_/_/_/_/#

sub TAIKYAKU {

	$ksub2=0;
	if(!$ksyuppei){
	&K_LOG("$mmonth月:【軍事】出撃していません。");
	}else{
	require './lib/skl_lib.pl';
		my $ryounai=0;
		if($kiti =~ /-/){
			my @kitilist=split(/-/,$kiti);
			my $kiti_1=$kitilist[0];
			my $kiti_2=$kitilist[1];
			if($town_cou[$kiti_1] eq "$kcon" && $town_cou[$kiti_2] eq "$kcon"){
			$ryounai=1;
			}
		}else{
			if($town_cou[$kiti] eq "$kcon"){
			$ryounai=1;
			}
		}

		if($ryounai && $zcon eq "$kcon"){
		&TETTAI("$znameに撤退しました。");
		}else{
		$ksol = 0;
		&TETTAI('兵士を捨て撤退しました。');
		}
	$kstr_ex++;
	$kcex += 30;
	$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	&K_LOG("$mmonth月:$znameに退却しました。");
	}

}
1;
