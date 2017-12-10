#!/usr/bin/perl


#BMCOM入力（MAPVIEWER）

use lib './lib', './extlib';
use Jikkoku::Model::Chara::AutoModeList;

require './ini_file/index.ini';
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($mode eq "SETTEI") { &SETTEI; }
else{&MAIN; }


sub MAIN{

&TIME_DATA;
&CHARA_MAIN_OPEN;
($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);
&COUNTRY_DATA_OPEN("$kcon");

if($kiti eq ""){$kiti = 0;}
if($in{'no'} eq ""){$in{'no'} = "$kiti";}

$zukei = 1;
&HEADER;

print <<"EOM";
<script type="text/javascript">
<!--

	function cbo_select(prmStartNo,prmPeriod){
		var intA;
		for(intA = 0;intA < document.all.no.options.length;intA++){
			document.all.no.options[intA].selected = false;
		}
		for(intA = prmStartNo;intA < document.all.no.options.length;intA = intA + prmPeriod){
			document.all.no.options[intA].selected = true;
		}
	}

	function auto_limit(p){
		if(p == 0){
		document.all.opt1.disabled = true;
		document.all.opt2.disabled = true;
		}else if(p == 6){
		document.all.opt1.disabled = false;
		document.all.opt2.disabled = true;
		}else{
		document.all.opt1.disabled = false;
		document.all.opt2.disabled = false;
		}
	}

	function save_limit(no){
		if(no == 12){
		document.auto_save.first.disabled = false;
		document.auto_save.second.disabled = false;
		document.auto_save.name.disabled = false;
		}else if(no == 13){
		document.auto_save.first.disabled = true;
		document.auto_save.second.disabled = true;
		document.auto_save.name.disabled = true;
		}else if(no == 14){
		document.auto_save.first.disabled = false;
		document.auto_save.second.disabled = false;
		document.auto_save.name.disabled = true;
		}else if(no == 15){
		document.auto_save.first.disabled = true;
		document.auto_save.second.disabled = true;
		document.auto_save.name.disabled = false;
		}else{
		document.auto_save.first.disabled = false;
		document.auto_save.second.disabled = false;
		document.auto_save.name.disabled = false;
		}
	}

//-->
</script>


<div id="zukei">
<form action="./auto_in.cgi" method="post">$inline<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<button id="botan" type="submit"><div id="reload"></div></button>
</form>
</div>
EOM


print "<table cellspacing=\"0\" width=\"100%\"><tr><td width=\"50%\" valign=\"top\">";

#マップ
require "./log_file/map_hash/$in{'no'}.pl";

#BM地名
require "./ini_file/bmmaplist.ini";

$bmcolspan = $BM_X + 1;

print "<TABLE bgcolor\=$bg_c width\=100\% height\=5 border\=\"0\" cellspacing\=1 class=\"swindow\"><TBODY><TR><TH colspan\= $bmcolspan bgcolor\=442200 class=\"inwindow\"><span style=\"color:#FFFFFF;\"><B>\- $battkemapname\マップ \-</B></span></TH></TR><TR><TD width\=20 bgcolor\=$TD_C2>\-</TD>";

for($i=1;$i<$BM_X+1;$i++){
		print "<TD width=20 bgcolor=$TD_C1>$i</TD>";
	}
	print "</TR>";
     for($i=0;$i<$BM_Y;$i++){
		$n = $i+1;
		print "<TR><TD bgcolor=$TD_C3>$n</td>";
		for($j=0;$j<$BM_X;$j++){

			if($BM_TIKEI[$i][$j] == 17){
				($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
				print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"40\" height=\"40\"><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]$ikisaki2</font></TH>";
			}elsif($BM_TIKEI[$i][$j] == 16){
				($ikisaki,$ikisaki2,$ikisaki3) = split(/,/,$BM_TIKEI->[$i][$j]{'sekisyo'});
				print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"40\" height=\"40\"><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]$ikisaki2</font></TH>";
			}elsif($BM_TIKEI[$i][$j] eq ""){
				print "<TH bgcolor=$BMCOL[0] width=\"40\" height=\"40\">&nbsp;</TH>";
			}else{
				print "<TH bgcolor=$BMCOL[$BM_TIKEI[$i][$j]] width=\"40\" height=\"40\"><font color=\"white\">$BMNAME[$BM_TIKEI[$i][$j]]</font></TH>";
			}

		}
		print "</TR>";
	}

	print "</TBODY></TABLE>";


#AUTOMODE ON,OFF
print <<"EOM";

<form action="./auto_in.cgi" method="post">
<input type=hidden name=id value=$kid>

<select name=no>
EOM
	foreach $key (sort keys(%TIKEI)) {
	    print "<option value=\"$key\">$TIKEI{$key}";
	}
print <<"EOM";
</select>

<input type=hidden name=pass value=$kpass>
<input type=submit value="バトルマップを表示">
</form>

</td><td width=\"50%\" valign=\"top\">

EOM


#行動予約リスと
	open(IN,"./charalog/auto_com/$kid.cgi");
	@AUTO_COM = <IN>;
	close(IN);

print <<"EOM";

<!-- コマンド入力 -->
<form name="all" action="./auto_com.cgi" method="POST"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE width=100% bgcolor=$ELE_BG[$xele] cellspacing=1 class="swindow"><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH bgcolor=$ELE_BG[$xele] class="inwindow" colspan="4"><font color=$ELE_C[$xele]>BMコマンド入力</font></TH></TR>
<TR><TH colspan="4">$daytime</TH></TR>
<TR><td style="width:100%;text-align:center;" colspan="2">
No:<select name=no size=12 MULTIPLE>
<option value="all">ALL
EOM
	for($i=0;$i<$BMMAX_COM;$i++){
		($cid,$cno,$cname,$ctime,$csub,$cnum,$cend) = split(/<>/,$AUTO_COM[$i]);
		$no = $i+1;

		if($cid eq ""){
		$cname="　-　";
		}

		if($i eq "0"){
			print "<option value=\"$i\" SELECTED>$no　[$cname]";
		}else{
			print "<option value=\"$i\">$no　[$cname]";
		}
	}

print <<"EOM";
</select>
<BR>

No<select name=\"SEL1\">
<option value=\"1\" SELECTED>1
EOM
	for($i=2;$i<=48;$i++){
		print "<option value=\"$i\">$i";
	}
print <<"EOM";
</select>
から<select name=\"SEL2\">
<option value=\"1\" SELECTED>1
EOM
	for($i=2;$i<=24;$i++){
		print "<option value=\"$i\">$i";
	}
print <<"EOM";
</select>
毎に
<input type = "button" id="input" value = "選択" onClick = "cbo_select( 1 + this.form.SEL1.selectedIndex, 1 + this.form.SEL2.selectedIndex)">


</td><td style="width:100%;" colspan="2">


<select name="mode" size="14" onChange="auto_limit(this.value)">
<option value=0>BM自動モード解除
<option value="insert">空白を入れる
<option value="delete">削除
<optgroup label="== 行動 ==">
<option value=8>自動移動（隣接している指定都市まで自動で移動）
<option value=6>戦闘（周囲に敵がいる場合自動で攻撃する）
<optgroup label="== 移動 ==">
<option value=4>上に移動
<option value=3>下に移動
<option value=2>右に移動
<option value=1>左に移動
<option value=5>入城/出城
</select>

</td></tr>

<tr><td colspan="2">
オプション1:コマンド失敗時の設定<br>
(全ての行動系、移動系のコマンドの時有効)<br>
<select size="3" name="opt1">
<option value="0">そのコマンドを消化する
<option value="1" SELECTED>そのコマンドを消化しない
</select>
</td><td colspan="2">
オプション2:移動先や関所の上に敵がいた時の設定<br>
(自動移動コマンド、全ての移動系のコマンドの時有効)<br>
<select size="3" name="opt2">
<option value="0" SELECTED>戦闘する
<option value="1">何もしない
</select>
</td></tr>

<tr><td colspan="4" style="text-align:center;"><input type=submit id=input  value=\"実行\"></form></td></tr>

<tr><td colspan="4">
<font color="red">※使用する前にまずBM自動モードをONにしてください！</font>
<br>※コマンドは最短20秒毎に実行されていきます。
<br>※もちろん行動待機時間、移動Pなどは関係します。
<BR>※Noはctrlキーを押しながらクリックすると複数選択できます。
<BR>※コマンド入力がないところがあると自動的にBM自動モードが解除されます。
<br>
<br>
<a href="./auto_battle_exemple.html">コマンド入力例</a><br>
<br>
</TD></TR>
</td></tr>

<TR><TH bgcolor=$ELE_BG[$xele] colspan="4"><font color=$ELE_C[$xele]>コマンドリスト保存</font></TH></TR>
<tr><form action="./auto_com.cgi" method="POST" name="auto_save">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<td style="width:25%" rowspan="2">
<select name=mode size=4 onChange="save_limit(this.value)">
<option value="12">コマンドリスト保存
<option value="13">保存リストを見る
<option value="14">保存リスト読み込み
<option value="15">名前をつける
</select>
</td><td style="width:25%" rowspan="2">

保存リストの番号を選択:<br>
No<select name="save" size="6">
EOM
	#自分用のディレクトリがなかった時
	if(!opendir(DIR,"./charalog/auto_com_save/$kid")){
	mkdir("./charalog/auto_com_save/$kid");
	}

	open(IN,"./charalog/auto_com_save/$kid/list.cgi");
	@COM_DATA = <IN>;
	close(IN);
	for($i=1;$i<=15;$i++){
		if($COM_DATA[$i-1] ne "" && $COM_DATA[$i-1] ne "\n"){
		print "<option value=\"$i\">$i [ $COM_DATA[$i-1] ]";
		}else{
		print "<option value=\"$i\">$i [ - ]";
		} 
	}
print <<"EOM";
</select>
</td><td style="width:35%">

保存する位置、読み込む位置を選択:<br>
開始位置:<select name=\"first\">
<option value=\"1\" SELECTED>1
EOM
	for($i=2;$i<=$BMMAX_COM;$i++){
		print "<option value=\"$i\">$i";
	}
print <<"EOM";
</select>
終了位置:<select name=\"second\">
<option value=\"1\" SELECTED>1
EOM
	for($i=2;$i<=$BMMAX_COM;$i++){
		print "<option value=\"$i\">$i";
	}
print <<"EOM";
</select>
</td><th style="width:15%" rowspan="2">

<input type=submit id=input value="実行">
</th></tr>

<tr><td style="text-align:center;">
保存リストの名前（全角15文字以内）:<br>
<input type="text" name="name" value="" size="15">
</td></tr>

<tr><td colspan="4">※保存リストを読み込んだ際、保存リストより読み込む位置に指定された場所の方が広い場合、保存リストの内容を繰り返して読み込みます。<br>
　(例：保存リストを読み込む位置が開始位置2,終了位置13で、読み込む保存リストの内容が1:上に移動、2:入城/出城の場合→<br>
　コマンドリストのNO:2からNO:13まで上に移動→入城/出城のループになる。)
</td></tr>
</form>

</TBODY></TABLE>


<!-- BM自動モード -->
<br>
<h2><font color="#ff6600">■</font>BM自動モードの設定<font color="#ff6600">■</font></h2>
EOM
  my $auto_list_model = Jikkoku::Model::Chara::AutoModeList->new;
  my $mes = $auto_list_model->get_with_option($kid)->match(
    Some => sub { 'OFFにする' },
    None => sub { 'ONにする' },
  );
print <<"EOM";
<form action="./auto_in.cgi" method="post">
<input type=hidden name=mode value=SETTEI>
<input type=hidden name=id value="$kid">
<input type=hidden name=pass value="$kpass">
<input type=submit value="$mes">
</form>
<br>


</td></tr></table>

<center>
<form action="./status.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<TR><TH><input type=submit id=input  value="戻る">
</TH></TR></form>
</center>


EOM

&FOOTER;

exit;

}

#自動戦闘のONOFF
sub SETTEI {

  &CHARA_MAIN_OPEN;

  my $auto_list_model = Jikkoku::Model::Chara::AutoModeList->new;
  my $mes = $auto_list_model->get_with_option($kid)->match(
    Some => sub {
      $auto_list_model->delete($kid);
      'OFFにしました';
    },
    None => sub {
      $auto_list_model->add($kid);
      'ONにしました';
    },
  );
  $auto_list_model->save;

  &HEADER;

print <<"EOM";

<h2>$mes</h2>
<form action="@{[ suport_referer_file() ]}" method="post">
<input type="hidden" name="mode" value="STATUS">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=submit value="OK">


EOM

&FOOTER;
exit;
}
