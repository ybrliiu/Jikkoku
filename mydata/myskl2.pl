#_/_/_/_/_/_/_/_/#
# すきる(修得順) #
#_/_/_/_/_/_/_/_/#

sub MYSKL2 {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	#消費士気読み込み
	require "./lib/skl_lib.pl";

	$sklcss=1;
	&HEADER;

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);

	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
#支援スキル(文)、妨害スキル、じんかんよう,移動スキル,武官用,統率官用,#

	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);

	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);

	$ksentou = $kbouwin+$kkouwin+$kkoulos+$kboulos+$khiki;


#スキルとってないとき???
$yidou="？？？";
$yidou2="？？？";
$yidou3="？？？";
$yhokyu="？？？";
$ykagoH="？？？";
$ykagoLH="？？？";
$yyoudou="？？？";
$yyoudouL="？？？";
$ykonran="？？？";
$ykahei="？？？";
$ykobuH="？？？";
$ykobuLH="？？？";
$ysendou="？？？";
$ysendouL="？？？";
$ybukan="？？？";
$ybukan1="？？？";
$ybukan3="？？？";
$ybukan2="？？？";
$ybukan4="？？？";
$ytosotu="？？？";
$ytosotu1="？？？";
$ytosotu3="？？？";
$ytosotu2="？？？";
$ytosotu4="？？？";
$ykoujyou1="？？？";
$ykoujyou1m="？？？";
$ykoujyou2="？？？";
$ykoujyou2s="？？？";
$ykoujyou2m="？？？";
$yrenpei="？？？";
$yrenpei2="？？？";
$yrenpei3="？？？";
$yrenpei4="？？？";
$ynaisei="？？？";
$ynaisei2="？？？";
$ynoutka="？？？";
$ysyoutka="？？？";
$ytectka="？？？";
$ydbktka="？？？";
$yjnstka="？？？";
$yktktka="？？？";
$ynsktka="？？？";
$ykeiryaku="？？？";
$ykeiryaku2="？？？";
$ynou_h_tka="？？？";
$ysou_h_tka="？？？";
$ytec_h_tka="？？？";
$yshi_h_tka="？？？";
$ypri_h_tka="？？？";
$ytanren="？？？";
$ytanren2="？？？";
$ytanrentka="？？？";
$ybukiskl="-";
$ybukiskl2="-";
$yasidome="？？？";
$yrikan="？？？";
$yautosyugo="？？？";
$ysinko="？？？";
$ysinko2="？？？";
$ysinko3="？？？";
$ysinko4="？？？";
$yengo="？？？";
$yi_hojyo = "？？？";
$yi_hojyo2 = "？？？";
$yi_hojyo3 = "？？？";
$yi_hojyo4 = "？？？";
$ybouskl = "-";
$ybookskl = "-";


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

#移動スキル#
	if($kskl3 ne "" && $kskl3 ne "0"){
	$idou = "●駿足【小】<br><br>・最大移動ポイントが+1される。<br><br>・スキル修得ページでSPを4消費して修得。";
	$yidou="駿足【小】";
	}if($kskl3 eq "2" || $kskl3 eq "3"){
	$idou2 = "●迅速<br><br>・移動ポイント補充にかかる時間が20秒短縮される。<br><br>・駿足【小】を修得していること。<br>・スキル修得ページでSPを10消費して修得。";
	$yidou2="迅速";
	}if($kskl3 eq "3"){
	$idou3 = "●駿足【大】<br><br>・最大移動ポイントが+3される。<br><br>・迅速を修得していること。<br>・スキル修得ページでSPを12消費して修得。";
	$yidou3="駿足【大】";
	}


#文官用スキル1#
	if($ksien ne "" && $ksien ne "0"){
	$hokyu = "●補給<br><br>・自軍兵士が統率力の半分以上いるとき、自軍兵士を1〜<b>$siensol</b>人味方の部隊に引き渡す。引き渡した人数×相手兵種の値段 相手の金は減少する。<br>また、引き渡した人数分引き渡された軍の訓練値は減少する。<br>ただし、引き渡す側と引き渡される側の兵種が同じ場合、金と訓練値は減少しない。<br>引き渡す人数は統率力＋知力に依存。（行動）<br><br>・スキル修得ページでSPを5消費して修得。<br><br>・待機時間：<b>$koutime</b>秒<br>・リーチ：1<br>・消費士気：$MOR_HOKYU";
	$yhokyu="補給";
	}
	if(($ksien eq "2")||($ksien eq "3")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){

	$kagoseikou = int($kint/1.8);
	if($kagoseikou > 80){$kagoseikou = 80;}
	$kagojikan = int(($kint/30)*60);
	$kagojikan2 = int(($kint/10)*60);

	$kagoH = "●加護【小】<br><br>・指定した味方部隊の守備力が7%＋5上昇する。効果持続時間は<b>$kagojikan</b>〜<b>$kagojikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）<br><br>・補給を修得していること。<br>・スキル修得ページでSPを7消費して修得。<br><br>・待機時間：<b>$koutime1</b>秒<br>・成功率：<b>$kagoseikou</b>%<br>・リーチ：3<br>・消費士気：$MOR_S";
	$ykagoH="加護【小】";
	}
	if(($ksien eq "3")||($ksien eq "7")||($ksien eq "8")){

	$kagoLseikou = int($kint/2);
	if($kagoLseikou > 100){$kagoLseikou = 100;}
	$kagoLjikan = int(($kint/20)*60);
	$kagoLjikan2 = int(($kint/10)*60);

	$kagoLH = "●加護【大】<br><br>・指定した味方部隊の守備力が15%＋10上昇する。効果持続時間は<b>$kagoLjikan</b>〜<b>$kagoLjikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）<br><br>・加護【小】を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime2</b>秒<br>・成功率：<b>$kagoLseikou</b>%<br>・リーチ：4<br>・消費士気：$MOR_L";
	$ykagoLH="加護【大】";
	}
	if(($ksien eq "4")||($ksien eq "5")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){

	$kyoudouseikou = int($kint/1.8);
	if($kyoudouseikou > 80){$kyoudouseikou = 80;}
	$kyoudoujikan = int(($kint/30)*60);
	$kyoudoujikan2 = int(($kint/10)*60);

	$youdou = "●陽動【小】<br><br>・指定した敵部隊の攻撃力を7%減少させる。効果持続時間は<b>$kyoudoujikan</b>〜<b>$kyoudoujikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）<br><br>・補給を修得していること。<br>・スキル修得ページでSPを7消費して修得。<br><br>・待機時間：<b>$koutime1</b>秒<br>・成功率：<b>$kyoudouseikou</b>%<br>・リーチ：3<br>・消費士気：$MOR_S";
	$yyoudou="陽動【小】";
	}
	if(($ksien eq "5")||($ksien eq "8")||($ksien eq "9")){

	$kyoudouLseikou = int($kint/2);
	if($kyoudouLseikou > 100){$kyoudouLseikou = 100;}
	$kyoudouLjikan = int(($kint/20)*60);
	$kyoudouLjikan2 = int(($kint/10)*60);

	$youdouL = "●陽動【大】<br><br>・指定した敵部隊の攻撃力を15%減少させる。効果持続時間は<b>$kyoudouLjikan</b>〜<b>$kyoudouLjikan2</b>秒。<br>成功率、効果持続時間は知力に依存。（行動）<br><br>・陽動【小】を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime2</b>秒<br>・成功率：<b>$kyoudouLseikou</b>%<br>・リーチ：4<br>・消費士気：$MOR_L";
	$yyoudouL="陽動【大】";
	}

