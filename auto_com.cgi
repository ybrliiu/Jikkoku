#!/usr/bin/perl

#BMコマンド入力

use lib './lib', './extlib';

require './ini_file/index.ini';
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
&SERVER_STOP;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }

if($mode eq '0') { require 'auto_com/nyuryoku.pl';&NYURYOKU; }
elsif($mode eq '1') { require 'auto_com/move.pl';&MOVE; }
elsif($mode eq '2')  { require 'auto_com/move.pl';&MOVE; }
elsif($mode eq '3')  { require 'auto_com/move.pl';&MOVE; }
elsif($mode eq '4')  { require 'auto_com/move.pl';&MOVE; }
elsif($mode eq '5')  { require 'auto_com/nyuryoku.pl';&NYURYOKU; }
elsif($mode eq '6')  { require 'auto_com/nyuryoku.pl';&NYURYOKU; }
elsif($mode eq '7')  { require 'auto_com/nyuryoku.pl';&NYURYOKU; }
elsif($mode eq '8')  { require 'auto_com/auto_move.pl';&AUTO_MOVE; }
elsif($mode eq '9')  { require 'auto_com/auto_move2.pl';&AUTO_MOVE2; }
elsif($mode eq '10')  { require 'auto_com/auto_move3.pl';&AUTO_MOVE3; }
elsif($mode eq '11')  { require 'auto_com/automove_road.pl';&MAIN; }
elsif($mode eq '12')  { require 'auto_com/auto_com_save.pl';&SAVE; }
elsif($mode eq '13')  { require 'auto_com/auto_com_save.pl';&LOOK; }
elsif($mode eq '14')  { require 'auto_com/auto_com_save.pl';&LOAD; }
elsif($mode eq '15')  { require 'auto_com/auto_com_save.pl';&NAME; }
elsif ($mode eq 'delete') { require 'auto_com/delete.pl'; auto_com_delete(); }
elsif ($mode eq 'insert') { require 'auto_com/insert.pl'; auto_com_insert(); }
else { &ERR("不正なアクセスです。"); }
