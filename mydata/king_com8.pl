#_/_/_/_/_/_/_/_/_/_/#
#     　　簒奪　　     #
#_/_/_/_/_/_/_/_/_/_/#

sub KING_COM8 {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	if(($xgunshi ne $kid)&&($xxsub1 ne $kid)){&ERR("軍師か宰相でなければ実行できません。");}


#国民忠誠平均
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

$con=0;
$alltyusei=0;
	foreach(@CL_DATA){
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

	if($kcon eq $econ){
	$alltyusei += $ebank;
	$con++;
	}
}
$tyusei = int($alltyusei/$con);
	if($tyusei > 40){&ERR("国民の忠誠度平均が40以下ではありません。（平均：$tyusei）");}


	if($in{'connamechange'} eq "yes"){

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>国名を決めて下さい</h2><p>
<br>
<form action=\"./mydata.cgi\" method=\"post\">
<input type=text name=conname size=20>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=KING_COM8>
<input type=submit id=input value=\"決定\"></form>
<br>
<form action=\"./mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=KING_COM>
<input type=submit id=input value=\"指令部に戻る\"></form>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
</CENTER>
EOM

	&FOOTER;


	}else{

	$month_read = "$LOG_DIR/date_count.cgi";
	open(IN,"$month_read") or &ERR2("Can\'t file open!:month_read");
	@MONTH_DATA = <IN>;
	close(IN);

	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
	$old_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);

	if($in{'conname'} ne ""){

	if(length($in{'conname'}) < 3 || length($in{'conname'}) > 30) {
	&ERR("国名は全角1文字以上10文字以下で決めて下さい。");
	}else{
	$conname = "$in{'conname'}";
	$oldxname = "$xname";
	$xname = "$conname";
	&MAP_LOG("<font color=#165e83>【簒奪】</font>\[$old_date\]$oldxnameの国名は$xnameに変わり君主は$knameに変わりました。");
	&MAP_LOG2("<font color=#165e83>【簒奪】</font>\[$old_date\]$oldxnameの国名は$xnameに変わり君主は$knameに変わりました。");
	$cnchit = 1;
	}

	}else{
	$cnchit = 0;
	}

	if($xgunshi eq $kid){
		$xgunshi = "";
	}

	if($xxsub1 eq $kid){
		$xxsub1 = "";
	}

	$xsub = "$xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1,$xxsub2,";

	$xking = "$kid";

	if(!$cnchit){
	&MAP_LOG("<font color=#165e83>【簒奪】</font>\[$old_date\]$xnameの君主は$knameに変わりました。");
	&MAP_LOG2("<font color=#165e83>【簒奪】</font>\[$old_date\]$xnameの君主は$knameに変わりました。");
	}

	&COUNTRY_DATA_INPUT;

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>簒奪しました。</h2><p>
<form action=\"./mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=KING_COM>
<input type=submit id=input value=\"指令部に戻る\"></form>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
</CENTER>
EOM

	&FOOTER;

	}
	exit;

}
1;
