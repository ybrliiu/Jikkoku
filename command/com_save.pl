#
# コマンドのコマンドリスト保存関係 #
#


#コマンドリスト保存#
sub SAVE{

	if ($in{'save'} eq "" || $in{'save'} =~ m/[^0-9]/ || $in{'save'} < 1 || $in{'save'} > 15) { &ERR("保存リストの番号指定が異常です。"); }
	if ($in{'first'} eq "" || $in{'first'} =~ m/[^0-9]/ || $in{'first'} < 1 || $in{'first'} > $MAX_COM) { &ERR("開始位置の指定が異常です。"); }
	if ($in{'second'} eq "" || $in{'second'} =~ m/[^0-9]/ || $in{'second'} < 1 || $in{'second'} > $MAX_COM) { &ERR("終了位置の指定が異常です。"); }
	if ($in{'first'} > $in{'second'}) { &ERR("開始位置より終了位置のほうが小さいです。"); }
	if(length($in{'name'}) > 15) { &ERR("コマンドリストの名前が15文字以上になっています。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;


	#データ処理&ファイルオープン
	$in{'first'}-=1;
	$in{'second'}-=1;

	open(IN,"./charalog/command/$kid.cgi");
	@command_DATA = <IN>;
	close(IN);

	open(IN,"./charalog/com_save/$kid/$in{'save'}.cgi");
	@COM_DATA = <IN>;
	close(IN);

	open(IN,"./charalog/com_save/$kid/list.cgi");
	@NAME_DATA = <IN>;
	close(IN);


	#書き込み
	@NEW_COM_DATA=();
	for($i=$in{'first'};$i<=$in{'second'};$i++){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$command_DATA[$i]);
		push(@NEW_COM_DATA,"$cid<>$cno<>$cname<>$ctime<>$csub<>$cnum<>$cend<>\n");
	}
	open(OUT,">./charalog/com_save/$kid/$in{'save'}.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_COM_DATA;
	close(OUT);

	if($in{'name'} eq ""){$in{'name'} = "保存リスト$in{'save'}";}
	@NEW_NAME_DATA=();
	for($i=1;$i<=15;$i++){
		if($i == $in{'save'}){
			push(@NEW_NAME_DATA,"$in{'name'}\n");
		}else{
			if($NAME_DATA[$i-1] eq ""){
			push(@NEW_NAME_DATA,"\n");
			}else{
			push(@NEW_NAME_DATA,"$NAME_DATA[$i-1]");
			}
		}
	}
	open(OUT,">./charalog/com_save/$kid/list.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_NAME_DATA;
	close(OUT);


	$in{'first'}++;
	$in{'second'}++;
	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>コマンドリストのNO:$in{'first'}からNO:$in{'second'}までを$in{'name'}($in{'save'}番目)に保存しました。</h2><p>
<form action="./status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	&FOOTER;

	exit;

}


#コマンドリスト参照
sub LOOK{

	if ($in{'save'} eq "" || $in{'save'} =~ m/[^0-9]/ || $in{'save'} < 1 || $in{'save'} > 15) { &ERR("保存リストの番号指定が異常です。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;


	#データ処理&ファイルオープン
	open(IN,"./charalog/com_save/$kid/$in{'save'}.cgi") or &ERR("$in{'save'}番目には保存されていません。");
	@COM_DATA = <IN>;
	close(IN);
	$mes_num = @COM_DATA;
	if($mes_num == 0){ &ERR("$in{'save'}番目には保存されていません。"); }


	#出力内容加工
	$no = 1;
	foreach(@COM_DATA){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);

		if($cid eq ""){
		$cname="　-　";
		}
		$mess .= "$no:$cname<br>";
		$no++;
	}


	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$in{'save'}番目に保存されたコマンドリスト</h2><p>
<br>
$mess
<form action="./status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	&FOOTER;

	exit;

}


#コマンドリスト読み込み
sub LOAD{

	if ($in{'save'} eq "" || $in{'save'} =~ m/[^0-9]/ || $in{'save'} < 1 || $in{'save'} > 15) { &ERR("保存リストの番号指定が異常です。"); }
	if ($in{'first'} eq "" || $in{'first'} =~ m/[^0-9]/ || $in{'first'} < 1 || $in{'first'} > $MAX_COM) { &ERR("開始位置の指定が異常です。"); }
	if ($in{'second'} eq "" || $in{'second'} =~ m/[^0-9]/ || $in{'second'} < 1 || $in{'second'} > $MAX_COM) { &ERR("終了位置の指定が異常です。"); }
	if ($in{'first'} > $in{'second'}) { &ERR("開始位置より終了位置のほうが小さいです。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;


	#データ処理&ファイルオープン
	$in{'first'}-=1;
	$in{'second'}-=1;

	open(IN,"./charalog/command/$kid.cgi");
	@command_DATA = <IN>;
	close(IN);

	open(IN,"./charalog/com_save/$kid/$in{'save'}.cgi") or &ERR("$in{'save'}番目には保存されていません。");
	@COM_DATA = <IN>;
	close(IN);
	$mes_num = @COM_DATA;
	if($mes_num == 0){ &ERR("$in{'save'}番目には保存されていません。"); }


	#書き込み
	$n=0;
	for($i=$in{'first'};$i<=$in{'second'};$i++){
		if($n < $mes_num){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$n]);
			splice(@command_DATA,$i,1,"$cid<>$cno<>$cname<>$ctime<>$csub<>$cnum<>$cend<>\n");
			$n++;
		}else{
			$n=0;
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$n]);
			splice(@command_DATA,$i,1,"$cid<>$cno<>$cname<>$ctime<>$csub<>$cnum<>$cend<>\n");
			$n++;
		}
	}
	open(OUT,">./charalog/command/$kid.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @command_DATA;
	close(OUT);


	$in{'first'}++;
	$in{'second'}++;
	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$in{'save'}番目に保存されたコマンドリストをコマンドリストのNO:$in{'first'}からNO:$in{'second'}に読み込みました。</h2><p>
<form action="./status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	&FOOTER;

	exit;

}


#コマンドリストの名前変更
sub NAME{

	if ($in{'save'} eq "" || $in{'save'} =~ m/[^0-9]/ || $in{'save'} < 1 || $in{'save'} > 15) { &ERR("保存リストの番号指定が異常です。"); }
	if($in{'name'} eq "" || length($in{'name'}) > 15) { &ERR("名前が入力されていないか15文字以上になっています。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;


	#データ処理&ファイルオープン
	open(IN,"./charalog/com_save/$kid/list.cgi");
	@NAME_DATA = <IN>;
	close(IN);

	open(IN,"./charalog/com_save/$kid/$in{'save'}.cgi") or &ERR("$in{'save'}番目には保存されていません。");
	@COM_DATA = <IN>;
	close(IN);
	$mes_num = @COM_DATA;
	if($mes_num == 0){ &ERR("$in{'save'}番目には保存されていません。"); }


	#書き込み
	@NEW_NAME_DATA=();
	for($i=1;$i<=15;$i++){
		if($i == $in{'save'}){
			push(@NEW_NAME_DATA,"$in{'name'}\n");
		}else{
			if($NAME_DATA[$i-1] eq ""){
			push(@NEW_NAME_DATA,"\n");
			}else{
			push(@NEW_NAME_DATA,"$NAME_DATA[$i-1]");
			}
		}
	}
	open(OUT,">./charalog/com_save/$kid/list.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_NAME_DATA;
	close(OUT);


	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$in{'save'}番目の名前を $in{'name'} にしました。</h2><p>
<form action="./status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	&FOOTER;

	exit;

}

1;
