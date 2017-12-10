#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

use lib'./lib';
use Jikkoku::Util;
use CGI::Carp qw/fatalsToBrowser/;
use Jikkoku::Model::Config;

require './ini_file/index.ini';
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;

if(!$ADMIN_SET) { &ERR2("管理ツールを使用する設定になっていません。"); }

my $conf = Jikkoku::Model::Config->get->{site}{admin};

	$adminid = $conf->{id};
	$adminpass = $conf->{password};
	$bbskanri = $conf->{bbs_password};

if($mode eq 'CHANGE') { &CHANGE; }
elsif($mode eq 'MENTE') { &MENTE; }
elsif($mode eq 'MENTE2') { &MENTE2; }
elsif($mode eq 'CHANGE2') { &CHANGE2; }
elsif($mode eq 'BBS') { &BBS; }
elsif($mode eq 'DEL') { &DEL; }
elsif($mode eq 'DEL2') { &DEL2; }
elsif($mode eq 'DEL_LIST') { &DEL_LIST; }
elsif($mode eq 'ALL_DEL') { &ALL_DEL; }
elsif($mode eq 'INIT_DATA_ABMIT') { &INIT_DATA_ABMIT; }
elsif($mode eq 'INIT_DATA') { &INIT_DATA; }
elsif($mode eq 'BACK_UP') { &BACK_UP; }
elsif($mode eq 'BACK_UP_DEL') { &BACK_UP_DEL; }
elsif($mode eq 'ZATUBBS') { &ZATUBBS; }
elsif($mode eq 'ZATUBBS_ALLDEL') { &ZATUBBS_ALLDEL; }
elsif($mode eq 'ZATUBBS_BDEL') { &ZATUBBS_BDEL; }
elsif($mode eq 'ICON') { &ICON; }
elsif($mode eq 'ICON_DEL') { &ICON_DEL; }
elsif($mode eq 'OSIRASE') { &OSIRASE; }
elsif($mode eq 'OSIRASE2') { &OSIRASE2; }
elsif($mode eq 'announce') { announce() }
else{&TOP;}


#_/_/_/_/_/_/_/_/_/#
#_/   MAIN画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub TOP {

	open(IN,"$SYSTEM_LOG");
	@S_MOVE = <IN>;
	close(IN);
	$p=0;
	while($p<11){$Y_MES .= "<font color=000088>●</font>$S_MOVE[$p]<BR>";$p++;}

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	#id,pw再発行要請リスト
	open(IN, "./log_file/idpw.cgi");
	@idpw = <IN>;
	close(IN);

	&HEADER;

	print <<"EOM";

<h2>管理ツール</h2>
<CENTER>
<table width=80% cellspacing=1 border=0 bgcolor=$TABLE_C><TBODY bgcolor=$TD_C4>
<TR><TH colspan=2>管理メニュー</TH></TR>
<form method="post" action="admin.cgi">
<TR><Th>
<input type=hidden name=mode value=MENTE>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='キャラ編集１'>
</Th></form><TD>
・登録者のデータを編集します。通常はこちらで編集してください。
参加者の数が増えると使えなくなる可\能\性があります。
</TD></TR>
<form method="post" action="admin.cgi">
<TR><Th>
<input type=hidden name=mode value=INIT_DATA_ABMIT>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='初期化'>
</Th></form><TD>
・すべてのデータを初期化します。
</TD></TR>
<form method="post" action="admin.cgi">
<TR><Th>
<input type=hidden name=mode value=BACK_UP>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='バックアップ'>
</Th></form><TD>
・バックアップファイルを作成します。(ZIP形式で作成されます)
</TD></TR>
<form method="post" action="admin.cgi">
<TR><Th>
<input type=hidden name=mode value=ZATUBBS>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='雑談用BBS管理'>
</Th></form><TD>
・雑談用BBS管理画面に移動します。
</TD></TD></TR>
<form method="post" action="admin.cgi">
<TR><TH>
<input type=hidden name=mode value=ICON>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='画像アップローダ管理'>
</Th></form><TD>
・画像アップローダ管理画面に移動します。
</TD></TD></TR>
<form method="post" action="bbs.cgi">
<TR><TH>
<input type=hidden name=itstealth value=$bbskanri>
<input type=submit id=input value='専用BBS管理'>
</Th></form><TD>
・管理モードで専用BBSに移動します。管理が終わったらすぐに専用BBSの画面は閉じてください。<br>
（管理人の名前で投稿するにも管理モードで入る必要があります。）
</TD></TD></TR>
<form method="post" action="admin.cgi">
<TR><TH>
<input type=hidden name=mode value=OSIRASE>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='お知らせ'>
</Th></form><TD>
・ゲームのお知らせを出したり、管理人からマップログにお知らせを出す場合はこちら
</TD></TD></TR>

