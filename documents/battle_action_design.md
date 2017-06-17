# Jikkoku::Class::Role::BattleAction 消費クラスに関する方針
* Class builder -> Mouse
* 説明文など、消費ロール側で返却値を次々に拡張するようなメソッドに対してはメソッドモディファイアを用いず、
  基底ロールで空メソッドを宣言し多態性で対応する
* 引数チェックや、例外をなげるメソッドの拡張には(ensure_can_execなど)
  メソッドモディファイアを利用して良い
* 具体的な処理に関してはFacadeパターンを適用したService Class を作成し,そこで行う

# Jikkoku::Service::Role::BattleAction
* BattleAction の処理を実装したクラス
* BattleAction 実行可能か検証するメソッド ensure_can_exec
* BattleAction 実行メソッド exec
* exec 及び ensure_can_exec 両方で利用する変数はインスタンス変数に格納する

