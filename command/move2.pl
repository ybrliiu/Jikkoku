#_/_/_/_/_/_/_/_/_/_/#
#        移動２      #
#_/_/_/_/_/_/_/_/_/_/#

sub MOVE2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if($in{'num'} eq ""){&ERR("移動先が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&TIME_DATA;
	$num = $in{'num'};
	$hit=0;
	foreach(@z){
		if($_ eq $num){
			$hit=1;
		}
	}

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	@NEW_COM_DATA=();$i=0;
	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $MAX_COM){
				push(@NEW_COM_DATA,"$in{'mode'}<><>$town_name[$num]へ移動<>$tt<><>$in{'num'}<><>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"$in{'mode'}<><>$town_name[$num]へ移動<>$tt<><>$in{'num'}<><>\n");
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

#続けて移動するとき
	$nextnum = $lno+1;
	if($in{'no'} ne "all" && $nextnum <= $MAX_COM){
	$nextmove=<<"EOM";
<br>
<form action="./command.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=17>
<input type=hidden name=no value=$lno>
<input type=submit value="続けて移動する(No:$nextnum)"></form>
EOM
}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>NO:$noに$town_name[$num]へ移動を入力しました。</h2><p>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="ＯＫ"></form>
$nextmove
</CENTER>
EOM

	&FOOTER;

	exit;

}
1;
