#_/_/_/_/_/_/_/_/_/#
#_/   自動集合  _/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_AUTO {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);
	&TIME_DATA;

	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	if($kskl6 ne "1"){&ERR("自動集合スキルを修得していません。");}

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$mhit=0;$hit=0;@NEW_UNI_DATA=();
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$uid" eq "$kid"){
			$hit=1;
			$jname = "$uunit_name部隊";
			$mid = $unit_id;
			if($uauto){
				$uauto = 0;
				$mess = "OFF";
			}else{
				$uauto = 1;
				$mess = "ON";
			}
			push(@NEW_UNI_DATA,"$unit_id<>$uunit_name<>$ucon<>$ureader<>$uid<>$uname<>$uchara<>$umes<>$uflg<>$upos<>$uauto<>\n");
		}else{
			push(@NEW_UNI_DATA,"$_");
		}
	}

	if(!$hit){
		&ERR("隊長以外は実行できません。");
	}


	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	@MES_REG = <IN>;
	close(IN);

	$mes_num = @MES_REG;
	if($mes_num > $MES_MAX) { pop(@MES_REG); }
	unshift(@MES_REG,"333<>$kid<>$kpos<>$kname<><font color=00FF00>情報：自動集合が$messになりました。</font><>$jname<>$daytime<>$kchara<>$kcon<>$mid<>\n");

	&SAVE_DATA($MESSAGE_LIST,@MES_REG);

	&SAVE_DATA($UNIT_LIST,@NEW_UNI_DATA);

	&CHARA_MAIN_INPUT;
	&HEADER;

	if($M_FLAG){
	$url = "./i-command.cgi";
	}else{
	$url = "./mydata.cgi";
	}

	print <<"EOM";
<CENTER><hr size=0><h2>自動集合を$messにしました。</h2><p>
<form action="$url" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=UNIT_SELECT>
<input type=submit id=input value="部隊編成画面に戻る"></form>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
</CENTER>
EOM
	&FOOTER;
	exit;
}
1;
