#_/_/_/_/_/_/_/_/_/_/#
#      偵察      #
#_/_/_/_/_/_/_/_/_/_/#

sub TEI {

	$ksub2=0;
	if(($kclass<10000)||($kint < 50)){
		&K_LOG("$mmonth月:階級値もしくは知力不足で実行できませんでした。");
	}elsif($kgold<500){
		&K_LOG("$mmonth月:資金不足で実行できませんでした。");
	}else{
		$kgold -= 500;
		$kcex += 30;

	&TOWN_DATA_OPEN("$cnum");


	#キャラデータ全部オープン　1,7月以外なのは1,7月はcheck_com.cgiでopenしてるから#
	if($mmonth ne "1" && $mmonth ne "7"){
	opendir(dirlist,"./charalog/main");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"./charalog/main/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);
	}


		#バトルマップ読み込み
		do "./log_file/map_hash/$cnum.pl";

		KILL:for($i=0;$i<$BM_Y;$i++){
			for($j=0;$j<$BM_X;$j++){
				if($BM_TIKEI[$i][$j] == 18){
					foreach(@CL_DATA){
					($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
					($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
					($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);
						if($ex == $j && $ey == $i && $eiti eq $cnum){
						$def_list .= "$ename($esol) ";
						}
					}
				last KILL;
				}
			}
		}


		#迂回阻止度
		$shiro_sosi_p = int(($zshiro/(300+($myear*11.666)))*100);
		if($shiro_sosi_p > 100){
		$shiro_sosi_p = 100;
		$shiro_sosi_p += int ( ( ($zshiro-(300+($myear*11.666) ) )/( (300+($myear*11.666))*3 ) )*100 );
		if($shiro_sosi_p > 200){$shiro_sosi_p = 200;}
		}
		$shiro_sosi_s = $zshiro / (15+($myear*0.583));
		if($shiro_sosi_s > ($BMT_REMAKE*10)/60){
		$shiro_sosi_s = ($BMT_REMAKE*10)/60;
		$shiro_sosi_s += ($zshiro - (300+($myear*11.666)) )/( (15+($myear*0.583)) * 3);
		if($shiro_sosi_s > ($BMT_REMAKE*10)/30){$shiro_sosi_s = ($BMT_REMAKE*10)/30;}
		}
		$shiro_sosi_s = int($shiro_sosi_s*60);
		$shiro_sosi = "$shiro_sosi_p% (足止め効果:$shiro_sosi_s秒)";


		&K_LOG("$mmonth月:$znameを偵察しました。");
		&K_LOG("$znameの守備：$def_list");
		&K_LOG("農業：$znou\/$znou_max　商業：$zsyo\/$zsyo_max　技術：$zsub1\/9999　城壁：$zshiro\/$zshiro_max　城壁耐久力：$zdef_att\/9999　迂回阻止度：$shiro_sosi");
		&K_LOG("農民：$znum\/$zsub2　民忠：$zpri　相場：$zsouba");
		$kint_ex++;
		$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
	}

}
1;
