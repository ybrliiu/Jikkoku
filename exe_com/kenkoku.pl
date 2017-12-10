#_/_/_/_/_/_/_/_/_/_/#
#      建国     #
#_/_/_/_/_/_/_/_/_/_/#

sub KENKOKU {

	$ksub2=0;

	#統一したか確認
	open(IN, "./log_file/touitu_flag.cgi");
	$touitu = <IN>;
	close(IN);

	#既に建国コマンドで建国したことがあるか確認
	open(IN,"$LOG_DIR/kenkoku_list.cgi");
	@KENKOKU_LIST = <IN>;
	close(IN);
	$ken_hit=0;
	foreach(@KENKOKU_LIST){
		($kenid,$kencon,$kenname,$kensub) = split(/<>/);
		if($kenid eq $kid){
		$ken_hit=1;
		}
	}

	if($touitu == 1){
	&K_LOG("$mmonth月:統一後は建国できません。");
	}elsif($ken_hit){
	&K_LOG("$mmonth月:１期の間に建国コマンドを使用して建国できるのは１回までです。");
	}elsif(($kcon eq "0")&&(($zcon eq "0")||($zcon eq ""))){

		open(IN,"$TOWN_LIST") or &E_ERR("指定されたファイルが開けません。");
		@TOWN_DATA = <IN>;
		close(IN);

		open(IN,"$COUNTRY_LIST") or &E_ERR('ファイルを開けませんでした。err no :country');
		@COU_DATA = <IN>;
		close(IN);

		open(IN,"$COUNTRY_NO_LIST") or &E_ERR('ファイルを開けませんでした。err no :country no');
		@COU_NO_DATA = <IN>;
		close(IN);

		($cou_name,$color,$new_cou_no) = split(/,/,$csub);

		$new_cou_no = @COU_NO_DATA + 1;
		$kcon = $new_cou_no;
		push(@COU_DATA,"$new_cou_no<>$cou_name<>$color<>30<>$kid<><>$kname<>1<>\n");
		open(OUT,">$COUNTRY_LIST") or &E_ERR('COUNTRY データを書き込めません。');
		print OUT @COU_DATA;
		close(OUT);

		push(@COU_NO_DATA,"$new_cou_no<>$cou_name<>$color<>1<>$kid<><><>1<>\n");
		open(OUT,">$COUNTRY_NO_LIST") or &E_ERR('COUNTRY データを書き込めません。');
		print OUT @COU_NO_DATA;
		close(OUT);

		$zcon = $new_cou_no;


		foreach(@UNI_DATA){
			($unit_id,$uunit_name,$ucon,$ureader,$uid)=split(/<>/);
			if("$uid" eq "$kid" && $unit_id eq $kid && $ucon eq 0){$uhit=1;last;}
		}


		if($uhit){

			foreach(@UNI_DATA){
			($unit_id,$uunit_name,$ucon,$ureader,$uid)=split(/<>/);
				if($unit_id eq $kid && $uid ne $unit_id){
					$in{'eid'} = "$uid";
					&ENEMY_OPEN;

					if($eid ne ""){
						if($ebank == 100){
						$econ = $new_cou_no;
						$epos = $kpos;
						&E_LOG("$mmonth月:$uunit_name部隊の隊長が$cou_nameを建国したため、所属が$cou_nameになりました。");
						&ENEMY_INPUT;
						}
					}
				}elsif($unit_id eq $kid && $uid eq $unit_id){
					$unit_name = $uunit_name;
				}
			}
		}
	



		&MAP_LOG2("<font color=000088><B>【建国】</B></font>\[$old_date\]$knameが$cou_nameを建国しました。");
		&MAP_LOG("<font color=000088><B>【建国】</B></font>$knameが$cou_nameを建国しました。");
		$klea_ex++;
		$k_kei++;
		&K_LOG("$mmonth月:$cou_nameを建国しました。");
		if("$zname" ne ""){
			splice(@TOWN_DATA,$kpos,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		}

		#建国したことを記録
		unshift(@KENKOKU_LIST,"$kid<>$kname<><><>\n");
		open(OUT,">$LOG_DIR/kenkoku_list.cgi");
		print OUT @KENKOKU_LIST;
		close(OUT);

	}else{&K_LOG("$mmonth月:あなたかいまいる都市が無所属でありません。");}
	}
1;
