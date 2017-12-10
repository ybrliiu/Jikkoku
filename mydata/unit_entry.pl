#_/_/_/_/_/_/_/_/_/#
#_/    部隊登録  _/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_ENTRY {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");

	if($in{'unit_id'} eq "") { &ERR("所属する部隊が選択されていません。"); }

	&TIME_DATA;

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$hit=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if($uid eq $kid){&ERR("既に$uunit_name部隊に所属しています。");}
	}

	$hit=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if($unit_id eq $in{'unit_id'}){last;}
	}

	if($uflg){
		&ERR("入隊拒否になっています。");
	}

	if(!$hit){
		unshift(@UNI_DATA,"$unit_id<>$uunit_name<>$kcon<>0<>$kid<>$kname<>$kchara<>$umes<>$uflg<>$upos<>$uauto<>\n");
		open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
		@MES_REG = <IN>;
		close(IN);

		$jname = "$uunit_name部隊";
		$mes_num = @MES_REG;
		if($mes_num > $MES_MAX) { pop(@MES_REG); }
		unshift(@MES_REG,"333<>$kid<>$kpos<>$kname<><font color=00FF00>情報：$knameが$uunit_name部隊に入隊しました。</font><>$jname<>$daytime<>$kchara<>$kcon<>$unit_id<>\n");

		&SAVE_DATA($MESSAGE_LIST,@MES_REG);
	}

	&SAVE_DATA($UNIT_LIST,@UNI_DATA);

	&CHARA_MAIN_INPUT;

	&HEADER;

	if($M_FLAG){
	$url = "./i-command.cgi";
	}else{
	$url = "./mydata.cgi";
	}

	print <<"EOM";
<CENTER><hr size=0><h2>$uunit_name部隊に入隊しました。</h2><p>
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