</TBODY></TABLE>
<br>


<form method="post" action="admin.cgi">
<input type=hidden name=mode value=BBS>
MEMO:<input type=text name=message size=40>
NAME:<input type=text name=name size=10>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='メモ'>
<br></form>

<form method="post" action="index.cgi">
</select><input type=submit id=input value='編集を終える'>
<br></form>
</CENTER>

EOM
	open(IN,"$ADMIN_BBS");
	@A_BBS = <IN>;
	close(IN);

	# 管理者メモ
	print "<center><h3>管理者メモ</h3><table width=80% border=0 >@A_BBS</table>";

	# id,pw再要請
	print "<center><h3>id,pw再要請</h3><table width=80% border=0 >@idpw</table>";

	#システムログ
	print "<br><br><center><table><TR><TD colspan=\"2\"><div class=\"midasi3\"><b><font size=\"2\">&nbsp;SYSTEM LOG</font></div></b></TD></TR>
<TR><TD bgcolor=#baa98b colspan=\"2\" width=80% height=20 class=\"maru\"><font color=#6d614a size=2>$Y_MES</font></TD></TR></table></center>";

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/  MENTE画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub MENTE {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	$i=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			$datames = "検索：$dir/$file<br>\n";
			if(!open(page,"$dir/$file")){
				$datames .= "$dir/$fileがみつかりません。<br>\n";
				return 1;
			}
			@page = <page>;
			close(page);
			$list[$i]="$file";
			($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/,$page[0]);

			if("$in{'serch'}" ne ""){
				if("$ename" =~ "$in{'serch'}"){
					$human_data[$i]="$ehost<>$ename<>$eid<>$eiba<>";
				}else{
					next;
				}
			}else{
				if($in{'no'} eq "2"){
					$human_data[$i]="$ename<>$ehost<>$eid<>$eiba<>";
				}elsif($in{'no'} eq "3"){
					$human_data[$i]="$eid<>$ehost<>$ename<>$eiba<>";
				}elsif($in{'no'} eq "4"){
					$human_data[$i]="$eiba<>$eid<>$ehost<>$ename<>";
				}else{
					$human_data[$i]="$ehost<>$ename<>$eid<>$eiba<>";
				}
			}
			push(@newlist,"@page<br>");
			$i++;
		}
	}
	closedir(dirlist);

	@human_data = sort @human_data;

	$tt = time - (60 * 60 * 24 * 34);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime($tt);
	$year += 1900;
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%4d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);

	&HEADER;
	print <<"EOM";
<h2>キャラ管理ツール</h2><br>
・IDはファイル名と同じになっているので変更しないで下さい。<br>
・ホスト名は登録時の、ホスト2は随時更新。<br>
<form method="post" action="admin.cgi">
<input type=hidden name=mode value=CHANGE>編集するファイル：
<select name=fileno>
EOM
	$i=0;$w_host="";
	foreach(@human_data){
		if($in{'no'} eq "2"){
			($ename,$ehost,$eid,$eiba) = split(/<>/);
		}elsif($in{'no'} eq "3"){
			($eid,$ehost,$ename,$eiba) = split(/<>/);
		}elsif($in{'no'} eq "4"){
			($eiba,$eid,$ehost,$ename) = split(/<>/);
		}else{
			($ehost,$ename,$eid,$eiba) = split(/<>/);
		}
		print "<option value=$eid\.cgi>$eid $ename $ehost $eiba\n";
		if($in{'no'} eq "" || $in{'no'} eq "1"){
			if($w_host eq "$ehost"){
				$mess .= "$ename | $w_name<BR>\n";
			}
		}elsif($in{'no'} eq "4"){
			if($w_host2 eq "$eiba"){
				$mess .= "$ename | $w_name<BR>\n";
			}
		}

		$w_host = "$ehost";
		$w_host2 = "$eiba";
		$w_name = "$ename";
		$i++;
	}
