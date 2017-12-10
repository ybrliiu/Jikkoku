#自動移動 ルート表示#

sub MAIN{

&TIME_DATA;
&CHARA_MAIN_OPEN;
($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);
&COUNTRY_DATA_OPEN("$kcon");
&TOWN_DATA_OPEN();

if($kiti eq ""){$kiti = 0;}
if($in{'no'} eq ""){$in{'no'} = "$kiti";}


#ルートファイルが読み込めるか判断
$r_hit=0;
$dir="./log_file/map_road";
$target = "$in{'start'}\-$in{'target'}";
opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		$file =~ s/.pl//g;
		if($file eq $target){
		$r_hit=1;
		last;
		}
	}
closedir(dirlist);

local @ROOT=();
if($r_hit){
require "./log_file/map_road/$target.pl";
}

$target2 = "出発都市:$town_name[$in{'start'}]、移動先の都市:$town_name[$in{'target'}]";

&HEADER;

#マップ
require "./log_file/map_hash/$in{'no'}.pl";

#BM地名
require "./ini_file/bmmaplist.ini";

$bmcolspan = $BM_X + 1;

print <<"BOM";

<div style="width:100%;padding:5px;box-sizing:border-box;"><div style="width:100%;background-color:#414141;color:#FFFFFF;text-align:center;padding:2px;box-sizing:border-box;"><strong>- 自動移動のルート -</strong></div></div>

<div style="width:100%;padding:0 5px 5px 5px;box-sizing:border-box;"><div style="width:100%;background-color:#000000;color:#FFFFFF;padding:2px;box-sizing:border-box;">
BMで自動移動する際に通るルートを表示します。<br>
出発する都市、移動先の都市、表示する場所のマップを選択して表示してください。<br>
※ルートは毒をできるだけ避けて通る、最短距離です。<br>
</div></div>

BOM

print "<font color\=AA8866><B>\- $battkemapname\マップ \- (ルート:$target2)</B></font><TABLE bgcolor\=$bg_c width\=100\% height\=5 border\=\"0\" cellspacing\=1 class=\"swindow\"><TBODY><TR><TH colspan\= $bmcolspan bgcolor\=442200 class=\"inwindow\"><font color=FFFFFF>$new_date</TH></TR><TR><TD width\=20 bgcolor\=$TD_C2>\-</TD>";

for($i=1;$i<$BM_X+1;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<$BM_Y;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3>$n</td>";
		for($j=0;$j<$BM_X;$j++){

						$mess = "";
						if($ROOT[$i][$j]->{"$in{'no'}"} ne ""){
						$mess = " style=\"border: solid 5px #eeeeee\";";
						}
						

						if($BM_TIKEI[$i][$j] == 17){
						($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
						print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"40\" height=\"40\"$mess><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]$ikisaki2</font></TH>";
						}elsif($BM_TIKEI[$i][$j] == 16){
						($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
						print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"40\" height=\"40\"$mess><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]$ikisaki2</font></TH>";
						}elsif($BM_TIKEI[$i][$j] eq ""){
						print "<TH bgcolor=$BMCOL[0] width=\"40\" height=\"40\"$mess>&nbsp;</TH>";
						}else{
						print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"40\" height=\"40\"$mess><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]</font></TH>";
						}

		}
		print "</TR>";
	}

	print "</TBODY></TABLE>";


#AUTOMODE ON,OFF
print <<"EOM";

<form action="./auto_com.cgi" method="post">
<input type=hidden name=id value=$kid>

<select name="start">
EOM
	foreach my $key (sort keys(%TIKEI)) {
	    if($TIKEI{$key} !~ /-/){
	    $TIKEI{$key} =~ s/の城付近//g;
		if($in{'start'} eq "$key"){
	        print "<option value=\"$key\" SELECTED>出発都市:$TIKEI{$key}";
		}else{
	        print "<option value=\"$key\">出発都市:$TIKEI{$key}";
		}
	    }
	}
print <<"EOM";
</select>

<select name="target">
EOM
	foreach my $key (sort keys(%TIKEI)) {
	    if($TIKEI{$key} !~ /-/){
	    $TIKEI{$key} =~ s/の城付近//g;
		if($in{'target'} eq "$key"){
	        print "<option value=\"$key\" SELECTED>移動先の都市:$TIKEI{$key}";
		}else{
	        print "<option value=\"$key\">移動先の都市:$TIKEI{$key}";
		}
	    }
	}
print <<"EOM";
</select>

<select name=no>
EOM
	foreach $key (sort keys(%TIKEI)) {
	    if($in{'no'} eq "$key"){
	    print "<option value=\"$key\" SELECTED>表示マップ:$TIKEI{$key}";
	    }else{
	    print "<option value=\"$key\">表示マップ:$TIKEI{$key}";
	    }
	}
print <<"EOM";
</select>

<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=11>
<input type=submit value="表示">
</form>

<br>
<center>
<input type="button" value="閉じる" onClick="window.close();">
</center>


EOM

&FOOTER;

exit;

}

1;
