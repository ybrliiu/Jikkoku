#_/_/_/_/_/_/_/_/_/#
# 雑談用BBS書き込み  #
#_/_/_/_/_/_/_/_/_/#

sub ZATU_BBS_WRITE {

	if(length($in{'ins'}) > 6000) { &ERR("本文は2000字以内です"); }

	if($in{'ins'} eq "") { &ERR("メッセージが記入されていません。"); }

	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	&HOST_NAME;

	open(IN,"$ZATU_BBS_DATA") or &ERR('BBSファイルを開けませんでした。');
	@BBS_DATA = <IN>;
	close(IN);

	$bbs_num = @BBS_DATA;
	if($bbs_num > 100000) { pop(@BBS_DATA); }

	$bname = "投稿者：$kname";
	$bmes = $in{'ins'};

	$bno = 1;

	foreach(@BBS_DATA){
($lbno,$lbname,$lbgazou,$lbcolor,$lbmes,$lbtime,$lbsub1,$lbsub2,$lbsub3,$lbsub4,$lbsub5,$lbsub6)=split(/<>/);
		if($bno <= $lbno){
		$bno = $lbno+1;
		}
	}

unshift(@BBS_DATA,"$bno<>$bname<>$kchara<>$bcolor<>$bmes<>$daytime<>$bsub1<>$bsub2<>$bsub3<>$bsub4<>$bsub5<>$bsub6<>\n");

	open(OUT,">$ZATU_BBS_DATA") or &ERR('BBSファイルを開けませんでした。');
	print OUT @BBS_DATA;
	close(OUT);

	&HEADER;

print <<"EOM";
<CENTER><hr size=0><h2>投稿しました。</h2><p>

<form action="mydata.cgi" method="post">
<input type=hidden name=mode value=ZATU_BBS>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input value="OK">
</form>
</CENTER>

</CENTER>

EOM

	&FOOTER;

	exit;
}
1;