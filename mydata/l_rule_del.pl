#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/         国法  削除       _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub L_RULE_DEL{

	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	&HOST_NAME;
	&COUNTRY_DATA_OPEN("$kcon");

	if($xcid eq "0"){&ERR("無所属国は実行できません。");}
	if($in{'del_id'} eq "") { &ERR("メッセージが選択されていません。"); }
	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}

	open(IN,"$LOCAL_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@LOCAL_DATA = <IN>;
	close(IN);

	$mhit=0;$hit=0;@NEW_LOCAL_DATA=();
	foreach(@LOCAL_DATA){
		($bbid,$bbno,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype)=split(/<>/);
		if("$bbno" eq "$in{'del_id'}"){
			if($kcon eq $bbcon){
			$hit=1;
			$mes = "$bbmes";
			}else{
			$hit=0;
			}
		}else{
			push(@NEW_LOCAL_DATA,"$_");
		}
	}
	if(!$hit){&ERR("その国法は削除できません。");}

	open(OUT,">$LOCAL_LIST") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_LOCAL_DATA;
	close(OUT);

	&HEADER;
	print <<"EOM";
<CENTER><hr size=0><h2>$mesを削除しました。</h2><p>

<form action="$FILE_MYDATA" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=LOCAL_RULE>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;
	exit;
	
}
1;
