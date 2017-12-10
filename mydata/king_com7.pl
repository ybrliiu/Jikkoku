#_/_/_/_/_/_/_/_/_/_/#
#        国色変更     #
#_/_/_/_/_/_/_/_/_/_/#

sub KING_COM7 {

	if($in{'color'} eq ""){&ERR("色が指定されていません。");}
	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;

	if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}

	$color = $in{'color'};
	$xele = $color;

	&COUNTRY_DATA_INPUT;
	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>国の色を変更しました。</h2><p>
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

	exit;

}
1;