#文官用スキル2#
	if($kskl1 ne "" && $kskl1 ne "0"){
	$konran = "●混乱<br><br>・相手が最大<b>$kkk</b>秒移動以外の行動ができないようにする。<br>成功率、相手を行動できなくする時間は知力に依存。（行動）<br><br>・スキル修得ページでSPを10消費して修得。<br><br>・待機時間：<b>$koutime</b>秒<br>・成功率：<b>$kk</b>%<br>・リーチ：2<br>・消費士気：$MOR_KONRAN";
	$ykonran="混乱";
	}

  use lib './lib', './extlib';
  use Jikkoku::Model::Chara;
  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = $chara_model->get($kid);
  use Jikkoku::Class::Skill::Disturb::Stuck;
  my $stuck = Jikkoku::Class::Skill::Disturb::Stuck->new({chara => $chara, battle_map_model => ''});
  if ( $stuck->is_acquired ) {
    $asidome = <<"EOS";
●@{[ $stuck->name ]}<br>
<br>
・@{[ $stuck->description_of_effect ]}<br>
・@{[ $stuck->description_of_acquire ]}<br>
・@{[ $stuck->description_of_status ]}<br>
EOS
    $asidome =~ s/\n//g;
	  $yasidome = $stuck->name;
	}

  if($kskl1 >= 3){
	$rikan = "●離間<br><br>・戦闘中にイベント発生。敵部隊に離間工作をしかけ、敵兵を数人自分の部隊に引き入れる。<br>発動率は知力に依存。<br><br>・スキル修得ページでSPを15消費して修得。<br><br>・発動率：<b>$rikakaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$yrikan="離間";
	}


#仁官用スキル1#
	if($kskl2 ne "" && $kskl2 ne "0"){
	$kahei = "●徴募<br><br>・自軍のいる地形が住宅地、砦、城、関所の時のみ使える。自軍兵士が1人〜<b>$kaheisol2</b>人増える。<br>50R消費。また、兵士増加分訓練値と金が減少。<br>増える兵数は人望に依存。（行動）<br>※自分にしか使えません。<br><br>・スキル修得ページでSPを5消費して修得。<br><br>・待機時間：<b>$koutime3</b>秒<br>・消費士気：$MOR_TYOUBO";
	$ykahei="徴募";
	}
	if(($kskl2 eq "2")||($kskl2 eq "3")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){

	$kobuseikou = int($kcha/1.8);
	if($kobuseikou > 80){$kobuseikou = 80;}
	$kobujikan = int(($kcha/30)*60);
	$kobujikan2 = int(($kcha/10)*60);

	$kobuH = "●鼓舞【小】<br><br>・指定した味方部隊の攻撃力が7%上昇する。効果持続時間は<b>$kobujikan</b>〜<b>$kobujikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）<br><br>・徴募を修得していること。<br>・スキル修得ページでSPを7消費して修得。<br><br>・待機時間：<b>$koutime1</b>秒<br>・成功率：<b>$kobuseikou</b>%<br>・リーチ：3<br>・消費士気：$MOR_S";
	$ykobuH="鼓舞【小】";
	}
	if(($kskl2 eq "3")||($kskl2 eq "7")||($kskl2 eq "8")){

	$kobuLseikou = int($kcha/2);
	if($kobuLseikou > 100){$kobuLseikou = 100;}
	$kobuLjikan = int(($kcha/20)*60);
	$kobuLjikan2 = int(($kcha/10)*60);

	$kobuLH = "●鼓舞【大】<br><br>・指定した味方部隊の攻撃力が15%上昇する。効果持続時間は<b>$kobuLjikan</b>〜<b>$kobuLjikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）<br><br>・鼓舞【小】を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime2</b>秒<br>・成功率：<b>$kobuLseikou</b>%<br>・リーチ：4<br>・消費士気：$MOR_L";
	$ykobuLH="鼓舞【大】";
	}
	if(($kskl2 eq "4")||($kskl2 eq "5")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){

	$sendouseikou = int($kcha/1.8);
	if($sendouseikou > 80){$sendouseikou = 80;}
	$sendoujikan = int(($kcha/30)*60);
	$sendoujikan2 = int(($kcha/10)*60);

	$sendou = "●扇動【小】<br><br>・指定した敵部隊の守備力を7%+5減少させる。効果持続時間は<b>$sendoujikan</b>〜<b>$sendoujikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）<br><br>・徴募を修得していること。<br>・スキル修得ページでSPを7消費して修得。<br><br>・待機時間：<b>$koutime1</b>秒<br>・成功率：<b>$sendouseikou</b>%<br>・リーチ：3<br>・消費士気：$MOR_S";
	$ysendou="扇動【小】";
	}
	if(($kskl2 eq "5")||($kskl2 eq "8")||($kskl2 eq "9")){

	$sendouLseikou = int($kcha/2);
	if($sendouLseikou > 100){$sendouLseikou = 100;}
	$sendouLjikan = int(($kcha/20)*60);
	$sendouLjikan2 = int(($kcha/10)*60);

	$sendouL = "●扇動【大】<br><br>・指定した敵部隊の守備力を15%+10減少させる。効果持続時間は<b>$sendouLjikan</b>〜<b>$sendouLjikan2</b>秒。<br>成功率、効果持続時間は人望に依存。（行動）<br><br>・扇動【小】を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime2</b>秒<br>・成功率：<b>$sendouLseikou</b>%<br>・リーチ：4<br>・消費士気：$MOR_L";
	$ysendouL="扇動【大】";
	}

