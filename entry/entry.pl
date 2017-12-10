#_/_/_/_/_/_/_/_/_/#
#_/   新規登録   _/#
#_/_/_/_/_/_/_/_/_/#

use Jikkoku::Model::Config;
use Jikkoku::Model::Chara;
use Jikkoku::Model::Country;

sub ENTRY {

	&CHEACKER;
	&HEADER;

	$month_read = "$LOG_DIR/date_count.cgi";
	open(IN,"$month_read") or &ERR2("Can\'t file open!:month_read");
	@MONTH_DATA = <IN>;
	close(IN);

	($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
	$old_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
	$tikara = 155 + int $myear * 1.1;
	$kaku = 100 + int $myear * 1.1;

	open(IN,"$COUNTRY_MES") or &ERR("指定されたファイルが開けません。");
	@MES_DATA = <IN>;
	close(IN);

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	foreach(@COU_DATA){
		($x2cid,$x2name,$x2ele,$x2mark)=split(/<>/);
		$cou_name[$x2cid] = "$x2name";
		$cou_ele[$x2cid] = "$x2ele";
		$cou_mark[$x2cid] = "$x2mark";
	}

	$mess .= "<TR><TD BGCOLOR=$TD_C1 colspan=2>各国の新規参入者へのメッセージ</TD></TR>";
	foreach(@MES_DATA){
		($cmes,$cid)=split(/<>/);
		$mess .= "<TR><TD bgcolor=$ELE_C[$cou_ele[$cid]]>$cou_name[$cid]</TD><TD bgcolor=$ELE_C[$cou_ele[$cid]]>$cmes</TD></TR>";
	}


	open(IN,"$TOWN_LIST") or &ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);

	$zc=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con)=split(/<>/);
		$town_name[$zc] = "$z2name";
		$town_cou[$zc] = "$z2con";
		if($town_name[$zc] ne "雷州"){
			if($in{'con'} eq $zc){
			$t_list .= "<option value=\"$zc\" SELECTED>$z2name【$cou_name[$z2con]】";
			}else{
			$t_list .= "<option value=\"$zc\">$z2name【$cou_name[$z2con]】";
			}
		}
		$zc++;
	}


	if($in{'cyusei'} eq ""){$in{'cyusei'} = 75;}


	if($in{'url'} eq ""){$nurl = "http://";}else{$nurl = "$in{'url'}";}
	if($in{'mail'} eq ""){$nmail = "\@";}else{$nmail = "$in{'mail'}";}
	if($ATTESTATION){$emes = "・<font color=red>認証ID付きの確認メールを送りませんので適当に入力してください。</font><BR>(※このメールアドレスはゲーム内でも使用しません。もちろんスパムメールやその他への利用も一切しません。)";}
	else{$emes = "・入力すると、パスワードを忘れた時や管理人と連絡をとる時に役立ちます。（入力しなくても登録はできます）";}
	print <<"EOM";
	<script language="JavaScript">
		function changeImg(){
			num=document.para.chara.selectedIndex;
			document.Img.src="$IMG/"+ num +".gif";
		}
	</script>
<hr size=0><CENTER><font size=4><b>-- 武将登録 --</b></font><hr size=0><form action="$FILE_ENTRY" method="post" name=para><input type="hidden" name="mode" value="NEW_CHARA">
<table bgcolor=$TABLE_C width=80% border=0 cellpadding="1" cellspacing="1" class="kaku">$mess</table>
<br>
<table bgcolor=$TABLE_C border=0 cellpadding="3" cellspacong="1"><tr><TD colspan=2 bgcolor=$TD_C1>
* IDとPASSが同じ場合登録出来ません。<BR>
* 多重登録は出来ません<BR>
* 最大登録人数は$ENTRY_MAX名です。（現在登録者$num名）<BR>
* すべての項目を記入してください。<BR>
* <a href="./manual.html" TARGET="_blank">ゲーム説明</a>をよく読んでから参加してください。<BR>
* <a href="./manual.html#l" TARGET="_blank">ルール</a>をよく読んでください。ルールを守れない方は登録しないで下さい。<BR>
*初期位置に何処の支配もうけていない都市（【】空欄の都市）を選択すると君主として参加\可\能\です。それ以外はその街の所有者の配下になります。<a href="./ranking.cgi" TARGET="_blank">街一覧</a> <BR>
* 途中仕官ボーナスがあります。<BR>
</TD></tr><tr bgcolor=$TD_C2><TD width=100>名 前</tD><tD bgcolor=$TD_C3><input type="text" name="chara_name" size="30" value="$in{'chara_name'}"><br>・武将の名前を入力してください。<BR>[全角大文字で１〜１５文字以内]</tD></tr><tr><TD bgcolor=$TD_C2>イメージ</TD><TD bgcolor=$TD_C3><TABLE bgcolor=$TABLE_C border=2><TR><TD><img src=\"$IMG/0.gif\" name=\"Img\">
</TD></TR></TABLE><select name=chara onChange=\"changeImg()\">
EOM
	$i=0;
	foreach (0..$CHARA_IMAGE){
		if($i eq $in{'chara'}){
		print "<option value=\"$_\" SELECTED>イメージ[$_]\n";
		}else{
		print "<option value=\"$_\">イメージ[$_]\n";
		}
	$i++;
	}
	print <<"EOM";
</select><br>・武将のイメージを選んでください。<br>
※後から変更可能です。また、登録後使いたい画像をアップロードして使う事もできます。)<a href="aicon.cgi" class="mikata" target="_blank">アイコン一覧</a></TH></tr>

