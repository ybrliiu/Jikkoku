#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       会議室削除     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub COUNTRY_DEL{

	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	&HOST_NAME;
	&COUNTRY_DATA_OPEN("$kcon");

	if($xcid eq "0"){&ERR("無所属国は実行できません。");}
	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}
	if($in{'type'} eq "sure"){
		if($in{'del'} ne "yes"){&ERR("チェックボックスにチェックが入っていません。");}
		}
	if($in{'no'} eq ""){&ERR("削除するレスが選択されていません。");}

	open(IN,"$BBS_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
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

	if(!$hit){&ERR("削除対象が存在しません。");}	

	if($lbbcon ne $kcon){&ERR("他国の会議室のデータは削除できません。");}

	splice(@BBS_DATA,$skno,1) or &ERR('削除できませんでした。');

	open(OUT,">$BBS_LIST") or &ERR('ファイルを開けませんでした。');
	print OUT @BBS_DATA;
	close(OUT);

	&HEADER;
	print <<"EOM";
<CENTER><hr size=0><h2>削除しました。</h2><p>

<form action="./mydata.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;
	exit;
	
}
1;
