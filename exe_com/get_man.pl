#_/_/_/_/_/_/_/_/#
#      登用      #
#_/_/_/_/_/_/_/_/#

sub GET_MAN {

	$ksub2=0;
	if($kgold < 50){
		&K_LOG("$mmonth月:金が足りません。");
	}else{

		$kgold-=50;
		$kcex += 40;
		open(IN,"$MESSAGE_LIST2");
		@MES_REG2 = <IN>;
		close(IN);
		$mes_num = @MES_REG2;
		if($mes_num > $MES_MAX) { pop(@MES_REG2); }
		unshift(@MES_REG2,"$cnum<>$kid<>$kpos<>$kname<>$csub<>$cno<>$ctime<>$kchara<>$cend<>\n");
		open(OUT,">$MESSAGE_LIST2");
		print OUT @MES_REG2;
		close(OUT);
		&K_LOG("$mmonth月:$cnoに密書を送りました。");
		$kcha_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;