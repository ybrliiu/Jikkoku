
# やること

battle map の作成
 * timer (java script)

Model::* の Mouse化, 設計再構築(特に Chara::*
Role::Diplomacy Role::Tiny -> Mouse
Model::Role::TextData::Integration::Expires

Skill Model はキャッシュ有りでいいような気がしてきた(もう少し考える)
chara_model 新仕様のメソッドに切り替えてく
Chara::Soldier の利用

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
* qw// -> qw( ) (関数、メソッド)
* Mouse化!! (Class::TextData HashField も書き換えつつ)
  & ファイルを取り扱うロールのようなもの -> Base::TextData::Divison 相当, Modelにも使用可能
* Model::Player をちゃんとインスタンス化させる(全部)
* Diplomacy の year を elapsed_year に変更する(誤解をさけるため)
* scssの整理
* Jikkoku::Rooter Nodeオブジェクトに直接デフォルトルートを書き込む
* Jikkoku::Template テンプレート自動選択

