#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      他のプレイヤーにメッセージ送信      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub MES_SEND2 {

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);

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

	$po=0;

	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg) = split(/<>/);
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

			if($ename eq $in{'mes_name'}){
			$po +=1;
			$lname = "<font color=blue>$ename</font>さんに手紙を送信：";
			$list = "<input type=hidden name=mes_id value=$eid>";
		}
	}

		if($lname eq ""){
			$aname = "<blockquote><table border=0 cellspacing=0 cellpadding=26 width=400><tr><td align=center><fieldset><b>ERROR!</b><br><br><font color=red>検索した人は見つかりませんでした。</font><BR><BR><form action=$FILE_MYDATA method=post><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=LETTER><input type=submit id=input value=戻る></form></fieldset></tr></td></table></blockquote>";
		}

	&HEADER;

	print <<"EOM";
<hr size=0><h2>他の武将に手紙を送る<BR></h2><hr>
<CENTER><BR>
<BR>他の武将に手紙を送れます。<BR>
<font size=1>(※嫌がらせのメッセージを送られた方は管理人まで連絡して下さい。)</font><BR>
<BR>
<form action="$FILE_MYDATA" method="post">


$lname<BR>



<textarea name=message cols=65 rows=3>
</textarea><br>
$list
<input type=hidden name=id value=$kid>
<input type=hidden name=name value=$kname>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=MES_SEND>
<input type=submit id=input value="手紙を送る"><br>
</form><BR>
$aname
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