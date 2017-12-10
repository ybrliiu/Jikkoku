#_/_/_/_/_/_/_/_/_/#
#_/    部隊配属  _/#
#_/_/_/_/_/_/_/_/_/#

sub UNIT_SELECT {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TOWN_DATA_OPEN;

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


	$syozoku = "<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_ENTRY><input type=submit id=input value=\"所属\">"; 

	$mess = "<HR size=0><b class=\"clit\">新規部隊作成</B></font><form action=\"$FILE_MYDATA\" method=\"post\"><TABLE bgcolor=$TABLE_C><TR><TD bgcolor=$TD_C3>部隊名</TD><TD bgcolor=$TD_C2><input type=text name=name size=30><BR>\[全角大文字で２〜１５文字以内\]</TD></TR><TD bgcolor=$TD_C3>部隊募集のコメント</TD><TD bgcolor=$TD_C2><textarea name=mes cols=30 rows=2>
</textarea><BR>\[全角大文字で０〜５０文字以内\]</TD></TABLE><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=MAKE_UNIT><input type=submit id=input value=\"部隊作成\"></form>";

	$kaisan ="";

	open(IN,"$UNIT_LIST") or &ERR("指定されたファイルが開けません。");
	@UNI_DATA = <IN>;
	close(IN);

	@UNI_DATA2 = @UNI_DATA;
	$i=0;
	foreach(@UNI_DATA){
		($unit_id,$uunit_name,$ucon,$ureader,$uid,$uname,$uchara,$umes,$uflg,$upos,$uauto)=split(/<>/);
		if("$ucon" eq "$kcon" && $ureader){

			$unit_num=1;
			$unit_list = "$uname";

			if("$uid" eq "$kid"){

				foreach(@UNI_DATA2){
					($unit_id2,$uunit_name2,$ucon2,$ureader2,$uid2,$uname2,$uchara2,$umes2,$uflg2)=split(/<>/);
					if("$unit_id" eq "$unit_id2" && !$ureader2){
						$unit_list .= ",$uname2";
						$unit_num++;
						$u_member .= "<option value=$uid2>$uname2";
					}
				}

			if($kid eq "$unit_id"){
			($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);

				if($kskl6 eq "1"){
				$as_mes = "<TR><TD bgcolor=$TD_C3><b>自動集合</B></TD><TD bgcolor=$TD_C2><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_AUTO><input type=submit id=input value=\"自動集合ON・OFF\"></form>※ONにすると自分のコマンド実行時に部隊員を部隊拠点に召集します。<font color=red>自動集合実行毎に米500消費。</font><br>部隊拠点が敵に支配されている場合は実行されません。</TD></TR>";
				}

				$mess = "<HR size=0><h2><font color=blue><b>●部隊長コマンド</B></font></h2>
<TABLE bgcolor=$TABLE_C>
<TR><TD bgcolor=$TD_C3><b>部隊拠点変更</B></TD><TD bgcolor=$TD_C2><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_POS><input type=submit id=input value=\"変更\"></form>※実行すると部隊拠点が現在の滞在都市に変更されます。</TD></TR>
<TR><TD bgcolor=$TD_C3><b>拠点帰還</B></TD><TD bgcolor=$TD_C2><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_KIKAN><input type=submit id=input value=\"帰還\"></form>※実行すると部隊長のみ部隊拠点に帰還します。<font color=red>米3000消費。</font><br>部隊拠点が敵に支配されている場合は実行できません。</TD></TR>
$as_mes
<TR><TD bgcolor=$TD_C3><b>入隊制限</B></TD><TD bgcolor=$TD_C2><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_CHANGE><input type=submit id=input value=\"入隊拒否・許可\"></form>※実行すると他の人はその部隊に入隊出来なくなります。</TD></TR>
<TR><TD bgcolor=$TD_C3><b>部隊員解雇</B></TD><TD bgcolor=$TD_C2><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><select name=did>$u_member</select><input type=hidden name=mode value=UNIT_OUT><input type=submit id=input value=\"部員解雇\"></form>※実行するとその部員は退去させられます。</TD></TR>
<TR><TD bgcolor=$TD_C3><b>部隊情報変更</B></TD><TD bgcolor=$TD_C2>部隊募集コメントを変更します。<br><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=CHANGE_UNIT><textarea name=mes cols=30 rows=2>
</textarea><input type=submit id=input value=\"変更\"></form>\[全角大文字で０〜５０文字以内\]</TD></TR></TABLE>";
				$reader = 1;

			}

			}else{
				foreach(@UNI_DATA2){
					($unit_id2,$uunit_name2,$ucon2,$ureader2,$uid2,$uname2,$uchara2,$umes2,$uflg2)=split(/<>/);
					if("$unit_id" eq "$unit_id2" && !$ureader2){
						$unit_list .= ",$uname2";
						$unit_num++;
					}
				}
			}


			if($uflg eq "1"){
				$u_mes = "入隊拒否";
			}else{
				$u_mes = "入隊ＯＫ";
			}

			if($uauto eq "1"){
				$auto_mes = "ON";
			}else{
				$auto_mes = "OFF";
			}


	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg) = split(/<>/);
($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

			if("$eid" eq "$unit_id"){

				$com_list = "";
				open(IN,"./charalog/command/$eid.cgi");
				@COM_DATA = <IN>;
				close(IN);
				for($i=0;$i<$MAX_COM;$i +=1){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
					$no = $i+1;
					if($cid eq ""){
					$com_list .= "$no: - <BR>";
					}else{
					$com_list .= "$no:$cname<BR>";
					}
					if($i>=3){last;}
				}

				$next_time = int(($edate + $TIME_REMAKE - $tt)/60);
	$nexttime33 = int($edate + $TIME_REMAKE - $tt)-($next_time*60);
        	if($next_time < 0){
                $next_time = 0;
    	 }
        	if($nexttime33 < 0){
                $nexttime33 = 0;
    	 }
                $acmin = $min + $next_time + 0 * ($TIME_REMAKE/60);
		$acs = $sec;
                $achour = $hour;
                $acday = $mday;

		$acsec = $acs + $nexttime33;

                while($acsec >= 60){
                        $acmin++;
                        $acsec = $acsec - 60;
                }

                while($acmin >= 60){
                        $achour++;
                        $acmin = $acmin - 60;
                }

			$unit_party .= "<TR><TD bgcolor=$TD_C3><input type=radio name=unit_id value=$unit_id></TD><TD bgcolor=$TD_C2><img src=\"$IMG/$uchara.gif\" width=\"$img_wid\" height=\"$img_height\" alt=\"$uname\"></TD><TD bgcolor=$TD_C1><font size=1>$uunit_name部隊<BR>($uname)</TD><td bgcolor=$TD_C1>$unit_list</td><td bgcolor=$TD_C2>$unit_num人</td><td bgcolor=$TD_C2>$umes</td><TD bgcolor=$TD_C1>$u_mes</TD><TD bgcolor=$TD_C1 align=center>$town_name[$upos]</TD><TD bgcolor=$TD_C2 align=center>$auto_mes</TD><TD bgcolor=$TD_C1>$acmin分$acsec秒</TD><td bgcolor=$TD_C2>$com_list</td></tr>";
		}
	}
		}

		if($uid eq $kid){
			$k_hit=1;
			$kunit_name = "<font color=red>$uunit_name\</font>部隊に所属しています。";
			$kaisan ="<HR size=0><form action=\"$FILE_MYDATA\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_DELETE><input type=submit id=input value=\"部隊脱退・解散\"></form>";
			$syozoku = "";
			if(!$reader){$mess = "";}
		}
	}

	if(!$k_hit){
		$kunit_name = "<font color=\"red\">部隊に所属していません。</font>";
	}

	&HEADER;

	print <<"EOM";
