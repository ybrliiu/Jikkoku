#_/_/_/_/_/_/_/_/#
#スキル修得&SP購入#
#_/_/_/_/_/_/_/_/#

sub SKL_BUY {

	#消費士気読み込み
	require './lib/skl_lib.pl';

	&CHARA_MAIN_OPEN;
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);
	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;
	&HEADER;

#SP購入関係#
	$kspbuy += 0;
	$nokori = 40-$kspbuy;
	$first = 5000+($kspbuy*1000);
	if($first > 30000){$first = 30000;}

#移動スキル#
	if($kskl3 ne "3"){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●移動スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>BM上での移動が早くなるスキルです。</TD></TR>";
	}
	if($kskl3 eq ""){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=12></TD><TD bgcolor=$TD_C2><b>駿足【小】</b></TD><TD align=center bgcolor=$TD_C3>4</TD><TD bgcolor=$TD_C2>最大移動ポイントが+1される。</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}if($kskl3 eq "1"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=13></TD><TD bgcolor=$TD_C2><b>迅速</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>移動ポイント補充にかかる時間が20秒短縮される。</TD><TD bgcolor=$TD_C3>駿足【小】を修得していること。</TD></TR>";
	}if($kskl3 eq "2"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=14></TD><TD bgcolor=$TD_C2><b>駿足【大】</b></TD><TD align=center bgcolor=$TD_C3>12</TD><TD bgcolor=$TD_C2>最大移動ポイントが+3される。</TD><TD bgcolor=$TD_C3>迅速を修得していること。</TD></TR>";
	}

#集合スキル#
	if($kskl6 eq ""){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●集合スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>集合した時に効果を発揮する、部隊長向けのスキルです。</TD></TR>";

	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=40></TD><TD bgcolor=$TD_C2><b>自動集合</b></TD><TD align=center bgcolor=$TD_C3>3</TD><TD bgcolor=$TD_C2>コマンド実行時に自動的に部隊員を部隊拠点に集合させる。<br>部隊編成画面でON/OFF切り替え可能。<br>自動集合を実行毎に500R消費。</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}

#文官用スキル1#
	if($ksien ne "8"){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●支援スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>文官向けの、自分や味方の戦闘を補助するスキルです。</TD></TR>";
	}
	if($ksien eq "" || $ksien eq "0"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=1></TD><TD bgcolor=$TD_C2><b>補給</b></TD><TD align=center bgcolor=$TD_C3>5</TD><TD bgcolor=$TD_C2>自軍兵士が統率力の半分以上いるとき、自軍兵士を少し味方の部隊に引き渡す。<br>引き渡した人数×相手兵種の値段 相手の金は減少する。<br>また、引き渡した人数分引き渡された軍の訓練値は減少する。<br>ただし、引き渡す側と引き渡される側の兵種が同じ場合、金と訓練値は減少しない。<br>士気$MOR_HOKYU消費。引き渡す人数は統率力＋知力に依存。（行動）</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}if($ksien eq "1" || $ksien eq "4" || $ksien eq "5"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=4></TD><TD bgcolor=$TD_C2><b>加護【小】</b></TD><TD align=center bgcolor=$TD_C3>7</TD><TD bgcolor=$TD_C2>指定した味方部隊の守備力が7％＋5上昇する。士気$MOR_S消費。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C3>補給を修得していること。</TD></TR>";
	}if($ksien eq "2" || $ksien eq "6" || $ksien eq "9"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=5></TD><TD bgcolor=$TD_C2><b>加護【大】</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>指定した味方部隊の守備力が15％＋10上昇する。士気$MOR_L消費。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C3>加護【小】を修得していること。</TD></TR>";
	}if($ksien eq "1" || $ksien eq "2" || $ksien eq "3"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=6></TD><TD bgcolor=$TD_C2><b>陽動【小】</b></TD><TD align=center bgcolor=$TD_C3>7</TD><TD bgcolor=$TD_C2>指定した敵部隊の攻撃力を7％減少させる。士気$MOR_S消費。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C3>補給を修得していること。</TD></TR>";
	}if($ksien eq "4" || $ksien eq "6" || $ksien eq "7"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=7></TD><TD bgcolor=$TD_C2><b>陽動【大】</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>指定した敵部隊の攻撃力が15％減少させる。士気$MOR_L消費。<br>成功率、効果持続時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C3>陽動【小】を修得していること。</TD></TR>";
	}

