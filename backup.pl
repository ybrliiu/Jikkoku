#バックアップ#

sub BACKUP {

require './ini_file/index.ini';
require 'suport.pl';

use File::Copy 'copy';


#武将データメインバックアップ#
if($hour == 21){
$from = "./charalog/main";
$to   = "./backup-main";

	opendir(dirlist,"$from");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){

			copy("$from/$file", "$to") or &ERR2("Can't copy \"$from/$file\" to \"$to\": $!\n");
		}
	}
	closedir(dirlist);
}elsif($hour == 0){
$from = "./charalog/main";
$to   = "./backup-main2";

	opendir(dirlist,"$from");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){

			copy("$from/$file", "$to") or &ERR2("Can't copy \"$from/$file\" to \"$to\": $!\n");
		}
	}
	closedir(dirlist);
}

#他のバックアップ#
if($hour == 21){
$to   = "./backup";
copy("$UNIT_LIST", "$to") or &ERR2("Can't copy \"$UNIT_LIST\" to \"$to\": $!\n");
copy("$BBS_LIST", "$to") or &ERR2("Can't copy \"$BBS_LIST\" to \"$to\": $!\n");
copy("$MESSAGE_LIST", "$to") or &ERR2("Can't copy \"$MESSAGE_LIST\" to \"$to\": $!\n");
copy("$MAP_LOG_LIST", "$to") or &ERR2("Can't copy \"$MAP_LOG_LIST\" to \"$to\": $!\n");
copy("$MAP_LOG_LIST2", "$to") or &ERR2("Can't copy \"$MAP_LOG_LIST2\" to \"$to\": $!\n");
copy("$TOWN_LIST", "$to") or &ERR2("Can't copy \"$TOWN_LIST\" to \"$to\": $!\n");
copy("$COUNTRY_LIST", "$to") or &ERR2("Can't copy \"$COUNTRY_LIST\" to \"$to\": $!\n");
copy("$COUNTRY_MES", "$to") or &ERR2("Can't copy \"$COUNTRY_MES\" to \"$to\": $!\n");
}elsif($hour == 0){
$to   = "./backup2";
copy("$UNIT_LIST", "$to") or &ERR2("Can't copy \"$UNIT_LIST\" to \"$to\": $!\n");
copy("$BBS_LIST", "$to") or &ERR2("Can't copy \"$BBS_LIST\" to \"$to\": $!\n");
copy("$MESSAGE_LIST", "$to") or &ERR2("Can't copy \"$MESSAGE_LIST\" to \"$to\": $!\n");
copy("$MAP_LOG_LIST", "$to") or &ERR2("Can't copy \"$MAP_LOG_LIST\" to \"$to\": $!\n");
copy("$MAP_LOG_LIST2", "$to") or &ERR2("Can't copy \"$MAP_LOG_LIST2\" to \"$to\": $!\n");
copy("$TOWN_LIST", "$to") or &ERR2("Can't copy \"$TOWN_LIST\" to \"$to\": $!\n");
copy("$COUNTRY_LIST", "$to") or &ERR2("Can't copy \"$COUNTRY_LIST\" to \"$to\": $!\n");
copy("$COUNTRY_MES", "$to") or &ERR2("Can't copy \"$COUNTRY_MES\" to \"$to\": $!\n");
}

#バックアップ記録#
open(IN, "./log_file/b_con.cgi");
$count = <IN>;
close(IN);
$count = 1;
open(OUT, "> ./log_file/b_con.cgi");
print OUT "$count";
close(OUT);
	&SYSTEM_LOG("<font color=#FFFFFF>\[バックアップ\]</font> バックアップデータを更新しました。");


}

1;