#仁官用スキル2-移動補助#
	if($kskl8 =~ /1/){
	$syukuti = int($kcha/5);if($syukuti > 50){$syukuti = 50;}
	$syuku_seikou = int($kcha*0.65);if($syuku_seikou > 90){$syuku_seikou=90;}
	$i_hojyo = "●縮地<br><br>・指定した味方部隊の移動ポイント補充時間を<b>$syukuti</b>秒短縮する。<br>短縮する時間は人望に依存。(行動)<br><br>・スキル修得ページでSPを7消費して修得。<br><br>・待機時間：<b>$koutime5</b>秒<br>・成功率：<b>$syuku_seikou</b>%<br>・リーチ：4<br>・消費士気：$MOR_SYUKUTI";
	$yi_hojyo = "縮地";
	}
	if($kskl8 =~ /2/){
	$kasoku = int($kcha/30);if($kasoku > 10){$kasoku = 10;}
	$kasoku_seikou = int($kcha*0.55);if($kasoku_seikou > 95){$kasoku_seikou=95;}
	$i_hojyo2 = "●加速<br><br>・指定した味方部隊の移動ポイントを上限を超えて+<b>$kasoku</b>する。<br>プラスする移動ポイントは人望に依存。(行動)<br>※移動ポイントが50以上の場合は増やせない。<br><br>・縮地を修得していること。<br>・スキル修得ページでSPを13消費して修得。<br><br>・待機時間：<b>$koutime2</b>秒<br>・成功率：<b>$kasoku_seikou</b>%<br>・リーチ：5<br>・消費士気：$MOR_KASOKU";
	$yi_hojyo2 = "加速";
	}
	if($kskl8 =~ /3/){
	$sendouLjikan = int(($kcha/20)*60);$sendouLjikan2 = int(($kcha/10)*60);
	$kinto_seikou = int($kcha*0.45);if($kinto_seikou > 90){$kinto_seikou=90;}
	$i_hojyo3 = "●觔斗雲<br><br>・指定した味方に觔斗雲を付与し、消費移動Pが多い地形での消費移動Pを抑える。<br>効果持続時間は<b>$sendouLjikan</b>〜<b>$sendouLjikan2</b>秒。600G消費。成功率は人望に依存。(行動)<br><br>・加速を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime5</b>秒<br>・成功率：<b>$kinto_seikou</b>%<br>・リーチ：4<br>・消費士気：$MOR_KINTOUN";
	$yi_hojyo3 = "觔斗雲";
	}
	if($kskl8 =~ /4/){
	$kaihi_kaku = int($kcha/9);if($kaihi_kaku > 33){$kaihi_kaku = 33;}
	$i_hojyo4 = "●回避<br><br>・戦闘中にイベント発生。自軍は敵からの攻撃を完全に回避し、そのターン敵から受けるダメージが0になる。<br>発動率は人望に依存。<br><br>・加速を修得していること。<br>スキル修得ページでSPを15消費して修得。<br><br>・発動率：<b>$kaihi_kaku</b>%";
	$yi_hojyo4 = "回避";
	}

