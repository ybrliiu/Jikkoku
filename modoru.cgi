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
if($ENV{'HTTP_REFERER'} !~ /i/ && $MEIRO){ &ERR2("不正なアクセスです。");}
&DECODE;
&TOP;

#_/_/_/_/_/_/_/_/_/#
#_/    TOP画面   _/#
#_/_/_/_/_/_/_/_/_/#

sub TOP {

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&COUNTRY_DATA_OPEN($kcon);
	&TIME_DATA;

	open(IN,"$ARM_LIST");
	@ARM_DATA = <IN>;
	close(IN);
	
	if($kazoku eq "機"){$zokG = ($kaai/4.5);}else{$zokG = ($kaai/3);}
	$armval = int(($karm+$zokG) * 2333);


	&HEADER;

	print <<"EOM";
<TABLE bgcolor=#000000 width=100% height=100%><TR><TD align=center>
<TABLE bgcolor=#000000 width=100%>
<TR><TH bgcolor=414141>
<font color=red> -武 器 闇 市 場 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]国</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#000000 border="2"><TR><TD bgcolor=#414141>
<font color="white">へいらっしゃい！<BR>ここでは普通の武器屋ではお目にかかれない珍しい武器を売ってるぜ。<BR>現在$knameが装備している<font color="blue">$kaname</font>は金<font color=red>$armval</font>で下取るぜ。<BR>是非手にとって見てくれ！<BR>
※武器についての詳細は<a href="./manual.html#soubi" target="_blank">ここ</a>をみてください。<br>
</font>
</TD></TR></TABLE>
</TD></TR>

<TR><TD>
<form action="$COMMAND" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$TABLE_C>
EOM

	open(IN,"$ARM_LIST") or &ERR('ファイルを開けませんでした。');
	@ARM_DATA = <IN>;
	close(IN);

	$list = "<TR><TD bgcolor=$TD_C1>選択</TD><TD bgcolor=$TD_C2>名称</TD><TD align=right bgcolor=$TD_C3>値段</TD><TD bgcolor=$TD_C2 align=center>威力</TD><TD bgcolor=$TD_C10 align=center>属性</TD><TD bgcolor=$TD_C10 align=center>相性</TD><TD align=right bgcolor=$TD_C2>必要技術</TD><TD align=right bgcolor=$TD_C2>必要階級</TD></TR>";
	$s_i=0;
	foreach(@ARM_DATA){
		($armname,$armval,$armdmg,$armwei,$armele,$armsta,$armclass,$armtownid) = split(/<>/);
		if(($armtownid eq 20)&&($zsub1 >= $armsta)){
			if($kvsub2 eq 0){$armval = int($armval / 10);}
			$armkaikyu = $armsta*5;
			if($armkaikyu > 25000){$armkaikyu = 25000;}
	
			$list .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=$s_i></TD><TD bgcolor=$TD_C2>$armname</TD><TD align=right bgcolor=$TD_C3>金 $armval</TD><TD bgcolor=$TD_C2 align=center>$armdmg</TD><TD bgcolor=$TD_C10 align=center>$armwei</TD><TD bgcolor=$TD_C10 align=center>+$armele</TD><TD align=right bgcolor=$TD_C2>$armsta</TD><TD align=right bgcolor=$TD_C2>$armkaikyu</TD></TR>";
		}
		$s_i++;
	}


print <<"EOM";
$list
</TABLE><BR>
No:<select name=no size=6 MULTIPLE>
<option value="all">ALL
EOM
	for($i=0;$i<$MAX_COM;$i++){
		$no = $i+1;
		if($i eq "0"){
			print "<option value=\"$i\" SELECTED>$no";
		}else{
			print "<option value=\"$i\">$no";
		}
	}

print <<"EOM";
</select>

<input type=hidden name=mode value=22>
<input type=submit id=input value=\"購入\"></form>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;


}
