
# やること

## 戦闘プログラム作成中

* battle_event_executer skill 実装  
  * 計数攻撃, 破壊攻撃, 犠牲攻撃, 会心攻撃 実装完了
  * 猛攻 実装完了
  * 突撃, 攻勢, 密集
    * スキル作成 実装完了
    * event executer service 実装完了
    * 陣形再編 service 実装完了
    * skill category command 実装完了

    * event executer Role化
    * Roleの使用箇所明確化(衝突するかどうか, すればドキュメントに記載)
    * event executer テスト
    * 陣形再編service テスト
  * 回避
  * 離間
  * 米俵, 短百, マンリ, キブン
  * 波状攻撃
  * それぞれのスキルのテスト
* 戦闘開始前のイベントロールもいる(強襲の戦闘開始前イベントとか)

* 戦闘後処理
* Battle 攻城戦は拡張した別クラスで作成(is_siege => 0)
* 攻城時のみ効果発動するスキル(Battle->is_siege)

* CharaPower test

## 修正箇所

既存のプログラム関係
  * stuck skill つかえるようになっていない
  * 犠牲攻撃のON/OFFは_config{is_sacifice_attack_available}の値で決定するようになっている
  * 会心攻撃 最大ダメージ2倍に(あわせて新スキルの説明も変える)

Class層
  * C::Chara set value exception & use trigger
  * Skill UsedInBattleMap::DependOnAbilities abilities_sum は lazy_buildにしてしまう
  * BattleMAp書き換え,service化, Extend class作成

Model層
  * 非Mouse Class 書き換え
  * Model::Role::TextData::Integration::Expiresの利用

* 相互に依存してしまっているモジュールを切り離す

戦闘,BattleActionが終わったら
コマンド作成
コマンド実行部分作成
BM自動モード作成
とりま完成

# 最終目標
スキルは全て書き換え
戦闘行動を全て書き換え
スキルの症状のボーナスを効果発揮時に変更
バトルマップ部分を書き換え

# テスト
* 初期仕官制限
  新規登録
  仕官コマンド
  寝返り
  あと、これらのエラー表示をわかりやすく
* 相討ちのテスト　都市支配時

# 時間があれば
* バトルマップ別のログを導入
* 反乱は考える
* 説明書に兵種について追記, 解放階級などを記入

## bug
* NPCのバグ
* bm_id がおそらく自動モードの時に突如として消えることが, なぜ?

# 予定

* NPCとの戦闘時のバグ
-> 暫く放置, 作りなおす

* 期中の仕様変更に関するガイドラインを作成
* 期変更時のガイドラインを作成

## MEMO

* 戦闘時,スキル毎にメッセージ出させるなら
  WriteToLog Roleを実装, Service class を作ってBattleLoop開始前に呼び出し

# commit / abort / lock について
* lock = トランザクション開始でだいたいあってる
* class 単位で分割されていない場合
object に対して 失敗時abort, 成功時何もしない
  (途中までの変更を一時保存して、abortで一時保存時点に戻りたい場合
    update_textdata -> abort で実現可能だが、使用箇所があるか不明)
* model にたいして 中身触る前に lock -> commit or abort
class 単位で分割されている場合
object に対して lock -> commit or abort

# 設置方法
* Mouse は鯖上でコンパイル
* perl Build.PL
* ./Build
* コンパイル時にバージョンが低くて上手くいかないので、最新バージョンのをローカルにおいて先に明示的に読み込ませる
* コンパイルしてできたものは blib/arch/Some/Module/... にある
* それを extlib/ 直下に移動

# 最終目標
* write test
* Diplomacy の year を elapsed_year に変更する(誤解をさけるため)
* scssの整理
* Jikkoku::Rooter Nodeオブジェクトに直接デフォルトルートを書き込む
* Jikkoku::Template テンプレート自動選択

