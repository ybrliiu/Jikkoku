#!/usr/bin/perl

#専用BBS

use lib'./lib';
use CGI::Carp qw/fatalsToBrowser/;
use Jikkoku::Model::Config;
require './ini_file/index.ini';
require 'suport.pl';

  my $conf = Jikkoku::Model::Config->get->{site}{admin};
	my $bbskanri = $conf->{bbs_password};

	&DECODE;

	if($mode eq "BBS_WRITE") { require 'bbs/bbs_write.pl';&BBS_WRITE; }
	if($mode eq "BBS_DEL") { require 'bbs/bbs_del.pl';&BBS_DEL; }

	open(IN,"./bbs/senb.cgi") or &ERR2('ファイルを開けませんでした。err no :country_bbs');
	@BBS_DATA = <IN>;
	close(IN);

	if($in{'itstealth'} eq "$bbskanri"){
	$formp ="<input type=hidden name=itstealth value=$bbskanri>";
	}

	&HEADER;

	print <<"EOM";
<TABLE WIDTH="100%" height=100%>
<TBODY><TR>
<TD BGCOLOR=$ELE_BG[$xele] WIDTH=100% height=5 class="maru">　<font color=$ELE_C[$xele] size=4><B>十国志NET 専用BBS</B></font></TD>
</TR>
<TR>
<TD height="5">
<TABLE border="0" width=100%><TBODY>
<TR><TD width="100%" bgcolor=$TALK_BG><font color=$TALK_FONT>十国志NETの専用BBSです。<br>バグ、要望、仕様の質問などがありましたらここに書き込んでください。</font></TD>
</TR>
</TBODY></TABLE>
</TD>
</TR>
<TR>
<TD align=center valign=top>

<br><form action="./bbs.cgi" method="post">
名前<input type=text name=name size=40 value=$in{'name'}><br>
画像<input type=text name=icon size=40 value=$in{'icon'}><br>
題名<input type=text name=title size=40><br>
<textarea name=ins cols=50 rows=7>
</TEXTAREA>

