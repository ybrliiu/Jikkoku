#_/_/_/_/_/_/_/_/#
#      調査      #
#_/_/_/_/_/_/_/_/#

sub TYOUSA {

	if($in{'no'} eq ""){&ERR("NO:が入力されていません。");}
	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN($kcon);
	&TIME_DATA;

	&HEADER;
	$no = $in{'no'} + 1;

	foreach(@no){
		$no_list .= "<input type=hidden name=no value=$_>"
	}

	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 調 査 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>指定した武将を調査します。<BR>どれくらい詳しく調査できるかは、知力に依存しています．<BR>金500必要です。<BR></font>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>
<form action="$COMMAND" method="post">
$no_list
<br>
<select name=tid>
<option value="">調査する武将をを選択
EOM

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);

	@tmp = map {(split /<>/)[10]} @CL_DATA;
	@CL_DATA = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	foreach(@CL_DATA) {
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos) = split(/<>/);
		if($eid eq $kid) { next; }
		if($cou_name[$econ] eq ""){
			$con[0] .= "<option value=$eid>$ename\n";
		}else{
			$con[$econ] .= "<option value=$eid>$ename\n";
		}
	}

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_NO = <IN>;
	close(IN);
	
	foreach(@COU_NO){
		($xxcid,$xxname,$xxele,$xxnum,$xxins,$xxind,$xxall,$xxgold,$xxhp,$xxmaxhp,$xxstr,$xxvit,$xxagi,$xxat)=split(/<>/);
		print "<option>==== $xxname ====\n";
		print "$con[$xxcid]";
	}
	$c_num = @COU_DATA;
print <<"EOM";
<option>==== 無所属国 ====\n
$con[0]
</select>
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=kensaku value=0>
<input type=hidden name=mode value=63>
<input type=submit value="決定"><br>
</form>
<hr size="0">
<blockquote>
<table border="0" cellspacing="0" cellpadding="26" width="400">
<tr><td align="center">
<fieldset>
<form action="$COMMAND" method="post">
$no_list
<legend>名前を入力：</legend>
<input type=text name=tid size=10>
<input type=hidden name=id value=$kid>
<input type=hidden name=kensaku value=1>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=63>
<input type=submit value="決定">
</form></fieldset></td></tr></table></blockquote>
<hr size="0">
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;