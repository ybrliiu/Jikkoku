use Jikkoku;
use Jikkoku::Template qw( take_in );

my $layout = take_in 'templates/layouts/default.pl';

sub {
  my $args = shift;
  my ($announcements, $game_conf, $game_date, $game_record, $login_list, $map_logs, $history_logs, $cache_id, $cache_pass)
    = map { $args->{$_} } qw( announcements game_conf game_date game_record login_list map_logs history_logs cache_id cache_pass );

  my $this = sub {
    qq{
<div class="grid-around">
<header>
  <div id="header">
    <h1>$game_conf->{title}</h1>
    <h2>@{[ $game_record->formatted_period ]}</h2>
    <br>
    <strong>[@{[ $game_date->date ]}]</strong><br>
    次回の更新まで <strong>@{[ $game_date->min_until_next_update ]}</strong> 分<br>
    <br>
  </div>
</header>
</div>

<div class="grid width-20pc">

  <nav>
  <ul id="menu">
    <li class="not-list"><h2>■メニュー■</h2></l
  } . do {
    my $url_and_link_name_pairs = [
      [ '/', 'HOME' ],
      [ '/forum', '専用BBS' ],
      [ '/register', '新規登録' ],
      [ '/charactor-list', '登録武将一覧' ],
      [ '/ranking', '名将ランキング' ],
      [ '/compere-country-power', '国力比較' ],
      [ '/map', '勢力図' ],
      [ '/documents', '説明書' ],
      [ '/unified-history', '歴代統一国' ],
      [
        'https://github.com/ybrliiu/Jikkoku/blob/master/spec_change_log.md',
        '変更履歴'
      ],
      [ '/???', 'テスト面' ],
      [ 'https://www9.atwiki.jp/jikkokusinet/pages/1.html', '十国志NETwiki' ],
    ];
    join "\n", map {
      my ($url, $link_name) = @$_;
      qq{<a href="$url"><li>【$link_name】</li></a>}
    } @$url_and_link_name_pairs;
  } . qq{
  </ul>
  </nav>

</div>

<div class="grid width-60pc">

  <div>
    <div class="subhead"><h2>お知らせ</h2></div>
    <div class="show-log-wrapper background-white">
      <div class="show-log scroll">
  } . do {
    join("\n", map {
      qq{
        <table>
          <tr>
            <td>●@{[ $_->time ]}</td>
            <td>@{[ $_->message ]}</td>
          </tr>
        </table>
        <hr class="botted-line">
      };
    } @$announcements) . qq{
        <hr class="botted-line">
        <table>
          <tr>
            <td></td>
            <td>これ以上前のお知らせは<a href="003.html" target="_blank">こちら</a>。</td>
          </tr>
        </table>
        <hr class="botted-line">
    };
  } . qq{
      </div>
    </div>
  </div>

  <div>
    <div class="subhead"><h2>MAP LOG</h2></div>
    <div class="show-log-wrapper background-lightdarkred">
      <div class="show-log scroll">
  } . do {
    join "\n", map { qq{<span class="green">●</span>$_<br> } } @$map_logs;
  } . qq{
      </div>
    </div>
  </div>

  <div>
    <div class="subhead"><h2>HISTORY LOG</h2></div>
    <div class="show-log-wrapper background-lightdarkred">
      <div class="show-log scroll">
  } . do {
    join "\n", map { qq{<span class="green">●</span>$_<br>} } @$history_logs;
  } . qq{
      </div>
    </div>
  </div>

</div>

<div class="grid-right width-20pc">

  <div id="login-form">
    <form action="/player/login" method="post">
      <h2>■ログイン■</h2>
      <input type="text" size="10" name="id" value="$cache_id" placeholder="ユーザーID">
      <input type="password" size="10" name="pass" value="$cache_pass" placeholder="パスワード">
      <label class="snazzy-checkbox">
        <input type="checkbox" name="save-id-and-password" value="yes">ID、パスワードを保存する
        <span>ID、パスワードを保存する</span>
      </label>
      <input type="submit" value="ログイン">
    </form>
  </div>

  <div id="sub-info">
    <p>ログイン人数 : @{[ scalar @$login_list ]}人</p>
    <p>最大登録人数($game_conf->{max_chara}人)</p>
    <p class="red">総アクセス数 : @{[ $game_record->access_count ]}</p>
  </div>

</div>
    };
  };
  $layout->($this, $args);
};