print <<"EOM";
</select><input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='編集'>
<br></form>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value=MENTE>
<br><input type=radio name=no value="1">ホスト名順（<font color=red>2重登録チェック</font>）<br>
<input type=radio name=no value="2">名前順<br>
<input type=radio name=no value="3">ＩＤ順<br>
<input type=radio name=no value="4">ホスト2順（<font color=red>2重登録チェック</font>）<br>
名前検索<input type=text name=serch size=20><br>
<input type=submit id=input value='順変更'>
<br></form>

<h2>ファイル消去</h2>
・２重登録者を強制削除します。<BR>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value=DEL_LIST>
<input type=submit id=input value='削除者リスト'>
<br></form>


２重登録疑惑者<p>
<font color=red>$mess</font>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='TOP'>
<br></form>

EOM
	open(IN,"$ADMIN_LIST");
	@A_LOG = <IN>;
	close(IN);
	print "@A_LOG";

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/#
#_/   DEL LIST画面   _/#
#_/_/_/_/_/_/_/_/_/_/_/#

sub DEL_LIST {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	$tt = time - (60 * 60 * 24 * 34);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime($tt);
	$year += 1900;
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%4d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	$i=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			$datames = "検索：$dir/$file<br>\n";
			if(!open(page,"$dir/$file")){
				$datames .= "$dir/$fileがみつかりません。<br>\n";
				return 1;
			}
			@page = <page>;
			close(page);
			$list[$i]="$file";
			($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/,$page[0]);

			if($edate < $tt){
			$i++;
			($sec2,$min2,$hour2,$mday2,$mon2,$year2,$wday2,$yday2) = localtime($edate);
			$mon2++;
			$last_login = "$mon2月$mday2日$hour2時$min2分";
			$LIST .= "<TR><TD>$ename</TD><TD>$eid</TD><TD>$email</TD><TD>$last_login</TD></TR>";
			}
		}
	}
	closedir(dirlist);

	@human_data = sort @human_data;
	$a = "ss";
	$dir="./charalog/main";
	unlink("$dir/$a\.cgi");

	&HEADER;
	print <<"EOM";
<h2>キャラ管理ツール</h2>
<br>

<h2>ファイル消去</h2>
<TABLE><TBODY>
<TR><TD>名前</TD><TD>ID</TD><TD>MAIL</TD><TD>最終更新</TD></TR>
$LIST
</TBODY></TABLE>

＞＞以上の人を削除します。宜しいですか？<BR>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value=ALL_DEL>
<input type=submit id=input value='削除'>
<br></form>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
<br></form>


EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/ ファイル削除 _/#
#_/_/_/_/_/_/_/_/_/#

sub ALL_DEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	$tt = time - (60 * 60 * 24 * 34);

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	$i=0;
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			$datames = "検索：$dir/$file<br>\n";
			if(!open(page,"$dir/$file")){
				$datames .= "$dir/$fileがみつかりません。<br>\n";
			}
			@page = <page>;
			close(page);
			$list[$i]="$file";
			($eid,$epass,$ename,$eurl,$echara,$esex,$ehp,$emaxhp,$emp,$emaxmp,$eele,$estr,$evit,$eint,$emen,$eagi,$ecom,$egold,$e_ex,$ecex,$eunit,$econ,$earm,$epro,$eacc,$esub1,$esub2,$etac,$esta,$epos,$emes,$ehost,$edate,$esyo,$eclass,$etotal,$ekati) = split(/<>/,$page[0]);
			if($edate < $tt){
				$dir2="./charalog/main";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/log";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/blog";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/auto_com";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/memo";
				unlink("$dir2/$eid\.cgi");
				$dir2="./charalog/command";
				unlink("$dir2/$eid\.cgi");

				$i++;
			}
		}
	}
	closedir(dirlist);


	&HOST_NAME;

	&TIME_DATA;

	&MAP_LOG("<font color=red><B>\[削除\]</B></font> ３４日以降ログインのない方を削除しました。");

	&HEADER;
	print <<"EOM";
