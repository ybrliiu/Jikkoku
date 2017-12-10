#_/_/_/_/_/_/_/_/#
#      すきる      #
#_/_/_/_/_/_/_/_/#

sub MYSKL {

  &CHARA_MAIN_OPEN;
  &COUNTRY_DATA_OPEN("$kcon");
  &TIME_DATA;
  &HEADER;

  #スキル消費士気読み込み
  require "./lib/skl_lib.pl";

  ($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);

  ($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
#支援スキル(文)、1妨害スキル、2仁官用,3移動スキル,4武官用,5統率官用,6自動集合,7武官用2,8仁官用2#

  ($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);

  ($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);

  $ksentou = $kbouwin+$kkouwin+$kkoulos+$kboulos+$khiki;


#確率や待機時間
  $k = $kint*0.0035;
  if($k > 0.6){$k = 0.6;}
  $kk = int($k*100);
  $kkk = int($kint*1.3);
  if($kkk > $BMT_REMAKE*2){
  $kkk = $BMT_REMAKE*2;
  }

  $st_kaku = $kint*0.006;
  if($st_kaku > 0.9){$st_kaku = 0.9;}
  $st_kaku = int($st_kaku*100);
  $st_time = int($kint*1.5);
  if($st_time > $BMT_REMAKE*2){
  $st_time = $BMT_REMAKE*2;
  }

  $ta = $kint / 1000;
  if($ta > 0.33){$ta = 0.33;}
  $tata = int($ta*100);

  $t = $klea / 1000;
  if($t > 0.33){$t = 0.33;}
  $tt = int($t*100);

  $g = $kstr / 1000;
  if($g > 0.33){$g = 0.33;}
  $gg = int($g*100);

  $siensol = int(($kint+$klea)/5);

  $kaheisol2 = int($kcha/20);
  if($kaheisol2 < 1){$kaheisol2 = 1;}

  $totukaku = int($klea/9);
  if($totukaku > 35){$totukaku=35;}
  $kseikaku = int($klea/12);
  if($kseikaku > 30){$kseikaku=30;}
  $mssykaku = int($klea/12);
  if($mssykaku > 30){$mssykaku=30;}

  $keikaku = int($kstr/9);
  if($keikaku > 35){$keikaku=35;}
  $kaikaku = int($kstr/10);
  if($kaikaku > 33){$kaikaku=33;}
  $hakkaku = int($kstr/33);
  if($hakkaku > 10){$hakkaku=10;}
  $giskaku = int($kstr/10);
  if($giskaku > 33){$giskaku=33;}
  $kyosyudn = int($kstr/50)+3;

  $yokukaku = int($kstr/3);
  if($yokukaku > 60){$yokukaku=60;}
  $mokokaku = int($kstr/9);
  if($mokokaku > 33){$mokokaku=33;}
  $hajyokaku = int($kstr/10);
  if($hajyokaku > 30){$hajyokaku=30;}

  $rikakaku = int($kint/10);
  if($rikakaku > 27){$rikakaku=27;}

  
  $koutime = $BMT_REMAKE;
  $koutime1 = $BMT_REMAKE/2;
  $koutime2 = $BMT_REMAKE*2/3;
  $koutime3 = $BMT_REMAKE*1.5;
  $koutime4 = int($BMT_REMAKE/2);
  $koutime5 = int($BMT_REMAKE*3/4);

#文官用スキル1#
  if($ksien ne "" && $ksien ne "0"){
  $hokyu = "<TR><TD bgcolor=$TD_C2><b>補給</b></TD><TD bgcolor=$TD_C2>自軍兵士が統率力の半分以上いるとき、自軍兵士を1〜<b>$siensol</b>人味方の部隊に引き渡す。<br>引き渡した人数×相手兵種の値段 相手の金は減少する。<br>また、引き渡した人数分引き渡された軍の訓練値は減少する。<br>ただし、引き渡す側と引き渡される側の兵種が同じ場合、金と訓練値は減少しない。<br>引き渡す人数は統率力＋知力に依存。（行動）</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを5消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime</b>秒<br>リーチ：1<br>消費士気：$MOR_HOKYU</TD></TR>";
  }
  if(($ksien eq "2")||($ksien eq "3")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){

  $kagoseikou = int($kint/1.8);
  if($kagoseikou > 80){$kagoseikou = 80;}
  $kagojikan = int(($kint/30)*60);
  $kagojikan2 = int(($kint/10)*60);

  $kagoH = "<TR><TD bgcolor=$TD_C2><b>加護【小】</b></TD><TD bgcolor=$TD_C2>指定した味方部隊の守備力が7％＋5上昇する。効果持続時間は<b>$kagojikan</b>〜<b>$kagojikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C2>補給を修得していること。<br>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime1</b>秒<br>成功率：<b>$kagoseikou</b>%<br>リーチ：3<br>消費士気：$MOR_S</TD></TR>";
  }
  if(($ksien eq "3")||($ksien eq "7")||($ksien eq "8")){

  $kagoLseikou = int($kint/2);
  if($kagoLseikou > 100){$kagoLseikou = 100;}
  $kagoLjikan = int(($kint/20)*60);
  $kagoLjikan2 = int(($kint/10)*60);

  $kagoLH = "<TR><TD bgcolor=$TD_C2><b>加護【大】</b></TD><TD bgcolor=$TD_C2>指定した味方部隊の守備力が15％＋10上昇する。効果持続時間は<b>$kagoLjikan</b>〜<b>$kagoLjikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C2>加護【小】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime2</b>秒<br>成功率：<b>$kagoLseikou</b>%<br>リーチ：4<br>消費士気：$MOR_L</TD></TR>";
  }
  if(($ksien eq "4")||($ksien eq "5")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){

  $kyoudouseikou = int($kint/1.8);
  if($kyoudouseikou > 80){$kyoudouseikou = 80;}
  $kyoudoujikan = int(($kint/30)*60);
  $kyoudoujikan2 = int(($kint/10)*60);

  $youdou = "<TR><TD bgcolor=$TD_C2><b>陽動【小】</b></TD><TD bgcolor=$TD_C2>指定した敵部隊の攻撃力を7％減少させる。効果持続時間は<b>$kyoudoujikan</b>〜<b>$kyoudoujikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C2>補給を修得していること。<br>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime1</b>秒<br>成功率：<b>$kyoudouseikou</b>%<br>リーチ：3<br>消費士気：$MOR_S</TD></TR>";
  }
  if(($ksien eq "5")||($ksien eq "8")||($ksien eq "9")){

  $kyoudouLseikou = int($kint/2);
  if($kyoudouLseikou > 100){$kyoudouLseikou = 100;}
  $kyoudouLjikan = int(($kint/20)*60);
  $kyoudouLjikan2 = int(($kint/10)*60);

  $youdouL = "<TR><TD bgcolor=$TD_C2><b>陽動【大】</b></TD><TD bgcolor=$TD_C2>指定した敵部隊の攻撃力を15％減少させる。効果持続時間は<b>$kyoudouLjikan</b>〜<b>$kyoudouLjikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C2>陽動【小】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime2</b>秒<br>成功率：<b>$kyoudouLseikou</b>%<br>リーチ：4<br>消費士気：$MOR_L</TD></TR>";
  }

#文官用スキル2#
  if($kskl1 ne "" && $kskl1 ne "0"){
  $konran = "<TR><TD bgcolor=$TD_C2><b>混乱</b></TD><TD bgcolor=$TD_C2>相手が最大<b>$kkk</b>秒移動以外の行動ができないようにする。<br>成功率、相手を行動できなくする時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime</b>秒<br>成功率：<b>$kk</b>%<br>リーチ：2<br>消費士気：$MOR_KONRAN</TD></TR>";
  }

  use lib './lib', './extlib';
  use Jikkoku::Model::Chara;
  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = $chara_model->get($kid);

  use Jikkoku::Class::Skill::Disturb::Stuck;
  my $stuck = Jikkoku::Class::Skill::Disturb::Stuck->new({ chara => $chara });
  if ( $stuck->is_acquired ) {
    $asidome = <<"EOS";
<TR>
  <TD bgcolor=$TD_C2><strong>@{[ $stuck->name ]}</TD>
  <TD bgcolor=$TD_C2>@{[ $stuck->description_of_effect ]}</TD>
  <TD bgcolor=$TD_C2>@{[ $stuck->description_of_acquire ]}</TD>
  <TD bgcolor=$TD_C2>@{[ $stuck->description_of_status ]}</TD>
</TR>
EOS
  }

  if($kskl1 >= 3){
  $rikan = "<TR><TD bgcolor=$TD_C2><b>離間</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。敵部隊に離間工作をしかけ、敵兵を数人自分の部隊に引き入れる。<br>発動率は知力に依存。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$rikakaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }

#仁官用スキル1#
  if($kskl2 ne "" && $kskl2 ne "0"){
  $kahei = "<TR><TD bgcolor=$TD_C2><b>徴募</b></TD><TD bgcolor=$TD_C2>自軍のいる地形が住宅地、砦、城、関所の時のみ使える。自軍兵士が1人〜<b>$kaheisol2</b>人増える。<br>50R消費。また、兵士増加分訓練値と金が減少。<br>増える兵数は人望に依存。（行動）<br>※自分にしか使えません。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを5消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime3</b>秒<br>消費士気：$MOR_TYOUBO</TD></TR>";
  }
  if(($kskl2 eq "2")||($kskl2 eq "3")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){

  $kobuseikou = int($kcha/1.8);
  if($kobuseikou > 80){$kobuseikou = 80;}
  $kobujikan = int(($kcha/30)*60);
  $kobujikan2 = int(($kcha/10)*60);

  $kobuH = "<TR><TD bgcolor=$TD_C2><b>鼓舞【小】</b></TD><TD bgcolor=$TD_C2>指定した味方部隊の攻撃力が7％上昇する。効果持続時間は<b>$kobujikan</b>〜<b>$kobujikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C2>徴募を修得していること。<br>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime1</b>秒<br>成功率：<b>$kobuseikou</b>%<br>リーチ：3<br>消費士気：$MOR_S</TD></TR>";
  }
  if(($kskl2 eq "3")||($kskl2 eq "7")||($kskl2 eq "8")){

  $kobuLseikou = int($kcha/2);
  if($kobuLseikou > 100){$kobuLseikou = 100;}
  $kobuLjikan = int(($kcha/20)*60);
  $kobuLjikan2 = int(($kcha/10)*60);

  $kobuLH = "<TR><TD bgcolor=$TD_C2><b>鼓舞【大】</b></TD><TD bgcolor=$TD_C2>指定した味方部隊の攻撃力が15％上昇する。効果持続時間は<b>$kobuLjikan</b>〜<b>$kobuLjikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C2>鼓舞【小】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime2</b>秒<br>成功率：<b>$kobuLseikou</b>%<br>リーチ：4<br>消費士気：$MOR_L</TD></TR>";
  }
  if(($kskl2 eq "4")||($kskl2 eq "5")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){

  $sendouseikou = int($kcha/1.8);
  if($sendouseikou > 80){$sendouseikou = 80;}
  $sendoujikan = int(($kcha/30)*60);
  $sendoujikan2 = int(($kcha/10)*60);

  $sendou = "<TR><TD bgcolor=$TD_C2><b>扇動【小】</b></TD><TD bgcolor=$TD_C2>指定した敵部隊の守備力を7％+5減少させる。効果持続時間は<b>$sendoujikan</b>〜<b>$sendoujikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C2>徴募を修得していること。<br>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime1</b>秒<br>成功率：<b>$sendouseikou</b>%<br>リーチ：3<br>消費士気：$MOR_S</TD></TR>";
  }
  if(($kskl2 eq "5")||($kskl2 eq "8")||($kskl2 eq "9")){

  $sendouLseikou = int($kcha/2);
  if($sendouLseikou > 100){$sendouLseikou = 100;}
  $sendouLjikan = int(($kcha/20)*60);
  $sendouLjikan2 = int(($kcha/10)*60);

  $sendouL = "<TR><TD bgcolor=$TD_C2><b>扇動【大】</b></TD><TD bgcolor=$TD_C2>指定した敵部隊の守備力を15％+10減少させる。効果持続時間は<b>$sendouLjikan</b>〜<b>$sendouLjikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C2>扇動【小】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime2</b>秒<br>成功率：<b>$sendouLseikou</b>%<br>リーチ：4<br>消費士気：$MOR_L</TD></TR>";
  }

#仁官用スキル2-移動補助#
  if($kskl8 =~ /1/){
  $syukuti = int($kcha/5);if($syukuti > 50){$syukuti = 50;}
  $syuku_seikou = int($kcha*0.65);if($syuku_seikou > 90){$syuku_seikou=90;}
  $i_hojyo = "<TR><TD bgcolor=$TD_C2><b>縮地</b></TD><TD bgcolor=$TD_C2>味方の移動ポイント補充時間を<b>$syukuti</b>秒短縮する。<br>短縮する時間、成功率は人望に依存。(行動)</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime5</b>秒<br>成功率：<b>$syuku_seikou</b>%<br>リーチ：4<br>消費士気：$MOR_SYUKUTI</TD></TR>";
  }
  if($kskl8 =~ /2/){
  $kasoku = int($kcha/30);if($kasoku > 10){$kasoku = 10;}
  $kasoku_seikou = int($kcha*0.55);if($kasoku_seikou > 95){$kasoku_seikou=95;}
  $i_hojyo2 = "<TR><TD bgcolor=$TD_C2><b>加速</b></TD><TD bgcolor=$TD_C2>味方の移動ポイントを上限を超えて+<b>$kasoku</b>する。<br>プラスする移動ポイント、成功率は人望に依存。(行動)<br>※移動ポイントが50以上の場合は増やせない。</TD><TD bgcolor=$TD_C2>縮地を修得していること。<br>スキル修得ページでSPを13消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime2</b>秒<br>成功率：<b>$kasoku_seikou</b>%<br>リーチ：5<br>消費士気：$MOR_KASOKU</TD></TR>";
  }
  if($kskl8 =~ /3/){
  $sendouLjikan = int(($kcha/20)*60);$sendouLjikan2 = int(($kcha/10)*60);
  $kinto_seikou = int($kcha*0.45);if($kinto_seikou > 90){$kinto_seikou=90;}
  $i_hojyo3 = "<TR><TD bgcolor=$TD_C2><b>觔斗雲</b></TD><TD bgcolor=$TD_C2>味方に觔斗雲を付与し、消費移動Pが多い地形での消費移動Pを抑える。<br>觔斗雲の効果中は消費移Pが3以上の地形に移動した時に消費する移Pが3になる。<br>効果持続時間は<b>$sendouLjikan</b>〜<b>$sendouLjikan2</b>秒。効果持続時間、成功率は人望に依存。(行動)</TD><TD bgcolor=$TD_C2>加速を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime5</b>秒<br>成功率：<b>$kinto_seikou</b>%<br>リーチ：4<br>消費士気：$MOR_KINTOUN</TD></TR>";
  }
  if($kskl8 =~ /4/){
  $kaihi_kaku = int($kcha/9);if($kaihi_kaku > 33){$kaihi_kaku = 33;}
  $i_hojyo4 = "<TR><TD bgcolor=$TD_C2><b>回避</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。自軍がは敵からの攻撃を完全に回避し、そのターン敵から受けるダメージが0になる。<br>発動率は人望に依存。</TD><TD bgcolor=$TD_C2>加速を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$kaihi_kaku</b>%</TD></TR>";
  }

#移動スキル#
  if($kskl3 ne "" && $kskl3 ne "0"){
  $idou = "<TR><TD bgcolor=$TD_C2><b>駿足【小】</b></TD><TD bgcolor=$TD_C2>最大移動ポイントが+1される。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを4消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kskl3 eq "2" || $kskl3 eq "3"){
  $idou2 = "<TR><TD bgcolor=$TD_C2><b>迅速</b></TD><TD bgcolor=$TD_C2>移動ポイント補充にかかる時間が20秒短縮される。</TD><TD bgcolor=$TD_C2>駿足【小】を修得していること。<br>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kskl3 eq "3"){
  $idou3 = "<TR><TD bgcolor=$TD_C2><b>駿足【大】</b></TD><TD bgcolor=$TD_C2>最大移動ポイントが+3される。</TD><TD bgcolor=$TD_C2>迅速を修得していること。<br>スキル修得ページでSPを12消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

#武官用スキル#
  if($kskl4 =~ /0/){
  $bukan = "<TR><TD bgcolor=$TD_C2><b>計数攻撃</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。出撃中計数攻撃が発動した回数+3ダメージ与える。（但しダメージが増えるのは発動回数15回まで。）<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを5消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$keikaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }if($kskl4 =~ /1/){
  $bukan1 = "<TR><TD bgcolor=$TD_C2><b>破壊攻撃</b></TD><TD bgcolor=$TD_C2>戦闘中に低確率でイベント発生。相手に大ダメージを与える。<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C2>計数攻撃を修得していること。<br>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$hakkaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }if($kskl4 =~ /2/){
  $bukan2 = "<TR><TD bgcolor=$TD_C2><b>会心攻撃</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。そのターン相手に与えるダメージが1.5倍になる。<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C2>計数攻撃を修得していること。<br>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$kaikaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }if($kskl4 =~ /3/ || $kskl4 =~ /5/){
    if($kskl4 =~ /3/){
    $kirikae = "on";
    $g_on = "checked";
    }else{
    $kirikae = "off";
    $g_off = "checked";
    }
  $bukan3 = "<TR><TD bgcolor=$TD_C2><b>犠牲攻撃</b></TD><form action=\"./mydata.cgi\" method=\"post\"><TD bgcolor=$TD_C2>戦闘中にイベント発生。自軍の兵士を何人か犠牲にし、相手に犠牲になった兵士×3のダメージを与える。(城壁戦は犠牲にした兵士×10)<br>但し、犠牲にする兵数は自軍の兵数が1人より少なくなるようにすることはない。<br>発動率は武力に依存。<br>・on/off切り替え(現在:<b>$kirikae</b>)　<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=GISEI_KIRIKAE><input type=radio name=gisei value=1 $g_on>on<input type=radio name=gisei value=0 $g_off>off<input type=submit value=\"切り替え\"></TD></form><TD bgcolor=$TD_C2>破壊攻撃を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$giskaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }if($kskl4 =~ /4/){
  $bukan4 = "<TR><TD bgcolor=$TD_C2><b>強襲</b></TD><TD bgcolor=$TD_C2>自軍の攻守を+<b>$kyosyudn</b>\%、相手の攻守を-<b>$kyosyudn</b>\%して戦闘を仕掛ける。また、最初のターンに相手にダメージを与える。<br>自軍の攻守が上昇する割合と相手の攻守が減少する割合は武力に依存。（戦闘モード）</TD><TD bgcolor=$TD_C2>会心攻撃を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime</b>秒<br>消費士気：$MOR_KYOSYU</TD></TR>";
  }

#武官用侵攻用スキル#
  $aplus=5;
  if($kskl7 =~ /1/){
  $sinko = "<TR><TD bgcolor=$TD_C2><b>侵攻強化</b></TD><TD bgcolor=$TD_C2>侵攻側かつ武力が100以上の時、攻撃力+15。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを5消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  if($kskl7 =~ /2/){
  $sinko2 = "<TR><TD bgcolor=$TD_C2><b>進撃</b></TD><TD bgcolor=$TD_C2>武力が115以上の時使用可能。<br>侵攻側の時、使用してから410秒間攻撃力が25%上昇、その後200秒間守備力-50%。<br>防衛側の時、使用してから610秒間守備力-50%。（行動）</TD><TD bgcolor=$TD_C2>侵攻強化を修得していること。<br>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>消費士気:$MOR_SINGEKI<br>再使用時間：1200秒</TD></TR>";
  }
  if($kskl7 =~ /3/){
    if($kskl7 =~ /4/){
    $aplus=10;
    }
  $sinko3 = "<TR><TD bgcolor=$TD_C2><b>猛攻</b></TD><TD bgcolor=$TD_C2>侵攻側かつ武力が130以上の時、攻守+5%。(計$aplus%)<br>また、戦闘中にイベント発生。発動毎に攻撃力が+20され、敵にダメージを与える。<br>発動率は武力に依存。<br>※上昇した攻撃力は撤退すると元に戻る。<br>※1回の出撃中に上昇する攻撃力は60まで。<br>※攻城戦は発動率が半減する。</TD><TD bgcolor=$TD_C2>進撃を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$mokokaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }
  if($kskl7 =~ /4/){
    if($kskl7 =~ /3/){
    $aplus=10;
    }
  $sinko4 = "<TR><TD bgcolor=$TD_C2><b>波状攻撃</b></TD><TD bgcolor=$TD_C2>侵攻側かつ武力が130以上の時、攻守+5%(計$aplus%)、波状攻撃モード使用可能。<br><b>波状攻撃モード</b>：行動待機時間が通常の戦闘の2/3になる。<br>さらに戦闘中に波状攻撃イベント発生。敵に数ダメージ与える。城壁戦にも有効。<br>波状攻撃イベントの発動率は武力に依存。（戦闘モード）</TD><TD bgcolor=$TD_C2>進撃を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime2</b>秒<br>波状攻撃：<b>$hajyokaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]<br>消費士気：$MOR_HAJYO</TD></TR>";
  }

#統率官用スキル#
  if($kskl5 =~ /0/){
  $tosotu = "<TR><TD bgcolor=$TD_C2><b>突撃</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。相手にダメージを与える。<br>発動率は統率力に依存。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを5消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$totukaku</b>%<br>リーチ：1</TD></TR>";
  }if($kskl5 =~ /0/ && $kskl5 =~ /1/){
  $tosotu1 = "<TR><TD bgcolor=$TD_C2><b>攻勢</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。発動毎に攻撃力が+10され、相手に少しダメージを与える。<br>発動率は統率力に依存。<br>※上昇した攻撃力は撤退すると元に戻る。<br>※1回の出撃中に上昇する攻撃力は50まで。<br>※攻城戦は発動率が半減する。</TD><TD bgcolor=$TD_C2>突撃を修得していること。<br>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$kseikaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }if($kskl5 =~ /0/ && $kskl5 =~ /2/){
  $tosotu2 = "<TR><TD bgcolor=$TD_C2><b>密集</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。発動毎に守備力が+10される。<br>発動率は統率力に依存。<br>※上昇した守備力は撤退すると元に戻る。<br>※1回の出撃中に上昇する守備力は50まで。<br>※攻城戦は発動率が半減する。</TD><TD bgcolor=$TD_C2>突撃を修得していること。<br>スキル修得ページでSPを10消費して修得。</TD><TD bgcolor=$TD_C2>発動率：<b>$mssykaku</b>%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }if($kskl5 =~ /0/ && $kskl5 =~ /1/ && $kskl5 =~ /3/){
  $tosotu3 = "<TR><TD bgcolor=$TD_C2><b>包囲</b></TD><TD bgcolor=$TD_C2>敵が30人以下の時、(自軍-敵軍)×1.5だけ攻撃力上昇。（戦闘モード）</TD><TD bgcolor=$TD_C2>攻勢を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime</b>秒<br>消費士気：$MOR_HOUI</TD></TR>";
  }if($kskl5 =~ /0/ && $kskl5 =~ /2/ && $kskl5 =~ /4/){
  $tosotu4 = "<TR><TD bgcolor=$TD_C2><b>陣形再編</b></TD><TD bgcolor=$TD_C2>陣形の再編にかかる時間を使用時の1/4に短縮する。（行動）</TD><TD bgcolor=$TD_C2>密集を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime4</b>秒<br>消費士気：$MOR_SAIHEN</TD></TR>";
  }

#未使用#
  if(($ksz eq "2")||($ksz eq "1")){
  $zouen = "<TR><TD bgcolor=$TD_C2>増援</TD><TD bgcolor=$TD_C2>増援：自軍兵士が少し増える。<br>発動率は知力に依存。</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>$zz％</TD></TR>";}
  if($ksz eq "2"){
  $timea = "<TR><TD bgcolor=$TD_C2>時間攻撃</TD><TD bgcolor=$TD_C2>時間攻撃：敵軍に発動した時のターン数ダメージを与える。<br>発動率は知力に依存。</TD><TD bgcolor=$TD_C2>増援スキルを修得した後<BR>スキル修得ページで100000G払い修得。</TD><TD bgcolor=$TD_C2>$tata％</TD></TR>";}
  if(($ksg eq "2")||($ksg eq "1")){
  $rentou = "<TR><TD bgcolor=$TD_C2>連闘</TD><TD bgcolor=$TD_C2>１ターンに２回まで<BR>連続で戦闘ができるようになる。</TD><TD bgcolor=$TD_C2>スキル修得ページで40000G払い修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  if($ksg eq "2"){
  $gisei = "<TR><TD bgcolor=$TD_C2>犠牲攻撃</TD><TD bgcolor=$TD_C2>犠牲攻撃：自軍兵士を数名犠牲にして、<br>犠牲にした兵数×２だけ相手兵数を減らす。<br>(攻城時は犠牲にした兵数×5)<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C2>連闘スキル修得後<br>スキル修得ページで100000G払い修得。</TD><TD bgcolor=$TD_C2>$gg％</TD></TR>";
  }
  if(($ksub1_ex eq "40")||($ksub1_ex eq "41")||($ksub1_ex eq "42")||($ksub1_ex eq "44")){
  $kayaku = "<TR><TD bgcolor=$TD_C2>火薬</TD><TD bgcolor=$TD_C2>火薬燃焼：一回の戦闘で一度だけ発動する。<br>敵に1〜10ダメージ与える。<b>更に50%の確率で火事が発生する。<br>火事：毎ターン火薬燃焼で倒した兵数÷2ダメージ与える。</TD><TD bgcolor=$TD_C2>火槍兵、火槍騎兵、火弓兵、炎騎兵の<br>いずれかを雇っている時。</TD><TD bgcolor=$TD_C2>火薬燃焼：15%<br>火事：100%</TD></TR>";
  }

#技能系スキル#
  if(($ksub1_ex eq "12")||($ksub1_ex eq "68")){
  $koujyou1 = "<TR><TD bgcolor=$TD_C2><b>攻城１【小】</b></TD><TD bgcolor=$TD_C2>攻城時ターン数+1。</TD><TD bgcolor=$TD_C2>衝車、雲梯の<br>いずれかを雇っている時。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif(($ksub1_ex eq "29")||($ksub1_ex eq "28")){
  $koujyou1 = "<TR><TD bgcolor=$TD_C2><b>攻城１【大】</b></TD><TD bgcolor=$TD_C2>攻城時ターン数+2。</TD><TD bgcolor=$TD_C2>投石機を雇っている時。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  if($koujyou2 eq "2"){
  $koujyou2m = "<TR><TD bgcolor=$TD_C2><b>攻城２【大】</b></TD><TD bgcolor=$TD_C2>攻城時ターン数+3。</TD><TD bgcolor=$TD_C2>城壁との戦闘回数100回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($koujyou2 eq "1"){
  $koujyou2m = "<TR><TD bgcolor=$TD_C2><b>攻城２【中】</b></TD><TD bgcolor=$TD_C2>攻城時ターン数+2。</TD><TD bgcolor=$TD_C2>城壁との戦闘回数30回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($koujyou2 eq "0"){
  $koujyou2m = "<TR><TD bgcolor=$TD_C2><b>攻城２【小】</b></TD><TD bgcolor=$TD_C2>攻城時ターン数+1。</TD><TD bgcolor=$TD_C2>城壁との戦闘回数10回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  if($ksub1_ex eq "999"){
  $ryakudatu = "<TR><TD bgcolor=$TD_C2><b>略奪</b></TD><TD bgcolor=$TD_C2>略奪：戦闘前に農民から金と米を0~2000略奪する。</TD><TD bgcolor=$TD_C2>鴉軍を雇っている時。</TD><TD bgcolor=$TD_C2>100%</TD></TR>";
  $seiei = "<TR><TD bgcolor=$TD_C2>精鋭</TD><TD bgcolor=$TD_C2>兵士猛特訓をすると訓練値が750まで上昇する。</TD><TD bgcolor=$TD_C2>鴉軍を雇っている時。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  if($krenpei eq "3"){
  $renpei = "<TR><TD bgcolor=$TD_C2><b>練兵【大】</b></TD><TD bgcolor=$TD_C2>訓練系コマンドの効果が大きく上昇</TD><TD bgcolor=$TD_C2>訓練系コマンド80回<br>徴兵80回<br>戦闘回数160回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($krenpei eq "2"){
  $renpei = "<TR><TD bgcolor=$TD_C2><b>練兵【中】</b></TD><TD bgcolor=$TD_C2>訓練系コマンドの効果が上昇</TD><TD bgcolor=$TD_C2>訓練系コマンド40回<br>徴兵40回<br>戦闘回数80回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($krenpei eq "1"){
  $renpei = "<TR><TD bgcolor=$TD_C2><b>練兵【小】</b></TD><TD bgcolor=$TD_C2>訓練系コマンドの効果が少し上昇</TD><TD bgcolor=$TD_C2>訓練系コマンド20回<br>徴兵20回<br>戦闘回数40回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($krenpei eq "0"){
  $renpei = "<TR><TD bgcolor=$TD_C2><b>練兵【微】<b></TD><TD bgcolor=$TD_C2>訓練系コマンドの効果微上昇</TD><TD bgcolor=$TD_C2>訓練系コマンド10回<br>徴兵10回<br>戦闘回数20回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

  if($knaiskl eq "0"){
  $naisei = "<TR><TD bgcolor=$TD_C2><b>内政強化【小】</b></TD><TD bgcolor=$TD_C2>内政系コマンドの効果微上昇</TD><TD bgcolor=$TD_C2>内政系コマンド100回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /1/){
  $naisei = "<TR><TD bgcolor=$TD_C2><b>内政強化【大】</b></TD><TD bgcolor=$TD_C2>内政系コマンドの効果が少し上昇</TD><TD bgcolor=$TD_C2>内政系コマンド300回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /2/){
  $noutka = "<TR><TD bgcolor=$TD_C2><b>農政特化</b></TD><TD bgcolor=$TD_C2>農業開発、農地開拓を実行した時の内政値の上昇値が2.0倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /3/){
  $syoutka = "<TR><TD bgcolor=$TD_C2><b>商政特化</b></TD><TD bgcolor=$TD_C2>商業発展、市場建設を実行した時の内政値の上昇値が2.0倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /4/){
  $tectka = "<TR><TD bgcolor=$TD_C2><b>技術特化</b></TD><TD bgcolor=$TD_C2>技術開発を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /5/){
  $dbktka = "<TR><TD bgcolor=$TD_C2><b>土木特化</b></TD><TD bgcolor=$TD_C2>城壁強化、城壁拡張、城壁耐久力強化を実行した時の内政値の上昇値が1.8倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /6/){
  $jnstka = "<TR><TD bgcolor=$TD_C2><b>仁政特化</b></TD><TD bgcolor=$TD_C2>米施しを実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /7/){
  $ktktka = "<TR><TD bgcolor=$TD_C2><b>開拓特化</b></TD><TD bgcolor=$TD_C2>開拓を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($knaiskl =~ /8/){
  $nsktka = "<TR><TD bgcolor=$TD_C2><b>入植特化</b></TD><TD bgcolor=$TD_C2>入植を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。</TD><TD bgcolor=$TD_C2>内政強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

  if($kkeiskl eq "0"){
  $keiryaku = "<TR><TD bgcolor=$TD_C2><b>計略強化【小】</b></TD><TD bgcolor=$TD_C2>計略系コマンドの効果微上昇</TD><TD bgcolor=$TD_C2>計略系コマンド100回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kkeiskl =~ /1/){
  $keiryaku = "<TR><TD bgcolor=$TD_C2><b>計略強化【大】</b></TD><TD bgcolor=$TD_C2>計略系コマンドの効果が少し上昇</TD><TD bgcolor=$TD_C2>計略系コマンド300回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kkeiskl =~ /2/){
  $nou_h_tka = "<TR><TD bgcolor=$TD_C2><b>農地破壊特化</b></TD><TD bgcolor=$TD_C2>農地破壊を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>計略強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kkeiskl =~ /3/){
  $sou_h_tka = "<TR><TD bgcolor=$TD_C2><b>市場破壊特化</b></TD><TD bgcolor=$TD_C2>市場破壊を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>計略強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kkeiskl =~ /4/){
  $tec_h_tka = "<TR><TD bgcolor=$TD_C2><b>技術衰退特化</b></TD><TD bgcolor=$TD_C2>技術衰退を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>計略強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kkeiskl =~ /5/){
  $shi_h_tka = "<TR><TD bgcolor=$TD_C2><b>工事妨害特化</b></TD><TD bgcolor=$TD_C2>城壁劣化を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>計略強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($kkeiskl =~ /6/){
  $pri_h_tka = "<TR><TD bgcolor=$TD_C2><b>流言特化</b></TD><TD bgcolor=$TD_C2>流言を実行した時の内政値の減少値が1.9倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C2>計略強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  
  if($ktanskl eq "0"){
  $tanren = "<TR><TD bgcolor=$TD_C2><b>鍛錬強化【小】</b></TD><TD bgcolor=$TD_C2>能力強化コマンドを実行した時にかかる金が300Gになる。</TD><TD bgcolor=$TD_C2>能力強化コマンド100回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($ktanskl eq "1"){
  $tanren = "<TR><TD bgcolor=$TD_C2><b>鍛錬強化【大】</b></TD><TD bgcolor=$TD_C2>能力強化コマンドを実行した時にかかる金が100Gになる。</TD><TD bgcolor=$TD_C2>能力強化コマンド300回</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }if($ktanskl eq "2"){
  $tanrentka = "<TR><TD bgcolor=$TD_C2><b>鍛錬特化</b></TD><TD bgcolor=$TD_C2>能力強化を実行したときに得られる経験値が+4になる。</TD><TD bgcolor=$TD_C2>鍛錬強化【大】を修得していること。<br>スキル修得ページでSPを15消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

#自動集合
  if($kskl6 eq "1"){
  $autosyugo = "<TR><TD bgcolor=$TD_C2><b>自動集合</b></TD><TD bgcolor=$TD_C2>コマンド実行時に自動的に部隊員を部隊拠点に集合させる。<br>部隊編成画面でON/OFF切り替え可能。<br>自動集合を実行毎に500R消費。(行動)</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを3消費して修得。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

#掩護
  use Jikkoku::Class::Skill::Protect::Protect;
  my $protect = Jikkoku::Class::Skill::Protect::Protect->new({ chara => $chara });
  if ( $protect->is_acquired ) {
    $engo = <<"EOS";
<TR>
  <TD bgcolor=$TD_C2><b>@{[ $protect->name ]}</b></TD>
  <TD bgcolor=$TD_C2>@{[ $protect->description_of_effect ]}</TD>
  <TD bgcolor=$TD_C2>@{[ $protect->description_of_acquire ]}</TD>
  <TD bgcolor=$TD_C2>@{[ $protect->description_of_status ]} </TD>
</TR>
EOS
  }

#武器スキル
  if($khohei eq "1"){
  $bukiskl = "<TR><TD bgcolor=$TD_C2><b>米俵</b></TD><TD bgcolor=$TD_C2>戦闘中にイベントが発生。<br>米俵を敵に投げつけ、ダメージを与える。発動毎に500R消費。</TD><TD bgcolor=$TD_C2>武器：米俵を装備していること。</TD><TD bgcolor=$TD_C2>発動率：15%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }elsif($khohei eq "2"){
  $bukiskl = "<TR><TD bgcolor=$TD_C2><b>短陌</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。<br>銅銭を取り出し、敵に投げつける。<br>あったった個数分敵にダメージ。発動毎に500G消費。</TD><TD bgcolor=$TD_C2>武器：短陌を装備していること。</TD><TD bgcolor=$TD_C2>発動率：15%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }elsif($khohei eq "3"){
  $bukiskl = "<TR><TD bgcolor=$TD_C2><b>龜文</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。発動ターン、自分の被ダメージが1になる。</TD><TD bgcolor=$TD_C2>武器：干将・莫耶を装備していること。</TD><TD bgcolor=$TD_C2>発動率：12%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR><TR><TD bgcolor=$TD_C2><b>漫理</b></TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。敵にダメージを与える。</TD><TD bgcolor=$TD_C2>武器：干将・莫耶を装備していること。</TD><TD bgcolor=$TD_C2>発動率：12%<br>リーチ：$SOL_AT[$ksub1_ex]</TD></TR>";
  }elsif($khohei eq "7"){
  $bukiskl = "<TR><TD bgcolor=$TD_C2><b>槊</b></TD><TD bgcolor=$TD_C2>槍騎兵使用時攻撃力+10。</TD><TD bgcolor=$TD_C2>武器：槊を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($khohei eq "8"){
  $bukiskl = "<TR><TD bgcolor=$TD_C2><b>攻城弩</b></TD><TD bgcolor=$TD_C2>攻城時攻撃力+80、守備力+40、ターン数+1。</TD><TD bgcolor=$TD_C2>武器：攻城弩を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

#防具スキル
  if($kbouskl eq "1"){
  $bouskl = "<TR><TD bgcolor=$TD_C2><b>歩人甲</b></TD><TD bgcolor=$TD_C2>歩兵使用時守備力+30。</TD><TD bgcolor=$TD_C2>防具：歩人甲を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbouskl eq "2"){
  $bouskl = "<TR><TD bgcolor=$TD_C2><b>馬甲</b></TD><TD bgcolor=$TD_C2>騎兵使用時守備力+20。</TD><TD bgcolor=$TD_C2>防具：馬甲を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbouskl eq "3"){
  $bouskl = "<TR><TD bgcolor=$TD_C2><b>挂甲</b></TD><TD bgcolor=$TD_C2>騎兵使用時守備力+10。</TD><TD bgcolor=$TD_C2>防具：挂甲を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbouskl eq "4"){
  $bouskl = "<TR><TD bgcolor=$TD_C2><b>軽布甲</b></TD><TD bgcolor=$TD_C2>弓兵使用時攻撃力+20。</TD><TD bgcolor=$TD_C2>防具：軽布甲を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }
  
#書物スキル
  if($kbookskl eq "1"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>農書</b></TD><TD bgcolor=$TD_C2>農業開発、農地開拓を実行した時の内政値の上昇値が+1.0倍される。</TD><TD bgcolor=$TD_C2>書物：農書を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbookskl eq "2"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>塩鉄論</b></TD><TD bgcolor=$TD_C2>商業発展、市場建設を実行した時の内政値の上昇値が+1.0倍される。</TD><TD bgcolor=$TD_C2>書物：塩鉄論を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbookskl eq "3"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>造営法式</b></TD><TD bgcolor=$TD_C2>技術開発を実行した時の内政値の上昇値が+1.1倍される。</TD><TD bgcolor=$TD_C2>書物：造営法式を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbookskl eq "4"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>夢渓筆談</b></TD><TD bgcolor=$TD_C2>城壁強化、城壁拡張、城壁耐久力強化を実行した時の内政値の上昇値が+0.9倍される。</TD><TD bgcolor=$TD_C2>書物：夢渓筆談を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbookskl eq "5"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>戦国策</b></TD><TD bgcolor=$TD_C2>計略系コマンド実行時の効果が+0.5倍される。</TD><TD bgcolor=$TD_C2>書物：戦国策を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbookskl eq "6"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>数書九章</b></TD><TD bgcolor=$TD_C2>内政系コマンドを実行した時に上昇する書物の威力が+0.2に上昇する。</TD><TD bgcolor=$TD_C2>書物：数書九章を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }elsif($kbookskl eq "7"){
  $bookskl = "<TR><TD bgcolor=$TD_C2><b>論語</b></TD><TD bgcolor=$TD_C2>米施し、開拓、入植を実行した時の内政値の上昇値が+0.9倍される。</TD><TD bgcolor=$TD_C2>書物：論語を装備していること。</TD><TD bgcolor=$TD_C2>-</TD></TR>";
  }

  print <<"EOM";
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - スキル一覧 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele] class="mwindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>自分が修得してるスキルの一覧です。[<a href="./manual.html#ski" target="_blank">スキルについて</a>]</font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>

<form action="./mydata.cgi" method="post" align="right">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MYSKL2>
<input type=submit id=input value="スキルツリー"></form>

<TABLE bgcolor=$TABLE_C class="mwindow" style="margin:3px">
<TR><TD bgcolor=$TABLE_C colspan=3><b>●バトルマップ上</b></TD></TR>
<TR><TD bgcolor=$TD_C3 width="65">スキル名</TD><TD bgcolor=$TD_C3>説明</TD><TD bgcolor=$TD_C3>取得条件</TD><TD bgcolor=$TD_C3>待機時間、発動率など</TD></TR>

$engo
$idou
$idou3
$idou2
$hokyu
$kagoH
$kagoLH
$youdou
$youdouL
$konran
$asidome
$kahei
$kobuH
$kobuLH
$sendou
$sendouL
$bukan4
$sinko4
$tosotu3
$tosotu4
$i_hojyo
$i_hojyo2
$i_hojyo3

<TR><TD bgcolor=$TABLE_C colspan=3><b>●戦闘中</b></TD></TR>
<TR><TD bgcolor=$TD_C3>スキル名</TD><TD bgcolor=$TD_C3>説明</TD><TD bgcolor=$TD_C3>取得条件</TD><TD bgcolor=$TD_C3>発動率、リーチ</TD></TR>

$bukan
$bukan1
$bukan2
$bukan3
$sinko
$sinko2
$sinko3
$tosotu
$tosotu1
$tosotu2
$rikan
$i_hojyo4
$koujyou1
$koujyou2m
$bukiskl
$bouskl

<TR><TD bgcolor=$TABLE_C colspan=3><b>●コマンド</b></TD></TR>
<TR><TD bgcolor=$TD_C3>スキル名</TD><TD bgcolor=$TD_C3>説明</TD><TD bgcolor=$TD_C3>取得条件</TD><TD bgcolor=$TD_C3>発動率</TD></TR>

$renpei
$naisei
$noutka
$syoutka
$tectka
$dbktka
$jnstka
$ktktka
$nsktka
$keiryaku
$nou_h_tka
$sou_h_tka
$tec_h_tka
$shi_h_tka
$pri_h_tka
$tanren
$tanrentka
$autosyugo
$bookskl

</TABLE>

<br>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form>

</TD></TR></TABLE>


EOM

  &FOOTER;

  exit;

}


#犠牲攻撃on/off切り替え#
sub GISEI_KIRIKAE{

  if($in{'gisei'} eq ""){&ERR('選択されていません。');}

  &CHARA_MAIN_OPEN;
  ($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
#支援スキル(文)、1妨害スキル、2仁官用,3移動スキル,4武官用,5統率官用,6自動集合,7武官用2,8仁官用2#

  if($kskl4 !~ /3/ && $kskl4 !~ /5/){&ERR('犠牲攻撃を修得していません。');}

  if($in{'gisei'} eq "0"){
  $kskl4 =~ s/3/5/g;
  $mess = "犠牲攻撃をoffにしました。";
  }else{
  $kskl4 =~ s/5/3/g;
  $mess = "犠牲攻撃をonにしました。";
  }

  $kst = "$ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9,";
  &CHARA_MAIN_INPUT;
  &HEADER;

print <<"EOM";
<CENTER><hr size=0><h2>$mess</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="ＯＫ"></form>
<form action="./mydata.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MYSKL>
<input type=submit id=input value="スキル確認画面に戻る"></form>

</CENTER>
EOM

  &FOOTER;
  exit;
}
1;
