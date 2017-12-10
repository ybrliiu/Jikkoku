#_/_/_/_/_/_/_/_/_/_/#
#      建国２      #
#_/_/_/_/_/_/_/_/_/_/#

sub KENKOKU2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	open(IN,"$TOWN_LIST") or &E_ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);
	open(IN,"$COUNTRY_LIST") or &E_ERR('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	open(IN,"$COUNTRY_NO_LIST") or &E_ERR('ファイルを開けませんでした。err no :country no');
	@COU_NO_DATA = <IN>;
	close(IN);

	($z2name,$z2con)=split(/<>/,$TOWN_DATA[$kpos]);
		if($in{'ele'} eq ""){
			&ERR("色を選択してください。");
		}elsif($in{'armname'} eq "" || length($in{'armname'}) < 2 || length($in{'armname'}) > 30) {
			&ERR("国の名前が正しく入力されていません。");
		}
		$color = $in{'ele'};
		$cou_name = $in{'armname'};
		$new_cou_no = @COU_NO_DATA + 1;

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	@NEW_COM_DATA=();$i=0;
	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $MAX_COM){
			push(@NEW_COM_DATA,"$in{'mode'}<><>建国<>$tt<>$cou_name,$color,$new_cou_no,<><><>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"$in{'mode'}<><>建国<>$tt<>$cou_name,$color,$new_cou_no,<><><>\n");
					$lno = $_ + 1;
					$no .= "$lno,";
				}
			}
			if(!$ahit){
				push(@NEW_COM_DATA,"$_");
			}

			$i++;
		}
	}
	open(OUT,">./charalog/command/$kid.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_COM_DATA;
	close(OUT);

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>NO:$noに建国を入力しました。</h2><p>
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