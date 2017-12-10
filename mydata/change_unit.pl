#_/_/_/_/_/_/_/_/_/#
#_/    部隊情報変更  _/#
#_/_/_/_/_/_/_/_/_/#

sub CHANGE_UNIT {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	if($in{'mes'} eq "") { &ERR("入力されてません。"); }
	elsif(length($in{'mes'}) > 150) { &ERR("部隊募集コメントは、５０文字以下で入力して下さい。"); }

		$zc=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if(("$kid" eq "$unit_id")&&("$uid" eq "$kid")){
		$change = 1;
		$azc = $zc;
		$aunit_id = $unit_id;
		$auunit_name = "$uunit_name";
		$aucon = $ucon;
		$aureader = $ureader;
		$auid = $uid;
		$auname = "$uname";
		$aumes = "$in{'mes'}";
		$auflg = $uflg;
		$aupos = $upos;
		$auauto = $uauto;
		}
	$zc++;
	}

	if(!$change){
		&ERR("隊長以外実行できません。");
	}

	if($change){
splice(@UNI_DATA,$azc,1,"$aunit_id<>$auunit_name<>$aucon<>$aureader<>$auid<>$auname<>$kchara<>$aumes<>$auflg<>$aupos<>$auauto<>\n");

	&SAVE_DATA($UNIT_LIST,@UNI_DATA);
	}

	&CHARA_MAIN_INPUT;

	&HEADER;

	if($M_FLAG){
	$url = "./i-command.cgi";
	}else{
	$url = "./mydata.cgi";
	}

	print <<"EOM";
<CENTER><hr size=0><h2>変更しました。</h2><p>

<form action="$url" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=UNIT_SELECT>
<input type=submit value="部隊編成画面に戻る"></form>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="街に戻る"></form></CENTER>
EOM
	&FOOTER;
	exit;
}
1;
