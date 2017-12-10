#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       専用BBS削除     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub BBS_DEL{

	&HOST_NAME;

	if($in{'itstealth'} eq "" || $in{'itstealth'} ne "$bbskanri"){&ERR2("管理人でなければ実行できません。");}
	if($in{'type'} eq "sure"){
		if($in{'del'} ne "yes"){&ERR2("チェックボックスにチェックが入っていません。");}
		}
	if($in{'no'} eq ""){&ERR2("削除するレスが選択されていません。");}

	open(IN,"./bbs/senb.cgi") or &ERR2('ファイルを開けませんでした。err no :country');
	@BBS_DATA = <IN>;
	close(IN);

	$i = 0;
	$hit=0;
	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);

		if($in{'no'} eq $bbno){
		$skno = $i;
		$lbbcon = $bbcon;
		$hit=1;
		}

	$i++;
	}

	if(!$hit){&ERR2("削除対象が存在しません。");}	

	splice(@BBS_DATA,$skno,1) or &ERR2('削除できませんでした。');

	open(OUT,">./bbs/senb.cgi") or &ERR2('ファイルを開けませんでした。');
	print OUT @BBS_DATA;
	close(OUT);

	&HEADER;
	print <<"EOM";
<CENTER><hr size=0><h2>削除しました。</h2><p>

<form action="./bbs.cgi" method="post">
<input type=hidden name=itstealth value=$bbskanri>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;
	exit;
	
}
1;
