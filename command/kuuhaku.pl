#_/_/_/_/_/_/_/_/_/_/#
#      空白注入    #
#_/_/_/_/_/_/_/_/_/_/#

sub KUUHAKU {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if($in{'no'} eq "all"){&ERR("削除にALL選択はできません。");}
	&CHARA_MAIN_OPEN;
	&TIME_DATA;

	$num = $no[0]+1;
	$num2 = $no[0];
	$sum = @no;

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	for($i=0;$i<$sum;$i++){
	$O_COM .= "0<><><>$tt<><><><>\n";
	}
	$O_COM .= "$COM_DATA[$num2]";

	splice(@COM_DATA,$no[0],1, ($O_COM)) or &ERR('空白を入れることができませんでした。');

	$mes_num = @COM_DATA;
	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	open(OUT,">./charalog/command/$kid.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @COM_DATA;
	close(OUT);

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>NO:$numに$sum個空白を入れました。</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	&FOOTER;

	exit;

}
1;
