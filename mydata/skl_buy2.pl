#_/_/_/_/_/_/_/_/_/_/#
#    すきる購入２      #
#_/_/_/_/_/_/_/_/_/_/#

sub SKL_BUY2 {

	if($in{'select'} eq ""){&ERR("修得するスキルが入力されていません。");}
	&COUNTRY_DATA_OPEN($kpos);
	&TIME_DATA;
	&CHARA_MAIN_OPEN;
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);
	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);

	if($in{'select'} eq "1"){
	if(5 > $ksg){
	&ERR("SPが足りません。");
	}elsif($ksien > 0){
	&ERR("既に修得しています。");
		}else{	
	$ksien = 1;
	$ksg -= 5;
	$zou = "スキル：補給を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：補給を修得しました。");
		}
	}elsif($in{'select'} eq "2"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl1 > 0){
	&ERR("既に修得しています。");
		}else{	
	$kskl1 = 1;
	$ksg -= 10;
	$zou = "スキル：混乱を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：混乱を修得しました。");
		}
	}elsif($in{'select'} eq "3"){
	if(5 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl2 > 0){
	&ERR("既に修得しています。");
		}else{	
	$kskl2 = 1;
	$ksg -= 5;
	$zou = "スキル：徴募を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：徴募を修得しました。");
		}
	}elsif($in{'select'} eq "4"){
	if(7 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($ksien eq "2")||($ksien eq "3")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){
	&ERR("既に修得しています。");
	}elsif($ksien ne "1" && $ksien ne "4" && $ksien ne "5"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($ksien eq "1"){	
			$ksien = 2;
			}elsif($ksien eq "4"){
			$ksien = 6;
			}elsif($ksien eq "5"){
			$ksien = 9;
			}
	$ksg -= 7;
	$zou = "スキル：加護【小】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：加護【小】を修得しました。");
		}
	}elsif($in{'select'} eq "5"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($ksien eq "3")||($ksien eq "7")||($ksien eq "8")){
	&ERR("既に修得しています。");
	}elsif($ksien ne "2" && $ksien ne "6" && $ksien ne "9"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($ksien eq "2"){	
			$ksien = 3;
			}elsif($ksien eq "6"){
			$ksien = 7;
			}elsif($ksien eq "9"){
			$ksien = 8;
			}
	$ksg -= 15;
	$zou = "スキル：加護【大】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：加護【大】を修得しました。");
		}
	}elsif($in{'select'} eq "6"){
	if(7 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($ksien eq "4")||($ksien eq "5")||($ksien eq "6")||($ksien eq "7")||($ksien eq "8")||($ksien eq "9")){
	&ERR("既に修得しています。");
	}elsif($ksien ne "1" && $ksien ne "2" && $ksien ne "3"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($ksien eq "1"){	
			$ksien = 4;
			}elsif($ksien eq "2"){
			$ksien = 6;
			}elsif($ksien eq "3"){
			$ksien = 7;
			}
	$ksg -= 7;
	$zou = "スキル：陽動【小】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：陽動【小】を修得しました。");
		}
	}elsif($in{'select'} eq "7"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($ksien eq "5")||($ksien eq "8")||($ksien eq "9")){
	&ERR("既に修得しています。");
	}elsif($ksien ne "4" && $ksien ne "6" && $ksien ne "7"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($ksien eq "4"){	
			$ksien = 5;
			}elsif($ksien eq "6"){
			$ksien = 9;
			}elsif($ksien eq "7"){
			$ksien = 8;
			}
	$ksg -= 15;
	$zou = "スキル：陽動【大】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：陽動【大】を修得しました。");
		}
	}elsif($in{'select'} eq "8"){
	if(7 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($kskl2 eq "2")||($kskl2 eq "3")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){
	&ERR("既に修得しています。");
	}elsif($kskl2 ne "1" && $kskl2 ne "4" && $kskl2 ne "5"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($kskl2 eq "1"){	
			$kskl2 = 2;
			}elsif($kskl2 eq "4"){
			$kskl2 = 6;
			}elsif($kskl2 eq "5"){
			$kskl2 = 9;
			}
	$ksg -= 7;
	$zou = "スキル：鼓舞【小】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：鼓舞【小】を修得しました。");
		}
	}elsif($in{'select'} eq "9"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($kskl2 eq "3")||($kskl2 eq "7")||($kskl2 eq "8")){
	&ERR("既に修得しています。");
	}elsif($kskl2 ne "2" && $kskl2 ne "6" && $kskl2 ne "9"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($kskl2 eq "2"){	
			$kskl2 = 3;
			}elsif($kskl2 eq "6"){
			$kskl2 = 7;
			}elsif($kskl2 eq "9"){
			$kskl2 = 8;
			}
	$ksg -= 15;
	$zou = "スキル：鼓舞【大】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：鼓舞【大】を修得しました。");
		}
	}elsif($in{'select'} eq "10"){
	if(7 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($kskl2 eq "4")||($kskl2 eq "5")||($kskl2 eq "6")||($kskl2 eq "7")||($kskl2 eq "8")||($kskl2 eq "9")){
	&ERR("既に修得しています。");
	}elsif($kskl2 ne "1" && $kskl2 ne "2" && $kskl2 ne "3"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($kskl2 eq "1"){	
			$kskl2 = 4;
			}elsif($kskl2 eq "2"){
			$kskl2 = 6;
			}elsif($kskl2 eq "3"){
			$kskl2 = 7;
			}
	$ksg -= 7;
	$zou = "スキル：扇動【小】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：扇動【小】を修得しました。");
		}
	}elsif($in{'select'} eq "11"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif(($kskl2 eq "5")||($kskl2 eq "8")||($kskl2 eq "9")){
	&ERR("既に修得しています。");
	}elsif($kskl2 ne "4" && $kskl2 ne "6" && $kskl2 ne "7"){
	&ERR("スキル修得条件を満たしていません。");
		}else{
			if($kskl2 eq "4"){	
			$kskl2 = 5;
			}elsif($kskl2 eq "6"){
			$kskl2 = 9;
			}elsif($kskl2 eq "7"){
			$kskl2 = 8;
			}
	$ksg -= 15;
	$zou = "スキル：扇動【大】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：扇動【大】を修得しました。");
		}
	}elsif($in{'select'} eq "12"){
	if(4 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl3 > 0){
	&ERR("既に修得しています。");
		}else{
	$kskl3 = 1;
	$ksg -= 4;
	$zou = "スキル：駿足【小】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：駿足【小】を修得しました。");
		}
	}elsif($in{'select'} eq "13"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl3 > 1){
	&ERR("既に修得しています。");
	}elsif($kskl3 != 1){
	&ERR("スキル修得条件を満たしていません。");
		}else{
	$kskl3 = 2;
	$ksg -= 10;
	$zou = "スキル：迅速を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：迅速を修得しました。");
		}
	}elsif($in{'select'} eq "14"){
	if(12 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl3 != 2){
	&ERR("スキル修得条件を満たしていません。");
	}elsif($kskl3 eq "3"){
	&ERR("既に修得しています。");
		}else{
	$kskl3 = 3;
	$ksg -= 12;
	$zou = "スキル：駿足【大】を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：駿足【大】を修得しました。");
		}
	}elsif($in{'select'} eq "15"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /2/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":2";
	$ksg -= 15;
	$zou = "スキル：農政特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：農政特化を修得しました。");
		}
	}elsif($in{'select'} eq "16"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /3/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":3";
	$ksg -= 15;
	$zou = "スキル：商政特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：商政特化を修得しました。");
		}
	}elsif($in{'select'} eq "17"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /4/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":4";
	$ksg -= 15;
	$zou = "スキル：技術特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：技術特化を修得しました。");
		}
	}elsif($in{'select'} eq "18"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /5/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":5";
	$ksg -= 15;
	$zou = "スキル：土木特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：土木特化を修得しました。");
		}
	}elsif($in{'select'} eq "19"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /6/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":6";
	$ksg -= 15;
	$zou = "スキル：仁政特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：仁政特化を修得しました。");
		}
	}elsif($in{'select'} eq "20"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /7/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":7";
	$ksg -= 15;
	$zou = "スキル：開拓特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：開拓特化を修得しました。");
		}
	}elsif($in{'select'} eq "21"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($knaiskl =~ /8/){
	&ERR("既に修得しています。");
	}elsif($knaiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$knaiskl .= ":8";
	$ksg -= 15;
	$zou = "スキル：入植特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：入植特化を修得しました。");
		}
	}elsif($in{'select'} eq "22"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kkeiskl =~ /2/){
	&ERR("既に修得しています。");
	}elsif($kkeiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kkeiskl .= ":2";
	$ksg -= 15;
	$zou = "スキル：農地破壊特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：農地破壊特化を修得しました。");
		}
	}elsif($in{'select'} eq "23"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kkeiskl =~ /3/){
	&ERR("既に修得しています。");
	}elsif($kkeiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kkeiskl .= ":3";
	$ksg -= 15;
	$zou = "スキル：市場破壊特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：市場破壊特化を修得しました。");
		}
	}elsif($in{'select'} eq "24"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kkeiskl =~ /4/){
	&ERR("既に修得しています。");
	}elsif($kkeiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kkeiskl .= ":4";
	$ksg -= 15;
	$zou = "スキル：技術衰退特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：技術衰退特化を修得しました。");
		}
	}elsif($in{'select'} eq "25"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kkeiskl =~ /5/){
	&ERR("既に修得しています。");
	}elsif($kkeiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kkeiskl .= ":5";
	$ksg -= 15;
	$zou = "スキル：工事妨害特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：工事妨害特化を修得しました。");
		}
	}elsif($in{'select'} eq "26"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kkeiskl =~ /6/){
	&ERR("既に修得しています。");
	}elsif($kkeiskl !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kkeiskl .= ":6";
	$ksg -= 15;
	$zou = "スキル：流言特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：流言特化を修得しました。");
		}
	}elsif($in{'select'} eq "27"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($ktanskl eq "2"){
	&ERR("既に修得しています。");
	}elsif($ktanskl ne "1"){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$ktanskl = 2;
	$ksg -= 15;
	$zou = "スキル：鍛錬特化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：鍛錬特化を修得しました。");
		}
	}elsif($in{'select'} eq "28"){
	if(5 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl4 =~ /0/){
	&ERR("既に修得しています。");
		}else{	
	$kskl4 = 0;
	$ksg -= 5;
	$zou = "スキル：計数攻撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：計数攻撃を修得しました。");
		}
	}elsif($in{'select'} eq "29"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl4 =~ /1/){
	&ERR("既に修得しています。");
	}elsif($kskl4 !~ /0/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl4 .= ":1";
	$ksg -= 10;
	$zou = "スキル：破壊攻撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：破壊攻撃を修得しました。");
		}
	}elsif($in{'select'} eq "30"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl4 =~ /2/){
	&ERR("既に修得しています。");
	}elsif($kskl4 !~ /0/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl4 .= ":2";
	$ksg -= 10;
	$zou = "スキル：会心攻撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：会心攻撃を修得しました。");
		}
	}elsif($in{'select'} eq "31"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl4 =~ /3/){
	&ERR("既に修得しています。");
	}elsif($kskl4 !~ /0/ || $kskl4 !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl4 .= ":3";
	$ksg -= 15;
	$zou = "スキル：犠牲攻撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：犠牲攻撃を修得しました。");
		}
	}elsif($in{'select'} eq "32"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl4 =~ /4/){
	&ERR("既に修得しています。");
	}elsif($kskl4 !~ /0/ || $kskl4 !~ /2/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl4 .= ":4";
	$ksg -= 15;
	$zou = "スキル：強襲を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：強襲を修得しました。");
		}
	}elsif($in{'select'} eq "33"){
	if(5 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl5 =~ /0/){
	&ERR("既に修得しています。");
		}else{	
	$kskl5 = 0;
	$ksg -= 5;
	$zou = "スキル：突撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：突撃を修得しました。");
		}
	}elsif($in{'select'} eq "34"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl5 =~ /1/){
	&ERR("既に修得しています。");
	}elsif($kskl5 !~ /0/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl5 .= ":1";
	$ksg -= 10;
	$zou = "スキル：攻勢を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：攻勢を修得しました。");
		}
	}elsif($in{'select'} eq "35"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl5 =~ /2/){
	&ERR("既に修得しています。");
	}elsif($kskl5 !~ /0/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl5 .= ":2";
	$ksg -= 10;
	$zou = "スキル：密集を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：密集を修得しました。");
		}
	}elsif($in{'select'} eq "36"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl5 =~ /3/){
	&ERR("既に修得しています。");
	}elsif($kskl5 !~ /0/ || $kskl5 !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl5 .= ":3";
	$ksg -= 15;
	$zou = "スキル：包囲を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：包囲を修得しました。");
		}
	}elsif($in{'select'} eq "37"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl5 =~ /4/){
	&ERR("既に修得しています。");
	}elsif($kskl5 !~ /0/ || $kskl5 !~ /2/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl5 .= ":4";
	$ksg -= 15;
	$zou = "スキル：陣形再編を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：陣形再編を修得しました。");
		}
	}elsif($in{'select'} eq "38"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl1 > 1){
	&ERR("既に修得しています。");
	}elsif($kskl1 != 1){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl1 = 2;
	$ksg -= 10;
	$zou = "スキル：足止めを修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：足止めを修得しました。");
		}
	}elsif($in{'select'} eq "39"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl1 == 3){
	&ERR("既に修得しています。");
	}elsif($kskl1 != 2){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl1 = 3;
	$ksg -= 15;
	$zou = "スキル：離間を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：離間を修得しました。");
		}
	}elsif($in{'select'} eq "40"){
	if(3 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl6 eq "1"){
	&ERR("既に修得しています。");
		}else{	
	$kskl6 = 1;
	$ksg -= 3;
	$zou = "スキル：自動集合を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：自動集合を修得しました。");
		}
	}elsif($in{'select'} eq "41"){
	if(5 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl7 =~ /1/){
	&ERR("既に修得しています。");
		}else{	
	$kskl7 = 1;
	$ksg -= 5;
	$zou = "スキル：侵攻強化を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：侵攻強化を修得しました。");
		}
	}elsif($in{'select'} eq "42"){
	if(10 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl7 =~ /2/){
	&ERR("既に修得しています。");
	}elsif($kskl7 !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl7 .= ":2";
	$ksg -= 10;
	$zou = "スキル：進撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：進撃を修得しました。");
		}
	}elsif($in{'select'} eq "43"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl7 =~ /3/){
	&ERR("既に修得しています。");
	}elsif($kskl7 !~ /2/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl7 .= ":3";
	$ksg -= 15;
	$zou = "スキル：猛攻を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：猛攻を修得しました。");
		}
	}elsif($in{'select'} eq "44"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl7 =~ /4/){
	&ERR("既に修得しています。");
	}elsif($kskl7 !~ /2/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl7 .= ":4";
	$ksg -= 15;
	$zou = "スキル：波状攻撃を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：波状攻撃を修得しました。");
		}
	}elsif($in{'select'} eq "45"){
	if(7 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl8 =~ /1/){
	&ERR("既に修得しています。");
		}else{	
	$kskl8 = 1;
	$ksg -= 7;
	$zou = "スキル：縮地を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：縮地を修得しました。");
		}
	}elsif($in{'select'} eq "46"){
	if(13 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl8 =~ /2/){
	&ERR("既に修得しています。");
	}elsif($kskl8 !~ /1/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl8 .= ":2";
	$ksg -= 13;
	$zou = "スキル：加速を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：加速を修得しました。");
		}
	}elsif($in{'select'} eq "47"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl8 =~ /3/){
	&ERR("既に修得しています。");
	}elsif($kskl8 !~ /2/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl8 .= ":3";
	$ksg -= 15;
	$zou = "スキル：觔斗雲を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：觔斗雲を修得しました。");
		}
	}elsif($in{'select'} eq "48"){
	if(15 > $ksg){
	&ERR("SPが足りません。");
	}elsif($kskl8 =~ /4/){
	&ERR("既に修得しています。");
	}elsif($kskl8 !~ /2/){
	&ERR("スキル修得条件を満たしていません。");
		}else{	
	$kskl8 .= ":4";
	$ksg -= 15;
	$zou = "スキル：回避を修得しました。";
	&K_LOG("【<font color=red>修得</font>】スキル：回避を修得しました。");
		}

	}else{&ERR("不正なアクセスです。");}

	$kst = "$ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9,";
	$ksub4 = "$krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2,";

	&CHARA_MAIN_INPUT;

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$zou</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="ＯＫ"></form>
<form action="./mydata.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=SKL_BUY>
<input type=submit id=input value="スキル購入画面に戻る"></form>

</CENTER>
EOM

	&FOOTER;

	exit;

}
1;
