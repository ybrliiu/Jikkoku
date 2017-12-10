#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################


require './ini_file/index.ini';
require './ini_file/i-index.ini';
require 'i-suport.pl';

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
	$p=0;
	while($p<=100){$log_list .= "<font color=navy>●</font>$LOG_DATA[$p]<BR>";$p++;}

	&HEADER;
	print <<"EOM";
[過去ログ](100件)<br>
<br>
$log_list
<form action=\"i-status.cgi\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit value=\"街へ戻る\"></form>
EOM

	&FOOTER;
	exit;

}

