# モデル層設計

## 共通
* 複数のclass層のオブジェクトを管理するための層
* get method でデータを取得, ただし出来る限り要素の修得にはget_with_optionを利用すること
* get_all method でデータを取得
* 複数のインスタンスを取得するメソッドの名前は get_***_towns_by_*** のような感じで
* 条件に合うインスタンスがあるかどうかをしらべるメソッドの名前は has_***_towns 

## Model::Integration
* 1つのファイルで複数のデータを管理しているファイルの為のモデル
* with Role::FileHandler のため、lock, commit, abort が可能
* Integration は特性上resultクラス的な特徴も持つので, viewにそのまま渡しても良い。

## Model::Division
* 1つのディレクトリで複数のデータを管理しているデータのためのモデル
* 複数のデータを更新するとget_allの時に不整合が発生する問題
* foreach method でファイル読みこむたびに
  - lock はファイルごと=インスタンスごとに
  - これでデータ整合性の問題は特にないはずです
* get_all
* get_all_with_result 
  -> get_allの結果を取得した側で加工したい場合や, キャッシュ化したい場合に利用(後述)

## Model::Division::Result
* Model::Division::*_with_result で帰ってくるクラス
* 例えば、ArrayRefで返却された値を、受け取った側で加工したい場合とかに使う
* 帰ってきたArrayRefをgrep, mapとかで加工したい場合があるとする, でもそのコードを
  いちいち書くのはDRYでなく、Model側にメソッドとして用意したいところ
  しかし、Model側にメソッドとして用意しようとするとキャッシュする必要が有り、
  キャッシュの管理が大変
  resultクラスはそのような問題を解決する


