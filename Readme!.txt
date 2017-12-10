十国志NET

このプログラムはmaccyu氏が作成した三国志NET Ver.2.80 を元にルナさんの三国志NET月華の戦闘システムを取り入れ、liiuが大幅に改造したプログラムです。
このプログラムはmaccyu氏が作成した超汚いプログラムをliiuが更に汚くした、ヤバイプログラムです。
読んで失神しないようにして下さい。

【注意】
・プログラムはUTF-8で書いているので恐らくメール認証機能は文字化けするような気がします。
メールを送信するプログラムは専用BBSの書き込み部分などにもあるので、それを参考にして作りなおしてください。(Don't use jcode.pl,use encode.pm)
・ディレクトリ image はパーミッションを「777」または「707」にして下さい。
そうしないと画像アップローダのプログラムuploder.phpが動きません。
・バックアップファイル作成機能はサーバによっては使えない場合があります。
・推奨環境 PHP 5以上、perl 5.14(perl4ベースで記述してますが一部perl5の機能を使っています。perl4の部分はちゃんと動いてます)
perl5.18以下と思われる(5.20でdoでのsub呼び出しがエラーになったため)
・CGI.pmくらい使えばよかったのにねえ

【免責事項】                                                
このスクリプトはフリーソフトです。このスクリプトを使用した 
いかなる損害に対して作者は一切の責任を負いません。         
無断で配布することは禁止です。   

【戦闘システムについて】
三国志NET月華の戦闘システムを参考にさせていただきました。

【素材配布元】
・背景画像 ちゃきん様 http://sozai.chakin.com/
・画像アップローダ(少しいじらせていただいています) e-web様 http://www.eweb-design.com/
・アイコン画像 モアイ部様,Edge+様,ジェリーフィッシュ海賊団様
・graph.cgiのグラフ描画にはChart.jsを使わせていただきました。

【変数一覧】
$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip";
$ksenj = "陣形番号,出兵フラグ,部隊の位置,x座標,y座標,移動P補充時間,行動待機時間,移動p,計数攻撃カウント,攻勢カウント,密集カウント,陣形変更時間,カモフラージュ度（隠密度）";
$ksub4 = "$krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2,";
$ksub4 = "錬兵スキル,人斬り報酬回数,撃破恩賞回数,残念賞回数,攻城スキル,加護状態,加護状態L,陽動状態,陽動状態L,鼓舞状態,鼓舞状態L,扇動状態,扇動状態L,内政スキル,計略スキル,鍛錬スキル,筋斗雲状態,状態サブ1,状態サブ2,";

【陣形説明】
陣形名称<>攻撃力up(%)<>守備力up(%)<>得意攻撃力up(%)<>得意守備力up(%)<>攻撃力up(数値)<>守備力up(数値)<>得意陣形,,,,,,,<>変更までにかかる時間<>必要階級値<>説明文<>sub2<>習得方法(1=スキル、2=特殊)<>

【リセットの仕方】
まず、index.iniの期数を増やして
更新開始秒を計算して更新開始日に設定して
更新開始日の更新開始日の時刻に時間ちょうどにアクセス
もし時間ずれたらlog_file/data_count.cgi正しい時間に直す
以上

【注意】
perl4時代の恐ろしく汚いプログラムをかなり無計画に拡張しているのでメンテナンス性は異常なまでに悪いです。
あしからず。

●備考　個人データ追加時　編集ファイル
entry/new_chara.cgi
suport.pl
i-suport.pl
return.pl
admin.cgi
check_com.cgi


三国志NET月龍 更新履歴


Ver.0.0 骨組みの完成

	Ver.0.00 三国志NET龍紀をベースに三国志NET月龍開発開始。MAP表示だけできるようになった。
	Ver.0.01 移動だけできるようになった。


Ver.0.1 戦闘システムの完成

	Ver.0.10 戦闘プログラムを移植する。
	Ver.0.11 戦闘プログラムのログとかちゃんとできてなかったので修正。
	Ver.0.12~0.16 関所出入りとかできるようになった。また、兵種もこちらにあわせて調整した。一応戦闘システムはこれで完成。


Ver.0.2 スキルの調整・追加

	Ver.0.20 三国志NET龍紀のスキルでこちらで使えない物を削除。
		 特殊技能等もこちらにあわせて調整。
	Ver.0.21 スキルをいくつか追加。


Ver.0.3 整頓

	Ver.0.30 ・アイコン一覧をCGIにした。
	Ver.0.31 ・index.iniあたりを変えた。アイコン一覧を登録したり、バージョン表示できるようにしたり。
	Ver.0.32 ・調査コマンド実行プログラム exe_com/tyousa.pl の修正。
	          ・いらないファイルを削除（テストで使ってた物とか）。
	Ver.0.33 ・バトルマップで敵もしくは味方の上にカーソルをあわせると
	          その武将の情報がバルーン表示でおおざっぱに見れるようにした。
	Ver.0.34 ・自己紹介をプロフィールに変更。BM、手紙、武将一覧、名将でバルーンで見れるようになった。
	         ・今何期かをindex.iniで設定できるようにした。
	Ver.0.35 ・手紙ログページlog.cgiを追加（国宛100件、都市、密書、個宛、部隊宛50件）
	           ・手紙書き込み時のセキリュティを強化（上層部でなくても他国に手紙に遅れるの）
	Ver.0.36 ・画像アップローダuploder.php設置。
	           なぜかperlのが動かなかったのでこれだけphp。しかも文字コードがこれだけs-jis
	ver.0.37 ・文字サイズ＆表示コマンド数設定追加。スマホでもちゃんと表示されるようにした。めっちゃ大変やった；
	          ・敵の城の上には行けなくした。
	          ・城に敗北したとき都市データが破損するバグ一応修正。
	ver.0.38-0.39 ・スマホ一部のJS対応(マウス重ねた時の処理)←ちゃんとなってない？
	 ・城壁戦闘時違う武将にもログが行ってしまうバグ修正。
	・アイコン削除機能追加。
	fix ・敦煌のMAP追加。
	fix2 ・寡兵スキルの追加。
	fix5 ・武器属性の仕様変更。説明書も更新。寿州金陵のmap追加
	　　　 ・役職補正の中で防御力が上がるのも入れた
		・攻撃力守備力表示の修正
	fix6 ・武器属性の仕様変更後きちんと動作してなかったところを修正。

Ver.0.4 マップの完成

	Ver.0.40 ・MAPの不具合3ヶ所修正。鳳翔-成都間,鳳翔MAP追加
	Ver.0.41 ・加護スキル追加 完了
		 ・変数の説明$kskl 一応した
		 ・状態表示 status,newbm,i-newbm,menu.cgi 完了 up済み
		・説明書更新 完了 up済み
		・状態ついてるときの戦闘動作 完了 動作確認ok! up済み
		・open_map.pl(完了)のレイアウト up済み
		・状態表示画像作る　完了 up済み
	fix ・携帯版bmの修正 完了 up済み
		・名将のバグ 修正済
		・index.cgi(+index.ini)のレイアウト修正
	fix2 ・支援系スキルは自分にもできるようになった（一部除く）
		・スキル一覧で謎の数字が 修正
	
	Ver.0.42 ・追加スキルの閲覧購入表示関係を完成させる myskl,skl_buy,skl_buy2,status,newbm,i-newbm完了 動作確認まだ
		・追加スキルプログラム全部作った（加護、扇動、陽動、鼓舞）
		 ・追加スキルで自分に支援できるものの修正（（kago,kagoL,kobu,kobuL）完了
	fix	・ほうしょう京兆間、京兆、京兆しんよう間MAP追加
		・しょうしどのリーチ増加
		・城壁が反撃できないバグ修正（無限リーチ化した）
	fix2	newbmに再読み込みボタン配置 完了
		呪術兵義勇軍武力マイナスする 完了
		機属性の補正表示おかしい 完了
		battle.pl軽量化(bmmaplst.ini追加) 完了
	fix3	国情報の白の守備おかしい　修正
		デザイン少し変更

	Ver.0.43 あとmapつくるだけ...
	fix 広州MAPの不具合修正、status.cgiの守備表示不具合修正
	fix2 兵の追加、ばらんす調整,index.ini,status.cgi,newbm.cgi,i-newbm.cgi,battle.pl,exe_com/get_sol.pl,command/get_sol.pl
	更新開始前に登録した武将が無限更新されるバグ修正,entry/newchara.cgi
	時間取得修正suport.pl

	Ver.0.44 移動スキル追加
	fix 管理画面初期化のところ一旦確認ページふませるようにした。admin.cgi
	Ver.0.45 status.cgiスマホ表示対応。（レイアウト変更＋コマンド全件表示アコーディオン）
	Ver.0.46 内政系強化、計略系強化、鍛錬強化スキル追加
	Ver.0.47 スキル修得をポイント制に、CSS3を使ったレイアウト変更段階一、各種レイアウト調整、会議室削除機能追加、
会議室lと国法のセキュリティ強化,コマンド空白注入削除機能追加
	fix スキル説明、部隊などのファイルロック強化、携帯版部隊宛バグ修正
	fix2 部隊宛バグ修正
	Ver.0.48 武将データバックアップ機能追加(index.cgi)
		これにより新たにディレクトリ backup-main(武将メインデータ),backup を作成
		スタイルシート適用（ボタン、入力フォーム）
		陣形の枠組み、newbm,log.cgi,携帯版のデザイン修正
	Ver.0.49 兵種の追加（武官B,A騎　鴉軍は標準化）,会議室にスレ一覧追加,陣形データ書物データ不足BMAPデータ更新
	fix exe_com/出兵守備移動スキル未対応バグ修正、細かいUI変更、batllecm以下地名読み込み軽量化、デザイン変更,001.html変更,説明書変更、初心者用説明加筆


Ver.0.5 スキル、陣形の追加

	Ver.0.50
	スマホレイアウト変更suport.pl、admin.cgiのバグ修正、登録時のpass文字数増やす、ツールチップ追加
	battle.pl(突撃、計数攻撃、犠牲攻撃(犠牲にする兵数は自軍の兵士が1未満にならないような仕様にした、理由は処理が複雑過ぎるのと勝敗をどう判定するか考え方が分かれるため、スキル発動部分を整理&単純化)
	スキル追加のため $ksenjに変数追加 battlecm.cgi,mydata/jinkei.pl,check_com.cgi,status,newbm,i-newbm,batllecn以下全部
	退却時の処理の追加(battlecm.cgi,hokyu.pl,idou.pl,battle.pl,taikyaku.pl,exe_com/taikaku.pl)
	スキル説明の修正
	fix おかしい仕様になってたところ修正（陣形再編時間関連）、説明書陣形についてかいた
	fix2 バグ修正(Reset.cgi-backupファイル消す,偵察コマンドバグ＆仕様変更,)

	Ver.0.51 SYSTEM_LOG追加、管理人からのお知らせ追加(TOP),TOPのデザイン変更
	Ver.0.52 バックアップ2追加（ディレクトリbackup2,backup-main2追加）、武将データ自動復旧機能追加(return.pl)
	Ver.0.53 index.cgi reset.cgi systemlog追加 フラグ必要スキルのアイコン作成&status系いじる,
skl説明見やすくした
	fix return.plのバグ修正、説明書追記
	Ver.0.54 携帯版部隊編成追加
	Ver.0.55 国力比較（graph.cgi）
	fix バグ修正?
	Ver.0.56 説明書にスキルの追記。スキル確認画面で修得順に見れるようにした
	Ver.0.57 細かいレイアウト調整、兵種解説追加、バグ修正、graph.cgi軽量版追加,専用BBS追加、ログイン人数表示など
	Ver.0.58 水軍実装
	fix 戦闘ログとログ分離、その他バグ修正
	fix2 バグ修正、携帯版要素追加（国武将、国、都市データ）
	fix3 説明書大幅修正

--------------ここから正式公開、タイトルを三国志NET月龍から十国志NETに変更------------------------

	Ver.0.59 簒奪に条件：国民の忠誠度平均40以下を追加、農業商業技術の基本貢献を33に、流民イベのバグ修正（check_com.cgi）、説明書修正など
	fix スキルのバランス調整,表示ログ修正
	fix2 レイアウト修正、graph.cgiのバグ修正（0人国家がある時0除算が発生しエラーが出るバグ）


Ver.0.6x 運営中、適宜改良＆修正


	Ver.0.60 cookieでidとpass保存できるように　suport.plには準備整ってたのに、index.cgiでは&GET_COOKIEがなかた
	maccyu氏は何を考えていた？ 	index.cgi,suport.pl,status.cgi,entry/new_chara.cgi
	Ver.0.61 武器威力消えるバグ修正？（おそらくcheck_com.cgiの武器なし処理のせい）,BM上武器屋追加、スキル武器追加
	Ver.0.62 BM自動化プログラム auto_in.cgi,log_file/auto_list.cgi,charalog/auto_com/以下,auto_com.cgi,auto_com/以下
	BMコマンド入力出きるようになった
	※最初に使用するときはNo:allを選択して何かコマンド入力することが必要
	入城時にログ出すように
	反乱イベントのあたり修正
	status.cgi,mycou.cgiの守備表示バグ修正
	戦争コマンドの入力時連闘がでるの修正
	check_com.cgiのキャラ削除時、reset.cgi、base.cssの修正
	装備品購入コマ入力時金足りなくても行けるようにcommand/def_buy,arm_buy,bou_buy.cgi
	cssボタン半透明に
	部隊入隊時離脱時解雇時のメッセージ修正

	Ver.0.63
	・更新20分、更新時間19時～25時,行動待機120秒に(おそらくindex.cgiとcheck_com.cgiの$idataや$kdata+$TIME_REMAKEのところをいじるとできる)
	・階級500ごとに昇格
	index.ini,check_com.cgi,index.cgiいじった
	・いしゅうらいしゅう移動可能log_file/f_town.cgiに、操作性改善auto_in.cgi,satus,newbm,i-newbm.cgi,balecm/idou.pl
	・時間制限 batlecm.cgi,battlecm/idou.pl
	・兵種調整 index.ini,exe_com/get_sol.pl,command/get_sol.pl,battlecm/battle.pl,auto_exe.cgi,BM操作系	(status,newbm,i-ne)
	・バックアップ系も時間制限に合わせる　index.cgi,return.pl,backup.pl
	・兵士特訓など一部コマンドの開放時期の調整 check_com,status,i-status
	・職補正調整 　大将軍　攻+30→+20 騎馬将軍　攻+20→+15 manual,king_com,status,newbm,i-new,battle.pl,auto_exe
	・徴募コスト増大 200R→500R batlecm/kahei.pl,status,newbm,i-new
	・破壊攻撃の威力:15
	・計数攻撃 ダメージ発動回数+3に,説明を詳しく 
	・犠牲攻撃　犠牲兵士は1～9人
	・短百 ダメ1～10に
	・武器成長速度up 0.1→0.15
	・支配時の減少内政値変更
	・攻城兵のスキル変更
	・攻城スキル習得を容易に ＠battle.pl,myskl,myskl2,sklbuy,check_com,manual
	・スキルにリーチつける(突撃はリーチ1) myskl,myskl2
	・スキルの時間調整（混乱(調整必要なし)、陣形再編）myskl,myskl2
	・陣形の時間調整 jinkei.cgi
	・リセット時stop_conリセット reset.cgi
	・BM_COMの新規登録時作成 new_chara.cgi
	・雷州で建国できないように entry.pl
	・耐久直の仕様変化 exe_com/shiro_tai.pl,shirokaku.pl,man,status,i-status,mycou.cgi
	・下野と反乱コマンドの差別化、コスト増大(下野:階級値-1000に、また下野時に撤退)exe_com/geya.pl,check_com,man
	・移動(か戦闘)CM入力変らいしゅうのあたり command/battle.pl
	・階級Lv.の表記 check_com,ranking,mycou2
	・バグ発見、更新開始が少し遅くなる(new_chara.cgi 20分変更のため? 修正済
	・status.cgiのコマンド一覧の時間　時間制限に合わせる
	・迅速の短縮時間は30→20秒に<br>
	・加護【小】、加護【大】、扇動【小】、扇動【大】の効果変更 小は5%+10→5%+5 大は10%+20→10%+10<br>
	・内政強化、計略強化、鍛錬強化【大】をそれぞれ400→300回で取得に
	・耐久直の仕様変化 exe_com/shiro_tai.pl,shirokaku.pl,man,status,i-status これも確認
	fix?
	●id,pw忘れたとき　idpw.cgi,index.cgi,admin.cgi,manual.html
	・装備品開放は技術依存(威力120:技術7000) log_file/dou.cgi,arm.cgi,pro.cgi command/arm_buy,def_buy,bou_buy batlecm/bukiya.pl modoru.cgi check_ccom.cgi
	・陣形再編のリキャストタイム増加 60秒？myskl2,myskl,battlecm/saihen.pl
	・徴兵画面徴兵しやすく
	・装備品デザイン modoru,bukiya,arm.cgi
	・説明書に困ったときの、ステータスの説明に詳細を、書き換え、追加説明 他国領内通過時の規程
	・id,pw忘れたときメールと名前入力したら送るように、専Bで書き込みあればmail入るように、説明書修正idpw.cgi,bbs.cgi,manual,bbs/bbs_write.pl
	・下野と反乱コマンドの差別化、コスト増大(下野:階級値-1000に、また下野時に撤退)exe_com/geya.pl,check_com,man
	・解雇時完全BMリセット mydata/king_com4.pl
	・統一ログ、battle.pl,suport.pl
	・徴兵による減少農民数緩和 exe/get_sol.pl 人数*6
	・混乱時間調整rand（知力）、加護とか使用金額低下500-300.1000-600、強襲弱体化(基礎値3%?)
	fix2
	・階級値上昇時にメッセージ、開放階級値厳格化 bm表示系、mydata.pl,check_com
	・移動に時間がかかりすぎる都市間BMいくつか修正
	・新武器および武器スキルを追加（さく、干将）
	Ver.0.64
	・移動、空白、コマンド削除しやすく
	・スキル系統別分割
	・攻勢5回まで テスト auto_exeまだ
	・統一ログ出てない auto_exeまだ
	・統官及び武官の能力調整　統率-0.1　武+0.1  auto_exeまだ
	・スキル追加（謀略、混乱→足止め→離間） 離間のauto_exeまだ
	・やっぱ軽量化いるよ...。battle.pl軽量化 スキル発動部分 スキル発動のところのif文はrandある文とskl条件文に分ける
	・装備品は技術&階級依存に
	・bm表示 加護金額
	・マップ縮小
	・能力強化　金マイナスでもできる
	・初期忠誠値70
	・給料割れすぎ、アップする
	・災害イベントの修正　確率減らして、損害大きく
	・統一のルール規程変更
	・混乱取得にかかるSP10に
	・reset.cgi blackacklistもリセット
	・職選択で任命かい叙できるように
	fix
	・admin.cgi 管理人からのお知らせ機能追加？
	fix2
	・バトルマップの記述変更 多分軽量化になったと思う...。
	Ver.0.65
	・初期内政値は今3倍
	・部隊自動集合拠点
	・自動集合のスキル化
	・布告するとき開栓時刻と布告国明記してないと無効にする、スパイ行為禁止に反乱等をそそのかすことの禁止、無所属での戦闘について
	・登録後も同一IPからの接続ないか確かめadmin.cgi,sttatus.cgi
	・メモは個人ファイルから分離
	・城壁ステバグ修正
	・恩賞　伝説と被らないように...。
	・侵攻防衛の判定変更(守備:武将滞在都市で勝利、もしくは自国で 侵攻:相手国、都市間で)
	・支配回数、城壁削り数、ランキング名称＆見やすく
	・攻勢発動率かなり下げるか上昇威力下げる($klea/12)
	・鼓舞、扇動、徴募、強襲、足止め、包囲など金使うのコスト減らす(半額)、7%15%
	・内政特化計略特化(鍛錬特化?)威力うp(鍛錬特化は+4、内政特化は+*0.2)
	・恩賞と城壁削り、支配回数カウント確認
	・移動大移動P+3
	・admin.cgiの整理
	・削除までのターン数54
	・コマンド最大数126
	・出兵を出城と表記
	・弩兵弓兵能力変更
	・統一後は建国できなく
	・武官新スキル:侵攻スキル
	Ver.0.66
	・宣戦布告システムmydata/king_com,sensen,hukoku satus,i-staus,ranking battlecm/battle,sekisyo
	・status.cgiコマンド欄の時刻が時々おかしいの修正
	・文官用仁官用支援スキル、妨害スキル効果時間増加　確率上昇（歩兵援護導入したら効果時間下げたほうがいいかも）
	・国宛件数、手紙保存件数変更
	・状態:攻勢,密集(猛攻の処理)の説明変更
	・説明書、チュートリアル改訂
	fix
	・BMで自動的にJSで行動可能時間、移P補充、陣形変更までの時間カウントダウン bm系&mydata.pl,mydata.cgi,alert.pl
	・bm行動系ENEMY_OPEN使用と確率
	・スマホバルーンにも対応 jqballun.css,jquary.js使用
	バルーン使用箇所(status.cgi,newbm.cgi,log.cgi, mylog.chi,mycou.cgi,mycou2.cgi,  ranking.cgi,rankng2.cgi suport.pl)
	国色RGBA追加index.ini
	・NPC撃破報酬(金&SP取得確率up) 説明書:農民の反乱にNPCのこと書く、設定の加筆
	・個人プロフファイル分離？ mydata.pl,mee2.pl,新ディレクトリ,menu.cgi i-status.cgi,reset.cgi,check_com.cgi
	Ver.0.67
	・スキル退却時はサブルーチン化(lib/skl_lib.pl)
	退却使用 battlecm.cgi battlecm/taikyaku.pl/idou.pl/battle.pl mydata/king_com4.pl exe_com/taikyaku.pl
	・バグfix 足止め:移P0になってなかったの newbm,status:BMpopup状態表示したときpopupでないの battle.pl:勝利回数防衛回数のカウント以前のままだったので修正
	・専用Bにage機能追加
	・new_chara.cgiの表示コマンド数60に,デフォでBM表示
	・歩兵に掩護スキル追加:battle.pl,engo.pl,battlecm.cgi,myskl.pl,myskl2.pl,lib/skl_lib.pl,manual.html,command/get_sol.pl,exe_com/get_sol.pl,bm系,memo.cgi,reset.cgi
	・兵種計算関数化(hs_keisan.pl削除,lib/hs_keisan.pl追加 bm系&battle.pl,mydata.pl,i-status.cgi,mycou2.cgi
	・強襲効果微妙に上昇。
	・統一後史記の自動更新 battle.pl lib/rekisi_kiroku.pl
	ver.0.68
	・説明書:行動待機時間について追記(完了)
	・巡察コマンド追加(完了)
	・UI変更(完了)
	*兵士防御力あげる(歩対騎で想定)(設定完了)
	・テスト鯖設置(リセットのみ)
	・tool-tipをttをjqueryで開発(完了)
	・兵種能力変更適応(完了)
	・cssファイルの名前(base.css)、jquellyのヴァージョンアップ(2.13)
	・説明書に推奨環境
	ver.0.69
	・統一後史記の自動更新 バグ修正 ok
	・波状攻撃効果上昇、攻勢、密集の効果下げ 確認
	・※イベントが発生した戦闘のみ云々削除
	・人望用スキル移動補助追加 kinto.pl,kasoku.pl,syukuti.pl,battlecm.cgi,menu.cgi,check_com.cgi
	・bm系setintarver１つにまとめて軽くする 完了
	・bmのpopup少し大きくする
	・idou.plの修正_kinto    デバッグ
	・説明書追記 筋斗雲状態、スキル 完了


Ver.0.7x 運営中、軽量化とBM自動化の実現、HTML5化、各官のコンセプトを考えたスキル構成


	ver.0.70
	・キャラデータ整理、効果防具＆書物追加 　書物：内政での成長スピードが早い書物、農業特化の書物　防具:歩兵使用時、騎兵使用時防御力up　武器:攻城用武器
	suport.pl,i-suport.pl 完了
	log_file/arm,bou,pro.cgi 完了
	command/arm.pl,bou.pl,pro.pl,完了
	check_com.cgi,myskl,myskl2 完了
	battle.pl,防具実装,回避実装 完了
	com/内政、計略系
	特殊書物値段上昇、スキル説明,あと計略系の確認 完了css 文字サイズcss 文字サイズ
	・bmの操作楽に メニュー削除完了
	 あと、カウントダウン部分の改修(status,i-newbm)、レイアウト再変更(newbm) 完了
	BM表示の設定項目増やすmydata.pl,indbm.pl,status.i-status　完了
	アップロードするの:readme,battlecm,newbm,status,i-newbm,suport(コマンド入力抜いて),index,i-status
	mydata/mydata.pl,jinkei.pl,indbm.pl,
	ini_file/index.ini
	fix 統一時建国の判定変更 log_file/touitu_flag.cgiに記録 check_com,exe/kenkoku.pl,reset.cgi,lib/rekisi_kiroku.pl
	ver.0.71
	・マップデータを多次元配列化し軽量化(BMを使用したものは全てプログラム変更)
	・無所属武将は無所属都市以外に向けて入城、出城不可テスト 完了
	改良したのアップデートする 完了
	ver0.72
	・ui変更 mapのtooltip変更 map_open.pl,status.cgi,base.css,suport.pl,com/get_sol.pl,new_bm.cgi
	REKISI/map系も修正
	・月末コマンド表示おかしい問題 修正
	・犠牲攻撃on/off実装 完了 myskl,myskl2,mydata.cgi
	・登録時、あらたにプロフィールと忠誠度の入力欄を追加(プロフィールは任意) entry.pl,new_chara.cgi
	・BMで出城する際の仕様を変更 城壁の高い敵国都市の城付近MAPからその国の他の都市へ攻めこもうとすると、城壁の多さに応じて移動P補充時間と行動待機時間が増えるようになります。 sekisyo.pl,bm系
	・最優先城の守備新MAPに対応 status,i-status,exe/tei.pl,mycou.pl, 完了
	・撤退時のメッセージがおかしいの修正./battlecm.cgi./exe_com/taikyaku.pl./battlecm/battle.pl./battlecm/taikyaku.pl./battlecm/idou.pl./lib/skl_lib.pl 完了
	・退却コマンド仕様変更→自領土なら兵士捨てない 完了
	・戦争時の報酬の見直し(NPC撃破時のSP入手確率減少、威力高い装備の成長値減少、獲得貢献値の減少、特別ボーナスの減少) 完了
	・城壁のスキルバグ多分修正　完了
	・城壁を少し強くします。 完了
	・足止めの成功率と範囲を強化 完了
	・加速の上限 完了
	・反乱後の行動制限、部隊の移動可能範囲、出城、迂回阻止度について説明書に明記 、下野についても 完了
	・兵士猛特訓が使用可能になる階級値上昇(50000)
	・建国コマンドの仕様変更 １人の武将に付き建国できるのは１回まで。(ただし登録時に建国した場合はカウントされません。) 建国後は部隊員は全員建国都市に移動。チェック完了
	・反乱の仕様変更 国民の忠誠度の平均が50以下の時に実行可能。階級値減少-1000、金米-20000。反乱成功時の部隊の位置は城壁地形以外のランダムな場所に。 チェック完了
	・君主、軍師、宰相全員がいない場合、国民が誰かが軍師になれる機能追加 あと実行部分を作れば チェック完了
	・攻城用弩のスキル実装してないじゃないですかヤダー、battle.pl 移動P補充時間増加の所　完了
	・陣形再編　再編時間を3/4にする　に 完了
	・entry.cgi BM表示方法を2(通常表示する)にする 完了
	・mycou.cgiのバグ 修正完了
	・batttle.plのバグ (統一歴史の記録がおかしい),bakcklist使用していないので削除 完了
	・携帯版i-statusの武将プロフバグ,i-newbmのプロフバグ,menu.cgiでBM時は詳細な情報を,陣形を変えるときのバグ,携帯で実際見た時のバ	グ 修
	・初心者向けのざっとした説明 syosin_1.html 登録時に表示
	・BM表示実行部分の文章
	・status,newbmのデザイン整理、css化（スマホの時はコマンドを選択しやすく） suport.pl,status.cgi,js/status.css
	fix
	・プロフ用バルーン　おかしくなっているので適応させる(status.cgi以外全部)
	・設定のところを整理(コマンド表示数の設定の削除)
	・最後admin.cgiのマップ生成機能削除
	・旧マップデータを削除　何かあれば旧verをupして作成
	ver.0.73
	・SP購入できるように skl_buy.pl
	・manual.html,ルールの変更(発言に関する禁止事項の変更、明確に定義付け)
	・設定のところのランキング NPC除外
	・BM行動予約を復活(戦闘のみ)
	・削除された時及びリセット時 autolist削除
	・反乱　無所属からの反乱は階級値減らない
	・城壁守備力微増
	ver.0.73fix
	・パーミッション設定しなおし
	/REKISI,/lock,/image,/js→755,それ以外のディレクトリ→700,後はスクリプトは604,CGIは755
	・exe_com/battle.plでバグ 不正なフォーム？
	→requireでマップ読み込まなかったのが原因,doに書き換え
	他にもexe/town_def,back_def,tei,tyousa,check_comも修正
	・関所の迂回阻止度のバグ修正(sekisyo.pl
	ver.0.74
	・BM自動モード
	自動移動を追加 auto_in.cgi,auto_com.cgi,auto_exe,auto_com/以下全部 完了
	スキル関係のサブルーチン化も(skl_lib.pl) 完了
	仕様変更
	・下野　階級-500、ブラックリスト非登録 完了
	・会心威力さげ 2倍→1.5　完了
	・城の上にいるときは徴兵できるように、徴兵失敗時の貢献値微増 完了
	・城壁がスキルを使うように(大体毎ターン2ダメくらいに調整) 完了
	・退却こマンドは、自軍が自領土にいるときのみ可能　完了
	・包囲の強化30人以下　完了
	・城壁耐久力の減少率抑える 完了
	・補給　自軍の兵士が統率の50%以上の時のみ使用可能。　完了
	説明書修正 完了
	ver.0.75
	・コマンドリスト保存機能,reset.cgi 完了
	ver..0.76
	移動待機時間、行動待機時間が来た時に音ならす　完了
	ver.0.77
	・スキルのMP化-士気化
	・士気の値設定　完了
	・bm系、スキル説明 完了
	・士気減少完了
	・説明書、　完了
	・昂揚→進撃 完了
	・status.cgi デザイン変更 完了
	・log.cgiもstatus.cgiと同じように 完了
	・通常コマンド入力でもコマンドリスト保存ができるように→この際リスト保存と同時に名前付けれるように 完了
	・コマンドリスト部分のcssにiosで滑らかにスクロールするcss入れる 完了
	・説明書　BM自動行動について 完了
	・NPCが反撃してくるように 
	fix
	・BMでの行動に時間帯制限つけるかをindex.iniで設定できるようにした
	・jcode.plの消去
	・米売り額増額
	・戦闘解除ターンの調整(2日ちょうど)
	・バグ:扇動あたりした時に攻城回数とかがリセット　修正
	fix2
  ・外部VPSからindex.cgiとauto_exe.cgiを定期的に叩くプログラム設置(Mojo::IOLoop)
  ・auto_exe.cgiからidou.plを実行した時のバグを修正
  fix3
  ・new_issue suport.plのTOWN_OPEN()を複数回使用したことにより、国の所属都市数がおかしくなり、結果ちゃんと滅亡しなくなるバグ
  発生状況: battle.pl を auto_exe.cgi から使用した時→一応修正、動作確認
  fix4
  ・status.cgiのレイアウト変更
  ・特殊書物の早期解放
  ・攻城兵の時は城壁スキルの発動率低下
  ・迂回阻止度の効果上昇
  ・変更履歴
  ・お知らせ
  fix5
  ・反乱コマンドの実行の際、chara_data_all_openされてなくて起こるバグを修正
  * 反乱コマンドのバグ修正(金米の制限が10000になっていた)
  * 戦闘解除前に城壁を攻撃した場合の、(xxターン) ってとこ、建国してからのターン数が表示されているので、戦闘解除期間 - 建国してからに変更
  ・混乱成功上限60%, MP -20
  * 短縮布告のマップログ表示、年表示がおかしいので(+965しない)
  ・進撃の攻撃上昇率を 30 -> 25%, 使用後の守備力減少率を 30% -> 50%に
  * 統一後、無所属武将は無所属都市以外の都市へ向けて出城できるように
  * 米売り額3万
  * 統一後、ブラックリストに登録されていても仕官可能

特殊書物の追加
BMで時間不足のエラー起きた時はautocom_writeしない,説明書きに追加
敵武将オープン時にエラー

統率官以外で統率力があがりやすいように...(ボーナスとかで)
・map_hash読み込み時の初期化(check_com,auto_exeのループ内の最初に @BM_TIKEI=(); を宣言)

改造推進点
・HTML5化を少しづつ進めていく
・BMでの距離測る時にabs関数使っていく
・コマンド入力楽に→ajaxかiframeで？
・BM自動モードの開発(行動の追加)
・コンセプトを意識してスキルを考える
[人官用に成功率や効果時間をあげるスキル追加するかも、統率＆人望用に回復主体のスキル]
・手紙の所リアルタイムチャットにしちゃえ(BM,手紙にajax)
・status.cgi jsとcssをなるべく別ファイルに分離,


・アイコン画像形式なんでもいけるように、画像upろだのperl化


#それ以降
戦闘回数50回毎に攻守強化スキル
援軍システム
reset.cgi,backup.plなどをlibディレクトリにまとめる
・軽量化 武将一覧の配列 出撃していないのは排除する(newbmで実験したところ、2ミリ秒しか処理時間短くならなかった)
・ゲームの紹介、トップページ的な？


#もっとあとに
	^戦闘チュートリアル
	*データ整理して軽量化&わかりやすく（兵種のとこなど）
	*武器スキル充実　初期武器を威力120まであげるとスキル覚える
	*初期　属性武器選択可能?
	*多重対策強化
	・兵種スキル、罠スキル、成功率や効果を上げるスキル、隠密＆索敵スキル
	・普通の戦闘とは関係ないmap(泰山などのダンジョンマップ)
	・伝説の急造拠点建築みたいのを可能に(生産コマンド、煉瓦生産などでストック、新拠点に資源移動で城壁構築


	
	#バグ
	・キャラ登録 更新マイナスの時更新時間しばらく変に new_chara.cgi
	・更新時間00:00のときstatus.cgiのコマンド月表示がおかしくなる?
	・城壁のステ　城壁の上に武将がいないか検索した最後のが反映されてるぽいので注意

	#細かすぎるので対応してないバグ
	・graph.cgiで0人の国があった場合にいくつかのグラフでカーソル乗っけても数値が出てこなくなる
	・携帯版bmpopup(menu.cgi) 掩護のアイコンは面倒なので出していない
	・なぜか専用bbsなどのメールお知らせ機能が機能していない


	#それ以外の予定
	武将でーたいがいのバックアップ自動復旧？
	チャットルーム追加（commet?[vita]）
	携帯版(後司令部、スキル関連)
	名将、個人のランキング項目増やす？国武将データ一覧で並び替え付け加え?


守備システム変更?
徴募敵都市でできないようにする？
バックアップ、自動復旧あたりは重いのでバックアップフラグファイルにlockかけて、万が一の場合はfork使用考える


Ver.0.6 軽量化、安定化、多重対策、バックアップなど,低ON者対策システム(BM自動モード)

Ver.0.7 アイテム、国庫（施設）の追加


