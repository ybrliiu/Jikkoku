#_/_/_/_/_/_/_/_/_/_/#
#        調査２      #
#_/_/_/_/_/_/_/_/_/_/#

sub TYOUSA2 {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	if($in{'tid'} eq ""){&ERR("相手が選択されていません。");}
	if($in{'kensaku'} eq "" || $in{'kensaku'} >= 2){&ERR("は？");}
	&CHARA_MAIN_OPEN;

	$tid = $in{'tid'};
	$kensaku = $in{'kensaku'};

	opendir(dirlist,"./charalog/main");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"./charalog/main/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);

	if($kensaku){
	$thit = 0;
	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg) = split(/<>/);
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

			if($ename eq $tid){
			$tid = "$eid";
			$tname = "$ename";
			$thit = 1;
			last;
		}
	}
	if(!$thit){&ERR("入力された名前の武将は見つかりませんでした。");}

	}elsif(!$kensaku){
	$thit = 0;
	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg) = split(/<>/);
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

			if($eid eq $tid){
			$tname = "$ename";
			$thit = 1;
			last;
		}
	}
	if(!$thit){&ERR("？　選択した名前の武将は見つかりませんでした。");}
	}

	open(IN,"./charalog/command/$kid.cgi");
	@COM_DATA = <IN>;
	close(IN);

	$mes_num = @COM_DATA;

	if($mes_num > $MAX_COM) { pop(@COM_DATA); }

	@NEW_COM_DATA=();$i=0;

	if($in{'no'} eq "all"){
		while(@NEW_COM_DATA < $MAX_COM){
			push(@NEW_COM_DATA,"$in{'mode'}<><>$tnameを調査<>$tt<><>$tid<><>\n");
		}
		$no = $in{'no'};
	}else{
		foreach(@COM_DATA){
			($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/);
			$ahit=0;
			foreach(@no){
				if($i eq $_){
					$ahit=1;
					push(@NEW_COM_DATA,"$in{'mode'}<><>$tnameを調査<>$tt<><>$tid<><>\n");
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
<CENTER><hr size=0><h2>NO:$noに$tnameを調査を入力しました。</h2><p>
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