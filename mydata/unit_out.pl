#_/_/_/_/_/_/_/_/_/#
#_/    部隊登録  _/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_OUT {

	&CHARA_MAIN_OPEN;

	if($in{'did'} eq $kid){&ERR("自分は解雇できません。");}
	elsif($in{'did'} eq ""){&ERR("対象が指定されていません。");}

	&TIME_DATA;

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$mhit=0;$hit=0;@NEW_UNI_DATA=();
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$unit_id" eq "$kid"){
			$hit=1;
			last;
		}
	}

	if(!$hit){
		&ERR("隊長以外実行できません。");
	}

	@NEW_UNI_DATA=();
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
			if("$uid" eq "$in{'did'}"){
				open(IN,"./charalog/main/$in{'did'}.cgi");
				@E_DATA = <IN>;
				close(IN);
				($eid,$epass,$ename) = split(/<>/,$E_DATA[0]);
				$mess = "$uunit_name部隊から$enameを解雇しました。";
				$jname = "$uunit_name部隊";
				$kiunit = "$unit_id";
			}else{
				push(@NEW_UNI_DATA,"$_");
			}
	}

	open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
	@MES_REG = <IN>;
	close(IN);

	$mes_num = @MES_REG;
	if($mes_num > $MES_MAX) { pop(@MES_REG); }
	unshift(@MES_REG,"333<>$kid<>$kpos<>$kname<><font color=FF0000>情報：$mess</font><>$jname<>$daytime<>$kchara<>$kcon<>$kiunit<>\n");

	$mes_num = @MES_REG;
	if($mes_num > $MES_MAX) { pop(@MES_REG); }
	unshift(@MES_REG,"$eid<>$kid<>$kpos<>$kname<><font color=FF0000>情報：$mess</font><>$ename<>$daytime<>$kchara<>$kcon<>0<>\n");

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