#武官用スキル#
	if($kskl4 =~ /0/){
	$bukan = "●計数攻撃<br><br>・戦闘中にイベント発生。出撃中計数攻撃が発動した回数+3ダメージ与える。（但しダメージが増えるのは発動回数15回まで。）<br>発動率は武力に依存。<br><br>・スキル修得ページでSPを5消費して修得。<br><br>・発動率：<b>$keikaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ybukan="計数攻撃";
	}if($kskl4 =~ /1/){
	$bukan1 = "●破壊攻撃<br><br>・戦闘中に低確率でイベント発生。相手に大ダメージを与える。<br>発動率は武力に依存。<br><br>・計数攻撃を修得していること。<br>・スキル修得ページでSPを10消費して修得。<br><br>・発動率：<b>$hakkaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ybukan1="破壊攻撃";
	}if($kskl4 =~ /2/){
	$bukan2 = "●会心攻撃<br><br>・戦闘中にイベント発生。そのターン相手に与えるダメージが1.5倍になる。<br>発動率は武力に依存。<br><br>・計数攻撃を修得していること。<br>・スキル修得ページでSPを10消費して修得。<br><br>・発動率：<b>$kaikaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ybukan2="会心攻撃";
	}if($kskl4 =~ /3/ || $kskl4 =~ /5/){
		if($kskl4 =~ /3/){
		$kirikae = "on";
		$g_on = "checked";
		}else{
		$kirikae = "off";
		$g_off = "checked";
		}
	$bukan3 = "●犠牲攻撃<br><br>・戦闘中にイベント発生。自軍の兵士を何人か犠牲にし、相手に犠牲になった兵士×3のダメージを与える。(城壁戦は犠牲にした兵士×10)<br>但し、犠牲にする兵数は自軍の兵数が1人より少なくなるようにすることはない。<br>発動率は武力に依存。<br><form action='./mydata.cgi' method='post'>・on/off切り替え(現在:<b>$kirikae</b>)　<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=GISEI_KIRIKAE><input type=radio name=gisei value=1 $g_on>on<input type=radio name=gisei value=0 $g_off>off<input type=submit value='切り替え'></form><br>・破壊攻撃を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・発動率：<b>$giskaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ybukan3="犠牲攻撃";
	}if($kskl4 =~ /4/){
	$bukan4 = "●強襲<br><br>・自軍の攻守を+<b>$kyosyudn</b>\%、相手の攻守を-<b>$kyosyudn</b>\%して戦闘を仕掛ける。また、最初のターンに相手にダメージを与える。<br>自軍の攻守が上昇する割合と相手の攻守が減少する割合は武力に依存。（戦闘モード）<br><br>・会心攻撃を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime</b>秒<br>・消費士気：$MOR_KYOSYU";
	$ybukan4="強襲";
	}

#武官用侵攻用スキル#
	$aplus=5;
	if($kskl7 =~ /1/){
	$sinko = "●侵攻強化<br><br>・侵攻側かつ武力が100以上の時、攻撃力+15。<br><br>・スキル修得ページでSPを5消費して修得。";
	$ysinko="侵攻強化";
	}
	if($kskl7 =~ /2/){
	$sinko2 = "●進撃<br><br>・武力が115以上の時使用可能。<br>侵攻側の時、使用してから410秒間攻撃力が25%上昇、その後200秒間守備力-50%。<br>防衛側の時、使用してから610秒間守備力-50%。（行動）<br><br>・侵攻強化を修得していること。<br>・スキル修得ページでSPを10消費して修得。<br><br>・消費士気：$MOR_SINGEKI<br>・再使用時間：1200秒";
	$ysinko2="進撃";
	}
	if($kskl7 =~ /3/){
		if($kskl7 =~ /4/){
		$aplus=10;
		}
	$sinko3 = "●猛攻<br><br>・侵攻側かつ武力が130以上の時、攻守+5%。(計$aplus%)<br>また、戦闘中にイベント発生。発動毎に攻撃力が+20され、敵にダメージを与える。<br>発動率は武力に依存。<br>※上昇した攻撃力は撤退すると元に戻る。<br>※1回の出撃中に上昇する攻撃力は60まで。<br>※攻城戦は発動率が半減する。<br><br>・進撃を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・発動率：<b>$mokokaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ysinko3="猛攻";
	}
	if($kskl7 =~ /4/){
		if($kskl7 =~ /3/){
		$aplus=10;
		}
	$sinko4 = "●波状攻撃<br><br>・侵攻側かつ武力が130以上の時、攻守+5%(計$aplus%)、波状攻撃モード使用可能。<br><b>波状攻撃モード</b>：行動待機時間が通常の戦闘の2/3になる。<br>さらに戦闘中に波状攻撃イベント発生。敵に数ダメージ与える。城壁戦にも有効。1000G消費。<br>波状攻撃イベントの発動率は武力に依存。（戦闘モード）<br><br>・進撃を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime2</b>秒<br>波状攻撃：<b>$hajyokaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]<br>・消費士気：$MOR_HAJYO";
	$ysinko4="波状攻撃";
	}

#統率官用スキル#
	if($kskl5 =~ /0/){
	$tosotu = "●突撃<br><br>・戦闘中にイベント発生。相手にダメージを与える。<br>発動率は統率力に依存。<br><br>・スキル修得ページでSPを5消費して修得。<br><br>・発動率：<b>$totukaku</b>%<br>・リーチ：1";
	$ytosotu="突撃";
	}if($kskl5 =~ /0/ && $kskl5 =~ /1/){
	$tosotu1 = "●攻勢<br><br>・戦闘中にイベント発生。発動毎に攻撃力が+10され、相手に少しダメージを与える。<br>発動率は統率力に依存。<br>※上昇した攻撃力は撤退すると元に戻る。<br>※1回の出撃中上昇する攻撃力は50まで。<br>※攻城戦は発動率が半減する。<br><br>・突撃を修得していること。<br>・スキル修得ページでSPを10消費して修得。<br><br>・発動率：<b>$kseikaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ytosotu1="攻勢";
	}if($kskl5 =~ /0/ && $kskl5 =~ /2/){
	$tosotu2 = "●密集<br><br>・戦闘中にイベント発生。発動毎に守備力が+10される。<br>発動率は統率力に依存。<br>※上昇した守備力は撤退すると元に戻る。<br>※1回の出撃中に上昇する守備力は50まで。<br>※攻城戦は発動率が半減する。<br><br>・突撃を修得していること。<br>・スキル修得ページでSPを10消費して修得。<br><br>・発動率：<b>$mssykaku</b>%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ytosotu2="密集";
	}if($kskl5 =~ /0/ && $kskl5 =~ /1/ && $kskl5 =~ /3/){
	$tosotu3 = "●包囲<br><br>・敵が30人以下の時、(自軍-敵軍)×1.5だけ攻撃力上昇。（戦闘モード）<br><br>・攻勢を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime</b>秒<br>・消費士気：$MOR_HOUI";
	$ytosotu3="包囲";
	}if($kskl5 =~ /0/ && $kskl5 =~ /2/ && $kskl5 =~ /4/){
	$tosotu4 = "●陣形再編<br><br>・陣形の再編にかかる時間を使用時の1/4に短縮する。（行動）<br><br>・密集を修得していること。<br>・スキル修得ページでSPを15消費して修得。<br><br>・待機時間：<b>$koutime4</b>秒<br>・消費士気：$MOR_SAIHEN";
	$ytosotu4="陣形再編";
	}


