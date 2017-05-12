# 十国志NET Server Side 規約

# 使用言語, モジュール
* 言語                 : Perl
* クラス作成           : Mouse
* WAF                  : 独自作成(Jikkoku::Web) (ルーティングには Rooter::Boom を使用)
* 例外処理             : デフォルト(eval - if)
* 引数チェック         : Hash, HashRef -> Jikkoku::Util::validate_values, 普通の引数 : if - Carp::croak
* テンプレートエンジン : 使用せず, CodeRef を組み合わせて近いものを実現

# 用語

## chara, charactor
プログラム内でのゲームのユーザーのことを指す  
元々の三Nのプログラム内でのユーザーの呼称がそのようであったことに由来する。。  

## result class 
例えば、ArrayRefで返却された値を、受け取った側で加工したい場合がある場合に作るクラス  
帰ってきたArrayRefをgrep, mapとかで加工したい場合があるとする, でもそのコードを  
いちいち書くのはDRYでなく、Model側などでメソッドとして用意したいところ  
しかし、Model側にメソッドとして用意しようとするとキャッシュする必要が有り、  
キャッシュの管理が大変  
resultクラスはそのような問題を解決する  

## service class(仮)
手続き的な処理(具体的な処理)を行うためのクラス  
Service層, Web::Controller層などが該当する  
処理を実行するためのメソッドや、処理が実行できるか確認するようなメソッドなど、少ないメソッドで構成される  
インスタンス変数は, メソッドをまたいで使いたいModelオブジェクトの変数などが入り、Read Onlyになっている  
もしくは、メソッドをまたいで使いたい変数が少なければクラスメソッドとして処理を実装しても良いだろう  
そのあたりはもう少し実装したりしつつ考える必要がある, 現状ではnewして使う方針ですすめる  
実行したい処理が完了すれば,service classのインスタンスは即座に破棄される(してもよい)  

# クラス作成についての規約
* 出来る限りロール, 委譲, 継承を利用してDRYにすること  
* インスタンス変数は、出来る限りオブジェクト生成時に値を代入し, 一度代入した値はRead Onlyにすること  
  -> Read Only にできない場合は, Result Class, Domain Class の作成を検討する  
* メソッドは、出来る限りそのインスタンスのみに関連する情報のみを扱うようにすること  
  -> 例えばCountryクラスからmembersメソッドが生えていて,Countryに所属する全てのCharactorを取得できるようなメソッド  
     Charaクラスからcommandメソッドが生えていて、CharactorのCommandが取得できてしまうようなメソッドは実装すべきでない  
     代わりに, 前者ならModel::Chara->get_all_with_result -> Result->get_charactors_by_country_id で取得し、  
     後者ならModel::Chara::Command->get($chara->id) -> command->get(10) のようにする  
  -> なぜそうするかというと、そのようなメソッドを作り始めるときりがない上に、オブジェクト指向の原則に反し複雑性は増すため  
  -> メタメタでいろいろDBでよしなにしてくれるようなAniki, Active Record のようなORMを使っているのならそのようなメソッドが生えてきても便利だし  
     管理もしんどくないが十国志NETではそもそもDB使わないしDB以外の様々な永続記憶装置を使って整合性を取るのが非常に大変なので  
     そんなことしたくないっていうもある  
* 親クラスのメソッドをoverrideするときはoverride & super method modifier を使うこと
  -> 例外として,overrideされていない親クラスのメソッドを呼び出したい時にのみ, $self->SUPER:: を使う(Jikkoku::Web::Controller::Chara::Base 参照)
* 消費ロールのメソッドをoverrideするときはaround method modifier を使うこと

# パッケージ構成について

## Jikkoku::Class
アプリケーション中で使用するオブジェクト群  

## Jikkoku::Model
アプリケーション中で使用するオブジェクトを管理するモジュール群  

## Jikkoku::Web
WEBアプリ本体  

