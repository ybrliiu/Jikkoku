#_/_/_/_/_/_/_/_/_/_/#
#      移動      #
#_/_/_/_/_/_/_/_/_/_/#

sub MOVE {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if ($in{'opt1'} eq "" || $in{'opt1'} =~ m/[^0-9]/ || $in{'opt1'} > 1) { &ERR("オプション1の値が異常です。"); }
	if ($in{'opt2'} eq "" || $in{'opt2'} =~ m/[^0-9]/ || $in{'opt2'} > 1) { &ERR("オプション2の値が異常です。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;

	if($mode eq '1') { $mess = "左に"; }
	elsif($mode eq '2')  { $mess = "右に"; }
	elsif($mode eq '3')  { $mess = "下に"; }
	elsif($mode eq '4')  { $mess = "上に"; }
	$mess .= "移動";
	if($in{'opt1'} eq 0){ $mess .= "(消化、"; }else{ $mess.= "（消化しない、";}
	if($in{'opt2'} eq 0){ $mess .= "戦闘）"; }else{ $mess.= "何もしない）";}

	open(IN,"./charalog/auto_com/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $BMMAX_COM) { pop(@COM_DATA); }

	@NEW_COM_DATA=();$i=0;
	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $BMMAX_COM){
			push(@NEW_COM_DATA,"1<>$mode<>$mess<><><>$$in{'opt1'}<>$in{'opt2'}<>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"1<>$mode<>$mess<><><>$in{'opt1'}<>$in{'opt2'}<>\n");
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
	open(OUT,">./charalog/auto_com/$kid.cgi") or &ERR('ファイルを開けませんでした。');
	print OUT @NEW_COM_DATA;
	close(OUT);

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>NO:$noに$messを入力しました。</h2><p>
<form action="./auto_in.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	&FOOTER;

	exit;

}
1;