#技能系スキル#
	if(($ksub1_ex eq "12")||($ksub1_ex eq "28")){
	$koujyou1 = "●攻城１【小】<br><br>・攻城時ターン数+1。<br><br>・衝車、雲梯のいずれかを雇っている時。";
	$ykoujyou1="攻城１【小】";
	}elsif($ksub1_ex eq "29"){
	$koujyou1m = "●攻城１【大】<br><br>・攻城時ターン数+2。<br><br>・投石機を雇っている時。";
	$ykoujyou1m="攻城１【大】";
	}
	if($koujyou2 eq "2"){
	$koujyou2m = "●攻城２【大】<br><br>・攻城時ターン数+3。<br><br>・城壁との戦闘回数100回";
	$koujyou2s = "●攻城２【中】<br><br>・攻城時ターン数+2。（効果は重複しません）<br><br>・城壁との戦闘回数30回";
	$koujyou2 = "●攻城２【小】<br><br>・攻城時ターン数+1。（効果は重複しません）<br><br>・城壁との戦闘回数10回";
	$ykoujyou2="攻城２【小】";
	$ykoujyou2s="攻城２【中】";
	$ykoujyou2m="攻城２【大】";
	}elsif($koujyou2 eq "1"){
	$koujyou2s = "●攻城２【中】<br><br>・攻城時ターン数+2。<br><br>・城壁との戦闘回数30回";
	$koujyou2 = "●攻城２【小】<br><br>・攻城時ターン数+1。（効果は重複しません）<br><br>・城壁との戦闘回数10回";
	$ykoujyou2="攻城２【小】";
	$ykoujyou2s="攻城２【中】";
	}elsif($koujyou2 eq "0"){
	$koujyou2 = "●攻城２【小】<br><br>・攻城時ターン数+1。<br><br>・城壁との戦闘回数10回";
	$ykoujyou2="攻城２【小】";
	}


	if($krenpei eq "3"){
	$renpei4 = "●練兵【大】<br><br>・訓練系コマンドの効果が大きく上昇<br><br>・訓練系コマンド80回<br>徴兵80回<br>戦闘回数160回";
	$renpei3 = "●練兵【中】<br><br>・訓練系コマンドの効果が上昇（効果は重複しません）<br><br>・訓練系コマンド40回<br>徴兵40回<br>戦闘回数80回";
	$renpei2 = "●練兵【小】<br><br>・訓練系コマンドの効果が少し上昇（効果は重複しません）<br><br>・訓練系コマンド20回<br>徴兵20回<br>戦闘回数40回";
	$renpei = "●練兵【微】<br><br>・訓練系コマンドの効果微上昇（効果は重複しません）<br><br>・訓練系コマンド10回<br>徴兵10回<br>戦闘回数20回";
	$yrenpei="練兵【微】";
	$yrenpei2="練兵【小】";
	$yrenpei3="練兵【中】";
	$yrenpei4="練兵【大】";
	}elsif($krenpei eq "2"){
	$renpei3 = "●練兵【中】<br><br>・訓練系コマンドの効果が上昇<br><br>・訓練系コマンド40回<br>徴兵40回<br>戦闘回数80回";
	$renpei2 = "●練兵【小】<br><br>・訓練系コマンドの効果が少し上昇（効果は重複しません）<br><br>・訓練系コマンド20回<br>徴兵20回<br>戦闘回数40回";
	$renpei = "●練兵【微】<br><br>・訓練系コマンドの効果微上昇（効果は重複しません）<br><br>・訓練系コマンド10回<br>徴兵10回<br>戦闘回数20回";
	$yrenpei="練兵【微】";
	$yrenpei2="練兵【小】";
	$yrenpei3="練兵【中】";
	}elsif($krenpei eq "1"){
	$renpei2 = "●練兵【小】<br><br>・訓練系コマンドの効果が少し上昇<br><br>・訓練系コマンド20回<br>徴兵20回<br>戦闘回数40回";
	$renpei = "●練兵【微】<br><br>・訓練系コマンドの効果微上昇（効果は重複しません）<br><br>・訓練系コマンド10回<br>徴兵10回<br>戦闘回数20回";
	$yrenpei="練兵【微】";
	$yrenpei2="練兵【小】";
	}elsif($krenpei eq "0"){
	$renpei = "●練兵【微】<br><br>・訓練系コマンドの効果微上昇<br><br>・訓練系コマンド10回<br>徴兵10回<br>戦闘回数20回";
	$yrenpei="練兵【微】";
	}

	if($knaiskl eq "0"){
	$naisei = "●内政強化【小】<br><br>・内政系コマンドの効果微上昇<br><br>・内政系コマンド100回";
	$ynaisei="内政強化【小】";
	}if($knaiskl =~ /1/){
	$naisei = "●内政強化【小】<br><br>・内政系コマンドの効果微上昇（効果は重複しません）<br><br>・内政系コマンド100回";
	$naisei2 = "●内政強化【大】<br><br>・内政系コマンドの効果が少し上昇<br><br>・内政系コマンド300回";
	$ynaisei="内政強化【小】";
	$ynaisei2="内政強化【大】";
	}if($knaiskl =~ /2/){
	$noutka = "●農政特化<br><br>・農業開発、農地開拓を実行した時の内政値の上昇値が2.0倍され、実行した時にかかる金が0Gになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ynoutka="農政特化";
	}if($knaiskl =~ /3/){
	$syoutka = "●商政特化<br><br>・商業発展、市場建設を実行した時の内政値の上昇値が2.0倍され、実行した時にかかる金が0Gになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ysyoutka="商政特化";
	}if($knaiskl =~ /4/){
	$tectka = "●技術特化<br><br>・技術開発を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる金が0Gになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ytectka="技術特化";
	}if($knaiskl =~ /5/){
	$dbktka = "●土木特化<br><br>・城壁強化、城壁拡張、城壁耐久力強化を実行した時の内政値の上昇値が1.8倍され、<br>実行した時にかかる金が0Gになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ydbktka="土木特化";
	}if($knaiskl =~ /6/){
	$jnstka = "●仁政特化<br><br>・米施しを実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$yjnstka="仁政特化";
	}if($knaiskl =~ /7/){
	$ktktka = "●開拓特化<br><br>・開拓を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$yktktka="開拓特化";
	}if($knaiskl =~ /8/){
	$nsktka = "●入植特化<br><br>・入植を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。<br><br>・内政強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ynsktka="入植特化";
	}

	if($kkeiskl eq "0"){
	$keiryaku = "●計略強化【小】<br><br>・計略系コマンドの効果微上昇<br><br>・計略系コマンド100回";
	$ykeiryaku="計略強化【小】";
	}if($kkeiskl =~ /1/){
	$keiryaku = "●計略強化【小】<br><br>・計略系コマンドの効果微上昇（効果は重複しません）<br><br>・計略系コマンド100回";
	$keiryaku2 = "●計略強化【大】<br><br>・計略系コマンドの効果が少し上昇<br><br>・計略系コマンド300回";
	$ykeiryaku="計略強化【小】";
	$ykeiryaku2="計略強化【大】";
	}if($kkeiskl =~ /2/){
	$nou_h_tka = "●農地破壊特化<br><br>・農地破壊を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。<br><br>・計略強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ynou_h_tka="農地破壊特化";
	}if($kkeiskl =~ /3/){
	$sou_h_tka = "●市場破壊特化<br><br>・市場破壊を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。<br><br>・計略強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ysou_h_tka="市場破壊特化";
	}if($kkeiskl =~ /4/){
	$tec_h_tka = "●技術衰退特化<br><br>・技術衰退を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。<br><br>・計略強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ytec_h_tka="技術衰退特化";
	}if($kkeiskl =~ /5/){
	$shi_h_tka = "●工事妨害特化<br><br>・城壁劣化を実行した時の内政値の減少値が1.95倍され、<br>実行した時にかかる金が0Gになる。<br><br>・計略強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$yshi_h_tka="工事妨害特化";
	}if($kkeiskl =~ /6/){
	$pri_h_tka = "●流言特化<br><br>・流言を実行した時の内政値の減少値が1.9倍され、<br>実行した時にかかる金が0Gになる。<br><br>・計略強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ypri_h_tka="流言特化";
	}
	
	if($ktanskl eq "0"){
	$tanren = "●鍛錬強化【小】<br><br>・能力強化コマンドを実行した時にかかる金が300Gになる。<br><br>・能力強化コマンド100回";
	$ytanren="鍛錬強化【小】";
	}if($ktanskl eq "1"){
	$tanren = "●鍛錬強化【小】<br><br>・能力強化コマンドを実行した時にかかる金が300Gになる。（効果は重複しません）<br><br>・能力強化コマンド100回";
	$tanren2 = "●鍛錬強化【大】<br><br>・能力強化コマンドを実行した時にかかる金が100Gになる。<br><br>・能力強化コマンド300回";
	$ytanren="鍛錬強化【小】";
	$ytanren2="鍛錬強化【大】";
	}if($ktanskl eq "2"){
	$tanren = "●鍛錬強化【小】<br><br>・能力強化コマンドを実行した時にかかる金が300Gになる。（効果は重複しません）<br><br>・能力強化コマンド100回";
	$tanren2 = "●鍛錬強化【大】<br><br>・能力強化コマンドを実行した時にかかる金が100Gになる。<br><br>・能力強化コマンド300回";
	$tanrentka = "●鍛錬特化<br><br>・能力強化を実行したときに得られる経験値が+4になる。<br><br>・鍛錬強化【大】を修得していること。<br>・スキル修得ページでSPを15消費して修得。";
	$ytanren="鍛錬強化【小】";
	$ytanren2="鍛錬強化【大】";
	$ytanrentka="鍛錬特化";
	}

