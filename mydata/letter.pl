#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      他のプレイヤーにメッセージ送信      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub LETTER {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);

	&HEADER;
	print <<"EOM";
<hr size=0><h2>他の武将に手紙を送る<BR></h2><hr>
<CENTER><BR>
<BR>他の武将に手紙を送れます。<BR>
<font size=1>※親しくない相手に手紙を送るときは最初に「個宛失礼します」と書きましょう。</font><BR>
<font size=1>※嫌がらせのメッセージを送られた方は管理人まで連絡して下さい。</font><BR>
<BR>
<form action="$FILE_MYDATA" method="post">

<textarea name=message cols=65 rows=3>
</textarea><br>

<select name=mes_id>
<option value="">送る相手を選択
EOM

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);

	@tmp = map {(split /<>/)[10]} @CL_DATA;
	@CL_DATA = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	foreach(@CL_DATA) {
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/);
		if($eid eq $kid) { next; }
		if($cou_name[$econ] eq ""){
			$con[0] .= "<option value=$eid>$enameさんへ\n";
		}else{
			$con[$econ] .= "<option value=$eid>$enameさんへ\n";
		}
	}

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_NO = <IN>;
	close(IN);
	
	foreach(@COU_NO){
		($xxcid,$xxname,$xxele,$xxnum,$xxins,$xxind,$xxall,$xxgold,$xxhp,$xxmaxhp,$xxstr,$xxvit,$xxagi,$xxat)=split(/<>/);
		print "<option>==== $xxname ====\n";
		print "$con[$xxcid]";
	}
	$c_num = @COU_DATA;
print <<"EOM";
<option>==== 無所属国 ====\n
$con[0]
</select>
<input type=hidden name=id value=$kid>
<input type=hidden name=name value=$kname>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MES_SEND>
<input type=submit id=input value="手紙を送る"><br>
</form>
<blockquote>
<table border="0" cellspacing="0" cellpadding="26" width="400">
<tr><td align="center">
<fieldset>
<form action="./mydata.cgi" method="post">
<legend>送る相手を検索：</legend>
<input type=text name=mes_name size=10>
<input type=hidden name=id value=$kid>
<input type=hidden name=name value=$kname>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MES_SEND2>
<input type=submit id=input value="検索">
</form></fieldset></td></tr></table></blockquote>
<HR size=0>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
EOM
	&FOOTER;
	exit;

}
1;
