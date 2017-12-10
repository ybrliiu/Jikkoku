#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################


require './ini_file/index.ini';
require 'suport.pl';

if($MENTE) { &ERR("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
&TOP;

#_/_/_/_/_/_/_/_/_/#
#_/    TOP画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub TOP {

	&CHARA_MAIN_OPEN;
	open(IN,"./charalog/log/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);
	&TOWN_DATA_OPEN($kpos);
	&COUNTRY_DATA_OPEN($kcon);

	$p=0;
	foreach(@LOG_DATA){
		$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;
	}

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

	$list = "<TR><TD></TD><TH>名前</TH><TH>武力</TH><TH>知力</TH><TH>統率力</TH><TH>人望</TH><TH>兵士数</TH><TH>国名</TH><TH>コマンド</TH></TR>";
	$num=0;
	foreach(@CL_DATA){
		($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);
		if($epos eq $kpos){
			$num++;
			$com_list = "";
			if($kcon eq $econ){
				open(IN,"./charalog/command/$eid.cgi");
				@COM_DATA = <IN>;
				close(IN);
				for($i=0;$i<$MAX_COM;$i++){
					($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$COM_DATA[$i]);
					$no = $i+1;
					if($cid eq ""){
					$com_list .= "$no: - <BR>";
					}else{
					$com_list .= "$no:$cname<BR>";
					}
					if($i>=4){last;}
				}
			}
			if($num < 100){
			$balllist .= "\$(\".$eid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style='background-color:rgba($ELE_RGBA[$cou_ele[$econ]]0.7);'><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$eid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";
			$busylink ="<span class=\"$eid\">$ename</span>";
			$list .= "<TR><TD><img src=$IMG/$echara.gif width=64 height=64></TD><TD>$busylink</TD><TD>$estr</TD><TD>$eint</TD><TD>$elea</TD><TD>$echa</TD><TD>$esol</TD><TD>$cou_name[$econ]</TD><TD>$com_list</TD></TR>";
			}
		}
	}

	$b_js = 1;
	&HEADER;
	print <<"EOM";

<script type="text/javascript"><!--
var num = 0;

\$(document).ready(function(){

$balllist

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

});
--></script>

<TABLE WIDTH="100%" height=100% cellpadding="0" cellspacing="0" border=0><tr><td align=center>
<B>$zname滞在者（$num人）</b>：
<TABLE border=0 cellspacing=1 bgcolor=$TABLE_C class="kaku">
    <TBODY bgcolor=FFFFFF>
$list
</TBODY></TABLE>
<center>
<BR>
<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"戻る\">
</form>
</TD></TR>
</TBODY></TABLE>

EOM

	&FOOTER;
	exit;

}
