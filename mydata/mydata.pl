#_/_/_/_/_/_/_/_/#
#   個人データ   #
#_/_/_/_/_/_/_/_/#

sub MYDATA {

	require './lib/hs_keisan.pl';

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;
	&HEADER;


	#順位#

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/,$page[0]);

	if($ename =~ "【NPC】"){next;}

	($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
	($esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$ehiki,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$esihaicn,$ekezuricn) = split(/,/,$esub3);

	#攻防力計算
	($eatt_add,$eatt_def) = &HS_KEISAN(0,0,$esub1_ex,$estr,$eint,$elea,$echa,$earm,$ebook,$emes);
	$ekou = int($estr + $earm + $eatt_add);
	$ebou = int($eatt_def + $emes + ($egat / 2));
	$ekoubou = $ekou+$ebou;

	$esentou = $ebouwin + $ekouwin + $ekoulos + $eboulos + $ehiki + $esihai;
	$esensin = $ebouwin + $ekouwin;
			push(@CL_DATA,"$eid<>$esitahei<>$esarehei<>$ebouwin<>$ekouwin<>$ekoulos<>$eboulos<>$ekun<>$enai<>$emei<>$esentou<>$esensin<>$eoujyou<>$e_kei<>$e_tan<>$esihai<>$ekezuri<>$ekou<>$ebou<>$ekoubou<>\n");
		}
	}
	closedir(dirlist);

	@tmp = map {(split /<>/)[1]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesitahei == $esitahei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ktaosij = $j;
		}
		$mesitahei = $esitahei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[2]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesarehei == $esarehei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ksarej = $j;
		}
		$mesarehei = $esarehei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[3]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mebouwin == $ebouwin){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kbwj =$j;
		}
		$mebouwin = $ebouwin;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[4]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mekouwin == $ekouwin){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kkwj =$j;
		}
		$mekouwin = $ekouwin;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[5]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mekoulos == $ekoulos){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kklj =$j;
		}
		$mekoulos = $ekoulos;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[6]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($meboulos == $eboulos){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kblj =$j;
		}
		$meboulos = $eboulos;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[7]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mekun == $ekun){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kkunj =$j;
		}
		$mekun == $ekun;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[8]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($menai == $enai){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$knaij =$j;
		}
		$menai = $enai;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[9]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($memei == $emei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ktyouj =$j;
		}
		$memei = $emei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[10]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesentou == $esentou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ksentouj =$j;
		}
		$mesentou = $esentou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[11]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin) = split(/<>/);

		if($mesensin == $esensin){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$ksensinj =$j;
		}
		$mesensin = $esensin;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[12]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou) = split(/<>/);

		if($meoujyou == $eoujyou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$koujyouj =$j;
		}
		$meoujyou = $eoujyou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[13]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei) = split(/<>/);

		if($me_kei == $e_kei){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_keij =$j;
		}
		$me_kei = $e_kei;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[14]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan) = split(/<>/);

		if($me_tan == $e_tan){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_tanj =$j;
		}
		$me_tan = $e_tan;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[15]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai) = split(/<>/);

		if($me_siha == $esihai){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_sihaj =$j;
		}
		$me_siha = $esihai;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[16]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri) = split(/<>/);

		if($me_kezu == $ekezuri){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$k_kezuj =$j;
		}
		$me_kezu = $ekezuri;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[17]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$ekou) = split(/<>/);

		if($meatt_add == $ekou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$katj =$j;
		}
		$meatt_add = $ekou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[18]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$ekou,$ebou) = split(/<>/);

		if($mdef == $ebou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kdefj =$j;
		}
		$mdef = $ebou;
		$mj = $j;
		$i++;
	}

	@tmp = map {(split /<>/)[19]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	foreach(@POINT){
		($eid,$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$esentou,$esensin,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$ekou,$ebou,$ekoubou) = split(/<>/);

		if($mkb == $ekoubou){
		$j = $mj;
		}else{
		$j = $i;
		}
		if($eid eq $kid){
		$kkbj =$j;
		}
		$mkb = $ekoubou;
		$mj = $j;
		$i++;
	}

#終了#


#メモ読み込み
	open(IN, "./charalog/memo/$kid.cgi");
	$memo = <IN>;
	close(IN);

#プロフ読み込み
	open(IN, "./charalog/prof/$kid.cgi");
	$prof = <IN>;
	close(IN);

#タグ
	$memo =~ s/<br>/\n/g;

	$prof =~ s/<br>/\n/g;
	if($prof =~ /<font color=\"red\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"red\">/<red>/g;
	$prof =~ s/<\/font>/<\/red>/g;
	}if($prof =~ /<font color=\"blue\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"blue\">/<blue>/g;
	$prof =~ s/<\/font>/<\/blue>/g;
	}if($prof =~ /<font color=\"#00FF00\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"#00FF00\">/<green>/g;
	$prof =~ s/<\/font>/<\/green>/g;
	}if($prof =~ /<font color=\"#000000\">/ && $prof =~ /\<\/font\>/){
	$prof =~ s/<font color=\"#000000\">/<black>/g;
	$prof =~ s/<\/font>/<\/black>/g;
	}if($prof =~ /<a href\=\"/ && $prof =~ /\" target=\"_blank\"/ && $prof =~ /<\/a\>/){
	$prof =~ s/<a href\=\"/<a>/g;
	$prof =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($kcm =~ /<font color=\"red\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"red\">/<red>/g;
	$kcm =~ s/<\/font>/<\/red>/g;
	}if($kcm =~ /<font color=\"blue\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"blue\">/<blue>/g;
	$kcm =~ s/<\/font>/<\/blue>/g;
	}if($kcm =~ /<font color=\"#00FF00\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"#00FF00\">/<green>/g;
	$kcm =~ s/<\/font>/<\/green>/g;
	}if($kcm =~ /<font color=\"#000000\">/ && $kcm =~ /\<\/font\>/){
	$kcm =~ s/<font color=\"#000000\">/<black>/g;
	$kcm =~ s/<\/font>/<\/black>/g;
	}if($kcm =~ /<a href\=\"/ && $kcm =~ /\" target=\"_blank\"/ && $kcm =~ /<\/a\>/){
	$kcm =~ s/<a href\=\"/<a>/g;
	$kcm =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($kaname =~ /<font color=\"red\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"red\">/<red>/g;
	$kaname =~ s/<\/font>/<\/red>/g;
	}if($kaname =~ /<font color=\"blue\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"blue\">/<blue>/g;
	$kaname =~ s/<\/font>/<\/blue>/g;
	}if($kaname =~ /<font color=\"#00FF00\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"#00FF00\">/<green>/g;
	$kaname =~ s/<\/font>/<\/green>/g;
	}if($kaname =~ /<font color=\"#000000\">/ && $kaname =~ /\<\/font\>/){
	$kaname =~ s/<font color=\"#000000\">/<black>/g;
	$kaname =~ s/<\/font>/<\/black>/g;
	}if($kaname =~ /<a href\=\"/ && $kaname =~ /\" target=\"_blank\"/ && $kaname =~ /<\/a\>/){
	$kaname =~ s/<a href\=\"/<a>/g;
	$kaname =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($kbname =~ /<font color=\"red\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"red\">/<red>/g;
	$kbname =~ s/<\/font>/<\/red>/g;
	}if($kbname =~ /<font color=\"blue\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"blue\">/<blue>/g;
	$kbname =~ s/<\/font>/<\/blue>/g;
	}if($kbname =~ /<font color=\"#00FF00\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"#00FF00\">/<green>/g;
	$kbname =~ s/<\/font>/<\/green>/g;
	}if($kbname =~ /<font color=\"#000000\">/ && $kbname =~ /\<\/font\>/){
	$kbname =~ s/<font color=\"#000000\">/<black>/g;
	$kbname =~ s/<\/font>/<\/black>/g;
	}if($kbname =~ /<a href\=\"/ && $kbname =~ /\" target=\"_blank\"/ && $kbname =~ /<\/a\>/){
	$kbname =~ s/<a href\=\"/<a>/g;
	$kbname =~ s/\" target=\"_blank\"/<aa>/g;
	}
	if($ksname =~ /<font color=\"red\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"red\">/<red>/g;
	$ksname =~ s/<\/font>/<\/red>/g;
	}if($ksname =~ /<font color=\"blue\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"blue\">/<blue>/g;
	$ksname =~ s/<\/font>/<\/blue>/g;
	}if($ksname =~ /<font color=\"#00FF00\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"#00FF00\">/<green>/g;
	$ksname =~ s/<\/font>/<\/green>/g;
	}if($ksname =~ /<font color=\"#000000\">/ && $ksname =~ /\<\/font\>/){
	$ksname =~ s/<font color=\"#000000\">/<black>/g;
	$ksname =~ s/<\/font>/<\/black>/g;
	}if($ksname =~ /<a href\=\"/ && $ksname =~ /\" target=\"_blank\"/ && $ksname =~ /<\/a\>/){
	$ksname =~ s/<a href\=\"/<a>/g;
	$ksname =~ s/\" target=\"_blank\"/<aa>/g;
	}


	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);

	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);
	
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);

	($karm2,$kaname2,$kazoku2,$kaai2) = split(/,/,$ksub5);

	$buki1 = "<option value=\"0\">名称:$kaname 威力:$karm 属性:$kazoku 相性:+$kaai【装備中】";
	if(($karm eq "")&&($kaname eq "")&&($kazoku eq "")&&($kaai eq "")){
	$buki1 = "<option value=\"0\">------【武器なし】-----";
	}
	$buki2 = "<option value=\"1\">名称:$kaname2 威力:$karm2 属性:$kazoku2 相性:+$kaai2";
	if(($karm2 eq "")&&($kaname2 eq "")&&($kazoku2 eq "")&&($kaai2 eq "")){
	$buki2 = "<option value=\"1\">------【武器なし】-----";
	}

	#移動P補充可能時通知設定
	if($ksettei2==1){$sel1="SELECTED";}elsif($ksettei2==2){$sel2="SELECTED";}elsif($ksettei2==3){$sel3="SELECTED";}
	#行動可能時通知設定
	if($ksettei4==1){$sel_1="SELECTED";}elsif($ksettei4==2){$sel_2="SELECTED";}elsif($ksettei4==3){$sel_3="SELECTED";}
	#BM表示設定
	if($kindbmm==1){$ind1="SELECTED";}elsif($kindbmm==2){$ind2="SELECTED";}elsif($kindbmm==3){$ind3="SELECTED";}

	#陣形読み込み#
	open(IN,"./log_file/jinkei.cgi") or &ERR2("陣形データ読み込み失敗");
	@JINKEI = <IN>;
	close(IN);
	
	$i = 0;
	if($kjinkei eq ""){$kjinkei=0;}
	foreach(@JINKEI){
	($jinname,$jinaup,$jindup,$jinaup2,$jindup2,$jinaup3,$jindup3,$jin_tokui,$jinchange,$jinclas,$jinsetumei,$jinsub,$jinsub2)=split(/<>/);
		if($kjinkei eq $i){
		$jin = "$jinname";
		$mes ="$jinsetumei陣形を整えるのにかかる時間は$jinchange秒。";
		$sel ="SELECTED";
			}else{
				$sel ="";
		}
		if($jinclas <= $kclass && $jinsub2 eq ""){
		$JINNAME[$i] = "<option value=\"$i\" $sel>$jinname";
			}
	$i++;
	}

	$ksentou = $kbouwin + $kkouwin + $kkoulos + $kboulos + $khiki + $ksihai;
	$ksensin = $kbouwin + $kkouwin;

	#攻防力計算
	($katt_add,$katt_def) = &HS_KEISAN(0,0,$ksub1_ex,$kstr,$kint,$klea,$kcha,$karm,$kbook,$kmes);
	$kkou = int($kstr + $karm + $katt_add);
	$kbou = int($katt_def + $kmes + ($kgat / 2));
	$kkoubou = $kkou+$kbou;

	$ihihi = int(rand(30));
	if($ihihi eq "1"){
	$ahaha = "<TABLE cellspacing=1 bgcolor=#000000><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=#000000 colspan=2><form action=\"./modoru.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=image src=image/img/3578.png></form></TABLE>";

	}

	print <<"EOM";
<!-- mp3演奏 -->
<script type="text/javascript"><!--

function play(foo){
	foo += 1;
	document.getElementById("sound-file-" + foo).play();
}

--></script>

<!-- mp3演奏 -->
EOM
for($i=1;$i<=7;$i++){
print "<audio id=\"sound-file-$i\" preload=\"auto\">
<source src=\"./sound/$i.mp3\" type=\"audio/mp3\">
</audio>
";
}
print <<"EOM";


<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 設定＆戦績 - </font>
</TH></TR>
</TABLE>

<TABLE border=0 bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>
<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>

<HR color="#000000">

<TABLE style="width:100%;border:0;">
<tr><td valign="top" width="100%" colspan="2">
<TABLE width="100%" cellspacing="1" bgcolor=$ELE_BG[$xele] class="mwindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=10 bgcolor=$ELE_BG[$xele] class="inwindow"><font color=$ELE_C[$xele]>- 設定 -</font></TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>マイページでのBM表示設定</TD><TH colspan=7>
<select name=sel>
<option value="0">移動しやすいタイプ 表示
<option value="1" $ind1>移動しやすいタイプ 非表示
<option value="2" $ind2>通常 表示する
<option value="3" $ind3>通常 表示しない
</select>
</TH><TH>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=INDBM>
<input type=submit id=input value="設定">
</form></TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>文字サイズ設定</TD><TH colspan=7>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=SIZECHANGE>
<select name=size>

EOM
for($i=1;$i<=40;$i++){
		if($i == $ksettei){
			print "<option value=\"$i\" SELECTED>$i";
		}else{
			print "<option value=\"$i\">$i";
		}
	}
print <<"EOM";

</TH><TH>
<input type=submit id=input value="決定">
</form></TH></TR>
<form action="./auto_in.cgi" method="post"><TR><TD colspan=2>BM上での行動予約(BM自動モード)</TD><TH colspan=8>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=submit id=input value=表示>
</form></TH></TR>
<form action="./mydata.cgi" method="post" name="base"><TR><TD colspan=2>移動P補充可能になった時の通知設定<br><font size="1">※BMを開いている時、移動ポイントが補充可能になった時の通知に関する設定です。</font></TD><TH colspan=4>
<select name=sel>
<option value="0">通知しない
<option value="1" $sel1>通知音を鳴らす
<option value="2" $sel2>アラートを出す
<option value="3" $sel3>通知音とアラートを出す
</select>
</TH><td style="width:70px;">
通知音設定
</td><TH style="width:10px;">
<select name="sound">
EOM
for($i=1;$i<=7;$i++){
	if($ksettei3 == $i){
	print "<option value=\"$i\" SELECTED>$i番\n";
	}else{
	print "<option value=\"$i\">$i番\n";
	}
}
print <<"EOM";
</select>
</TH><TH style="width:10px;">
<input type="button" onClick="play(document.base.sound.selectedIndex)" value="再生">
</TH><TH>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=\"ALERT\">
<input type=submit id=input value=設定>
</form></TH></TR>
<form action="./mydata.cgi" method="post" name="base2"><TR><TD colspan=2>行動可能になった時の通知設定<br><font size="1">※BMを開いている時、行動可能になった時の通知に関する設定です。</font></TD><TH colspan=4>
<select name=sel>
<option value="0">通知しない
<option value="1" $sel_1>通知音を鳴らす
<option value="2" $sel_2>アラートを出す
<option value="3" $sel_3>通知音とアラートを出す
</select>
</TH><td style="width:70px;">
通知音設定
</td><TH style="width:10px;">
<select name="sound2">
EOM
for($i=1;$i<=7;$i++){
	if($ksettei5 == $i){
	print "<option value=\"$i\" SELECTED>$i番\n";
	}else{
	print "<option value=\"$i\">$i番\n";
	}
}
print <<"EOM";
</select>
</TH><TH style="width:10px;">
<input type="button" onClick="play(document.base2.sound2.selectedIndex)" value="再生">
</TH><TH>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=\"ALERT2\">
<input type=submit id=input value=設定>
</form></TH></TR>
<TR><form action="./mydata.cgi" method="post"><TD colspan=1>陣形<br><font size="1">[<a href="./manual.html#jin" target="_blank">陣形について</a>]</font></TD>
<th width=70>$jin</th>
<TH colspan=6>$mes</TH>
<th>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=JINKEI>
<select name=jinkei>
@JINNAME
</select>
</TH><TH>
<input type=submit id=input value="変更"></form>
</TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>忠誠度<br><font size="1">※<font color=red>非常に重要です。</font>簒奪、反乱、建国に影響します。詳しくは<a href="./manual.html#tyuuusei" target="_blank">こちら</a></font></TD><TH colspan=7>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=CYUUSEI>
<input type=text name=cyuu size=5 value=\"$kbank\">
</TH><TH>
<input type=submit id=input value="忠誠">
</form></TH></TR>
<TR><form action="./mydata.cgi" method="post"><TD colspan=2>キャラ画像<br> <font size="1"><a href="$AICON_URL" target="_blank">アイコン一覧</a></font></TD><TH colspan=7>
<input type=hidden name=id value=\"$kid\">
<input type=hidden name=pass value=\"$kpass\">
<input type=hidden name=mode value=GAZOU>
<input type=text name=gazou size=5 value=\"$kchara\">
</TH><TH>
<input type=submit id=input value="変更"></form>
</TH></TR>
<TR><form action="./mydata.cgi" method="post"><TD colspan=1 rowspan=3>装備品名変更<br><font size="1">※全角１５文字まで</font></TD><th>武器</th><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=BOUNAME>
<input type=text name=armname size=30 value=\"$kaname\">
</TH><TH rowspan=3>
<input type=submit id=input value="変更">
</TH></TR>
<TR><th>防具</th><TH colspan=7>
<input type=text name=bouname size=30 value=\"$kbname\">
</TH></TR>
<TR><th>書物</th><TH colspan=7>
<input type=text name=proname size=30 value=\"$ksname\">
</TH></TR></form>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>装備武器変更<br><font size="1">※武器は最大2個まで所持できます。</font></TD><TH colspan=7>
<input type=hidden name=id value="$kid">
<input type=hidden name=pass value="$kpass">
<input type=hidden name=mode value=S_B_H>
<select name="buki" size=1>
$buki1
$buki2
</select>
</TH><TH>
<input type=submit id=input value="変更">
</form>
</TH>
</TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>戦闘勝利時のコメント<br><font size="1">※全角３０文字まで</font></TD><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MEE>
<input type=text name=mee size=46 value=\"$kcm\">
</TH><TH>
<input type=submit id=input value="決定"></form>
</TH></TR>
<form action="./mydata.cgi" method="post"><TR><TD colspan=2>プロフィール<br><font size="1">※全角10000文字まで</font></TD><TH colspan=7>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MEE2>
<textarea name=mes cols=50 rows=10>
$prof
</textarea>
</TH><TH>
<input type=submit id=input value="決定">
</form>
</TH>
</TR>
</TBODY></TABLE>

</td>

</tr>
<tr>

<td width=50%>

<TABLE width=100% cellspacing="1" bgcolor=$ELE_BG[$xele] class="mwindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele] colspan="3" class="inwindow"><font color=$ELE_C[$xele]>- 戦績 -</font></TH></TR>
<TR><TH>部門</TH><TH>数値</TH><TH>順位</TH></TR>
<TR><TD>攻撃力</TD><TH>$kkou</TH><TH>$katj位</TH></TR>
<TR><TD>守備力</TD><TH>$kbou</TH><TH>$kdefj位</TH></TR>
<TR><TD>攻撃力+守備力</TD><TH>$kkoubou</TH><TH>$kkbj位</TH></TR>
<TR><TD>戦闘回数</TD><TH>$ksentou 回</TH><TH>$ksentouj位</TH></TR>
<TR><TD>戦勝回数</TD><TH>$ksensin 回</TH><TH>$ksensinj位</TH></TR>
<TR><TD>侵攻勝利回数</TD><TH>$kkouwin 回</TH><TH>$kkwj位</TH></TR>
<TR><TD>侵攻敗北回数</TD><TH>$kkoulos 回</TH><TH>$kklj位</TH></TR>
<TR><TD>防衛勝利回数</TD><TH>$kbouwin 回</TH><TH>$kbwj位</TH></TR>
<TR><TD>防衛敗北回数</TD><TH>$kboulos 回</TH><TH>$kblj位</TH></TR>
<TR><TD>倒した兵数</TD><TH>$ksitahei 人</TH><TH>$ktaosij位</TH></TR>
<TR><TD>倒された兵数</TD><TH>$ksarehei 人</TH><TH>$ksarej位</TH></TR>
<TR><TD>都市支配回数</TD><TH>$ksihai 回</TH><TH>$k_sihaj位</TH></TR>
<TR><TD>攻城回数</TD><TH>$koujyou 回</TH><TH>$koujyouj位</TH></TR>
<TR><TD>城壁削り数</TD><TH>$kkezuri</TH><TH>$k_kezuj位</TH></TR>
<TR><TD>訓練回数</TD><TH>$kkun 回</TH><TH>$kkunj位</TH></TR>
<TR><TD>徴兵回数</TD><TH>$kmei 回</TH><TH>$ktyouj位</TH></TR>
<TR><TD>内政回数</TD><TH>$knai 回</TH><TH>$knaij位</TH></TR>
<TR><TD>計略回数</TD><TH>$k_kei 回</TH><TH>$k_keij位</TH></TR>
<TR><TD>能力強化回数</TD><TH>$k_tan 回</TH><TH>$k_tanj位</TH></TR>
</TBODY></TABLE>

</td><td width=50% valign="top">

<TABLE bgcolor=$ELE_BG[$xele] class="mwindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>- メモ -</font></TH></TR>
<form action="./mydata.cgi" method="post"><TR><TH>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MEMO>
<textarea name="message" cols="45" rows="13">
$memo
</textarea><BR>
<input type=submit id=input value="保存"></form>
</TR></TH>
</TBODY></TABLE>

</td><td valigh=top>

<TABLE border="0" bgcolor="#ffffff">
<tr><td>
</td><TD>$ahaha</TD></tr>
</TABLE>

</td></tr>

</table>
<BR>

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
