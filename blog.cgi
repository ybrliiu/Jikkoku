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
	open(IN,"./charalog/blog/$kid.cgi");
	@LOG_DATA = <IN>;
	close(IN);

	$p=0;
	foreach(@LOG_DATA){
		$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;
	}

	$ihihi = int(rand(9));
	if($ihihi eq "1"){
	$ahaha = "<form action=\"./modoru.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=image src=image/img/3578.png></form>";
	}

	$zukei = 1;
	&HEADER;
	print <<"EOM";


<div id="zukei">
<form action="./blog.cgi" method="post"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<button id="botan" type="submit"><div id="reload"></div></button>
<a href="#top"><div id="botan"><div id="up_arrow"></div></div></a>
<a href="#sita"><div id="botan"><div id="down_arrow"></div></div></a>
</form>
</div>


<CENTER><BR>
<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"戻る\">
</form>


- 戦闘ログ(600件) -
<BR>
<BR>
<TABLE border=0 cellspacing=1>
<TBODY><TR><TD>
$log_list
</TD></TR>
</TBODY></TABLE><BR>
$ahaha
<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"戻る\">
</form>

</TD></TR>
</TBODY></TABLE>

EOM

	&FOOTER;
	exit;

}