#文官用スキル2#
	if($kskl1 ne "3"){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●妨害スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>文官向けの、相手の行動を妨害するスキルです。</TD></TR>";
	}
	if($kskl1 eq ""){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=2></TD><TD bgcolor=$TD_C2><b>混乱</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>相手が一定時間移動以外の行動ができないようにする。士気$MOR_KONRAN消費。<br>成功率、相手を行動できなくする時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}if($kskl1 eq "1"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=38></TD><TD bgcolor=$TD_C2><b>足止め</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>相手が移動の際に消費する移Pを1.7倍にする。士気$MOR_ASIDOME消費。<br>成功率、消費移P増加時間は知力に依存。（行動）</TD><TD bgcolor=$TD_C3>混乱を修得していること。</TD></TR>";
	}if($kskl1 eq "2"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=39></TD><TD bgcolor=$TD_C2><b>離間</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。敵部隊に離間工作をしかけ、敵兵を数人自分の部隊に引き入れる。<br>発動率は知力に依存。</TD><TD bgcolor=$TD_C3>足止めを修得していること。</TD></TR>";
	}

#仁官用スキル1#
	if($kskl2 ne "8"){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●応援スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>仁官向けの、自分や味方の戦闘を補助するスキルです。</TD></TR>";
	}
	if($kskl2 eq "" || $kskl2 eq "0"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=3></TD><TD bgcolor=$TD_C2><b>徴募</b></TD><TD align=center bgcolor=$TD_C3>5</TD><TD bgcolor=$TD_C2>自軍のいる地形が住宅地、砦、城、関所の時のみ使える。自軍兵士が僅かに増加。<br>50R、士気$MOR_TYOUBO消費。また、兵士増加分訓練値と金が減少。<br>増える兵数は人望に依存。（行動）<br>※自分にしか使えません。</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}if($kskl2 eq "1" || $kskl2 eq "4" || $kskl2 eq "5"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=8></TD><TD bgcolor=$TD_C2><b>鼓舞【小】</b></TD><TD align=center bgcolor=$TD_C3>7</TD><TD bgcolor=$TD_C2>指定した味方部隊の攻撃力が7％上昇する。士気$MOR_S消費。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C3>徴募を修得していること。</TD></TR>";
	}if($kskl2 eq "2" || $kskl2 eq "6" || $kskl2 eq "9"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=9></TD><TD bgcolor=$TD_C2><b>鼓舞【大】</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>指定した味方部隊の攻撃力が15%上昇する。士気$MOR_L消費。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C3>鼓舞【小】を修得していること。</TD></TR>";
	}if($kskl2 eq "1" || $kskl2 eq "2" || $kskl2 eq "3"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=10></TD><TD bgcolor=$TD_C2><b>扇動【小】</b></TD><TD align=center bgcolor=$TD_C3>7</TD><TD bgcolor=$TD_C2>指定した敵部隊の守備力を7％+5減少させる。士気$MOR_S消費。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C3>徴募を修得していること。</TD></TR>";
	}if($kskl2 eq "4" || $kskl2 eq "6" || $kskl2 eq "7"){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=11></TD><TD bgcolor=$TD_C2><b>扇動【大】</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>指定した敵部隊の守備力を15％+10減少させる。士気$MOR_L消費。<br>成功率、効果持続時間は人望に依存。（行動）</TD><TD bgcolor=$TD_C3>扇動【小】を修得していること。</TD></TR>";
	}

#仁官用スキル2(移動補助)#
	if($kskl8 !~ /3/ || $kskl8 !~ /4/){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●移動補助スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>仁官向けの、味方の移動を補助するスキルです。</TD></TR>";
	}if($kskl8 eq ""){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=45></TD><TD bgcolor=$TD_C2><b>縮地</b></TD><TD align=center bgcolor=$TD_C3>7</TD><TD bgcolor=$TD_C2>味方の移動ポイント補充時間を短縮する。<br>士気$MOR_SYUKUTI消費。短縮する時間、成功率は人望に依存。(行動)</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}