<center><h2><font color=red>３４日以降ログインのない方(<font color=red>$i名</font>)を削除しました。</font></h2><hr size=0>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
<br></form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/  WRITE画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub BBS {

	&TIME_DATA;
	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	open(IN,"$ADMIN_BBS");
	@AD_DATA = <IN>;
	close(IN);

	if($in{'message'} eq "") { &ERR2("メッセージが記入されていません。"); }

	$bbs_num = @AD_DATA;
	if($bbs_num > 40) { pop(@AD_DATA); }

	unshift(@AD_DATA,"<font color=red>$in{'message'}</font> $in{'name'}より($mday日$hour時$min分)<BR><hr size=0>\n");

	open(OUT,">$ADMIN_BBS");
	print OUT @AD_DATA;
	close(OUT);

	&HEADER;
	print <<"EOM";
<h2>書き込みました。</h2>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
</select><input type=submit id=input value='戻る'>
<br></form>
EOM
	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/#
#_/   編集画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub CHANGE {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	$dir="./charalog/main";
	if(!open(page,"$dir/$in{'fileno'}")){
		$datames .= "$dir/$fileがみつかりません。<br>\n";
		return 1;
	}
	@page = <page>;
	close(page);
	
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5,$espbuy,$eskldata,$eskldata2,$esub6,$esub7,$esub8) = split(/<>/,$page[0]);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime($edate);
	$year += 1900;
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$daytime = sprintf("%4d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);
	
	&HEADER;
	print <<"EOM";
<form method="post" action="admin.cgi">
<h3><img src="$IMG/$echara.gif" width="$img_wid" height="$img_height" border=0> <font size=5 color=orange>$ename</font> ファイル</h3>
<table>
<tr>
<th>ID</th><td><input type=text name=eid value='$eid'></td>
<th>PASS</th><td><input type=text name=epass value='$epass'></td>
<th>NAME</th><td><input type=text name=ename value='$ename'></td>
<th>画像ID</th><td><input type=text name=echara value='$echara'></td>
<tr>
<th>武力</th><td><input type=text name=estr value='$estr'></td>
<th>知力</th><td><input type=text name=eint value='$eint'></td>
<th>統率力</th><td><input type=text name=elea value='$elea'></td>
<th>人望</th><td><input type=text name=echa value='$echa'></td>
</TR>
<tr>
<th>兵士数</th><td><input type=text name=esol value='$esol'></td>
<th>訓練</th><td><input type=text name=egat value='$egat'></td>
<th>国</th><td><input type=text name=econ value='$econ'></td>
<th>金</th><td><input type=text name=egold value='$egold'></td>
</TR>
<tr>
<th>米</th><td><input type=text name=erice value='$erice'></td>
<th>貢献</th><td><input type=text name=ecex value='$ecex'></td>
<th>階級値</th><td><input type=text name=eclass value='$eclass'></td>
<th>武器</th><td><input type=text name=earm value='$earm'></td>
</TR>
<tr>
<th>書籍</th><td><input type=text name=ebook value='$ebook'></td>
<th>忠誠</th><td><input type=text name=ebank value='$ebank'></td>
<th>経験値</th><td><input type=text name=esub1 value='$esub1'></td>
<th>削除ターン</th><td><input type=text name=esub2 value='$esub2'></td>
</TR>
<tr>
<th>現在位置</th><td><input type=text name=epos value='$epos'></td>
<th>防具</th><td><input type=text name=emes value='$emes'></td>
<th>ホスト</th><td><input type=text name=ehost value='$ehost'></td>
<th>更新日時</th><td><input type=text name=edate value='$edate'></td>
</TR>
<tr>
<th>MAIL</th><td><input type=text name=email value='$email'></td>
<th>行動チェック</th><td><input type=text name=eos value='$eos'></td>
<th>戦勝メッセージ</th><td><input type=text name=ecm value='$ecm'></td>
<th>スキル</th><td><input type=text name=est value='$est'></td>
</TR>
<tr>
<th>設定</th><td><input type=text name=esz value='$esz'></td>
<th>SP</th><td><input type=text name=esg value='$esg'></td>
<th>防具、書物スキル</th><td><input type=text name=eyumi value='$eyumi'></td>
<th>登録後IP</th><td><input type=text name=eiba value='$eiba'></td>
</tr>
<tr>
<th>武器スキル</th><td><input type=text name=ehohei value='$ehohei'></td>
<th>BM関係</th><td><input type=text name=esenj value='$esenj'></td>
<th>迷路入った回数</th><td><input type=text name=esm value='$esm'></td>
<th>防具名前</th><td><input type=text name=ebname value='$ebname'></td>
</tr>
<tr>
<th>武器名前</th><td><input type=text name=eaname value='$eaname'></td>
<th>書物名前</th><td><input type=text name=esname value='$esname'></td>
<th>武器属性</th><td><input type=text name=eazoku value='$eazoku'></td>
<th>武器相性</th><td><input type=text name=eaai value='$eaai'></td>
</tr>
<tr>
<th>戦績</th><td><input type=text name=esub3 value='$esub3'></td>
<th>特殊技能</th><td><input type=text name=esub4 value='$esub4'></td>
<th>武器２</th><td><input type=text name=esub5 value='$esub5'></td>
<th>SP購入回数</th><td><input type=text name=espbuy value='$espbuy'></td>
</tr>
<tr>
<th>スキル用</th><td><input type=text name=eskldata value='$eskldata'></td>
<th>スキル用</th><td><input type=text name=eskldata2 value='$eskldata2'></td>
<th>サブ6</th><td><input type=text name=esub6 value='$esub6'></td>
<th>サブ7</th><td><input type=text name=esub7 value='$esub7'></td>
</tr>
<tr>
<th>サブ8</th><td><input type=text name=esub8 value='$esub8'></td>
</tr>

</table>
<br>
<input type=hidden name=mode value=CHANGE2>
<input type=hidden name=fileno value=$in{'fileno'}>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='編集'>
<br></form>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='編集を止める'>
</form>
<br>
<br>
<br>
<br>
MAPログあり<br>
<form method="post" action="admin.cgi">
<input type=hidden name=filename value=$in{'fileno'}>
<input type=hidden name=mode value=DEL>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='このファイルを削除'>
</form>
<br>
<br>
<br>
MAPログなし<br>
<form method="post" action="admin.cgi">
<input type=hidden name=filename value=$in{'fileno'}>
<input type=hidden name=mode value=DEL2>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='このファイルを削除'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/   編集画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub CHANGE2 {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	$dir="./charalog/main";
	
	$newdata = "$in{'eid'}<>$in{'epass'}<>$in{'ename'}<>$in{'echara'}<>$in{'estr'}<>$in{'eint'}<>$in{'elea'}<>$in{'echa'}<>$in{'esol'}<>$in{'egat'}<>$in{'econ'}<>$in{'egold'}<>$in{'erice'}<>$in{'ecex'}<>$in{'eclass'}<>$in{'earm'}<>$in{'ebook'}<>$in{'ebank'}<>$in{'esub1'}<>$in{'esub2'}<>$in{'epos'}<>$in{'emes'}<>$in{'ehost'}<>$in{'edate'}<>$in{'email'}<>$in{'eos'}<>$in{'ecm'}<>$in{'est'}<>$in{'esz'}<>$in{'esg'}<>$in{'eyumi'}<>$in{'eiba'}<>$in{'ehohei'}<>$in{'esenj'}<>$in{'esm'}<>$in{'ebname'}<>$in{'eaname'}<>$in{'esname'}<>$in{'eazoku'}<>$in{'eaai'}<>$in{'esub3'}<>$in{'esub4'}<>$in{'esub5'}<>$in{'espbuy'}<>$in{'eskldata'}<>$in{'eskldata2'}<>$in{'esub6'}<>$in{'esub7'}<>$in{'esub8'}<>\n";

	open(page,">$dir/$in{'fileno'}");
	print page $newdata;
	close(page);
	&HOST_NAME;
		
	&ADMIN_LOG("<font color=blue>$in{'ename'} $dir/$in{'fileno'}を更新しました。「$host」</font>");
	&HEADER;
	print <<"EOM";
<center><h2><font color=blue>$in{'ename'} のファイル$dir/$in{'fileno'}を更新しました。</font></h2><hr size=0>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
EOM

	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/#
#_/ ファイル削除 _/#
#_/_/_/_/_/_/_/_/_/#

sub DEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	&HOST_NAME;
	open(IN,"./charalog/main/$in{'filename'}") or &ERR2('ファイルを削除できませんでした。');
	@CN_DATA = <IN>;
	close(IN);
	($kid,$kpass,$kname) = split(/<>/,$CN_DATA[0]);

	$dir2="./charalog/main";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/log";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/command";
	unlink("$dir2/$in{'filename'}");

	&ADMIN_LOG("<font color=red>$knameを削除しました。「$host」 </font>");

	&MAP_LOG("<font color=red><B>\[削除\]</B></font> $knameは削除されました。");

	&SYSTEM_LOG("<font color=red><B>\[削除\]</B></font> $knameは削除されました。");

	&HEADER;
	print <<"EOM";
<center><h2><font color=red>$knameを削除しました。</font></h2><hr size=0>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
<br></form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/ ファイル削除 _/#
#_/_/_/_/_/_/_/_/_/#

sub DEL2 {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
&HOST_NAME;
	open(IN,"./charalog/main/$in{'filename'}") or &ERR2('ファイルを削除できませんでした。');
	@CN_DATA = <IN>;
	close(IN);
	($kid,$kpass,$kname) = split(/<>/,$CN_DATA[0]);

	$dir2="./charalog/main";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/log";
	unlink("$dir2/$in{'filename'}");
	$dir2="./charalog/command";
	unlink("$dir2/$in{'filename'}");
	&ADMIN_LOG("<font color=red>$knameを削除しました。「$host」 </font>");

	open(IN,"$DEF_LIST");
	@DEF_LIST = <IN>;
	close(IN);

	@NEW_DEF_LIST_DEL=();
	foreach(@DEF_LIST){
		($tid,$tname,$ttown_id,$ttown_flg,$tcon) = split(/<>/);
		if("$tid" eq "$kid"){
		}else{
			push(@NEW_DEF_LIST_DEL,"$_");
		}
	}
	open(OUT,">$DEF_LIST");
	print OUT @NEW_DEF_LIST_DEL;
	close(OUT);

	&HEADER;
	print <<"EOM";
<center><h2><font color=red>$knameを削除しました。</font></h2><hr size=0>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
<br></form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/ 管理者ログ   _/#
#_/_/_/_/_/_/_/_/_/#

sub ADMIN_LOG {

	open(IN,"$ADMIN_LIST");
	@A_LOG = <IN>;
	close(IN);
	&TIME_DATA;

	unshift(@A_LOG,"$_[0]($mday日$hour時$min分)<BR>\n");
	splice(@A_LOG,20);

	open(OUT,">$ADMIN_LIST") or &ERR2('LOG 新しいデータを書き込めません。');
	print OUT @A_LOG;
	close(OUT);

}

#_/_/_/_/_/_/_/_/_/#
#_/ 初期化確認  _/#
#_/_/_/_/_/_/_/_/_/#

sub INIT_DATA_ABMIT {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	
	&HEADER;
	print <<"EOM";
<h2><font color=red>本当に初期化しますか？</h2></font>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=mode value=INIT_DATA>
<input type="text" size="15" name="start_time">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='初期化する'>
</form>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/#
#_/   初期化     _/#
#_/_/_/_/_/_/_/_/_/#

sub INIT_DATA {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	require "reset.cgi";
	RESET_MODE( $in{start_time} );
	&HOST_NAME;

	&ADMIN_LOG("全データを初期化しました。[$host]");
	
	&HEADER;
	print <<"EOM";
<h2><font color=red>全データを初期化しました。</h2></font>
<br>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#_/  バックアップ _/#
#_/_/_/_/_/_/_/_/_/#

sub BACK_UP {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	&HEADER;

	print <<"EOM";
<h2>バックアップ</h2>

<br>バックアップをとりました。
<br>成功している場合は実行結果がでて、失敗した場合はエラーメッセージが出ます。
<br><br>

EOM

	system("zip -r ./backup.zip .");
	print "done\n";

	print <<"EOM";
<br><br>
・バックアップが成功していたら<a href="./backup.zip">こちら</a>からDLして下さい。<br><br>
・作成したバックアップファイルはURLがわかったら誰でもDLできてしまいます。<br>
なので、DLが完了したら念のため下のボタンをクリックして削除して下さい。<br>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value="BACK_UP_DEL">
<input type=submit id=input value='削除'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  バックアップファイル削除 _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub BACK_UP_DEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	&HEADER;

	print <<"EOM";
<h2>バックアップファイル削除</h2>

<br>バックアップファイルを削除します。
<br>失敗した場合はエラーメッセージが出ます。
<br><br>

EOM

	if(unlink './backup.zip'){
        	print "<font color=blue>バックアップファイルを削除しました。</font>.\n";
	}else{
        	print "<center>ERROR!<br><font color=red>削除に失敗しました。</font></center>.\n";
	}

	print <<"EOM";
<br><br>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  雑談用BBS管理          _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ZATUBBS {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	&HEADER;

	print <<"EOM";
<h2><font color=blue>BBS管理モード</font></h2><br><br>・ログ全消去
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value="ZATUBBS_ALLDEL">
<input type=submit id=input value='削除'>
</form>
<br>・１つのメッセージだけ削除
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value="ZATUBBS_BDEL">
NO:<input type=text name=log size=10>
<input type=submit id=input value=\"実行\">
</form>
<hr>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>

EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  雑談用BBS全削除          _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ZATUBBS_ALLDEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	open(OUT,">$ZATU_BBS_DATA");
	print OUT @F_T_DATA;
	close(OUT);

	&HEADER;

	print <<"EOM";
<center><br>
<h3>全データ消去しました。</h3><br>
<form method="post" action="admin.cgi">
<input type=hidden name=mode value=ZATUBBS>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
EOM

	&FOOTER;
	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  雑談用BBS部分削除       _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ZATUBBS_BDEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	if($in{'log'} eq "") { &ERR2("消去するメッセージが選ばれていません。"); }
	if($in{'log'} =~ m/[^0-9]/) { &ERR2("フォームに数字以外の文字が含まれています。"); }

	open(IN,"$ZATU_BBS_DATA") or &ERR2('BBSファイルを開けませんでした。');
	@BBS_DATA = <IN>;
	close(IN);

	$zc = 0;

	foreach(@BBS_DATA){
		($lbno,$lbname,$lbgazou,$lbcolor,$lbmes,$lbtime,$lbsub1,$lbsub2,$lbsub3,$lbsub4,$lbsub5,$lbsub6)=split(/<>/);
		if($lbno eq "$in{'log'}"){
		$jkh = $zc;
		}
	$zc++;
	}

	splice(@BBS_DATA,$jkh,1);

	open(OUT,">$ZATU_BBS_DATA") or &ERR2('BBSファイルを開けませんでした。');
	print OUT @BBS_DATA;
	close(OUT);

	&HEADER;

	print <<"EOM";
<center><br>
<h3>削除しました。</h3><br>
<form method="post" action="admin.cgi">
<input type=hidden name=mode value=ZATUBBS>
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
</center>

EOM

	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  画像アップローダ管理     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ICON {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	&HEADER;

	print <<"EOM";
<h2><font color=blue>画像アップローダ管理モード</font></h2><br><br>
・アイコン一覧<br>
<form method="post" action="aicon.cgi" target="_blank">
<input type=submit id=input value="見る">
</form>
<br>
・アイコン画像を削除<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value="ICON_DEL">
削除したい画像の番号:<input type=text name=num size=10>
<input type=submit id=input value=\"実行\">
</form>
<hr>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>

EOM

	&FOOTER;
	exit;
}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  アイコン画像削除        _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ICON_DEL {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){ &ERR2("ＩＤ、パスワードエラー $num ");}
	if($in{'num'} eq "") { &ERR2("消去する画像が選ばれていません。"); }
	if($in{'num'} =~ m/[^0-9]/) { &ERR2("フォームに数字以外の文字が含まれています。"); }

	$icon = "image/$in{'num'}.gif";

	&HEADER;

	print <<"EOM";
<h2>アイコン画像削除</h2>

<br>アイコン画像を削除します。
<br>失敗した場合はエラーメッセージが出ます。
<br><br>

EOM

	if(unlink ("$icon")){
        	print "<font color=blue>アイコン画像を削除しました。</font>.\n";
	}else{
        	print "<center>ERROR!<br><font color=red>削除に失敗しました。</font></center>.\n";
	}

	print <<"EOM";
<br><br>
<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>
<br>
EOM

	&FOOTER;
	exit;
}



#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  管理人からの知らせ     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub OSIRASE {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}

	&HEADER;

	print <<"EOM";
<h2><font color=blue>お知らせを出す</font></h2><br><br>
・管理人からお知らせをMAPLOGに出します<br>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=hidden name=mode value="OSIRASE2">
<input type=text name=mes size=30>
<input type=submit id=input value=\"実行\">
</form>

<hr>
・ゲームのお知らせを出します<br>
<form method="post" action="admin.cgi">
  <input type="hidden" name="id" value="$in{id}">
  <input type="hidden" name="pass" value="$in{pass}">
  <input type="hidden" name="mode" value="announce">
  <textarea name="message" rows="8" cols="80"></textarea>
  <input type="submit" value="実行">
</form>

<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>

EOM

	&FOOTER;
	exit;
}



#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/  管理人からの知らせ2     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub OSIRASE2 {

	if($in{'id'} ne "$adminid" || $in{'pass'} ne "$adminpass"){
	&ERR2("ＩＤ、パスワードエラー $num ");}
	if($in{"mes"} eq "死ね" || $in{"mes"} eq ""){&ERR2("お知らせが入力されてないみたいです。");}
	elsif(length($in{'mes'}) > 240) { &ERR2("お知らせは80文字以内にして下さい"); }

	&MAP_LOG("<font color=black>[管理人からのお知らせ]</font>$in{'mes'}（管理人より）");

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>お知らせを出しました。</h2><p>
<form method="post" action="admin.cgi">
<input type=hidden name=id value="$in{id}">
<input type=hidden name=pass value="$in{pass}">
<input type=submit id=input value='戻る'>
</form>

EOM

	&FOOTER;
	exit;
}

# ゲームのお知らせ

sub announce {

  ERR2("ID, もしくはパスワードが間違っています") if $in{id} ne $adminid || $in{pass} ne $adminpass;
  ERR2("お知らせの内容が入力されていません") if $in{message} eq '';

  require Jikkoku::Model::Announce;
  my $announce_model = Jikkoku::Model::Announce->new;
  $announce_model->add_by_message( $in{message} );
  $announce_model->save;

	&HEADER;

	print <<"EOM";
<center>
<hr size=0>
<h2>お知らせを出しました。</h2>
<form method="post" action="admin.cgi">
  <input type=hidden name=id value="$in{id}">
  <input type=hidden name=pass value="$in{pass}">
  <input type=submit id=input value='戻る'>
</form>
</center>
EOM

	&FOOTER;
}

1;
