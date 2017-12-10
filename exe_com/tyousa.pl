#_/_/_/_/_/_/_/_/_/_/#
#      調査      #
#_/_/_/_/_/_/_/_/_/_/#

sub TYOUSA {

	$ksub2=0;
	if($kclass<5000){
		&K_LOG("$mmonth月:階級値不足で実行できませんでした。");
	}elsif($kgold<500){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{

	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN("$kcon");

		$kgold -= 500;
		$kcex += 37;
		$mhit = 0;

	open(IN,"./charalog/main/$cnum\.cgi") or $mhit = 1;
	@E_DATA = <IN>;
	close(IN);
				($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/,$E_DATA[0]);
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
($esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$ehiki,$eoujyou,$e_kei,$e_tan) = split(/,/,$esub3);
($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);
($esien,$eskl1,$eskl2,$eskl3,$eskl4,$eskl5,$eskl6,$eskl7,$eskl8,$eskl9) = split(/,/,$est);
($eindbmm,$esettei,$esettei2,$esettei3) = split(/,/,$esz);
($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL,$enaiskl,$ekeiskl,$etanskl,$ekinto,$e_jsub1,$e_jsub2) = split(/,/,$esub4);
($earm2,$eaname2,$eazoku2,$eaai2) = split(/,/,$esub5);

	&K_LOG("$mmonth月:$enameを調査しました。");

	if($kint >= 250){
		if($esyuppei){
		$px = $ex+1;
		$py = $ey+1;
		$syutugeki = "出撃中";
		#バトルマップ読み込み
		do "./log_file/map_hash/$eiti.pl";
		$aunt = "部隊所在地：$battkemapname";
		$aunt2 = "座標：\($px\.$py\)";
		}

				open(IN,"./charalog/command/$eid.cgi");
				@COM_DATA2 = <IN>;
				close(IN);
				for($i=0;$i<$MAX_COM;$i +=1){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA2[$i]);
					$no = $i+1;
					if($cid eq ""){
					$ecom_list .= "●$no: -  ";
					}else{
					$ecom_list .= "●$no:$cname ";
					}
					if($i>=1){last;}
				}

	&K_LOG("【$ename】武力：$estr\.$estr_ex 知力：$eint\.$eint_ex 統率力：$elea\.$elea_ex 人望：$echa\.$echa_ex 武器：$eaname\($eazoku\)：威力：$earm\(\+$eaai\) 武器２：$eaname2\($eazoku2\)：威力：$earm2\(\+$eaai2\) 書物：$esname：$ebook 忠誠値：$ebank");
	&K_LOG("兵数：$SOL_TYPE[$esub1_ex]\($SOL_ZOKSEI[$esub1_ex]\) $esol人 訓練値：$egat 貢献値：$ecex 階級値：$eclass 金：$egold 米：$erice 滞在都市：$town_name[$epos] $syutugeki $aunt $aunt2");
	&K_LOG("コマンド：$ecom_list");
	}elsif($kint >= 200){
		if($esyuppei){
		$px = $ex+1;
		$py = $ey+1;
		$syutugeki = "出撃中";
		#バトルマップ読み込み
		do "./log_file/map_hash/$eiti.pl";
		$aunt = "部隊所在地：$battkemapname";
		$aunt2 = "座標：\($px\.$py\)";
		}
	&K_LOG("【$ename】武力：$estr\.$estr_ex 知力：$eint\.$eint_ex 統率力：$elea\.$elea_ex 人望：$echa\.$echa_ex 武器：$eaname\($eazoku\)：威力：$earm\(\+$eaai\) 武器２：$eaname2\($eazoku2\)：威力：$earm2\(\+$eaai2\) 書物：$esname：$ebook 忠誠値：$ebank");
	&K_LOG("兵数：$SOL_TYPE[$esub1_ex]\($SOL_ZOKSEI[$esub1_ex]\) $esol人 訓練値：$egat 貢献値：$ecex 階級値：$eclass 金：$egold 米：$erice 滞在都市：$town_name[$epos] $syutugeki $aunt $aunt2");
	}elsif($kint >= 150){
		if($esyuppei){
		$syutugeki = "出撃中";
		#バトルマップ読み込み
		do "./log_file/map_hash/$eiti.pl";
		$aunt = "部隊所在地：$battkemapname";
		}
	&K_LOG("【$ename】武力：$estr\.$estr_ex 知力：$eint\.$eint_ex 統率力：$elea\.$elea_ex 人望：$echa\.$echa_ex 武器：$eaname\($eazoku\)：威力：$earm\(\+$eaai\) 武器２：$eaname2\($eazoku2\)：威力：$earm2\(\+$eaai2\) 書物：$esname：$ebook 忠誠値：$ebank");
	&K_LOG("兵数：$SOL_TYPE[$esub1_ex]\($SOL_ZOKSEI[$esub1_ex]\) $esol人 訓練値：$egat 貢献値：$ecex 階級値：$eclass 金：$egold 米：$erice 滞在都市：$town_name[$epos] $syutugeki $aunt");
	}elsif($kint >= 100){
		if($esyuppei){
		$syutugeki = "出撃中";
		}
	&K_LOG("【$ename】武力：$estr\.$estr_ex 知力：$eint\.$eint_ex 統率力：$elea\.$elea_ex 人望：$echa\.$echa_ex 武器：$eaname：威力：$earm 武器２：$eaname2：威力：$earm2 書物：$esname：$ebook 忠誠値：$ebank");
	&K_LOG("兵数：$esol人 貢献値：$ecex 階級値：$eclass 米：$erice 滞在都市：$town_name[$epos] $syutugeki");
	}elsif($kint >= 50){
		if($esyuppei){
		$syutugeki = "出撃中";
		}
	&K_LOG("【$ename】武力：$estr 知力：$eint 統率力：$elea 人望：$echa 武器：$eaname：威力：$earm 武器２：威力：$eaname2：$earm2 書物：$esname：$ebook 忠誠値：$ebank");
	&K_LOG("貢献値：$ecex 滞在都市：$town_name[$epos] $syutugeki");
	}else{
	6&K_LOG("【$ename】武力：$estr 知力：$eint 統率力：$elea 人望：$echa 武器：$eaname：威力：$earm 書物：$esname：$ebook 忠誠値：$ebank");
	}
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;
