#_/_/_/_/_/_/_/_/#
#    米売買      #
#_/_/_/_/_/_/_/_/#

sub BUY {

  my $MAX_TRANSACTION_VALUE = 30000;

	$ksub2=0;
	if($csub){
		if($cnum > $MAX_TRANSACTION_VALUE){
			$cnum = $MAX_TRANSACTION_VALUE;
		}
		if(!$cno){
			if($kgold >= $cnum){
				if($cnum * $csub){
					$kadd = int((2-$csub) * $cnum);
				}else{
					$kadd = 0;
				}
				$kgold -= $cnum;
				$krice += $kadd;
				&K_LOG("$mmonth月:【商人】：金$cnumを支払って$kaddの米を買いました。");
				$kint_ex++;
				$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,$ktec1,$ktec2,$ktec3,$kvsub1,$kvsub2,";
			}else{
				&K_LOG("$mmonth月:【商人】：所持金がたりません。");
			}
		}else{
			if($krice >= $cnum){
				$kadd = int($cnum * $csub);
				$krice -= $cnum;
				$kgold += $kadd;
				&K_LOG("$mmonth月:【商人】：$cnumの米を売って$kaddの金を買いました。");
				$kint_ex++;
				$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,$ktec1,$ktec2,$ktec3,$kvsub1,$kvsub2,";
			}else{
				&K_LOG("$mmonth月:【商人】：米がたりません。");
			}
		}
	}

}
1;