if($kskl8 =~ /1/){
	if($kskl8 !~ /2/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=46></TD><TD bgcolor=$TD_C2><b>加速</b></TD><TD align=center bgcolor=$TD_C3>13</TD><TD bgcolor=$TD_C2>味方の移動ポイントを上限を超えてプラスする。<br>士気$MOR_KASOKU消費。プラスする移動ポイント、成功率は人望に依存。(行動)</TD><TD bgcolor=$TD_C3>縮地を修得していること。</TD></TR>";
	}
	if($kskl8 =~ /2/ && $kskl8 !~ /3/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=47></TD><TD bgcolor=$TD_C2><b>觔斗雲</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>味方に觔斗雲を付与し、消費移動Pが多い地形での消費移動Pを抑える。<br>士気$MOR_KINTOUN消費。効果持続時間、成功率は人望に依存。(行動)</TD><TD bgcolor=$TD_C3>加速を修得していること。</TD></TR>";
	}
	if($kskl8 =~ /2/ && $kskl8 !~ /4/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=48></TD><TD bgcolor=$TD_C2><b>回避</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。自軍は敵からの攻撃を完全に回避し、そのターン敵から受けるダメージが0になる。<br>発動率は人望に依存。</TD><TD bgcolor=$TD_C3>加速を修得していること。</TD></TR>";
	}
}

#武官用スキル#
	if($kskl4 !~ /3/ || $kskl4 !~ /4/){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●戦闘術スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>武官向けの、戦闘を有利にするスキルです。</TD></TR>";
	}
	if($kskl4 eq ""){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=28></TD><TD bgcolor=$TD_C2><b>計数攻撃</b></TD><TD align=center bgcolor=$TD_C3>5</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。出撃中計数攻撃が発動した回数+3ダメージ与える。<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}
if($kskl4 =~ /0/){
	if($kskl4 !~ /1/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=29></TD><TD bgcolor=$TD_C2><b>破壊攻撃</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>戦闘中に低確率でイベント発生。相手に大ダメージを与える。<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C3>計数攻撃を修得していること。</TD></TR>";
	}if($kskl4 !~ /2/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=30></TD><TD bgcolor=$TD_C2><b>会心攻撃</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。そのターン相手に与えるダメージが1.5倍になる。<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C3>計数攻撃を修得していること。</TD></TR>";
	}if($kskl4 =~ /1/ && $kskl4 !~ /3/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=31></TD><TD bgcolor=$TD_C2><b>犠牲攻撃</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。自軍の兵士を何人か犠牲にし、相手に犠牲になった兵士×3のダメージを与える。(城壁戦は犠牲にした兵士×10)<br>発動率は武力に依存。</TD><TD bgcolor=$TD_C3>破壊攻撃を修得していること。</TD></TR>";
	}if($kskl4 =~ /2/ && $kskl4 !~ /4/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=32></TD><TD bgcolor=$TD_C2><b>強襲</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>自軍の攻守を上昇させ、相手の攻守を減少させて戦闘を仕掛ける。また、最初のターンに相手にダメージを与える。士気$MOR_KYOSYU消費。（戦闘モード）<br>自軍の攻守が上昇する割合と相手の攻守が減少する割合は武力に依存。</TD><TD bgcolor=$TD_C3>会心攻撃を修得していること。</TD></TR>";
	}
}

#武官用侵攻用スキル#
	if($kskl7 !~ /3/ || $kskl7 !~ /4/){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●侵攻スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>武官向けの、侵攻側の時の戦闘を有利にするスキルです。</TD></TR>";
	}if($kskl7 eq ""){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=41></TD><TD bgcolor=$TD_C2><b>侵攻強化</b></TD><TD align=center bgcolor=$TD_C3>5</TD><TD bgcolor=$TD_C2>侵攻側かつ武力が100以上の時、攻撃力+15。</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}
