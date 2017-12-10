#_/_/_/_/_/_/_/_/_/#
#_/ 携帯版部隊配属  _/#
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

	$mess = "<HR size=0><b class=\"clit\">新規部隊作成</B></font><form action=\"./i-command.cgi\" method=\"post\"><br>部隊名：<input type=text name=name size=30><BR>\[全角大文字で２〜１５文字以内\]<br>部隊募集のコメント：<textarea name=mes cols=30 rows=2>
</textarea><BR>\[全角大文字で０〜５０文字以内\]<br><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=MAKE_UNIT><input type=submit id=input value=\"部隊作成\"></form>";

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
				$as_mes = "<b>自動集合</B><br><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_AUTO><input type=submit id=input value=\"自動集合ON・OFF\"></form>※ONにすると自分のコマンド実行時に部隊員を部隊拠点に召集します。<font color=red>自動集合実行毎に米500消費。</font><br>部隊拠点が敵に支配されている場合は実行されません。<br><br>";
				}

				$mess = "<HR size=0><font color=blue><b>部隊長コマンド</B></font>
<br><br><b>部隊拠点変更</B><br><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_POS><input type=submit id=input value=\"変更\"></form>※実行すると部隊拠点が現在の滞在都市に変更されます。<br><br>
<b>拠点帰還</B><br><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_KIKAN><input type=submit id=input value=\"帰還\"></form>※実行すると部隊長のみ部隊拠点に帰還します。<font color=red>米3000消費。</font><br>部隊拠点が敵に支配されている場合は実行できません。<br><br>
$as_mes
<br><br><b>入隊制限</B><br><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_CHANGE><input type=submit id=input value=\"入隊拒否・許可\"></form>※実行すると他の人はその部隊に入隊出来なくなります。<br><br>
<b>部隊員解雇</B><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><select name=did>$u_member</select><input type=hidden name=mode value=UNIT_OUT><input type=submit id=input value=\"部員解雇\"></form>※実行するとその部員は退去させられます。<br><br>
<b>部隊情報変更</B><br>部隊募集コメントを変更します。<br><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=CHANGE_UNIT><textarea name=mes cols=30 rows=2>
</textarea><input type=submit id=input value=\"変更\"></form>\[全角大文字で０〜５０文字以内\]";
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
				for($i=0;$i<1;$i +=1){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
					$no = $i+1;
					if($cid eq ""){
					$com_list .= "$no: - <BR>";
					}else{
					$com_list .= "$no:$cname<BR>";
					}
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

			$unit_party .= "<input type=radio name=unit_id value=$unit_id>$uunit_name部隊($uname)<br>部隊員：$unit_list<br>人数：$unit_num人<br>部隊募集文：$umes<br>入隊受付：$u_mes<br>部隊拠点：$town_name[$upos]<br>自動集合：$auto_mes<br>コマンド：$com_list更新時間：$acmin分$acsec秒<hr>";
		}
	}
		}

		if($uid eq $kid){
			$k_hit=1;
			$kunit_name = "<font color=red>$uunit_name\</font>部隊に所属しています。";
			$kaisan ="<HR size=0><form action=\"./i-command.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_DELETE><input type=submit id=input value=\"部隊脱退・解散\"></form>";
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
<TD BGCOLOR=$ELE_BG[$kele] WIDTH=100% height=5>　<font color=$ELE_C[$kele]>　　　＜＜<B> * 部 隊 配 属 ・ 編 成*</B>＞＞</font></TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD height="5">
<TABLE  border="0"><TBODY>
<TR><TD width="100%" bgcolor=$TALK_BG><font color=$TALK_FONT>ここでは自国の所属する部隊に配属する事が出来ます。<BR>あなたは現在$kunit_name <BR>部隊に所属すると部隊チャットや集合コマンドで統制が取りやすくなります。<BR>また、自分が部隊長をしている場合、建国時に部隊に所属している武将全員が自分が建国した国の所属になります。</font></TD>
<TD bgcolor=$TD_C4></TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD><BR><BR>
<form action="./i-command.cgi" method="post">

EOM


print <<"EOM";
$unit_party

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
