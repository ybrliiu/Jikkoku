# _/_/_/_/_/_/_/_ #
#     更新処理    #
# _/_/_/_/_/_/_/_ #
sub CHECK_COM{

	# Command list
	require './ini_file/com_list.ini';
	#skl lib
	require './lib/skl_lib.pl';

	&D_F_LOCK;
	if (!-e $lockfile2) {&ERR2("ファイルロックされていません。");}

	open(IN,"$TOWN_LIST");
	@TOWN_DATA = <IN>;
	close(IN);

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	# 都市データを配列に格納
	$zc=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con,$z2num,$z2nou,$z2syo,$z2shiro)=split(/<>/);
		$town_name[$zc] = "$z2name";
		$town_cou[$zc] = "$z2con";
		$town_get[$z2con] += 1;
		$town_num[$z2con] += $z2num;
		$town_nou[$z2con] += $z2nou;
		$town_syo[$z2con] += $z2syo;
		$zc++;
	}

	# PLAYER DATAを配列に格納
	$dir="./charalog/main";
	if($mmonth eq "1" || $mmonth eq "7"){
		opendir(dirlist,"$dir");
		while($file = readdir(dirlist)){
			if($file =~ /\.cgi/i){
				if(!open(page,"$dir/$file")){
					&ERR2("ファイルオープンエラー！");
				}
				@page = <page>;
				close(page);
				($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex) = split(/<>/,$page[0]);
				$cou_num[$kcon]++;
				$cex_total[$kcon]++;
				push(@CL_DATA,"@page<br>");
			}
		}
		closedir(dirlist);
	}

	opendir(dirlist,"$dir");
	$kup_date=0;
	$thit=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$kspbuy,$kskldata,$kskldata2,$ksub6,$ksub7,$ksub8) = split(/<>/,$page[0]);

	#キャラでーたが壊れていたとき自動復旧#
	if($kid eq ""){
	require './return.pl';
	&RETURN;
	}

			if($kdate + $TIME_REMAKE < $date && $mtime > $kdate){
				$thit=1;
				($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);
($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);
				$ksentoukaisu = $kbouwin+$kkouwin+$kkoulos+$kboulos+$khiki;
				$ksentouwin = $kbouwin+$kkouwin;
				$ksentoulos = $kkoulos+$kboulos;
				($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
				($kindbmm,$ksettei,$ksettei2,$ksettei3,$ksettei4,$ksettei5) = split(/,/,$ksz);
				($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);
				($karm2,$kaname2,$kazoku2,$kaai2,$karmskl2) = split(/,/,$ksub5);
				($kbookskl,$kbouskl) = split(/,/,$kyumi);
				($ksiki,$ksiki_max) = split(/,/,$ksub6);

				#士気回復
				if($ksiki_max eq ""){$ksiki_max = 100;}
				$ksiki += int($ksiki_max*0.3);
				if($ksiki > $ksiki_max){$ksiki = $ksiki_max;}

				$maekaikyu = $kclass;
				if($mmonth eq "1"){
					&SALARY;
					if($cou_num[$kcon] eq "0" || $cou_num[$kcon] eq ""){
						$cou_num[$kcon] = 1;
					}
					$kadd = 0;
					if($cex_total[$kcon] ne 0){
					$kadd  = int(($ksal * $kcex / ($cex_total[$kcon]*160)) + $kcex * 1.3);
					}
					$s_num = int($kclass / $LANK);
					if($s_num > 100){$s_num = 100;}
					if(($s_num <= 10) && ($kadd > 1000 + $s_num * 500)){$kadd=1000 + $s_num * 500;}
					elsif(($s_num <= 30) && ($kadd > 6000 + ($s_num-10) * 300)){$kadd=6000 + ($s_num-10) * 300;}
					elsif($kadd > 12000 + ($s_num-30) * 200){$kadd=12000 + ($s_num-30) * 200;}
					$kgold += $kadd;
					$k_ex_fol= ($kclass % $LANK)+$kcex;
					$kclass += $kcex;
					if($k_ex_fol > $LANK){
						$s_num = int($kclass / $LANK);
						if($s_num > 100){$s_num = 100;}
						$nadd = int(rand(4));
						if($nadd eq "1"){
							$kstr++;
							$add_m = "武力";
						}elsif($nadd eq "2"){
							$kint++;
							$add_m = "知力";
						}elsif($nadd eq "3"){
							$kcha++;
							$add_m = "人望";
						}else{
							$klea++;
							$add_m = "統率力";
						}
						$ksg++;
						if($s_num <= 10){$max_sal = 1000 + $s_num * 500;}
						elsif($s_num <= 30){$max_sal = 6000 + ($s_num-10) * 300;}
						else{$max_sal = 12000 + ($s_num-30) * 200;}
						&K_LOG("$mmonth月:【<font color=red>昇格</font>】SPが１増えました！");
						&K_LOG("$mmonth月:【<font color=red>昇格</font>】$add_mが１上がりました！");
						&K_LOG("$mmonth月:【<font color=red>昇格</font>】Lv.$s_num $LANK[$s_num]になった！給与の最大支給額が<font color=red> $max_sal </font>になった！");

					}
					$kcex = 0;
					$ksm = 0;
					&K_LOG("$mmonth月:税金で<font color=red>$kadd</font>の金を徴収しました。");
				}elsif($mmonth eq "7"){
					&SALARY;
					if($cou_num[$kcon] eq "0" || $cou_num[$kcon] eq ""){
						$cou_num[$kcon] = 1;
					}
					$kadd = 0;
					if($cex_total[$kcon] ne 0){
					$kadd  = int(($ksal * $kcex / ($cex_total[$kcon]*160)) + $kcex * 1.3);
					}
					$s_num = int($kclass / $LANK);
					if($s_num > 100){$s_num = 100;}
					if(($s_num <= 10) && ($kadd > 1000 + $s_num * 500)){$kadd=1000 + $s_num * 500;}
					elsif(($s_num <= 30) && ($kadd > 6000 + ($s_num-10) * 300)){$kadd=6000 + ($s_num-10) * 300;}
					elsif($kadd > 12000 + ($s_num-30) * 200){$kadd=12000 + ($s_num-30) * 200;}
					$krice += $kadd;
					$k_ex_fol= ($kclass % $LANK)+$kcex;
					$kclass += $kcex;
					if($k_ex_fol > $LANK){
						$s_num = int($kclass / $LANK);
						if($s_num > 100){$s_num = 100;}
						$nadd = int(rand(4));
						if($nadd eq "1"){
							$kstr++;
							$add_m = "武力";
						}elsif($nadd eq "2"){
							$kint++;
							$add_m = "知力";
						}elsif($nadd eq "3"){
							$kcha++;
							$add_m = "人望";
						}else{
							$klea++;
							$add_m = "統率力";
						}
						$ksg++;
						if($s_num <= 10){$max_sal = 1000 + $s_num * 500;}
						elsif($s_num <= 30){$max_sal = 6000 + ($s_num-10) * 300;}
						else{$max_sal = 12000 + ($s_num-30) * 200;}
						&K_LOG("$mmonth月:【<font color=red>昇格</font>】SPが１増えました！");
						&K_LOG("$mmonth月:【<font color=red>昇格</font>】$add_mが１上がりました！");
						&K_LOG("$mmonth月:【<font color=red>昇格</font>】Lv.$s_num $LANK[$s_num]になった！給与の最大支給額が<font color=red> $max_sal </font>になった！");
					}
					$kcex = 0;
					&K_LOG("$mmonth月:収穫で<font color=red>$kadd</font>の食料を収穫しました。");
				}


				#階級上昇時メッセージ
				if($maekaikyu < 5000 && $kclass >= 5000){
				&K_LOG("$mmonth月:【<font color=red>新コマンド開放</font>】新たに農地開拓、市場建設、城壁拡張、開拓、調査コマンドが使用できるようになりました！");
				&K_LOG("$mmonth月:【<font color=red>陣形修得</font>】円陣、方陣、彎月陣、鶴翼陣を覚えました！");
				}elsif($maekaikyu < 6000 && $kclass >= 6000){
				&K_LOG("$mmonth月:【<font color=red>新コマンド開放</font>】新たに兵士猛訓練コマンドが使用できるようになりました！");
				}elsif($maekaikyu < 10000 && $kclass >= 10000){
				&K_LOG("$mmonth月:【<font color=red>新コマンド開放</font>】新たに農地破壊、市場破壊、技術衰退、城壁劣化、流言、偵察コマンドが使用できるようになりました！");
				&K_LOG("$mmonth月:【<font color=red>陣形修得</font>】曲陣、錘行陣、沖方陣、車輪陣、罘変陣、雁行陣を覚えました！");
				}elsif($maekaikyu < 15000 && $kclass >= 15000){
				&K_LOG("$mmonth月:【<font color=red>新コマンド開放</font>】新たに入植コマンドが使用できるようになりました！");
				}elsif($maekaikyu < 20000 && $kclass >= 20000){
				&K_LOG("$mmonth月:【<font color=red>陣形修得</font>】玄襄陣を覚えました！");
				}elsif($maekaikyu < 25000 && $kclass >= 25000){
				&K_LOG("$mmonth月:【<font color=red>新コマンド開放</font>】新たに兵士特訓コマンドが使用できるようになりました！");
				}elsif($maekaikyu < 50000 && $kclass >= 50000){
				&K_LOG("$mmonth月:【<font color=red>新コマンド開放</font>】新たに兵士猛特訓コマンドが使用できるようになりました！");
				}


				open(IN,"./charalog/command/$kid\.cgi");
				@COM_DATA = <IN>;
				close(IN);
				($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[0]);


	      my $stop_update_date = open_data("./log_file/stop_con.cgi");
        my $stopcount = $stop_update_date->[0];

        # 25時~19時更新停止処理
        $kdate += $stop_count < 18 ? $TIME_REMAKE : $TIME_REMAKE * 55;


				&CHARA_MAIN_INPUT;
				splice(@COM_DATA,0,1);
				push(@COM_DATA,"<><><><><><><>\n");

				open(OUT,">./charalog/command/$kid\.cgi");
				print OUT @COM_DATA;
				close(OUT);

				($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$kpos]);
				if($zcon eq "$kcon" || $cid eq "20" || $cid eq "21" || $cid eq "27" || $cid eq "56" || $cid eq "$HANRAN2" || $cid eq "$TAIKYAKU"|| $cid eq "0" || $cid eq ""){

					$kprodmg = 0;
					@BM_TIKEI = ();

					if($cid eq $NOUGYOU){
						if(!$nougyou){
							require "$EXE/nougyou.pl";
							$nougyou = TRUE;
						}
						&NOUGYOU;
					}elsif($cid eq $SYOUGYOU){
						if(!$syougyou){
							require "$EXE/syougyou.pl";
							$syougyou = TRUE;
						}
						&SYOUGYOU;
					}elsif($cid eq $SHIRO){
						if(!$shiro){
							require "$EXE/shiro.pl";
							$shiro = TRUE;
						}
						&SHIRO;
					}elsif($cid eq $RICE_GIVE){
						if(!$rice_give){
							require "$EXE/rice_give.pl";
							$rice_give = TRUE;
						}
						&RICE_GIVE;
					}elsif($cid eq $GET_SOL2){
						if(!$get_sol){
							require "$EXE/get_sol.pl";
							$get_sol = TRUE;
						}
						&GET_SOL;
					}elsif($cid eq $KUNREN){
						$ksub2=0;
						if($kgat > 100){
						$kcex += 30;
						&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
						$klea_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}else{
						if($krenpei eq "3"){
						$kunritu = 0.5;
						}elsif($krenpei eq "2"){
						$kunritu = 1;
						}elsif($krenpei eq "1"){
						$kunritu = 2;
						}elsif($krenpei eq "0"){
						$kunritu = 3;
						}else{
						$kunritu = 4;
						}
						$kgat += int($klea/$kunritu + rand($klea/$kunritu));
						if($kgat > 100){
							$kgat = 100;
						}
						$kcex += 30;
						&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
						$klea_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}
					}elsif($cid eq $MOUKUNREN){
						$ksub2=0;
						if(($kclass<6000)||($kgold < 50)){
							&K_LOG("$mmonth月:このコマンドを実行するために必要な金か階級値が足りません。");
						}elsif($kgat > 200){
						$kgold -= 50;
						$kcex += 33;
						&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
						$klea_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}else{
						if($krenpei eq "3"){
						$kunritu = 0.5;
						}elsif($krenpei eq "2"){
						$kunritu = 1;
						}elsif($krenpei eq "1"){
						$kunritu = 2;
						}elsif($krenpei eq "0"){
						$kunritu = 3;
						}else{
						$kunritu = 4;
						}
							$kgat += int($klea/$kunritu + rand($klea/$kunritu));
							$kgold -= 50;
							if($kgat > 200){
								$kgat = 200;
							}
							$kcex += 33;
							&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
							$klea_ex++;
							$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}
					}elsif($cid eq $TKUNREN){
						$ksub2=0;
						if(($kclass<25000)||($kgold < 100)){
							&K_LOG("$mmonth月:このコマンドを実行するために必要な金か階級値が足りません。");
						}elsif($kgat > 350){
						$kgold -= 100;
						$kcex += 37;
						&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
						$klea_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}else{
						if($krenpei eq "3"){
						$kunritu = 1;
						}elsif($krenpei eq "2"){
						$kunritu = 2;
						}elsif($krenpei eq "1"){
						$kunritu = 3;
						}elsif($krenpei eq "0"){
						$kunritu = 4;
						}else{
						$kunritu = 5;
						}
							$kgat += int($klea/$kunritu + rand($klea/$kunritu));
							$kgold -= 100;
							if($kgat > 350){
								$kgat = 350;
							}
							$kcex += 37;
							&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
							$klea_ex++;
							$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}
					}elsif($cid eq $MTKUNREN){
						$ksub2=0;
						if(($kclass<50000)||($kgold < 200)){
							&K_LOG("$mmonth月:このコマンドを実行するための金か階級値が足りません。");
						}elsif(($ksub1_ex ne "999")&&($kgat > 500)){
						$kgold -= 200;
						$kcex += 40;
						&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
						$klea_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}elsif($kgat > 750){
						$kgold -= 200;
						$kcex += 40;
						&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
						$klea_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}else{
						if($krenpei eq "3"){
						$kunritu = 1.5;
						}elsif($krenpei eq "2"){
						$kunritu = 2.5;
						}elsif($krenpei eq "1"){
						$kunritu = 3.5;
						}elsif($krenpei eq "0"){
						$kunritu = 4.5;
						}else{
						$kunritu = 5.5;
						}
							$kgat += int($klea/$kunritu + rand($klea/$kunritu));
							$kgold -= 200;
							if(($ksub1_ex ne "999")&&($kgat > 500)){
								$kgat = 500;
							}elsif($kgat > 750){
								$kgat = 750;
							}
							$kcex += 40;
							&K_LOG("$mmonth月:兵士の訓練度が<font color=red>$kgat</font>になりました。");
							$klea_ex++;
							$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						$kkun++;
						$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,";
						}
					}elsif($cid eq $TOWN_DEF){
						if(!$town_def){
							require "$EXE/town_def.pl";
							$town_def = TRUE;
						}
						&TOWN_DEF;
					}elsif($cid eq "18"){
						$ksub2=0;
						($z5name,$z5con,$z5num,$z5nou,$z5syo,$z5shiro,$z5nou_max,$z5syo_max,$z5shiro_max,$z5pri,$z5x,$z5y,$z5souba,$z5def_att,$z5sub1,$z5sub2,$z5[0],$z5[1],$z5[2],$z5[3],$z5[4],$z5[5],$z5[6],$z5[7])=split(/<>/,$TOWN_DATA[$cnum]);
						if($z5[0] ne $kpos && $z5[1] ne $kpos && $z5[2] ne $kpos && $z5[3] ne $kpos && $z5[4] ne $kpos && $z5[5] ne $kpos && $z5[6] ne $kpos && $z5[7] ne $kpos ){
							&K_LOG("$mmonth月:$z5nameには隣接していません。");
						}elsif($ksol <= 0 || $ksol eq ""){
							&K_LOG("$mmonth月:兵士0人では出兵できません。");
						}elsif($ksyuppei){
						$kcex += 25;
						$kstr_ex++;
						$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
						&K_LOG("$mmonth月:【コマンド失敗】既に出撃しています。武力経験値+1 貢献値+25");
						}else{
							if(!$battle){
								require "$EXE/battle.pl";
								$battle = TRUE;
							}												&BATTLE;
						}
					}elsif($cid eq $BUY2){
						if(!$buy){
							require "$EXE/buy.pl";
							$buy = TRUE;
						}
						&BUY;
					}elsif($cid eq "20"){
						$ksub2=0;
						$zhit=0;
						foreach(@z){
							if($_ eq $cnum){$zhit=1;}
						}
						if($zhit){
							$kpos = $cnum;
							$klea_ex++;
							$kcex += 28;
							$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
							&K_LOG("$mmonth月:$town_name[$cnum]へ移動しました。");
							if(($kcon eq 0)&&(rand(1) < 0.25)){
							$solpras = int(rand(5))+1;
							$ksol += $solpras;
							if($ksol > $klea){$ksol = $klea;}
							&K_LOG("$mmonth月:移動中にであった流民を配下に加えました。兵士+$solpras人");
							}
						}else{
							&K_LOG("$mmonth月:$town_name[$cnum]へ移動出来ません。現在位置：$zname");
						}
					}elsif($cid eq $SHIKAN){
						if(!$shikan){
							require "$EXE/shikan.pl";
							$shikan = TRUE;
						}
						&SHIKAN;
					}elsif($cid eq "22"){
						$ksub2=0;
						open(IN,"$ARM_LIST");
						@ARM_DATA = <IN>;
						close(IN);
						($armname,$armval,$armdmg,$armwei,$armele,$armsta,$armclass,$armtownid,$armsetumei,$armskl) = split(/<>/,$ARM_DATA[$cnum]);

						if($kazoku eq "機"){$zokG = ($kaai/4.5);}else{$zokG = ($kaai/3);}
						$armval2 = int(($karm+$zokG) * 2333);
						$armname2 = "$kaname";
						$armkaikyu = $armsta*5;
						if($armkaikyu > 25000){$armkaikyu = 25000;}

						if($armval > $kgold + $armval2){
							&K_LOG("$mmonth月:所持金がたりません。$armname 金:$armval");
						}elsif($zsub1 < $armsta){
							&K_LOG("$mmonth月:技術がたりません。$armname 必要技術:$armsta");
						}elsif($kclass < $armkaikyu){
							&K_LOG("$mmonth月:階級値がたりません。$armname 必要階級:$armkaikyu");
						}else{
							$kgold += $armval2;
							$kgold -= $armval;
							$karm = $armdmg;
							$kaname = "$armname";
							$kazoku = "$armwei";
							$kaai = $armele;
							if($armskl ne ""){$khohei = $armskl;}
							&K_LOG("$mmonth月:武器：$armname2を金<font color=red>$armval2</font>で売り$armnameを購入しました。");
								if($khohei == 1){&K_LOG("$mmonth月:【<font color=red>修得</font>】武器スキル：米俵を修得しました。");}
								elsif($khohei == 2){&K_LOG("$mmonth月:【<font color=red>修得</font>】武器スキル：短陌を修得しました。");}
						}
					}elsif($cid eq "23"){
						$ksub2=0;
						open(IN,"$PRO_LIST");
						@PRO_DATA = <IN>;
						close(IN);
						($proname,$proval,$prodmg,$prowei,$proele,$prosta,$proclass,$protownid,$prosetumei,$proskl) = split(/<>/,$PRO_DATA[$cnum]);

						$proval2 = int($kbook * 2333);
						$proname2 = "$ksname";
						$prokaikyu = $prosta*5;
						if($prokaikyu > 25000){$prokaikyu = 25000;}

						if($proval > $kgold + $proval2){
							&K_LOG("$mmonth月:所持金がたりません。$proname 金:$proval");
						}elsif($zsub1 < $prosta){
							&K_LOG("$mmonth月:技術がたりません。$proname 必要技術:$prosta");
						}elsif($kclass < $prokaikyu){
							&K_LOG("$mmonth月:階級値がたりません。$proname 必要階級:$prokaikyu");
						}else{
							$kgold += $proval2;
							$kgold -= $proval;
							$kbook = $prodmg;
							$ksname = $proname;
							if($proskl ne ""){$kbookskl = $proskl;}
							&K_LOG("$mmonth月:書籍：$proname2を金<font color=red>$proval2</font>で売り$pronameを購入しました。");
						}
					}elsif($cid eq $GET_MAN2){
						if(!$get_man){
							require "$EXE/get_man.pl";
							$get_man = TRUE;
						}
						&GET_MAN;
					}elsif($cid eq $TANREN2){
						if(!$tanren){
							require "$EXE/tanren.pl";
							$tanren = TRUE;
						}
						&TANREN;
					}elsif($cid eq $SYUUGOU){
						if(!$syuugou){
							require "$EXE/syuugou.pl";
							$syuugou = TRUE;
						}
						&SYUUGOU;
					}elsif($cid eq $TEC){
						if(!$tec){
							require "$EXE/tec.pl";
							$tec = TRUE;
						}
						&TEC;
					}elsif($cid eq $SHIRO_TAI){
						if(!$shiro_tai){
							require "$EXE/shiro_tai.pl";
							$shiro_tai = TRUE;
						}
						&SHIRO_TAI;
					}elsif($cid eq $NOUKAKU){
						if(!$noukaku){
							require "$EXE/noukaku.pl";
							$noukaku = TRUE;
						}
						&NOUKAKU;
					}elsif($cid eq $SYOKAKU){
						if(!$syokaku){
							require "$EXE/syokaku.pl";
							$syokaku = TRUE;
						}
						&SYOKAKU;
					}elsif($cid eq $SHIROKAKU){
						if(!$shirokaku){
							require "$EXE/shirokaku.pl";
							$shirokaku = TRUE;
						}
						&SHIROKAKU;
					}elsif($cid eq $NYUSYOKU){
						if(!$nyusyoku){
							require "$EXE/nyusyoku.pl";
							$nyusyoku = TRUE;
						}
						&NYUSYOKU;
					}elsif($cid eq "39"){
						$ksub2=0;
						($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$cnum]);
						if($zcon eq $kcon){
							&K_LOG("$mmonth月:自国の都市の農業を破壊することはできません。");
						}else{
							if(!$nouex){
								require "$EXE/nouex.pl";
								$nouex = TRUE;
							}
							&NOUEX;
						}
					}elsif($cid eq "41"){
						$ksub2=0;
						($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$cnum]);
						if($zcon eq $kcon){
							&K_LOG("$mmonth月:自国の都市の商業を下げることはできません。");
						}else{
							if(!$syouex){
								require "$EXE/syouex.pl";
								$syouex = TRUE;
							}
							&SYOUEX;
						}
					}elsif($cid eq "43"){
						$ksub2=0;
						($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$cnum]);
						if($zcon eq $kcon){
							&K_LOG("$mmonth月:自国の都市の技術を下げることはできません。");
						}else{
							if(!$tecex){
								require "$EXE/tecex.pl";
								$tecex = TRUE;
							}
							&TECEX;
						}
					}elsif($cid eq "45"){
						$ksub2=0;
						($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$cnum]);
						if($zcon eq $kcon){
							&K_LOG("$mmonth月:自国の都市の城壁は弱くできません。");
						}else{
							if(!$stex){
								require "$EXE/stex.pl";
								$stex = TRUE;
							}
							&STEX;
						}
					}elsif($cid eq "47"){
						$ksub2=0;
						($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$cnum]);
						if($zcon eq $kcon){
							&K_LOG("$mmonth月:自国の都市の民忠はさげられません。");
						}else{
							if(!$priex){
								require "$EXE/priex.pl";
								$priex = TRUE;
							}
							&PRIEX;
						}
					}elsif($cid eq "49"){
						if(!$tei){
							require "$EXE/tei.pl";
							$tei = TRUE;
							}
						&TEI;
					}elsif($cid eq "51"){
						$ksub2=0;
						open(IN,"$BOU_LIST");
						@BOU_DATA = <IN>;
						close(IN);
						($bouname,$bouval,$boudmg,$bouwei,$bouele,$bousta,$bouclass,$boutownid,$bousetumei,$bouskl) = split(/<>/,$BOU_DATA[$cnum]);
						$bouval2 = int($kmes * 2333);
						$bouname2 = "$kbname";
						$boukaikyu = $bousta*5;
						if($boukaikyu > 25000){$boukaikyu = 25000;}

						if($bouval > $kgold + $bouval2){
							&K_LOG("$mmonth月:所持金がたりません。$bouname 金:$bouval");
						}elsif($zsub1 < $bousta){
							&K_LOG("$mmonth月:技術がたりません。$bouname 必要技術:$bousta");
						}elsif($kclass < $boukaikyu){
							&K_LOG("$mmonth月:階級値がたりません。$bouname 必要階級:$boukaikyu");
						}else{
							$kgold += $bouval2;
							$kgold -= $bouval;
							$kmes = $boudmg;
							$kbname = $bouname;
							if($bouskl ne ""){$kbouskl = $bouskl;}
							&K_LOG("$mmonth月:防具：$bouname2を金<font color=red>$bouval2</font>で売り$bounameを購入しました。");
						}
					}elsif($cid eq $KAITAKU){
						if(!$kaitaku){
							require "$EXE/kaitaku.pl";
							$kaitaku = TRUE;
						}
						&KAITAKU;
					}elsif($cid eq $BACK_DEF){
						if(!$back_def){
							require "$EXE/back_def.pl";
							$back_def = TRUE;
						}
						&BACK_DEF;
					}elsif($cid eq $GEYA){
						if(!$geya){
							require "$EXE/geya.pl";
							$geya = TRUE;
						}
						&GEYA;
					}elsif($cid eq 56){
						if(!$kenkoku){
							require "$EXE/kenkoku.pl";
							$kenkoku = TRUE;
						}
						&KENKOKU;
					}elsif($cid eq $HANRAN2){
					$ksub2=0;

					#国民平均忠誠
					$tyusei = 0;
					if($kcon ne "0" && $kcon ne ""){
					$cou_sum=0;
					$alltyusei=0;
					foreach(@CL_DATA){
					($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
						if($kcon eq $econ){
						$alltyusei += $ebank;
						$cou_sum++;
						}
					}
					$tyusei = int($alltyusei/$cou_sum);
					}

						if($ksol <= 0){
							&K_LOG("$mmonth月:兵士0人では反乱はおこせません。");
						}elsif(($kcon ne 0)&&($kcon ne $zcon)){
							&K_LOG("$mmonth月:他国の領地で反乱はおこせません。");
						}elsif(($kgold < 10000)||($krice < 10000)){
							&K_LOG("$mmonth月:資金不足です。");
						}elsif($cnum ne $kpos){
							&K_LOG("$mmonth月:反乱を起こす予定地と違う場所にいます。");
						}elsif($tyusei > 50){&K_LOG("$mmonth月:国民の忠誠度平均が50以下ではありません。（平均：$tyusei）");
						}else{
						&COUNTRY_DATA_OPEN("$kcon");
						$kcex += 30;
						$kstr_ex++;
						$k_kei++;
						$kgold -= 20000;
						$krice -= 20000;
						$idate = time();
	&MAP_LOG2("<font color=blown>【反乱】</font>\[$old_date\]$znameで$knameが反乱をおこしました。");
						if($kcon ne 0){
						$kclass -= 1000;
						$nairanme = "反旗を翻し";
						$kcon = 0;
							if($ksyuppei){
							}else{
							#バトルマップ読み込み
							do "./log_file/map_hash/$kpos.pl";
							#ランダムに部隊を配置
							$randy = int(rand($BM_Y));
							$randx = int(rand($BM_X));
							$count = 0;
							for($i=$randy;$i<$BM_Y;$i++){
								for($j=$randx;$j<$BM_X;$j++){
									if($BM_TIKEI[$i][$j] ne "" && $BM_TIKEI[$i][$j] ne "18"){
									$hanran_x = $j;
									$hanran_y = $i;
									$count = 2;
									}
									if($i == $BM_Y-1 && $j == $BM_X-1){
									$count++;
									$i = 0;
									$j = 0;
									}
									if($count > 1){
									last;
									}
								}

								if($count > 1){
								last;
								}
							}
							if($hanran_x eq "" || $hanran_y eq ""){&K_LOG("$mmonth月:異常なバトルマップデータです。管理者に報告してください。");}
							$ksyuppei = 1;
							$kx = $hanran_x+0;
							$ky = $hanran_y+0;
							$kiti = $kpos;
							$kkoutime = $idate+($BMT_REMAKE*10);
							#移動スキル ./lib/skl_lib.pl
							&IDOUSKL;
							&IDOUSKL2;
							}
						}else{
							$nairanme = "反乱をおこし";
							if(!$ksyuppei){
							#バトルマップ読み込み
							do "./log_file/map_hash/$kpos.pl";
							#ランダムに部隊を配置
							$randy = int(rand($BM_Y));
							$randx = int(rand($BM_X));
							$count = 0;
							for($i=$randy;$i<$BM_Y;$i++){
								for($j=$randx;$j<$BM_X;$j++){
									if($BM_TIKEI[$i][$j] ne "" && $BM_TIKEI[$i][$j] ne "18"){
									$hanran_x = $j;
									$hanran_y = $i;
									$count = 2;
									}
									if($i == $BM_Y-1 && $j == $BM_X-1){
									$count++;
									$i = 0;
									$j = 0;
									}
									if($count > 1){
									last;
									}
								}

								if($count > 1){
								last;
								}
							}
							if($hanran_x eq "" || $hanran_y eq ""){&K_LOG("$mmonth月:異常なバトルマップデータです。管理者に報告してください。");}
							$ksyuppei = 1;
							$kx = $hanran_x+0;
							$ky = $hanran_y+0;
							$kiti = $kpos;
							$kkoutime = $idate+($BMT_REMAKE*10);
							#移動スキル ./lib/skl_lib.pl
							&IDOUSKL;
							&IDOUSKL2;
							}
						}
	&MAP_LOG("$mmonth月:$xnameの$kname$rank_mesは$nairanme$znameへ攻め込みました！");
	&K_LOG("$mmonth月:$xnameの$kname$rank_mesは$nairanme$znameへ攻め込みました！");
	&K_LOG2("$mmonth月:$xnameの$kname$rank_mesは$nairanme$znameへ攻め込みました！");

	#ブラックリスト処理
	open(IN,"$LOG_DIR/black_list.cgi");
	@B_LIST = <IN>;
	close(IN);

	@NEW_B_LIST=();
	$hit=0;
	foreach(@B_LIST){
		($bid,$bcon,$bname,$bsub) = split(/<>/);
		if($bid eq $kid && $bcon eq $kcon){
			$hit=1;
			push(@NEW_B_LIST,"$kid<>$kcon<>$kname<><>\n");
		}else{
			push(@NEW_B_LIST,"$_");
		}
	}

	if(!$hit){
		unshift(@NEW_B_LIST,"$kid<>$kcon<>$kname<><>\n");
	}

	open(OUT,">$LOG_DIR/black_list.cgi");
	print OUT @NEW_B_LIST;
	close(OUT);

						}
					}elsif($cid eq $TAIKYAKU){
						if(!$taikyaku){
							require "$EXE/taikyaku.pl";
							$taikyaku = TRUE;
						}
						&TAIKYAKU;
					}elsif($cid eq 63){
						if(!$tyousa){
							require "$EXE/tyousa.pl";
							$tyousa = TRUE;
						}
						&TYOUSA;
					}elsif($cid eq $JYUNSATU){
						if(!$jyunsatu){
							require "$EXE/jyunsatu.pl";
							$jyunsatu = TRUE;
						}
						&JYUNSATU;
					}else{
						$ksub2++;
						if($ksub2 > $DEL_TURN){
							#放置削除の処理
							unlink("./charalog/main/$kid\.cgi");
							unlink("./charalog/log/$kid\.cgi");
							unlink("./charalog/command/$kid\.cgi");
							unlink("./charalog/blog/$kid\.cgi");
							unlink("./charalog/auto_com/$kid\.cgi");
							unlink("./charalog/prof/$kid\.cgi");

							#BMCOM登録リストオープン
							open(IN,"./log_file/auto_list.cgi");
							my @auto_list = <IN>;
							close(IN);
							my $i=0;
							my @NEW=();
							foreach(@auto_list){
								if($_ eq "$kid.cgi\n"){
								}else{
								push(@NEW,"$_");
								}
							$i++;
							}
							open(OUT,">\./log_file/auto_list.cgi");
							print OUT @NEW;
							close(OUT);

							&MAP_LOG("[放置]：$knameは削除されました。");
							next;
						}
						&K_LOG("$mmonth月:何も実行しませんでした。");
					}

				}else{
					&K_LOG("$mmonth月:自国ではありません。");
				}

				$krice -= $ksol;
				if($krice < 0){
					&K_LOG("$mmonth月:<font color=red>【脱走】</font>:兵士「$kname米払ってくれないから逃げるわ」");
					$ksol = 0;
					$krice = 0;
				}elsif($krice < $ksol*12){
					&K_LOG("$mmonth月:<font color=red>【米不足】</font>:兵士「$knameの米少ないなぁ...脱走しようかな？」");
				}

				$uhit=0;
				if($kstr_ex >= 10){
					$kstr++;
					$kstr_ex-=10;
					$uhit=1;
					&K_LOG("$mmonth月:<font color=red>【上昇】</font>:$knameの武力が１上がった！");
				}
				if($kint_ex >= 10){
					$kint++;
					$kint_ex-=10;
					$uhit=1;
					&K_LOG("$mmonth月:<font color=red>【上昇】</font>:$knameの知力が１上がった！");
				}
				if($klea_ex >= 10){
					$klea++;
					$klea_ex-=10;
					$uhit=1;
					&K_LOG("$mmonth月:<font color=red>【上昇】</font>:$knameの統率力が１上がった！");
				}
				if($kcha_ex >= 10){
					$kcha++;
					$kcha_ex-=10;
					$uhit=1;
					&K_LOG("$mmonth月:<font color=red>【上昇】</font>:$knameの人望が１上がった！");
				}
				if($uhit){
					$ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
				}


				#自動集合
				if($kskl6 eq "1"){
					foreach(@UNI_DATA){
						($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
						if("$uid" eq "$kid" && $unit_id eq $kid){
						$uahit=1;
						$auto=$uauto;
						last;
						}
					}
					if($ucon eq $kcon && $zcon eq "$kcon" && $uahit && $auto){
					$uahit=0;$auto=0;
					$auto_syu=1;
					require "$EXE/syuugou.pl";
					&SYUUGOU;
					$auto_syu=0;
					}
				}


		$ksentoukaisu = $kbouwin+$kkouwin+$kkoulos+$kboulos+$khiki;
		$ksentouwin = $kbouwin+$kkouwin;
		$ksentoulos = $kkoulos+$kboulos;

		$bukinasi = 0;
		if(($karm eq "")&&($kaname eq "")&&($kazoku eq "")&&($kaai eq "")){$bukinasi = 1;}

		if($knai >= 300 && $knaiskl eq "0"){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：内政強化【大】を修得しました。");
		$knaiskl = 1;
		}elsif($knai >= 100 && $knaiskl eq ""){
		&K_LOG("$mmonth月:【<font color=red>修得</font>】スキル：内政強化【小】を修得しました。");
		$knaiskl = 0;
		}

		if($k_kei >= 300 && $kkeiskl eq "0"){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：計略強化【大】を修得しました。");
		$kkeiskl = 1;
		}elsif($k_kei >= 100 && $kkeiskl eq ""){
		&K_LOG("$mmonth月:【<font color=red>修得</font>】スキル：計略強化【小】を修得しました。");
		$kkeiskl = 0;
		}

		if($k_tan >= 300 && $ktanskl eq "0"){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：鍛錬強化【大】を修得しました。");
		$ktanskl = 1;
		}elsif($k_tan >= 100 && $ktanskl eq ""){
		&K_LOG("$mmonth月:【<font color=red>修得</font>】スキル：鍛錬強化【小】を修得しました。");
		$ktanskl = 0;
		}

		if(($kkun > 79)&&($kmei > 79)&&($ksentoukaisu > 159)&&($krenpei eq "2")){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：練兵【大】を修得しました。");
		$krenpei = 3;
		}elsif(($kkun > 39)&&($kmei > 39)&&($ksentoukaisu > 79)&&($krenpei eq "1")){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：練兵【中】を修得しました。");
		$krenpei = 2;
		}elsif(($kkun > 19)&&($kmei > 19)&&($ksentoukaisu > 39)&&($krenpei eq "0")){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：練兵【小】を修得しました。");
		$krenpei = 1;
		}elsif(($kkun > 9)&&($kmei > 9)&&($ksentoukaisu > 19)&&($krenpei eq "")){
		&K_LOG("$mmonth月:【<font color=red>修得</font>】スキル：練兵【微】を修得しました。");
		$krenpei = 0;
		}

		if($koujyou >= 100 && $koujyou2 eq "1"){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：攻城２【大】を修得しました。");
		$koujyou2 = 2;
		}elsif($koujyou >= 30 && $koujyou2 eq "0"){
		&K_LOG("$mmonth月:【<font color=red>上達</font>】スキル：攻城２【中】を修得しました。");
		$koujyou2 = 1;
		}elsif($koujyou >= 10 && $koujyou2 eq ""){
		&K_LOG("$mmonth月:【<font color=red>修得</font>】スキル：攻城２【小】を修得しました。");
		$koujyou2 = 0;
		}


		if($khitokiri eq ""){$khitokiri = 1;}
		$khkbounus = $khitokiri*1000;
		if($khkbounus <= $ksitahei){
			if($khitokiri%5 == 0){
			$upgold=20000;
			}else{
			$upgold=5000;
			}
		$kgold+=$upgold;
			if(($kint > $kstr)&&($kint > $kcha)&&($kint > $klea)){
			$kint++;
			$upmes = "知力";
			}elsif(($klea > $kstr)&&($klea > $kcha)&&($klea > $kint)){
			$klea++;
			$upmes = "統率力";
			}elsif(($kcha > $kstr)&&($kcha > $klea)&&($kcha > $kint)){
			$kcha++;
			$upmes = "人望";
			}else{
			$kstr++;
			$upmes = "武力";
			}
		&K_LOG("$mmonth月:【<font color=red>恩賞</font>】<font color=red>$khkbounus\</font>人切りを達成しました！　賞金$upgold\G　$upmes\+1");
		$khitokiri++;
		}

		if(!$kkezuricn){$kkezuricn = 1;}
		$khkbounus = $kkezuricn*1000;
		if($khkbounus <= $kkezuri){
			if($kkezuricn%5 == 0){
			$upcex=250;
			$upmes=2;
			}else{
			$upcex=125;
			$upmes=1;
			}
		$kmes+=$upmes;
		$kcex+=$upcex;
		&K_LOG("$mmonth月:【<font color=red>恩賞</font>】城壁<font color=red>$khkbounus\</font>削りを達成しました！　貢献値<font color=red>+$upcex</font>　防具威力<font color=red>+$upmes</font>");
		$kkezuricn++;
		}

		if(!$ksihaicn){$ksihaicn = 1;}
		$kstkbounus = $ksihaicn*10;
		if($kstkbounus <= $ksihai){
			if($ksihaicn%5 == 0){
			$upmes=2;
			$ksg++;
			$sp_mes="、SPが<font color=red>+1</font>";
			}else{
			$upmes=1;
			$sp_mes="";
			}
		$karm+=$upmes;
		if(($kazoku ne "無")&&($kazoku ne "")){
		$upmes2=$upmes*3;
		$kaai+=$upmes2;
		}else{
		$upmes2=0;
		}
		&K_LOG("$mmonth月:【<font color=red>恩賞</font>】支配回数<font color=red>$kstkbounus\</font>回を達成したので武器の威力が<font color=red>+$upmes</font>、武器属性の値が<font color=red>+$upmes2</font>$sp_mesされました。");
		$ksihaicn++;
		}

		if($kstk eq ""){$kstk = 1;}
		$kstkbounus = $kstk*10;
		if($kstkbounus <= $ksentouwin){
			if($kstk%5 == 0){
			$upmes=2;
			}else{
			$upmes=1;
			}
		$karm+=$upmes;
		$kmes+=$upmes;
		if(($kazoku ne "無")&&($kazoku ne "")){
		$upmes2=$upmes*3;
		$kaai+=$upmes2;
		}else{
		$upmes2=0;
		}
		&K_LOG("$mmonth月:【<font color=red>恩賞</font>】撃破数<font color=red>$kstkbounus\</font>回を達成したので武器、防具の威力が<font color=red>+$upmes</font>、武器属性の値が<font color=red>+$upmes2</font>強化されました。");
		$kstk++;
		}

		if($kgsk eq ""){$kgsk = 1;}
		$kgskbounus = $kgsk*10;
		if($kgskbounus <= $ksentoulos){
			if($kgsk%5 == 0){
			$upmes=2;
			}else{
			$upmes=1;
			}
		$karm+=$upmes;
		$kmes+=$upmes;
		if(($kazoku ne "無")&&($kazoku ne "")){
		$upmes2=$upmes*3;
		$kaai+=$upmes2;
		}else{
		$upmes2=0;
		}
		&K_LOG("$mmonth月:【<font color=red>残念賞</font>】<font color=red>$kgskbounus\</font>回撃破された残念賞として武器、防具の威力が<font color=red>+$upmes</font>、武器属性の値が<font color=red>+$upmes2</font>強化されました。");
		$kgsk++;
		}

		if($bukinasi){$karm = "";}

		$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
		$ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn,";
		$kst = "$ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9,";
		$ksz = "$kindbmm,$ksettei,$ksettei2,$ksettei3,$ksettei4,$ksettei5,";
		$ksub4 = "$krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2,";
		$ksub5 = "$karm2,$kaname2,$kazoku2,$kaai2,$karmskl2,";

				&CHARA_MAIN_INPUT;

				if($ACT_LOG){
					($qsec,$qmin,$qhour,$qday) = localtime($kdate);
					unshift(@ACT_DATA,"$knameを更新 \($qday日 $qhour:$qmin:$qsec\)\n");
				}
				$kup_date++;
				if($kup_date > $ENTRY_MAX){last;}
			}
		}
	}
	if($thit){
		&lock("xxx","1") or &ERR2("ファイルロックに失敗しました。");
		&SAVE_DATA($TOWN_LIST,@TOWN_DATA);
		&unlock("xxx");
	}

	closedir(dirlist);
	&D_UNLOCK_FILE;
}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub E_LOG2 {

	if($eid ne ""){
		open(IN,"./charalog/blog/$eid\.cgi");
		@E_LOG2 = <IN>;
		close(IN);
		unshift(@E_LOG2,"$_[0]($mday日$hour時$min分$sec秒)\n");
		splice(@E_LOG2,600);

		open(OUT,">./charalog/blog/$eid\.cgi");
		print OUT @E_LOG2;
		close(OUT);
	}
}

