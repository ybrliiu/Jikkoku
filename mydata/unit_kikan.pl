#_/_/_/_/_/_/_/_/_/#
#_/   部隊拠点帰還_/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_KIKAN {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);
	&TOWN_DATA_OPEN($kpos);
	&TIME_DATA;


	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	$mhit=0;$hit=0;@NEW_UNI_DATA=();
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$uid" eq "$kid"){
			$hit=1;
			if($kpos eq $upos){&ERR("部隊拠点と滞在都市が同じです");
			}elsif($kcon ne $town_cou[$upos]){&ERR("部隊拠点は他国に占領されています。");
			}else{
			$kpos = $upos;
			$krice-=3000;
			$mess=$town_name[$upos];
			}
		}
	}

	if(!$hit){
		&ERR("隊長以外は実行できません。");
	}

	&K_LOG("部隊拠点の$messに帰還しました。");

	&CHARA_MAIN_INPUT;
	&HEADER;

	if($M_FLAG){
	$url = "./i-command.cgi";
	}else{
	$url = "./mydata.cgi";
	}

	print <<"EOM";
<CENTER><hr size=0><h2>$messに帰還しました。</h2><p>
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
