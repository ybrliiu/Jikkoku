#_/_/_/_/_/_/_/_/#
#      鍛錬      #
#_/_/_/_/_/_/_/_/#

sub TANREN {

	$ksub2=0;
	if(($kgold < 500 && $ktanskl eq "")||($kgold < 300 && $ktanskl eq "0")||($kgold < 100 && ($ktanskl eq "1" || $ktanskl eq "2"))){
		&K_LOG("$mmonth月:金が足りません。");
	}else{
		if($cnum eq "1"){
			$kstr_ex +=2;
			if($ktanskl eq "2"){	#鍛錬スキル処理
			$kstr_ex +=2;
			}
			$a_mes = "武力";
		}elsif($cnum eq "2"){
			$kint_ex +=2;
			if($ktanskl eq "2"){	#鍛錬スキル処理
			$kint_ex +=2;
			}
			$a_mes = "知力";
		}elsif($cnum eq "3"){
			$klea_ex +=2;
			if($ktanskl eq "2"){	#鍛錬スキル処理
			$klea_ex +=2;
			}
			$a_mes = "統率力";
		}else{
			$kcha_ex +=2;
			if($ktanskl eq "2"){	#鍛錬スキル処理
			$kcha_ex +=2;
			}
			$a_mes = "人望";
		}
		if($ktanskl eq "0"){		#鍛錬スキル処理
		$kgold-=300;
		}elsif($ktanskl eq "1"){
		$kgold-=100;
		}elsif($ktanskl eq "2"){
		$kgold-=100;
		}else{
		$kgold-=500;
		}
		$k_tan++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
		&K_LOG("$mmonth月:$a_mesを強化しました。");
	}

}
1;