sub K_LOG2 {

	open(IN,"./charalog/blog/$kid\.cgi");
	@K_LOG2 = <IN>;
	close(IN);
	unshift(@K_LOG2,"$_[0]($mday日$hour時$min分$sec秒)\n");
	splice(@K_LOG2,600);
	open(OUT,">./charalog/blog/$kid\.cgi");
	print OUT @K_LOG2;
	close(OUT);
}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       給料計算           _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub SALARY {

	$ksal=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con,$z2num,$z2nou,$z2syo,$z2shiro)=split(/<>/);
		if($z2con eq $kcon){
			if($mmonth eq "1"){
				$ksal += int($z2syo * 12 * $z2num / 12000);
			}elsif($mmonth eq "7"){
				$ksal += int($z2nou * 12 * $z2num / 12000);
			}
		}
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       FILE LOCK        #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub D_F_LOCK {

	local($retry)=1;
	if (-e $lockfile2) {
		local($mtime) = (stat($lockfile2))[9];
		if ($mtime && $mtime < time - 60) { &D_UNLOCK_FILE; }
	}

	while (!mkdir($lockfile2, 0755)) {
		if (--$retry <= 0) { &ERR2("File lock error!<BR>データ更新中です。しばらくお待ちください。");
}
		sleep(1);
	}
}


# DATA LOCK #
sub lock #($file_name, $use_lock)
{
	local($file_name, $use_lock) = @_;
	local($lock_flag) = $file_name . ".lock";

	if ($use_lock) {
	local($i) = 0;
#	return -1 if (!-f $file_name);
	rmdir($lock_flag) if (-d $lock_flag && time - (stat($lock_flag))[9] > 60);
	while(!mkdir($lock_flag, 0755)) {
	select(undef, undef, undef, 0.05);
		return 0 if (++ $i >= 100);
		}
		return 1;
 	}
 	return 1;
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#     FILE UNLOCK        #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub D_UNLOCK_FILE
{
  rmdir("$lockfile2");
}

sub unlock
{
  rmdir("$_[0].lock") if (-d "$_[0].lock");
}

1;
