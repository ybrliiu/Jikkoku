#_/_/_/_/_/_/_/_/_/_/#
#      関所出入り      #
#_/_/_/_/_/_/_/_/_/_/#

use lib './lib', './extlib';
use Jikkoku::Class::Town;
use Jikkoku::Model::Unite;
use Jikkoku::Model::Diplomacy;
use Jikkoku::Model::GameDate;
my $town_class = 'Jikkoku::Class::Town';

sub SEKISYO {

	$odate = time();

	#年月表示
	$month_read = "$LOG_DIR/date_count.cgi";
	open(IN,"$month_read") or &ERR2("Can\'t file open!:month_read");
	@MONTH_DATA = <IN>;
	close(IN);
	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
	$old_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
	$wyear=$F_YEAR+$myear;

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

	&COUNTRY_DATA_OPEN("$kcon");
	&TOWN_DATA_OPEN;

	$tekiiru = 0;
	$stop_flag = 0;

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($ksol <= 0){
		&ERR("兵士がいません。");
	}else{

	#フォームデータ分割
	($inx,$iny) = split(/,/,$in{'sekisyo'});


#フォームが正常か確認、関所の先のMAPへ移動する前準備
	#バトルマップ読み込み
	do "./log_file/map_hash/$kiti.pl";

	if($BM_TIKEI[$iny][$inx] == "17" || $BM_TIKEI[$iny][$inx] == "16"){
	($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$iny][$inx]{'sekisyo'});
	$maeiti = "$kiti";
	$kiti = "$ikisaki";
	$sekix = $inx;
	$sekiy = $iny;
	$zsa = abs($kx-$inx);
	$zsa2 = abs($ky-$iny);
	$zsa3 = $zsa+$zsa2;
	if($zsa3 > 1){&ERR("フォームに不正な値が含まれています。");}


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

	foreach(@CL_DATA){
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
	($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);
	($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup) = split(/,/,$esenj);

		if($maeiti eq $eiti){
			if($kcon ne $econ){
				if($ex == $sekix && $ey == $sekiy){
				$in{'eid'} = "$eid";
				$kiti = "$maeiti";
				$tekiiru = 1;
				last;
				}
			}
		}
	}
	if($tekiiru){&ERR("敵がいるので関所の出入りができません。");}


		if($BM_TIKEI[$iny][$inx] == "17"){
			#自分が無所属かつ出兵先が無所属の場合
			($noiti,$noiti2) = split(/-/,$kiti);
			if($noiti eq $maeiti){$noiti3="$noiti2";}else{$noiti3="$noiti";}

      my $is_player_neutral = $kcon eq "" || $kcon eq "0";
      my $is_town_country_neutral = $town_cou[$noiti3] eq "0" || $town_cou[$noiti3] eq "";
      my $is_unite = Jikkoku::Model::Unite->is_unite;
			if ($is_player_neutral && !$is_town_country_neutral && !$is_unite) {
			  &ERR("無所属武将は無所属都市以外の都市へ向けて出城できません。(統一後は可能)");
			}

			#敵都市出兵時移P増加
			if (
        ($town_cou[$maeiti] ne "$kcon" && $town_cou[$maeiti] ne "" && $town_cou[$maeiti] ne "0") &&
        $town_shiro[$maeiti] > 0 &&
        ($town_cou[$maeiti] eq $town_cou[$noiti3])
      ) {
			  $stop_flag = 1;
			}
		$mess = "$ikisaki2へ向けて出城しました。";
		&MAP_LOG("$mmonth月:$xnameの$knameは$ikisaki2へ向けて出城しました！");
		&K_LOG("$mmonth月:$xnameの$knameは$ikisaki2へ向けて出城しました！");
		&K_LOG2("$mmonth月:$xnameの$knameは$ikisaki2へ向けて出城しました！");

		}elsif($BM_TIKEI[$iny][$inx] ==  "16"){

			# 宣戦布告確認
      my $now_game_date = Jikkoku::Model::GameDate->new->get;
      my $diplomacy_model = Jikkoku::Model::Diplomacy->new;

      my $can_passage = $diplomacy_model->can_passage( $kcon, $town_cou[$ikisaki], $now_game_date );

			if ($town_cou[$ikisaki] eq "" || $town_cou[$ikisaki] eq "0" || $town_cou[$ikisaki] eq "$kcon") {
        $can_passage = 1;
      }

      my $is_unite = Jikkoku::Model::Unite->is_unite;

			if (!$can_passage && !$is_unite) {
        &ERR('宣戦布告をしていないか、まだ開戦時間ではありません。<br>※他国と戦争するには、国の幹部の人が司令部から宣戦布告をしないとできません。');
      }

		$mess = "$ikisaki2に入りました。";
		&MAP_LOG("$mmonth月:$xnameの$knameは$ikisaki2に入城しました！");
		&K_LOG("$mmonth月:$xnameの$knameは$ikisaki2に入城しました！");
		&K_LOG2("$mmonth月:$xnameの$knameは$ikisaki2に入城しました！");
		}
	}else{
	&ERR("フォームに不正な値が含まれています。");
	}


#関所の移動先MAPに部隊を配置
	#バトルマップ読み込み
	do "./log_file/map_hash/$kiti.pl";

	$ahit = 0;
	SEKI:for($i=0;$i<$BM_Y;$i++){
		for($j=0;$j<$BM_X;$j++){

			if($BM_TIKEI[$i][$j] == 16 || $BM_TIKEI[$i][$j] == 17){
				($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});

				if($maeiti eq $ikisaki){
				$kx = $j;
				$ky = $i;
					if($stop_flag){

            my $add_move_time = $town_class->stop_around_move_time($town_shiro[$maeiti], $myear, $BMT_REMAKE);
						if($kbattletime < $odate + $add_move_time){
  						$kbattletime = $odate + $add_move_time;
	  					#移動スキル2 ./lib/skl_lib.pl
		  				&IDOUSKL2_2;
						}

            my $add_action_time = $town_class->stop_around_action_time($town_shiro[$maeiti], $myear, $BMT_REMAKE);
						if($kkoutime < $odate + $add_action_time){
			  			$kkoutime = $odate + $add_action_time;
						}

					}else{
						if($kkoutime < $odate+$BMT_REMAKE){
						  $kkoutime = $odate+$BMT_REMAKE;
						}
					}
				$ahit = 1;
				last SEKI;
				}
			}

		}
	}
	if(!$ahit){&ERR("バトルマップデータに異常があります。");}

	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$mess</h2><p>
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
