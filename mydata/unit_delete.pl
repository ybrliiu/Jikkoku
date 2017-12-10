#_/_/_/_/_/_/_/_/_/#
#_/    部隊登録  _/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_DELETE {

	&CHARA_MAIN_OPEN;
	&TIME_DATA;

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$mhit=0;$hit=0;@NEW_UNI_DATA=();
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$uid" eq "$kid"){
			$hit=1;
			if($kid eq "$unit_id"){
				$mhit = 1;
				$mid = $unit_id;
				$mess = "$uunit_name部隊を解散いたしました。";
			}else{
				$mess = "$uunit_name部隊から離脱しました。";
			}
			open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
			@MES_REG = <IN>;
			close(IN);

			$mes_num = @MES_REG;
			if($mes_num > $MES_MAX) { pop(@MES_REG); }
			unshift(@MES_REG,"333<>$kid<>$kpos<>$kname<><font color=FF0000>情報：$mess</font><>$uunit_name部隊<>$daytime<>$kchara<>$kcon<>$unit_id<>\n");


			&SAVE_DATA($MESSAGE_LIST,@MES_REG);
		}else{
			push(@NEW_UNI_DATA,"$_");
		}
	}

	if($mhit){
		@NEW_UNI_DATA=();
		foreach(@UNI_DATA){
			($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
			if("$mid" eq "$unit_id"){
			}else{
				push(@NEW_UNI_DATA,"$_");
			}
		}
	}


	if(!$hit){
		$kunit = "";
		$mess = "$uunit_name部隊から離脱しました。";
	}

	&SAVE_DATA($UNIT_LIST,@NEW_UNI_DATA);

	&CHARA_MAIN_INPUT;

	&HEADER;

	if($M_FLAG){
	$url = "./i-command.cgi";
	}else{
	$url = "./mydata.cgi";
	}

	print <<"EOM";
<CENTER><hr size=0><h2>$mess</h2><p>
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