<input type=hidden name=mode value=BBS_WRITE>
$formp
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


	@tmp = map {(split /<>/)[8]} @BBS_DATA;
	@BBS_DATA = @BBS_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];
	$s_n = 0;
	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($bbtype eq "0"){
			if(!$bbheap){
				if($s_n >= $bbs_no && $s_n < $bbs_no + $BBS_NEXT_NUM){
				$narabi[$bbno] = $s_n;
				}
			$s_n++;
			}
		}
	}



	$title = "<hr size=2 color=#000000><table border=0 width=85% bgcolor=$ELE_C[$xele]><tr><td><TR>
     <TD bgcolor=$ELE_BG[$xele] class=\"maru\" colspan=2><B><a name=\"itiran\"></a><font size=2 color=$ELE_C[$xele]>スレッド一覧</font></B></TD>
    </TR><tr><td>";
	$s_n = 0;
	foreach(@BBS_DATA){
		($bbid,$bbtitle,$bbmes,$bbcharaimg,$bbname,$bbhost,$bbtime,$bbele,$bbcon,$bbtype,$bbno,$bbheap)=split(/<>/);
		if($bbtype eq "0"){
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
		if($bbtype eq "0"){
			if(!$bbheap){
				if($s_n >= $bbs_no && $s_n < $bbs_no + $BBS_NEXT_NUM){
				$bno = $s_n+1;
				$bb_id[$n] = $bbno;
				$n++;
				$c_mes[$narabi[$bbno]] = "<table width=70%><tr><td align=right><a href=\"#itiran\">△スレッド一覧</a></td></tr></table><TABLE border=0 width=70% bgcolor=$ELE_C[$bbele]>


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
            <TD width=100% bgcolor=$ELE_BG[$bbele] class=\"maru\"><font color=ffffff><b>$bbmes</b></TD>
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
<form action=\"./bbs.cgi\" method=\"post\">
名前<input type=text name=name size=40 value=$in{'name'}><br>
画像<input type=text name=icon size=40 value=$in{'icon'}><br>
<textarea name=ins cols=40 rows=3>
</TEXTAREA> 
<input type=hidden name=b_no value=$bbno>
<input type=hidden name=mode value=BBS_WRITE>
$formp
<input type=submit id=input value=返信>
</TD></TR></form>
";
				if($in{'itstealth'} eq "$bbskanri"){
				$c_mes[$narabi[$bbno]] .= "<TR><TD colspan=2 align=right><form action=\"./bbs.cgi\" method=\"post\"><input type=hidden name=itstealth value=$bbskanri><input type=hidden name=no value=$bbno><input type=hidden name=type value=sure><input type=\"checkbox\" name=\"del\" value=\"yes\"><input type=hidden name=mode value=BBS_DEL><input type=submit id=input value=このスレッドを削除></form></TD></TR>";

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
		if($bbtype eq "0"){
			if($bbheap){
				$l=0;
				$no2[$bbheap]++;
				foreach(@bb_id){
					if($bbheap eq $bb_id[$l]){
						if(($no2[$bbheap] == 1)&&($in{'itstealth'} eq "$bbskanri")){
						$c_mes[$narabi[$bbheap]] .= "<form action=\"./bbs.cgi\" method=\"post\"><input type=hidden name=itstealth value=$bbskanri><input type=hidden name=mode value=BBS_DEL>";
						}
						if($in{'itstealth'} eq "$bbskanri"){
					$c_mes[$narabi[$bbheap]] .= "<TR><TD colspan=2 width=100%><TABLE cellspacing=1 width=100% bgcolor=$ELE_BG[$bbele] class=\"kaku\"><TBODY bgcolor=$ELE_C[$bbele]><TR><TD><input type=radio name=no value=$bbno></TD><TD width=100%><br><font color=$ELE_BG[$bbele]>$bbmes<br><br></TD><TD bgcolor=$ELE_BG[$bbele]><img src=$IMG/$bbcharaimg.gif width=64 height=64></TD></TR><TR><TD colspan=3><font size=1 color=$ELE_BG[$bbele]>$bbname <small>\[$bbtime\]</small></TD></TR></TABLE></TD></TR>";
						}else{
					$c_mes[$narabi[$bbheap]] .= "<TR><TD colspan=2 width=100%><TABLE cellspacing=1 width=100% bgcolor=$ELE_BG[$bbele] class=\"kaku\"><TBODY bgcolor=$ELE_C[$bbele]><TR><TD width=100%><font color=$ELE_BG[$bbele]><br>$bbmes<br><br></TD><TD bgcolor=$ELE_BG[$bbele]><img src=$IMG/$bbcharaimg.gif width=64 height=64></TD></TR><TR><TD colspan=3><font size=1 color=$ELE_BG[$bbele]>$bbname <small>\[$bbtime\]</small></TD></TR></TABLE></TD></TR>";
						}
						if(($no2[$bbheap] == $no[$bbheap])&&($in{'itstealth'} eq "$bbskanri")){
						$c_mes[$narabi[$bbheap]] .= "<TR><TD colspan=2 width=100%><TABLE cellspacing=0 width=100% bgcolor=$ELE_BG[$bbele] class=\"kaku\"><TBODY bgcolor=$ELE_C[$bbele]><TR><TD align=right><input type=submit id=input value=選択したレスを削除>
</form></TD></TR></TABLE></TD></TR>";
						}
					}
				$l++;
				}
			}
		}

	}


	foreach(@c_mes){
		if($_ ne ""){
			print "$_ </TBODY></TABLE><p>";
		}
	}


	if($in{'itstealth'} eq "$bbskanri"){
	$kanrip ="<input type=hidden name=itstealth value=$bbskanri>";
	$tujyo = "<form action=\"./bbs.cgi\" method=\"post\"><input type=submit id=input value=\"管理モードを終了する\"></form>"
	}
	$q=0;
	$n_bbs = $bbs_no + $BBS_NEXT_NUM;
	if($s_n >= $n_bbs){
	print " <form action=\"./bbs.cgi\" method=\"post\">
<input type=hidden name=bbs_no value=$n_bbs>$kanrip
<input type=submit id=input value=\"次の$BBS_NEXT_NUM件\">
</form>";
	}
print <<"EOM";
<a name="tail"></a>
</CENTER>
</TD>
</TR>
</TBODY></TABLE>
<br>
<br>
$tujyo
EOM

	&FOOTER;
	exit;