<tr bgcolor=$TD_C2>
  <TD>初期位置</TD>
  <TD bgcolor=$TD_C3>
    <select name="con">
      <option value=""> 選択してください
      $t_list
    </select>
    <br>
    ・所属する国を選んでください。（【】は建国可能)<br>
EOM
my $config = Jikkoku::Model::Config->get;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara_sum = @{ $chara_model->get_all };
my $country_model = Jikkoku::Model::Country->new;
my $available_num =
  $country_model->INFLATE_TO->number_of_chara_participate_available($chara_model, $country_model);
if ($chara_sum <= $config->{game}{participation_restriction_num}) {
   print qq{ ・<span class="red">現在、1つの国につき$available_num名までしか仕官できません。</span>
     <a href="manual.html#participation_restriction" target="_blank">【仕官制限について】</a>
     <a href="ranking.cgi" target="_blank">【武将一覧】<br>};
}
print <<"EOM";
  </TD>
</tr>
<tr>
  <TD bgcolor=$TD_C2>ID</TD>
  <TD bgcolor=$TD_C3>
    <input type="text" name="id" size="10" value="$in{'id'}"><br>
    ・参加する希望IDを記入してください。<BR>
    [半角英数字で４〜８文字以内]
  </TD>
</tr>
<tr>
  <TD bgcolor=$TD_C2>パスワード</TD>
  <TD bgcolor=$TD_C3>
    <input type="password" name="pass" size="10" value="$in{'pass'}"><br>
    ・パスワードを登録してください。<BR>[半角英数字で６〜１６文字以内]
  </TD>
</tr>
<tr><TD bgcolor=$TD_C2>\能\力</TD><TD bgcolor=$TD_C3>
<table>
<TR><TD>武力</TD><TD><input type="text" name="str" size="5" value="$in{'str'}">[1〜$kaku\]</TD></TR>
<TR><TD>知力</TD><TD><input type="text" name="int" size="5" value="$in{'int'}">[1〜$kaku\]</TD></TR>
<TR><TD>統率力</TD><TD><input type="text" name="tou" size="5" value="$in{'tou'}">[1〜$kaku\]</TD></TR>
<TR><TD>人望</TD><TD><input type="text" name="cea" size="5" value="$in{'cea'}">[1〜$kaku\]</TD></TR></TABLE>
・\能\力を指定して下さい。　<a href="manual.html#ste" class="mikata" target="_blank">【各能力の説明】</a>　<a href="001.html" class="mikata" target="_blank">【能力振り分けの例】</a><br>※一つの能力に特化させることをお勧めします。<BR>[全部の合計が<font color="red">$tikara</font>になるようにして下さい！]</TD></tr>
<tr><TD bgcolor=$TD_C2>忠誠度</TD><TD bgcolor=$TD_C3><input type="text" name="cyusei" size="5" value="$in{'cyusei'}">[0〜100]<br>
・所属国への忠誠度を設定してください。（登録後変更可能）<br>
※忠誠度が低い武将が多い国の武将は、君主の位を奪えたり反乱を起こせたりするようになります。（詳しくは<a href="./manual.html#jyo" class="mikata" target="_blank">こちら</a>）<br>
国に忠誠を誓おうと考えている方はこの値をなるべく高くして登録しましょう。</TD></tr>
<tr><TD bgcolor=$TD_C2>プロフィール</TD><TD bgcolor=$TD_C3><textarea name="mes" cols="50" rows="5">$in{'mes'}</textarea><br>
・プロフィールを入力してください。<br>
※入力は任意です。全角10000文字まで、登録後変更可能。
</TD></tr>
<tr><TD bgcolor=$TD_C2>メールアドレス</TD><TD bgcolor=$TD_C3><input type="text" name="mail" size="35" value="$nmail"><br> $emes</TD></tr>
</table>
<BR>
<TABLE width=80% bgcolor=$TABLE_C>
<tr><TH bgcolor=$TD_C3 colspan=2>君主</TH></TR>
<tr><TD bgcolor=$TD_C1 colspan=2>
・所属位置に*がついている場合はこちらも登録してください。
</TD></TR>
<tr bgcolor=$TD_C1><TD width=100>国名</tD><tD bgcolor=$TD_C3><input type="text" name="cou_name" size="30" value="$in{'cou_name'}"><br>・新国家の名称を決めてください。<BR>[全角大文字で１〜１５文字以内]</tD></tr>
<tr><TD bgcolor=$TD_C1>国色</TD><TD bgcolor=$TD_C4>
EOM
	$i=0;
	foreach(@ELE_BG){
		if($in{'ele'} eq $i){
		print "<input type=radio name=ele value=\"$i\" checked><font color=$ELE_BG[$i]>■</font> \n";
		}else{
		print "<input type=radio name=ele value=\"$i\"><font color=$ELE_BG[$i]>■</font> \n";
		}
	$i++;
	}
	print <<"EOM";
<br>・国の色を決めてください。</TD></tr>
</TABLE>

</table>
</td></tr>
<tr><TH align="center" bgcolor=$TABLE_C><input type="submit" value="登録"></TH></tr></table></form></CENTER>

EOM

	# フッター表示
	&FOOTER;

	exit;
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/   参加登録者上限チェック   _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub CHEACKER {

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);


	$num = @CL_DATA;

	if($ENTRY_MAX){
		if($num > $ENTRY_MAX){
			&ERR2("最大登録数\[$ENTRY_MAX\]を超えています。現在新規登録出来ません。");
		}
	}
}
1;
