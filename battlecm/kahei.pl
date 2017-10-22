#_/_/_/_/_/_/_/_/_/_/#
#      徴募スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub KAHEI {

  $idate = time();
  &TOWN_DATA_OPEN;  

  ($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
  ($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

  $ksiki -= $MOR_TYOUBO;
  if(!$ksyuppei){
    &ERR("出撃していません。");
  }elsif($idate < $kkoutime){
    $nokori = $kkoutime-$idate;
    &ERR("あと $nokori秒 行動できません。");
  }elsif($kskl2 eq "" || $kskl2 eq "0"){
    &ERR("徴募スキルを修得していません。");
  }elsif($ksiki < 0){
    &ERR("士気が足りません。");
  }else{

  #バトルマップ読み込み
  require "./log_file/map_hash/$kiti.pl";

  $okhit = 0;
  if($BM_TIKEI[$ky][$kx] == 4 ){
    $okhit = 1;
  }elsif($BM_TIKEI[$ky][$kx] == 16){
    $okhit = 1;
  }elsif($BM_TIKEI[$ky][$kx] == 17){
    $okhit = 1;
  }elsif($BM_TIKEI[$ky][$kx] == 18){
    $okhit = 1;
  }elsif($BM_TIKEI[$ky][$kx] == 19){
    $okhit = 1;
  }elsif($BM_TIKEI[$ky][$kx] == 22){
    $okhit = 1;
  }else{
    $okhit = 0;
  }


  if(!$okhit){
    &ERR("自軍がいる地形が住宅地、城、砦、関所のいずれかでなければこのスキルは使用できません。");
  }else{
  $krice -= 100;


  if($krice < 0){
    &ERR("米が足りません。");
  }

  if($ksol >= $klea){
    &ERR("これ以上兵士を持てません。");
  }

  $kaheiran = int(rand(int($kcha/20)))+1;
  $kahei1 = $kaheiran;
  $ksol += $kahei1;
  if($ksol > $klea){
  $kahei1 -= $ksol - $klea;
  $ksol = $klea;
  }

  $genmoney = $SOL_PRICE[$ksub1_ex]*$kahei1;
  $kgold1 = $kgold;
  $kgold1 -= $genmoney;
  if($kgold1 < 0){
    if($kgold < $SOL_PRICE[$ksub1_ex]){
    &ERR("金が足りません。");
    }else{
    $kahei1 = int($kgold/$SOL_PRICE[$ksub1_ex]);
    $genmoney = $SOL_PRICE[$ksub1_ex]*$kahei1;
    }
  }
  $kgold -= $genmoney;

  $kgat -= $kahei1;
  if($kgat < 0){
  $kgat = 0;
  }

  $kex_add = int($kahei1/2.5);

  &K_LOG("<font color=yellowgreen>【徴募】</font>兵を集めました。+<font color=red>$kahei1</font>人 金-<font color=red>$genmoney</font> 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.02</font>");
  &K_LOG2("<font color=yellowgreen>【徴募】</font>兵を集めました。+<font color=red>$kahei1</font>人 金-<font color=red>$genmoney</font> 貢献値+<font color=red>$kex_add</font> 書物威力+<font color=red>0.02</font>");
  &MAP_LOG("<font color=orange>【支援】</font>$knameは$knameに支援を行いました。($battkemapname\)");

  $kbook += 0.02;
  $kcex += $kex_add;
  $kkoutime = $idate+int($BMT_REMAKE*1.5);
  $ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
  &CHARA_MAIN_INPUT;
    }
  }

  &HEADER;

  print <<"EOM";
<CENTER><hr size=0><h2>徴募を行いました。</h2><p>
<form action="$BACK" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="OK">
</form>
</CENTER>
EOM
  &FOOTER;

  exit;

}
1;