<table width="100%" cellpadding="0" cellspacing="0" border=0><tr><td>
<TABLE WIDTH="100%" border=0>
<TBODY><TR>
<TD BGCOLOR=$ELE_BG[$kele] WIDTH=100% height=5>　<font color=$ELE_C[$kele] size=4>　　　＜＜<B> * 部 隊 配 属 ・ 編 成*</B>＞＞</font></TD>
</TR><TR>
<TD bgcolor=$TD_C4 height=5>
<TABLE border="0"><TBODY>
<TR>
<TBODY>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
</td></tr></table>
</TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD height="5">
<TABLE  border="0"><TBODY>
<TR><TD width="100%" bgcolor=$TALK_BG><font color=$TALK_FONT>ここでは自国の所属する部隊に配属する事が出来ます。<BR>あなたは現在$kunit_name <BR>部隊に所属すると部隊チャットや集合コマンド、自動集合で部隊拠点に部隊員を集めたりと統制が取りやすくなります。<BR>また、自分が部隊長をしている場合、建国時に部隊に所属している、</font><font color=red>忠誠度100の</font><font color=white>武将全員が自分が建国した国の所属になります。<br>※最初の部隊拠点は部隊作成時の滞在都市が設定されます。<br>※部隊についての詳細は<a target="_blank" href="./manual.html#butai">こちら</a>。</font><font color=red>デフォルトと違うところがあるので注意して下さい。</font></TD>
<TD bgcolor=$TD_C4></TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD><BR><BR>
<form action="$FILE_MYDATA" method="post">
<CENTER><TABLE bgcolor=$TABLE_C><TBODY><TR>
<TD bgcolor=$TD_C3>選択</TD><TD bgcolor=$TD_C2>隊長</TD><TD bgcolor=$TD_C1>部隊名(隊長)</TD><TD bgcolor=$TD_C1>所属武将</TD><TD bgcolor=$TD_C1>所属人数</TD><TD bgcolor=$TD_C2>部隊募集メッセージ</TD><TD bgcolor=$TD_C1>入隊受付</TD><TD bgcolor=$TD_C1>部隊拠点</TD><TD bgcolor=$TD_C1>自動集合</TD><TD bgcolor=$TD_C1>更新時間</TD><TD bgcolor=$TD_C1>部隊長コマンド</TD></TR>
EOM


print <<"EOM";
$unit_party
</TR></TBODY></TABLE></CENTER>

<BR>
$syozoku
</form>
$mess
$kaisan
<HR size=0>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
</TD>
</TR>
</TBODY></TABLE>
</td></tr></table>
EOM

	&FOOTER;
	exit;
}
1;