#自動集合
	if($kskl6 eq "1"){
	$yautosyugo = "自動集合";
	$autosyugo = "●自動集合<br><br>・コマンド実行時に自動的に部隊員を部隊拠点に集合させる。<br>部隊編成画面でON/OFF切り替え可能。<br>自動集合を実行毎に500R消費。<br><br>・スキル修得ページでSPを3消費して修得。";
	}

  use Jikkoku::Class::Skill::Protect::Protect;
  my $protect = Jikkoku::Class::Skill::Protect::Protect->new({ chara => $chara });
  if ( $protect->is_acquired ) {
    $yengo = $protect->name;
    $engo = <<"EOS";
●@{[ $protect->name ]}<br><br>
・@{[ $protect->description_of_effect ]}<br><br>
・@{[ $protect->description_of_acquire ]}<br><br>
・@{[ $protect->description_of_status ]}
EOS
    $engo =~ s/\n//g;
  }

#武器スキル
	if($khohei eq "1"){
	$ybukiskl="米俵";
	$bukiskl = "●米俵<br><br>・戦闘中にイベントが発生。<br>米俵を敵に投げつけ、ダメージを与える。発動毎に500R消費。<br><br>・武器：米俵を装備していること。<br><br>・発動率：17%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	}elsif($khohei eq "2"){
	$ybukiskl="短陌";
	$bukiskl = "●短陌<br><br>・戦闘中にイベント発生。<br>銅銭を取り出し、敵に投げつける。<br>あったった個数分敵にダメージ。発動毎に500G消費。<br><br>・武器：短陌を装備していること。<br><br>・発動率：15%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	}elsif($khohei eq "3"){
	$ybukiskl="龜文";
	$bukiskl = "●龜文<br><br>・戦闘中にイベント発生。発動ターン、自分の被ダメージが1になる。<br><br>・武器：干将・莫耶を装備していること。<br><br>・発動率：12%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	$ybukiskl2="漫理";
	$bukiskl2 = "●漫理<br><br>・戦闘中にイベント発生。敵にダメージを与える。<br><br>・武器：干将・莫耶を装備していること。<br><br>・発動率：12%<br>・リーチ：$SOL_AT[$ksub1_ex]";
	}elsif($khohei eq "7"){
	$ybukiskl="槊";
	$bukiskl = "●槊<br><br>・槍騎兵使用時攻撃力が+10。<br><br>・武器：槊を装備していること。";
	}elsif($khohei eq "8"){
	$ybukiskl="攻城弩";
	$bukiskl = "●攻城弩<br><br>・攻城時攻撃力+80、守備力+40、ターン数+1。<br><br>・武器：攻城弩を装備していること。";
	}

