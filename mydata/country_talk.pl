#_/_/_/_/_/_/_/_/_/#
#_/    会議室    _/#
#_/_/_/_/_/_/_/_/_/#

sub COUNTRY_TALK {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
    if($xcid eq 0){&ERR("無所属国は使用できません。");}
	$sno = int($kclass / $LANK);
	if($sno > 100){$sno = 100;}

	open(IN,"$BBS_LIST") or &ERR('ファイルを開けませんでした。err no :country_bbs');
	@BBS_DATA = <IN>;
	close(IN);


	&HEADER;

	print <<"EOM";
<TABLE WIDTH="100%" height=100%>
<TBODY><TR>
<TD BGCOLOR=$ELE_BG[$xele] WIDTH=100% height=5 class="maru">　<font color=$ELE_C[$xele] size=4>　　　＜＜<B> * $xname 会議室 *</B>＞＞</font></TD>
</TR><TR>
<TD height=5>
<TABLE border="0"><TBODY>
<TR>
<TD></TD>
<TD WIDTH=100% align=center>
<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="都市に戻る"></form>
</TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD height="5">
<TABLE border="0" width=100%><TBODY>
<TR><TD width="100%" bgcolor=$TALK_BG><font color=$TALK_FONT>自国専用の掲示板です。<BR>同じ軍の方とのコミュニケーションに御使いください。</font></TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD align=center>

<br><form action="./mydata.cgi" method="post">
題名<input type=text name=title size=40><p>
<textarea name=ins cols=40 rows=7>
</TEXTAREA> <img src="$IMG/$kchara.gif" width="64" height="64"><p>

<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=COUNTRY_WRITE>
<input type=submit id=input value="掲示">
</form>
</font>
EOM
	$BBS_NEXT_NUM = 20;

	if($in{'bbs_no'} eq ""){
		$bbs_no = 0;
	}else{
		$bbs_no = $in{'bbs_no'};
	}


	$title = "<hr size=2 color=#000000><table border=0 width=85% bgcolor=$ELE_C[$xele]><tr><td><TR>
     <TD bgcolor=$ELE_BG[$xele] class=\"maru\" colspan=2><B><a name=\"itiran\"></a><font size=2 color=$ELE_C[$xele]>スレッド一覧</font></B></TD>
    </TR><tr><td>";
	$s_n = 0;
	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($kcon eq "$bbcon" && $bbtype eq "0"){
			if(!$bbheap){
				if($s_n >= $bbs_no && $s_n < $bbs_no + $BBS_NEXT_NUM){
				$bno = $s_n+1;
				$title .= "<a href=\"#$bno\">$bno ▼$bbtitle</a>　";
				}
			$s_n++;
			}
		}
	}
	$title .= "<p align=right><a href=\"#tail\">▽ページの一番下に行く</a></td></tr></table><br><br>";
	print "$title";


	$s_n = 0;
	$n = 0;
	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($kcon eq "$bbcon" && $bbtype eq "0"){
			if(!$bbheap){
				if($s_n >= $bbs_no && $s_n < $bbs_no + $BBS_NEXT_NUM){
				$bno = $s_n+1;
				$bb_id[$n] = $bbno;
				$n++;
				$c_mes[$bbno] = "<table width=70%><tr><td align=right><a href=\"#itiran\">△スレッド一覧</a></td></tr></table><TABLE border=0 width=70% bgcolor=$ELE_C[$bbele]>


  <TBODY>
    <TR>
     <TD bgcolor=$ELE_BG[$xele] class=\"maru\" colspan=2><B><a name=\"$bno\"></a><font size=3 color=$ELE_C[$bbele]>$bno ▼$bbtitle</font></B></TD>
    </TR>
    <TR>
      <TD width=80 rowspan=3 valign=middle align=center><img src=$IMG/$bbcharaimg.gif width=64 height=64></TD>
      <TD>
      <TABLE border=0 width=100% bgcolor=$ELE_C[$bbele]>
        <TBODY>
          <TR>
            <TD width=100% bgcolor=$ELE_BG[$bbele] class=\"maru\"><font color=ffffff>$bbmes</TD>
          </TR>
        </TBODY>
      </TABLE>
      </TD>
    </TR>
    <TR>
      <TD><font size=1 color=$ELE_BG[$bbele]>$bbname </font></TD>
    </TR>
    <TR>
      <TD colspan=2 align=right><font size=1 color=$ELE_BG[$bbele]>$bbtime</font></TD>
    </TR>

    <TR>
      <TD colspan=2 align=right>
<form action=\"./mydata.cgi\" method=\"post\">
<textarea name=ins cols=40 rows=3>
</TEXTAREA> 
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=b_no value=$bbno>
<input type=hidden name=mode value=COUNTRY_WRITE>
<input type=submit id=input value=返信>
</TD></TR></form>
";
				if(($xking eq $kid)||($xgunshi eq $kid)||($xxsub1 eq $kid)){
				$c_mes[$bbno] .= "<TR><TD colspan=2 align=right><form action=\"./mydata.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=no value=$bbno><input type=hidden name=type value=sure><input type=\"checkbox\" name=\"del\" value=\"yes\"><input type=hidden name=mode value=COUNTRY_DEL><input type=submit id=input value=このスレッドを削除></form></TD></TR>";

					}
				}
			$s_n++;
			}else{
			$no[$bbheap]++;
			}
		}

	}


	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($kcon eq "$bbcon" && $bbtype eq "0"){
			if($bbheap){
				$l=0;
				$no2[$bbheap]++;
				foreach(@bb_id){
					if($bbheap eq $bb_id[$l]){
						if(($no2[$bbheap] == 1)&&(($xking eq $kid)||($xgunshi eq $kid)||($xxsub1 eq $kid))){
						$c_mes[$bbheap] .= "<form action=\"./mydata.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=COUNTRY_DEL>";
						}
						if(($xking eq $kid)||($xgunshi eq $kid)||($xxsub1 eq $kid)){
					$c_mes[$bbheap] .= "<TR><TD colspan=2 width=100%><TABLE cellspacing=1 width=100% bgcolor=$ELE_BG[$bbele] class=\"kaku\"><TBODY bgcolor=$ELE_C[$bbele]><TR><TD><input type=radio name=no value=$bbno></TD><TD width=100%><font color=$ELE_BG[$bbele]>$bbmes</TD><TD bgcolor=$ELE_BG[$bbele]><img src=$IMG/$bbcharaimg.gif width=64 height=64></TD></TR><TR><TD colspan=3><font size=1 color=$ELE_BG[$bbele]>$bbname <small>\[$bbtime\]</small></TD></TR></TABLE></TD></TR>";
						}else{
					$c_mes[$bbheap] .= "<TR><TD colspan=2 width=100%><TABLE cellspacing=1 width=100% bgcolor=$ELE_BG[$bbele] class=\"kaku\"><TBODY bgcolor=$ELE_C[$bbele]><TR><TD width=100%><font color=$ELE_BG[$bbele]>$bbmes</TD><TD bgcolor=$ELE_BG[$bbele]><img src=$IMG/$bbcharaimg.gif width=64 height=64></TD></TR><TR><TD colspan=3><font size=1 color=$ELE_BG[$bbele]>$bbname <small>\[$bbtime\]</small></TD></TR></TABLE></TD></TR>";
						}
						if(($no2[$bbheap] == $no[$bbheap])&&(($xking eq $kid)||($xgunshi eq $kid)||($xxsub1 eq $kid))){
						$c_mes[$bbheap] .= "<TR><TD colspan=2 width=100%><TABLE cellspacing=0 width=100% bgcolor=$ELE_BG[$bbele] class=\"kaku\"><TBODY bgcolor=$ELE_C[$bbele]><TR><TD align=right><input type=submit id=input value=選択したレスを削除>
</form></TD></TR></TABLE></TD></TR>";
						}
					}
				$l++;
				}
			}
		}

	}

	$s=@c_mes;
	$d=0;
	foreach(@c_mes){
		$new_c_mes[$s] = $c_mes[$d];
		$s--;
		$d++;
	}

	foreach(@new_c_mes){
		if($_ ne ""){
			print "$_ </TBODY></TABLE><p>";
		}
	}

	$q=0;
	$n_bbs = $bbs_no + $BBS_NEXT_NUM;
	if($s_n >= $n_bbs){
	print " <form action=\"./mydata.cgi\" method=\"post\">
<input type=hidden name=mode value=COUNTRY_TALK>
<input type=hidden name=bbs_no value=$n_bbs>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit id=input value=\"次の$BBS_NEXT_NUM件\">
</form>";
	}
print <<"EOM";
<a name="tail"></a>
</CENTER>
</TD>
</TR>
</TBODY></TABLE>
EOM

	&FOOTER;
	exit;
}
1;