if($kskl7 =~ /1/){
	if($kskl7 !~ /2/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=42></TD><TD bgcolor=$TD_C2><b>進撃</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>武力が115以上の時使用可能。<br>侵攻側の時、使用してから410秒間攻撃力が25%上昇、その後200秒間守備力-50%。<br>防衛側の時、使用してから610秒間守備力-50%。士気$MOR_SINGEKI消費、再使用時間1200秒。（行動）</TD><TD bgcolor=$TD_C3>侵攻強化を修得していること。</TD></TR>";
	}
	if($kskl7 =~ /2/ && $kskl7 !~ /3/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=43></TD><TD bgcolor=$TD_C2><b>猛攻</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>侵攻側かつ武力が130以上の時、攻守+5%。<br>また、戦闘中にイベント発生。発動毎に攻撃力が+20され、敵にダメージを与える。<br>発動率は武力に依存。<br>※上昇した攻撃力は撤退すると元に戻る。<br>※1回の出撃中に上昇する攻撃力は60まで。<br>※攻城戦は発動率が半減する。</TD><TD bgcolor=$TD_C3>進撃を修得していること。</TD></TR>";
	}
	if($kskl7 =~ /2/ && $kskl7 !~ /4/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=44></TD><TD bgcolor=$TD_C2><b>波状攻撃</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>侵攻側かつ武力が130以上の時、攻守+5%、波状攻撃モード使用可能。<br><b>波状攻撃モード</b>：行動待機時間が通常の戦闘より40秒短くなる。<br>さらに戦闘中に波状攻撃イベント発生。敵に数ダメージ与える。<br>城壁戦にも有効。士気$MOR_HAJYO消費。<br>波状攻撃イベントの発動率は武力に依存。（戦闘モード）</TD><TD bgcolor=$TD_C3>進撃を修得していること。</TD></TR>";
	}
}

#統率官用スキル#
	if($kskl5 !~ /3/ || $kskl5 !~ /4/){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●指揮スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>統率官向けの、戦闘を有利にするスキルです。</TD></TR>";
	}
	if($kskl5 eq ""){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=33></TD><TD bgcolor=$TD_C2><b>突撃</b></TD><TD align=center bgcolor=$TD_C3>5</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。相手にダメージを与える。<br>発動率は統率力に依存。</TD><TD bgcolor=$TD_C3>-</TD></TR>";
	}
if($kskl5 =~ /0/){
	if($kskl5 !~ /1/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=34></TD><TD bgcolor=$TD_C2><b>攻勢</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。発動毎に攻撃力が+10され、相手に少しダメージを与える。<br>発動率は統率力に依存。<br>※上昇した攻撃力は撤退すると元に戻る。<br>※1回の出撃中に上昇する攻撃力は50まで。<br>※攻城戦は発動率が半減する。</TD><TD bgcolor=$TD_C3>突撃を修得していること。</TD></TR>";
	}if($kskl5 !~ /2/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=35></TD><TD bgcolor=$TD_C2><b>密集</b></TD><TD align=center bgcolor=$TD_C3>10</TD><TD bgcolor=$TD_C2>戦闘中にイベント発生。発動毎に守備力が+10される。<br>発動率は統率力に依存。<br>※上昇した守備力は撤退すると元に戻る。<br>※1回の出撃中に上昇する守備力は50まで。<br>※攻城戦は発動率が半減する。</TD><TD bgcolor=$TD_C3>突撃を修得していること。</TD></TR>";
	}if($kskl5 =~ /1/ && $kskl5 !~ /3/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=36></TD><TD bgcolor=$TD_C2><b>包囲</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>敵が30人以下の時、(自軍-敵軍)×1.5だけ攻撃力上昇。士気$MOR_HOUI消費。（戦闘モード）</TD><TD bgcolor=$TD_C3>攻勢を修得していること。</TD></TR>";
	}if($kskl5 =~ /2/ && $kskl5 !~ /4/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=37></TD><TD bgcolor=$TD_C2><b>陣形再編</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>陣形の再編にかかる時間を使用時の1/4に短縮する。士気$MOR_SAIHEN消費。</TD><TD bgcolor=$TD_C3>密集を修得していること。</TD></TR>";
	}
}

