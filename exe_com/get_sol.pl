#_/_/_/_/_/_/_/_/#
#      徴兵      #
#_/_/_/_/_/_/_/_/#

sub GET_SOL {

  $ksub2=0;
#BM読み込み
  if ($ksyuppei) { do "./log_file/map_hash/$kiti.pl"; }
  if ( $ksyuppei &&
      ( $kiti ne $kpos || $zcon ne $kcon ||
        ( $BM_TIKEI[$ky][$kx] != 18 && $BM_TIKEI[$ky][$kx] != 22 )
    )
  ) {
    $kcex += 30;
    if(($kint > $kstr)&&($kint > $kcha)&&($kint > $klea)){
      $kint_ex++;
      $upmes = "知力";
    }elsif(($klea > $kstr)&&($klea > $kcha)&&($klea > $kint)){
      $klea_ex++;
      $upmes = "統率力";
    }elsif(($kcha > $kstr)&&($kcha > $klea)&&($kcha > $kint)){
      $kcha_ex++;
      $upmes = "人望";
    }else{
      $kstr_ex++;
      $upmes = "武力";
    }
    $ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
    $kmei++;
    $ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
    &K_LOG("$mmonth月:【コマンド失敗】出撃しているときは徴兵できません。$upmes経験値+1 貢献値+30");
  }elsif($kgold < $cnum * $SOL_PRICE[$csub]){
    &K_LOG("$mmonth月:【軍事】：所持金がたりません。");
  }elsif($zsub1 < $SOL_TEC[$csub]){
    &K_LOG("$mmonth月:【軍事】：都市の技術が足りません。");
  }elsif($znum < $cnum * 6){
    &K_LOG("$mmonth月:【軍事】：農民がたりません。");
  }elsif($zpri < int($cnum / 10)){
    &K_LOG("$mmonth月:【軍事】：農民が拒否しました。");
  }else{
    if($ksub1_ex eq $csub || $ksub1_ex eq "" && $csub eq 0){
      if($ksol + $cnum > $klea){
        $cnum = $klea - $ksol;
      }
      $ksol += $cnum;
      $sklmes = 0;
    }else{
      if($cnum > $klea){
        $cnum = $klea;
      }
      $ksol = $cnum;

      if((($ksub1_ex eq "12")||($ksub1_ex eq "68"))&&(($csub eq "12")||($csub eq "68"))){
        $sklmes = 0;
      }elsif((($ksub1_ex eq "28")||($ksub1_ex eq "29"))&&(($csub eq "28")||($csub eq "29"))){
        $sklmes = 0;
      }elsif((($ksub1_ex eq "100")||($ksub1_ex eq "101")||($ksub1_ex eq "102")||($ksub1_ex eq "104"))&&(($csub eq "100")||($csub eq "101")||($csub eq "102")||($csub eq "104"))){
        $sklmes = 0;
      }elsif($SOL_ZOKSEI[$ksub1_ex] eq "歩" && $SOL_ZOKSEI[$csub] eq "歩"){
        $sklmes=0;
      }else{
        $sklmes = 1;
      }

      if((($ksub1_ex eq "12")||($ksub1_ex eq "68"))&&($sklmes)){
        &K_LOG("$mmonth月:【<font color=red>忘却</font>】$SOL_TYPE[$ksub1_ex]を解雇したのでスキル：攻城１【小】を忘却しました。");
      }elsif((($ksub1_ex eq "100")||($ksub1_ex eq "101")||($ksub1_ex eq "102")||($ksub1_ex eq "104"))&&($sklmes)){
        &K_LOG("$mmonth月:【<font color=red>忘却</font>】$SOL_TYPE[$ksub1_ex]を解雇したのでスキル：火薬を忘却しました。");
      }elsif(($ksub1_ex eq "103")&&($sklmes)){
        &K_LOG("$mmonth月:【<font color=red>忘却</font>】$SOL_TYPE[$ksub1_ex]を解雇したのでスキル：精鋭を忘却しました。");
        &K_LOG("$mmonth月:【<font color=red>忘却</font>】$SOL_TYPE[$ksub1_ex]を解雇したのでスキル：略奪を忘却しました。");
      }elsif(($ksub1_ex eq "29" || $ksub1_ex eq "28")&&($sklmes)){
        &K_LOG("$mmonth月:【<font color=red>忘却</font>】$SOL_TYPE[$ksub1_ex]を解雇したのでスキル：攻城１【大】を忘却しました。");
      }elsif($SOL_ZOKSEI[$ksub1_ex] eq "歩" && $sklmes){
        &K_LOG("$mmonth月:【<font color=red>忘却</font>】$SOL_TYPE[$ksub1_ex]を解雇したのでスキル：掩護を忘却しました。");
      }

    }
    $kgat -= $cnum;
    if($kgat < 0 ){
      $kgat = 0;
    }
    $ksub1_ex = $csub;
    $kcex += 30;
    $ming = $cnum * $SOL_PRICE[$csub];
    $kgold -= $ming;
    $znum -= $cnum * 6;		
    if($cnum > 309){
      $zpri -= 30;
    }else{
      $zpri -= int($cnum / 10);
    }
    if("$zname" ne ""){
      splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
    }
    &K_LOG("$mmonth月:$SOL_TYPE[$ksub1_ex]を<font color=red>+$cnum</font>徴兵しました。金<font color=red>-$ming</font>");

    if((($csub eq "12")||($csub eq "68"))&&($sklmes)){
      &K_LOG("$mmonth月:【<font color=red>修得</font>】$SOL_TYPE[$csub]の効果によりスキル：攻城１【小】を修得しました。");
    }elsif((($csub eq "100")||($csub eq "101")||($csub eq "102")||($csub eq "104"))&&($sklmes)){
      &K_LOG("$mmonth月:【<font color=red>修得</font>】$SOL_TYPE[$csub]の効果によりスキル：火薬を修得しました。");
    }elsif(($csub eq "103")&&($sklmes)){
      &K_LOG("$mmonth月:【<font color=red>修得</font>】$SOL_TYPE[$csub]の効果によりスキル：精鋭を修得しました。");
      &K_LOG("$mmonth月:【<font color=red>修得</font>】$SOL_TYPE[$csub]の効果によりスキル：略奪を修得しました。");
    }elsif(($csub eq "29" || $csub eq "28")&&($sklmes)){
      &K_LOG("$mmonth月:【<font color=red>修得</font>】$SOL_TYPE[$csub]の効果によりスキル：攻城１【大】を修得しました。");
    }elsif(($SOL_ZOKSEI[$csub] eq "歩")&&($sklmes)){
      &K_LOG("$mmonth月:【<font color=red>修得</font>】$SOL_TYPE[$csub]の効果によりスキル：掩護を修得しました。");
    }

    # 状態をリセット,skl_lib.pl
    RESET_STATE();

    if(($kint > $kstr)&&($kint > $kcha)&&($kint > $klea)){$kint_ex++;}
    elsif(($klea > $kstr)&&($klea > $kcha)&&($klea > $kint)){$klea_ex++;}
    elsif(($kcha > $kstr)&&($kcha > $klea)&&($kcha > $kint)){$kcha_ex++;}
    else{
      $kstr_ex++;
    }
    $ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
    $kmei++;
    $ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
  }

}
1;
