#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

use lib './lib', './extlib';
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
require './ini_file/index.ini';
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($mode eq 'MES_SEND') { require 'mydata/mes_send.pl';&MES_SEND; }
elsif($mode eq 'COUNTRY_TALK') { require 'mydata/country_talk.pl';&COUNTRY_TALK; }
elsif($mode eq 'COUNTRY_WRITE') { require 'mydata/country_write.pl';&COUNTRY_WRITE; }
elsif($mode eq 'COUNTRY_DEL') { require 'mydata/country_del.pl';&COUNTRY_DEL; }
elsif($mode eq 'LOCAL_RULE') { require 'mydata/local_rule.pl';&LOCAL_RULE; }
elsif($mode eq 'L_RULE_WRITE') { require 'mydata/l_rule_write.pl';&L_RULE_WRITE; }
elsif($mode eq 'L_RULE_DEL') { require 'mydata/l_rule_del.pl';&L_RULE_DEL; }


elsif($mode eq 'COU_CHANGE') { require 'mydata/cou_change.pl';&COU_CHANGE; }
elsif($mode eq 'CYUUSEI') { require 'mydata/cyuusei.pl';&CYUUSEI; }
elsif($mode eq 'GAZOU') { require 'mydata/gazou.pl';&GAZOU; }
elsif($mode eq 'BOUNAME') { require 'mydata/bouname.pl';&BOUNAME; }
elsif($mode eq 'MEE') { require 'mydata/mee.pl';&MEE; }
elsif($mode eq 'MEE2') { require 'mydata/mee2.pl';&MEE2; }
elsif($mode eq 'MEMO') { require 'mydata/memo.pl';&MEMO; }
elsif($mode eq 'SKL_BUY') { require 'mydata/skl_buy.pl';&SKL_BUY; }
elsif($mode eq 'SP_BUY') { require 'mydata/skl_buy.pl';&SP_BUY; }
elsif($mode eq 'SKL_BUY2') { require 'mydata/skl_buy2.pl';&SKL_BUY2; }
elsif($mode eq 'MYSKL') { require 'mydata/myskl.pl';&MYSKL; }
elsif($mode eq 'GISEI_KIRIKAE') { require 'mydata/myskl.pl';&GISEI_KIRIKAE; }
elsif($mode eq 'MYSKL2') { require 'mydata/myskl2.pl';&MYSKL2; }
elsif($mode eq 'JINKEI') { require 'mydata/jinkei.pl';&JINKEI; }
elsif($mode eq 'MYDATA') { require 'mydata/mydata.pl';&MYDATA; }
elsif($mode eq 'LETTER') { require 'mydata/letter.pl';&LETTER; }
elsif($mode eq 'MES_SEND2') { require 'mydata/mes_send2.pl';&MES_SEND2; }
elsif($mode eq 'INDBM') { require 'mydata/indbm.pl';&INDBM; }
elsif($mode eq 'SIZECHANGE') { require 'mydata/sizechange.pl';&SIZECHANGE; }
elsif($mode eq 'ALERT') { require 'mydata/alert.pl';&ALERT; }
elsif($mode eq 'ALERT2') { require 'mydata/alert2.pl';&ALERT2; }
elsif($mode eq 'AAA') {
		if($ENV{'HTTP_REFERER'} !~ /i/ && $MEIRO){ &ERR2("不正なアクセスです。"); 
		}else{ require 'mydata/aaa.pl';&AAA; }
		}
elsif($mode eq 'S_B_H') { require 'mydata/s_b_h.pl';&S_B_H; }
elsif($mode eq 'ZATU_BBS') { require 'mydata/zatu_bbs.pl';&ZATU_BBS; }
elsif($mode eq 'ZATU_BBS_WRITE') { require 'mydata/zatu_bbs_write.pl';&ZATU_BBS_WRITE; }
elsif($mode eq 'MEE2') { require 'mydata/mee2.pl';&MEE2; }
elsif($mode eq 'KING_COM') { require 'mydata/king_com.pl';&KING_COM; }
elsif($mode eq 'KING_COM2') { require 'mydata/king_com2.pl';&KING_COM2; }
elsif($mode eq 'KING_COM3') { require 'mydata/king_com3.pl';&KING_COM3; }
elsif($mode eq 'KING_COM4') { require 'mydata/king_com4.pl';&KING_COM4; }
elsif($mode eq 'KING_COM5') { require 'mydata/king_com5.pl';&KING_COM5; }
elsif($mode eq 'KING_COM6') { require 'mydata/king_com6.pl';&KING_COM6; }
elsif($mode eq 'KING_COM7') { require 'mydata/king_com7.pl';&KING_COM7; }
elsif($mode eq 'KING_COM8') { require 'mydata/king_com8.pl';&KING_COM8; }

elsif($mode eq 'KARI_GUNSHI') { require 'mydata/kari_gunshi.pl';&KARI_GUNSHI; }

elsif($mode eq 'HUKOKU') { require 'mydata/hukoku.pl';&HUKOKU; }
elsif($mode eq 'SENSEN') { require 'mydata/sensen.pl';&SENSEN; }

elsif($mode eq 'UNIT_ENTRY') { require 'mydata/unit_entry.pl';&UNIT_ENTRY; }
elsif($mode eq 'UNIT_SELECT') { require 'mydata/unit_select.pl';&UNIT_SELECT; }
elsif($mode eq 'UNIT_OUT') { require 'mydata/unit_out.pl';&UNIT_OUT; }
elsif($mode eq 'MAKE_UNIT') { require 'mydata/make_unit.pl';&MAKE_UNIT; }
elsif($mode eq 'UNIT_DELETE') { require 'mydata/unit_delete.pl';&UNIT_DELETE; }
elsif($mode eq 'UNIT_CHANGE') { require 'mydata/unit_change.pl';&UNIT_CHANGE; }
elsif($mode eq 'CHANGE_UNIT') { require 'mydata/change_unit.pl';&CHANGE_UNIT; }
elsif($mode eq 'UNIT_POS') { require 'mydata/unit_pos.pl';&UNIT_POS; }
elsif($mode eq 'UNIT_KIKAN') { require 'mydata/unit_kikan.pl';&UNIT_KIKAN; }
elsif($mode eq 'UNIT_AUTO') { require 'mydata/unit_auto.pl';&UNIT_AUTO; }

elsif($mode eq 'MYLOG') { require 'mylog2.cgi';&MYLOG; }
elsif($mode eq 'BLOG') { require 'blog.cgi';&BLOG; }
elsif($mode eq 'AICON') { require 'aicon.cgi';&AICON; }

else{&ERR('正しく選択されていません。');}