#内政強化系スキル#
if($knaiskl =~ /1/){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●内政スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>特定の内政に特化することができるスキルです。<br>内政をたくさんした者が修得できます。</TD></TR>";

	if($knaiskl !~ /2/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=15></TD><TD bgcolor=$TD_C2><b>農政特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>農業開発、農地開拓を実行した時の内政値の上昇値が2.0倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}if($knaiskl !~ /3/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=16></TD><TD bgcolor=$TD_C2><b>商政特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>商業発展、市場建設を実行した時の内政値の上昇値が2.0倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}if($knaiskl !~ /4/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=17></TD><TD bgcolor=$TD_C2><b>技術特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>技術開発を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}if($knaiskl !~ /5/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=18></TD><TD bgcolor=$TD_C2><b>土木特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>城壁強化、城壁拡張、城壁耐久力強化を実行した時の内政値の上昇値が1.8倍され、<br>実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}if($knaiskl !~ /6/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=19></TD><TD bgcolor=$TD_C2><b>仁政特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>米施しを実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}if($knaiskl !~ /7/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=20></TD><TD bgcolor=$TD_C2><b>開拓特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>開拓を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}if($knaiskl !~ /8/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=21></TD><TD bgcolor=$TD_C2><b>入植特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>入植を実行した時の内政値の上昇値が2.2倍され、実行した時にかかる米が0Rになる。</TD><TD bgcolor=$TD_C3>内政強化【大】を修得していること</TD></TR>";
	}
}

#計略強化系スキル#
if($kkeiskl =~ /1/){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●計略スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>特定の計略に特化することができるスキルです。<br>計略をたくさんした者が修得できます。</TD></TR>";

	if($kkeiskl !~ /2/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=22></TD><TD bgcolor=$TD_C2><b>農地破壊特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>農地破壊を実行した時の内政値の減少値が1.95倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>計略強化【大】を修得していること</TD></TR>";
	}if($kkeiskl !~ /3/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=23></TD><TD bgcolor=$TD_C2><b>市場破壊特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>市場破壊を実行した時の内政値の減少値が1.95倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>計略強化【大】を修得していること</TD></TR>";
	}if($kkeiskl !~ /4/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=24></TD><TD bgcolor=$TD_C2><b>技術衰退特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>技術衰退を実行した時の内政値の減少値が1.95倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>計略強化【大】を修得していること</TD></TR>";
	}if($kkeiskl !~ /5/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=25></TD><TD bgcolor=$TD_C2><b>工事妨害特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>城壁劣化を実行した時の内政値の減少値が1.95倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>計略強化【大】を修得していること</TD></TR>";
	}if($kkeiskl !~ /6/){
	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=26></TD><TD bgcolor=$TD_C2><b>流言特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>流言を実行した時の内政値の減少値が1.9倍され、実行した時にかかる金が0Gになる。</TD><TD bgcolor=$TD_C3>計略強化【大】を修得していること</TD></TR>";
	}
}

#鍛錬強化系スキル#
	if($ktanskl eq "1"){
	$sklsetumei .= "<TR><TD colspan=3 bgcolor=\"#ff8855\"><font size=+1><b>●鍛錬スキル</b></font></TD><TD bgcolor=\"#ffbb84\" colspan=2>能力強化を実行したときの効果が上昇するスキルです。<br>能力強化をたくさんした者が修得できます。</TD></TR>";

	$sklsetumei .= "<TR><TD bgcolor=$TD_C1><input type=radio name=select value=27></TD><TD bgcolor=$TD_C2><b>鍛錬特化</b></TD><TD align=center bgcolor=$TD_C3>15</TD><TD bgcolor=$TD_C2>能力強化を実行したときに得られる経験値が+4になる。</TD><TD bgcolor=$TD_C3>鍛錬強化【大】を修得していること</TD></TR>";
	}

	print <<"EOM";
<!-- SP価格計算 -->
<script type="text/javascript">

function keisan(){
	var gold = 0;
	var money = document.spbuy.num.value;
	money = parseInt(money) + $kspbuy;
	var um = 0;

	for(i=$kspbuy;i<money;i++){
		um = (i*1000) + 5000;
		if(um > 30000){	
		um = 30000;
		}
		gold += um;
	}

	var hyoji = document.getElementById("fild");
	hyoji.innerHTML = gold;
}

