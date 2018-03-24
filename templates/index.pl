use Jikkoku;
use Jikkoku::Template;

my $layout = take_in 'templates/layouts/default.pl';

sub {
  my $args = shift;
  my ($announcements, $game_conf, $game_date, $game_record, $login_list, $map_logs, $history_logs, $cache_id, $cache_pass)
    = map { $args->{$_} } qw( announcements game_conf game_date game_record login_list map_logs history_logs cache_id cache_pass );
  my $this = sub {
    qq{
<table width="100%" cellpadding="0" cellspacing="0" border="0"
  style="margin-top: 5px"
>
  <tr>
    <td valign="top" align="left">[<a href=./i-index.cgi>携帯用</a>]</td>
    <td align="right">
      <!-- twitter -->
      <a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
        <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
       <!-- hatena! -->
       <a href="http://b.hatena.ne.jp/entry/lunadraco.sakura.ne.jp/sangokuframe/index.cgi" class="hatena-bookmark-button" data-hatena-bookmark-title="十国志NET" data-hatena-bookmark-layout="simple-balloon" title="このエントリーをはてなブックマークに追加"><img src="https://b.st-hatena.com/images/entry-button/button-only\@2x.png" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a>
       <script type="text/javascript" src="https://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>
       <!-- google plus -->
       <script src="https://apis.google.com/js/platform.js" async defer>
         {lang: 'ja'}
       </script>
       <div class="g-plusone" data-size="medium"></div>
       <!-- twitter link -->
       <a href="https://twitter.com/jikkokunet" class="twitter-follow-button" data-show-count="false">Follow \@jikkokunet</a>
       <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
      </td>
    </tr>
  </table>

  <center>
  <table width="100%" height=100% cellpadding="0" cellspacing="0" border=0>
    <tr>
    <td align=center valign=top>
      <br>
      <br>
      <table border=0 width="90%" height="100%" cellspacing=1>
        <tbody>
          <tr>
            <td align=center width="20%">
              <table cellspacing=5 class="midasi2">
                <tr>
                  <td align="center">■メニュー■</td>
                </tr>
                <tr><td>&nbsp;</td></tr>
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
      join '', map {
        my ($url, $link_name) = @$_;
        qq{
          <tr>
            <td bgcolor="#ffffff" class="maru2">
              ●<a href="$url" target="_blank">【$link_name】</a>
            </td>
          </tr>
        };
      } @$url_and_link_name_pairs;
    } . qq{         
                <tr><td>&nbsp;</td></tr>
                <tr>
                  <td align="center">
                    ログイン人数：@{[ scalar @$login_list ]}人
                  </td>
                </tr>
                <tr>
                  <td align="center">
                    最大登録人数($game_conf->{max_chara}人)
                  </td>
                </tr>
              </tr>
            </td>
            </table>
  
            <br>
            <br>
            <table bgcolor=#6d614a align=center border=0>
              <form action="/chara/mypage" method="POST">
                <input type="hidden" name="mode" value="STATUS">
                <tr>
                  <th bgcolor="#F0F0F0" height=5>USER ID</th>
                  <td><input type="text" size="10" name="id" value="$cache_id"></td>
                </tr>
                <TR>
                  <TH bgcolor="#F0F0F0" height=5>PASS WORD</th>
                  <td><input type="password" size="10" name="pass" value="$cache_pass"></TD>
                </TR>
                <tr>
                  <td colspan="2" align="left">
                    <input type="checkbox" name="cookie" value=\"yes\">ID、パスワードを保存する
                  </td>
                </TR>
<TR><td bgcolor=#cbba9e align=center colspan=2><input type="submit" id="input" value="ログイン"></td></tr></form>
<TR><td align="center" bgcolor="#F0F0F0" colspan="2"><a href="./idpw.cgi">【ID、パスワードを忘れた方】</a></th></TR>
</table>

</TD><TD align=center width="80%">
<p><TABLE width=95% height=140 bgcolor=#6d614a>
<TR>
  <TD align=center bgcolor=#cbba9e>
  <h1>
    <br>
    <font color=#6d614a>$game_conf->{title}</font>
  </h1>
  <p>
    <h2><font color=#6d614a>@{[ $game_record->period ]}</font></h2>
  </p>
<br>
<b>更新時間、BM行動可能時間：19:00～24:59</b>
<br>

<br><font size=2 color=#6d614a><B>[@{[ $game_date->date ]}]</b><BR>次回の更新まで <B>@{[ $game_date->min_until_next_update ]}</B> 分<BR></font>

<br>
<table><tbody>
<TR><TD><div class="midasi4"><b><font size="2">&nbsp;お知らせ</b></font></div></TD></TR>
<tr><td class="osirase2">
<div class="osirase">
    } . do {
      join('', map {
        qq{
          <hr class="kugiri">
          <table cellspacing="0">
            <tr>
              <td style="vertical-align: top; margin-right: 5px;">
                ●@{[ $_->time ]}
              </td>
              <td>@{[ $_->message ]}</td>
            </tr>
          </table>
        }
      } @$announcements) . qq{
        <hr class="kugiri">
        <table cellspacing="0">
          <tr>
            <td></td>
            <td>・これ以上前のお知らせは<a href="003.html" target="_blank">こちら</a>。</td>
          </tr>
        </table>
        <hr class="kugiri">
      };
    } . qq{
</div>
</td></tr></tbody></table>
<br>

</TD></TR></TABLE>

</TD></TR>
<TR><TD colspan="2" align=center valign="top" width=100%>

<br>
<table width=100% bgcolor="#f0f0f0" cellspacing=1 id="small"><tbody></tbody></table>
<table width=90%><TR><TD>
<CENTER><HR size=0><p align=right>[<font color=8E6C68>TOTAL ACCESS<font color=red><B> @{[ $game_record->access_count ]} </font></B>HIT</font>]</p>
</TD></TR>
<TR><TD colspan="2"><div class="midasi3"><b><font size="2">&nbsp;MAP LOG</b></font></div></TD></TR>
<TR>
  <TD bgcolor=#cbba9c colspan="2" width=80% height=20 class="maru">
    <font color=#6d614a size=2>
    } . do {
      join "\n", map { qq{<font color="#008800">$_</font><br>} } @$map_logs;
    } . qq{
    </font>
  </TD>
</TR>
<TR><TD colspan="2"><div class="midasi3"><b><font size="2">&nbsp;史記</font></div></b></TD></TR>
<TR>
  <TD bgcolor=#cbba9c colspan="2" width=80% height=20 class="maru">
    <font color=#6d614a size=2>
    } . do {
      join "\n", map { qq{<font color="#008800">$_</font><br>} } @$history_logs;
    } . qq{
    </font>
  </TD>
</TR>
</table>
<br>
<br>
</TBODY></TABLE>
</TR></TD></TABLE>
</TR></TD></TABLE>

<form method=post action=./admin.cgi>
ID:<input type=text name=id size=7>
PASS:<input type=password name=pass size=7>
<input type=submit id=input value=管理者>
</form>
    };
  };
  $layout->($this, $args);
};
