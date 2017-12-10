#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/     NEW CHARA DATA 作成    _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub DATA_SEND {

	&CHARA_MAIN_OPEN;
	&TOWN_DATA_OPEN("$kpos");
	&HEADER;

	$klank = int($kclass / $LANK);

	print <<"EOM";
<CENTER><h3>＞＞登録完了＜＜</h3>
<hr size=0>
$knameで$GAME_TITLEの世界に登録されました。<BR>IDとPASSを忘れないようにメモして置いて下さい。
<hr size=0>
ID：<font color=red>$in{'id'}</font><BR>
PASS ：<font color=red>$in{'pass'}</font><BR>
<p>
ステータス<BR><table border=0 bgcolor=$TABLE_C cellspacing=1 class="kaku"><TBODY bgcolor=$TD_C4>
<tr><td rowspan="8" align="center"><img src="$IMG/$in{'chara'}.gif"></td>
<td class="b1">名前</td><td>$in{'chara_name'}</td>
<td class="b1">国</td><td>$cou_name</td></tr>
<tr><td class="b1">階級</td><td>$LANK[$klank]</td>
<td class="b1">初期位置</td><td>$zname</td></tr>
<tr><td class="b1">武力</td><td>$in{'str'}</td>
<td class="b1">知力</td><td>$in{'int'}</td></tr>
<tr><td>統率力</td><td>$in{'tou'}</td>
<td>mail</td><td>$in{'mail'}</td></tr>
</table>
<br>
<p><font size="2" color="red">初心者の方は必ず読んでください！！</font></p>
<p>
初心者向け<form action="$FILE_ENTRY" method="post">
<input type="hidden" name=mode value=RESISDENTS>
<input type="hidden" name=id value="$in{'id'}">
<input type="hidden" name=num value="0">
<input type="hidden" name=pass value="$in{'pass'}">
<input type="submit" value="このゲームの簡単な説明">
</form><p>
<br>
<br>
経験者向け<form action="$FILE_STATUS" method="post">
<input type="hidden" name=mode value=STATUS>
<input type="hidden" name=id value="$in{'id'}">
<input type="hidden" name=pass value="$in{'pass'}">
<input type="hidden" name=hajime value="yes">
<input type="submit" value="ゲームを開始">
</form>
</CENTER>
EOM

		&FOOTER;

		exit;
}
1;