</script>

<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - ス キ ル 修 得 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>人望</TD><TH>$kcha</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>$cou_name[$kcon]</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white>スキルを修得します。[<a href="./manual.html#ski" target="_blank">スキルについて</a>]</font></TD><TD><form action="./modoru.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=image src=image/img/bar1.gif></form>
</TD></TR></TABLE>
</TD></TR>

<tr><td>
<table style="background-color:#4682B4;margin:5px;border-collapse:separate;border-spacing:3px;">
<tr><td bgcolor="#B0E6FF"><b>所持SP</b></td><td style="background-color:#CFFFFF;width:70px;text-align:center;"><b>　$ksg　</b></td>
<td bgcolor="#B0E6FF"><b>SP購入</b></td><form action="./mydata.cgi" method="post" name="spbuy">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<td style="background-color:#CFFFFF;width:180px;text-align:left;white-space: nowrap;">
<input name="num" type="text" size="8" value="1" maxlength="2" onChange="keisan();">
<input type="hidden" name="mode" value="SP_BUY">(計 <span id="fild" style="color:#222222;">$first</span> G)
</td>
<td bgcolor="#CFFFFF"><input type="submit" value="購入"></td>
<td bgcolor="#B0E6FF"><b>購入可能なSP数</b></td>
<th style="background-color:#CFFFFF;width:70px;"> 残り $nokori P </th>
</form></tr>
<tr><th style="background-color:#B0E6FF;">SPの購入について</th>
<td colspan="6" style="background-color:#CFFFFF;">※SPを1ポイント購入するごとにSPの価格は1000Gづつあがり、最大30000Gになります。<br>
　30000G以上は価格は上がりません。<br>
※SPは１期中に40ポイントまでしか購入できません。</td>
</table>
<br>
</td></tr>

<TR><TD>
<form action="./mydata.cgi" method="post">
<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass>
<TABLE bgcolor=$TABLE_C border="2" style="margin:4px;width:95%">

<TR><TD bgcolor=$TD_C1>選択</TD><TD bgcolor=$TD_C2>名称</TD><TD bgcolor=$TD_C3>必要SP</TD><TD bgcolor=$TD_C2>説明</TD><TD bgcolor=$TD_C3>必要条件</TD></TR>

$sklsetumei

</TABLE>

<input type=hidden name=mode value=SKL_BUY2>
<input type=submit id=input value=\"修得\"></form>


<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form></CENTER>

</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}


#SP購入
sub SP_BUY{

	&CHARA_MAIN_OPEN;
	&TIME_DATA;

	if ( $in{'num'} eq "" || $in{'num'} == 0 || $in{'num'} =~ m/[^0-9]/ ) {
    &ERR("購入する数値が無効な値です。");
  }
	my $nokori = 40 - $kspbuy;
	if ( $in{'num'} + $kspbuy > 40 ) {
    ERR("購入可能なSP数の上限を超えています。 (後 $nokori 購入可能）");
  }

  for ( my $i = $kspbuy; $i < $in{'num'} + $kspbuy; $i++ ) {
    my $uhi = 5000 + ( $i * 1000 );
    if ( $uhi > 30000 ) {
      $uhi = 30000;
    }
    $shouhi += $uhi;
  }

	$kgold -= $shouhi;
	if($kgold < 0){&ERR("金が足りません。");}

	$ksg += $in{'num'};
	$kspbuy += $in{'num'};

	$res_mes = "$knameはSPを$in{'num'}購入しました。金-$shouhi。";
	&K_LOG("【<span style='color:red;'>SP購入</span>】SPを<span style='color:red;'>$in{'num'}\</span>購入しました。金-$shouhi。");

	&CHARA_MAIN_INPUT;

	if("$ENV{'HTTP_REFERER'}" eq "$KEITAI_SURL"){
	$url = "./i-status.cgi";
	$mmode = "MENT";
	}else{
	$url = "./mydata.cgi";
	$mmode = "SKL_BUY";
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$res_mes</h2><p>
<form action="$url" method="post"><input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=$mmode>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;

	exit;
}
1;
