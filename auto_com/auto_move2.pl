#_/_/_/_/_/_/_/_/_/_/#
#      自動移動      #
#_/_/_/_/_/_/_/_/_/_/#

sub AUTO_MOVE2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if ($in{'opt1'} eq "" || $in{'opt1'} =~ m/[^0-9]/ || $in{'opt1'} > 1) { &ERR("オプション1の値が異常です。"); }
	if ($in{'opt2'} eq "" || $in{'opt2'} =~ m/[^0-9]/ || $in{'opt2'} > 1) { &ERR("オプション2の値が異常です。"); }
	&CHARA_MAIN_OPEN;
	&TIME_DATA;
	&TOWN_DATA_OPEN("$kpos");


	#ルートファイルが読み込めるか判断
	$r_hit=0;
	$dir="./log_file/map_road";
	$target = "$in{'start'}\-$in{'target'}";
	opendir(dirlist,"$dir");
		while($file = readdir(dirlist)){
			$file =~ s/.pl//g;
			if($file eq $target){
			$r_hit=1;
			last;
			}
		}
	closedir(dirlist);

	if(!$r_hit){&ERR("指定された都市間のルートを記録したファイルが存在しません。");}


	$mess="$town_name[$in{'start'}]から$town_name[$in{'target'}]へ移動";


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
			push(@NEW_COM_DATA,"$in{'mode'}<><>$mess<><>$target<>$in{'opt1'}<>$in{'opt2'}<>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"$in{'mode'}<><>$mess<><>$target<>$in{'opt1'}<>$in{'opt2'}<>\n");
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

#続けて移動するとき
	$nextnum = $lno+1;
	if($in{'no'} ne "all" && $nextnum <= $BMMAX_COM){
$nextmove="
<br>
<br>
<form action=\"./auto_com.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=start value=$in{'target'}>
<input type=hidden name=mode value=8>
<input type=hidden name=no value=$lno>
<table><tr><td>
オプション1:コマンド失敗時の設定<br>
<select name=opt1 size=3>
<option value=\"0\" ";if($in{'opt1'} eq "0"){$nextmove.="SELECTED";}$nextmove.=">そのコマンドを消化する
<option value=\"1\" ";if($in{'opt1'} eq "1"){$nextmove.="SELECTED";}$nextmove.=">そのコマンドを消化しない
</select>
</td><td style=\"width:10px;\"></td><td>
オプション2:移動先や関所の上に敵がいた時の設定<br>
<select name=opt2 size=3>
<option value=\"0\" ";if($in{'opt2'} eq "0"){$nextmove.="SELECTED";}$nextmove.=">戦闘する
<option value=\"1\" ";if($in{'opt2'} eq "1"){$nextmove.="SELECTED";}$nextmove.=">何もしない
</select>
</td></tr>
</table>
<br>
<input type=submit value=\"続けて移動する(No:$nextnum)\"></form>
";
}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>NO:$noに$messを入力しました。</h2><p>
<form action="./auto_in.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="ＯＫ"></form>
$nextmove
<br>
</CENTER>
EOM

	&FOOTER;

	exit;

}
1;