#防具スキル
	if($kbouskl eq "1"){
	$ybouskl="歩人甲";
	$bouskl = "●歩人甲<br><br>・歩兵使用時守備力+30。<br><br>・防具：歩人甲を装備していること。";
	}elsif($kbouskl eq "2"){
	$ybouskl="馬甲";
	$bouskl = "●馬甲<br><br>・騎兵使用時守備力+20。<br><br>・防具：馬甲を装備していること。";
	}elsif($kbouskl eq "3"){
	$ybouskl="挂甲";
	$bouskl = "●挂甲<br><br>・騎兵使用時守備力+10。<br><br>・防具：挂甲を装備していること。";
	}elsif($kbouskl eq "4"){
	$ybouskl="軽布甲";
	$bouskl = "●軽布甲<br><br>・弓兵使用時攻撃力+20。<br><br>・防具：軽布甲を装備していること。";
	}

#書物スキル
	if($kbookskl eq "1"){
	$ybookskl="農書";
	$bookskl = "●農書<br><br>・農業開発、農地開拓を実行した時の内政値の上昇値が+1.0倍される。<br><br>・書物：農書を装備していること。";
	}elsif($kbookskl eq "2"){
	$ybookskl="塩鉄論";
	$bookskl = "●塩鉄論<br><br>・商業発展、市場建設を実行した時の内政値の上昇値が+1.0倍される。<br><br>・書物：塩鉄論を装備していること。";
	}elsif($kbookskl eq "3"){
	$ybookskl="造営法式";
	$bookskl = "●造営法式<br><br>・技術開発を実行した時の内政値の上昇値が+1.1倍される。<br><br>・書物：造営法式を装備していること。";
	}elsif($kbookskl eq "4"){
	$ybookskl="夢渓筆談";
	$bookskl = "●夢渓筆談<br><br>・城壁強化、城壁拡張、城壁耐久力強化を実行した時の内政値の上昇値が+0.9倍される。<br><br>・書物：夢渓筆談を装備していること。";
	}elsif($kbookskl eq "5"){
	$ybookskl="戦国策";
	$bookskl = "●戦国策<br><br>・計略系コマンド実行時の効果が+0.5倍される。<br><br>・書物：戦国策を装備していること。";
	}elsif($kbookskl eq "6"){
	$ybookskl="数書九章";
	$bookskl = "●数書九章<br><br>・内政系コマンドを実行した時に上昇する書物の威力が+0.2に上昇する。<br><br>・書物：数書九章を装備していること。";
	}elsif($kbookskl eq "7"){
	$ybookskl="論語";
	$bookskl = "●論語<br><br>・米施し、開拓、入植を実行した時の内政値の上昇値が+0.9倍される。<br><br>・書物：論語を装備していること。";
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
<font color=white>自分が修得してるスキルの一覧です。<sub>[<a href="./manual.html#ski" target="_blank">スキルについて</a>]</sub></font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>


<script type="text/javascript">

message = ["","$idou","$idou2","$idou3","$hokyu","$kagoH","$kagoLH","$youdou","$youdouL","$konran","$kahei","$kobuH","$kobuLH",
"$sendou","$sendouL","$bukan","$bukan1","$bukan3","$bukan2","$bukan4","$tosotu","$tosotu1","$tosotu3","$tosotu2",
"$tosotu4","$koujyou1","$koujyou1m","$koujyou2","$koujyou2m","$renpei","$renpei2","$renpei3","$renpei4",
"$naisei","$naisei2","$noutka","$syoutka","$tectka","$dbktka","$jnstka","$ktktka","$nsktka",
"$keiryaku","$keiryaku2","$nou_h_tka","$sou_h_tka","$tec_h_tka","$shi_h_tka","$pri_h_tka",
"$tanren","$tanren2","$tanrentka","$bukiskl","$koujyou2s","$bukiskl2","$asidome","$rikan","$autosyugo",
"$sinko","$sinko2","$sinko3","$sinko4","$engo","$i_hojyo","$i_hojyo2","$i_hojyo3","$i_hojyo4","$bouskl","$bookskl",];

function changetext(msgnum){
	document.getElementById("objdiv").innerHTML = message[msgnum];
	}

</script>


<form action="./mydata.cgi" method="post" align="right">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MYSKL>
<input type=submit id=input value="用途別で表示する"></form>


<center>
<div class="skliti" style="height:400px">
<table cellspacing="0" style="width:100%">
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>移動スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(1)" onMouseout="changetext(0)">$yidou</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(2)" onMouseout="changetext(0)">$yidou2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(3)" onMouseout="changetext(0)">$yidou3</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>支援スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="3" align="center" onMouseover="changetext(4)" onMouseout="changetext(0)">$yhokyu</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(5)" onMouseout="changetext(0)">$ykagoH</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(6)" onMouseout="changetext(0)">$ykagoLH</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(7)" onMouseout="changetext(0)">$yyoudou</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(8)" onMouseout="changetext(0)">$yyoudouL</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>妨害スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(9)" onMouseout="changetext(0)">$ykonran</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(55)" onMouseout="changetext(0)">$yasidome</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(56)" onMouseout="changetext(0)">$yrikan</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>応援スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="3" align="center" onMouseover="changetext(10)" onMouseout="changetext(0)">$ykahei</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(11)" onMouseout="changetext(0)">$ykobuH</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(12)" onMouseout="changetext(0)">$ykobuLH</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(13)" onMouseout="changetext(0)">$ysendou</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(14)" onMouseout="changetext(0)">$ysendouL</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>移動補助スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="3" align="center" onMouseover="changetext(63)" onMouseout="changetext(0)">$yi_hojyo</td><td class="waku2" rowspan="3"><hr class="sen"></td><td class="waku" rowspan="3" align="center" onMouseover="changetext(64)" onMouseout="changetext(0)">$yi_hojyo2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(65)" onMouseout="changetext(0)">$yi_hojyo3</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(66)" onMouseout="changetext(0)">$yi_hojyo4</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>戦闘術スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="3" align="center" onMouseover="changetext(15)" onMouseout="changetext(0)">$ybukan</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(16)" onMouseout="changetext(0)">$ybukan1</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(17)" onMouseout="changetext(0)">$ybukan3</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(18)" onMouseout="changetext(0)">$ybukan2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(19)" onMouseout="changetext(0)">$ybukan4</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>侵攻スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="3" align="center" onMouseover="changetext(58)" onMouseout="changetext(0)">$ysinko</td><td class="waku2" rowspan="3"><hr class="sen"></td><td class="waku" rowspan="3" align="center" onMouseover="changetext(59)" onMouseout="changetext(0)">$ysinko2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(60)" onMouseout="changetext(0)">$ysinko3</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(61)" onMouseout="changetext(0)">$ysinko4</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>指揮スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="3" align="center" onMouseover="changetext(20)" onMouseout="changetext(0)">$ytosotu</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(21)" onMouseout="changetext(0)">$ytosotu1</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(22)" onMouseout="changetext(0)">$ytosotu3</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(23)" onMouseout="changetext(0)">$ytosotu2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(24)" onMouseout="changetext(0)">$ytosotu4</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>攻城１スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(25)" onMouseout="changetext(0)">$ykoujyou1</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(26)" onMouseout="changetext(0)">$ykoujyou1m</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>攻城２スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(27)" onMouseout="changetext(0)">$ykoujyou2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(53)" onMouseout="changetext(0)">$ykoujyou2s</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(28)" onMouseout="changetext(0)">$ykoujyou2m</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>錬兵スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(29)" onMouseout="changetext(0)">$yrenpei</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(30)" onMouseout="changetext(0)">$yrenpei2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(31)" onMouseout="changetext(0)">$yrenpei3</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(32)" onMouseout="changetext(0)">$yrenpei4</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>内政スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="13" align="center" onMouseover="changetext(33)" onMouseout="changetext(0)">$ynaisei</td><td rowspan="13" class="waku2"><hr class="sen"></td><td class="waku" rowspan="13" align="center" onMouseover="changetext(34)" onMouseout="changetext(0)">$ynaisei2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(35)" onMouseout="changetext(0)">$ynoutka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(36)" onMouseout="changetext(0)">$ysyoutka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(37)" onMouseout="changetext(0)">$ytectka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(38)" onMouseout="changetext(0)">$ydbktka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(39)" onMouseout="changetext(0)">$yjnstka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(40)" onMouseout="changetext(0)">$yktktka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(41)" onMouseout="changetext(0)">$ynsktka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>計略スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" rowspan="9" align="center" onMouseover="changetext(42)" onMouseout="changetext(0)">$ykeiryaku</td><td rowspan="9" class="waku2"><hr class="sen"></td><td class="waku" rowspan="9" align="center" onMouseover="changetext(43)" onMouseout="changetext(0)">$ykeiryaku2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(44)" onMouseout="changetext(0)">$ynou_h_tka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(45)" onMouseout="changetext(0)">$ysou_h_tka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(46)" onMouseout="changetext(0)">$ytec_h_tka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(47)" onMouseout="changetext(0)">$yshi_h_tka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(48)" onMouseout="changetext(0)">$ypri_h_tka</td></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>鍛錬スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(49)" onMouseout="changetext(0)">$ytanren</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(50)" onMouseout="changetext(0)">$ytanren2</td><td class="waku2"><hr class="sen"></td><td class="waku" align="center" onMouseover="changetext(51)" onMouseout="changetext(0)">$ytanrentka</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>集合スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(57)" onMouseout="changetext(0)">$yautosyugo</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>掩護スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(62)" onMouseout="changetext(0)">$yengo</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>武器スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(52)" onMouseout="changetext(0)">$ybukiskl</td><td class="waku2"></td><td class="waku" align="center" onMouseover="changetext(54)" onMouseout="changetext(0)">$ybukiskl2</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>防具スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(67)" onMouseout="changetext(0)">$ybouskl</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td colspan="7" bgcolor="#4682B4" align="center" class="radius"><font color="#FFFFFF"><b>書物スキル</b></font></td></tr>
<tr><td class="tate"></td></tr>
<tr><td class="waku" align="center" onMouseover="changetext(68)" onMouseout="changetext(0)">$ybookskl</td></tr>
</table>
</div>
<p align="right">※カーソルを合わせるとスキルの説明が表示されます。</p>
<div id="objdiv" class="swaku"></div>
</center>

<br><br><br><br><br><br><br>

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
1;
