#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       雑談用BBS     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ZATU_BBS {

	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	&HOST_NAME;
	&COUNTRY_DATA_OPEN("$kcon");

	open(IN,"$ZATU_BBS_DATA") or &ERR('BBSファイルを開けませんでした。');
	@BBS_DATA = <IN>;
	close(IN);

	&HEADER;

print <<"EOM";
<center><h2>$BBS_NAME<h2></center>
<TABLE border=0 width=100%>
<TR><TH width=1%></TH><TD>
<hr size=2>
<form action="mydata.cgi" method="post">
<input type=hidden name=mode value=ZATU_BBS_WRITE>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
本文<br>
 <textarea name="ins" cols=40 rows=7>
</textarea>　　
<input type=submit id=input value="投稿">
</form>
<hr size=2>
<hr>
EOM

	if($in{'ban'} eq ""){$in{'ban'} = 0;}
	$i = ($in{'ban'} + 0) * 20;
	$s_n = 0;
	$n = 0;
	$n += $i;
	$i += 20;

	foreach(@BBS_DATA){
		($bno,$bname,$bgazou,$bcolor,$bmes,$btime,$bsub1,$bsub2,$bsub3,$bsub4,$bsub5,$bsub6)=split(/<>/);

	if($n == $s_n && $n < $i){
	$bbsmes .= "<table colspna=\"0\"><tr><td width=\"$img_wid\" height=\"$img_height\"><img src=\"$IMG/$bgazou.gif\"></td><td>No:$bno $bname <font size=1>$btime</font>\<br\>\<br\>$bmes\<br\>\<br\></td></table><hr>";
	$n++;
	}
	if($s_n % 20 == 0){
	$s_p = $s_n / 20;
	$s_w = $s_p + 1;
	if($in{'ban'} eq $s_p){
	$nextpages .= "\[<b>$s_w</b>]";
	}else{
	$nextpages .= "\[<a href\=\"$SANGOKU_URL\/mydata\.cgi\?id\=$kid\&pass\=$kpass\&mode\=ZATU_BBS\&ban\=$s_p\">$s_w<\/a>\]";
	}
	}
	$s_n++;
	}

print <<"EOM";
$bbsmes
</CENTER>
<hr>
$nextpages
<hr>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form>

</TD>
</TR>
</TABLE>
EOM
	&FOOTER;

	exit;

}
1;
