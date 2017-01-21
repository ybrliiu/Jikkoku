use Jikkoku;
use Jikkoku::Template;

my $default = take_in 'templates/layouts/default.pl';

sub {
  my ($child, $args) = @_;

  push @{ $args->{CSS_FILES} }, 'country-color-table';

  my $this = sub {
    my ($chara) = ($args->{chara});

    my $mydata_button_origin = sub {
      my $top = qq{
        <form action="@{[ static_file('mydata.cgi') ]}" method="post">
          <input type="hidden" name="id" value="@{[ $chara->id ]}">
          <input type="hidden" name="pass" value="@{[ $chara->pass ]}">
      };
      my $bottom = qq{
        </form>
      };
      sub {
        my ($mode, $name) = @_;
        $top .
        qq{
          <input type="hidden" name="mode" value="$mode">
          <input type="submit" value="・$name">
        } .
        $bottom;
      };
    };
    my $mydata_button = $mydata_button_origin->();

    q{
      <script type="text/javascript">
        $(document).ready( function() {
      
          $("#menu li").hover(
            function () {
              this.style.backgroundColor = "#333333";
              this.style.color = "#EEEEEE";
              $(this).children('ul').animate({height: "show", opacity: "show"},{duration: "fast", easing: "swing"});
            }, function () {
              this.style.backgroundColor = "#EEEEEE";
              this.style.color = "#000000";
              $(this).children('ul').animate({height: "toggle", opacity: "toggle"},{duration: "fast", easing: "linear"});
            }
          );
      
        });
      </script>
    } . qq{
      <div id="menu">
      <div style="width:30px;height:30px;float:left;">
      </div>
      <li>▼ゲーム関連
        <ul>
        <li><a href="@{[ static_file 'index.cgi' ]}" target="_blank">・ゲームトップ</a></li>
        <li><a href="@{[ static_file 'bbs.cgi' ]}?name=@{[ $chara->name ]}&icon=@{[ $chara->icon ]}" target="_blank">・専用BBS</a></li>
        <li><a href="@{[ static_file 'manual.html' ]}" target="_blank">・説明書</a></li>
        <li><a href="@{[ static_file 'mydata.cgi' ]}?id=@{[ $chara->id ]}&pass=@{[ $chara->pass ]}&mode=ZATU_BBS" target="_blank">・雑談BBS</a></li>
        <li><a href="@{[ static_file 'entry.cgi' ]}?mode=RESISDENTS&id=@{[ $chara->id ]}&pass=@{[ $chara->pass ]}" target="_blank">・初心者向け説明</a></li>
        <li><a href="http://www9.atwiki.jp/jikkokusinet/pages/1.html" target="_blank">・十国志NETwiki</a></li>
        <li><a href="@{[ static_file 'REKISI/index.html' ]}" target="_blank">・歴代統一国</a></li>
        <li><a href="@{[ static_file 'aicon.cgi' ]}" target="_blank">・アイコン一覧</a></li>
        <li><a href="@{[ static_file 'rireki.html' ]}" target="_blank">・改造履歴</a></li>
        <li><a href="@{[ static_file 'manual.html#hatena' ]}" target="_blank">・困った時は</a></li>
        </ul>
      </li>
      <li><form action="@{[ static_file 'status.cgi' ]}" method="post"><input type=hidden name=id value=@{[ $chara->id ]}>
      <input type=hidden name=pass value=@{[ $chara->pass ]}><input type=hidden name=mode value=STATUS>
      <input type=submit value="マイページ"></form></li>
      <li>▼武将情報
        <ul>
          <li>@{[ $mydata_button->(MYDATA => '設定&戦績') ]}</li>
          <li>
            <form action="@{[ static_file 'auto_in.cgi' ]}" method="post"><input type=hidden name=id value=@{[ $chara->id ]}>
            <input type=hidden name=pass value=@{[ $chara->pass ]}>
            <input type=submit value="・BM行動予約"></form>
          </li>
          <li>@{[ $mydata_button->(MYSKL => 'スキル確認') ]}</li>
          <li>@{[ $mydata_button->(SKL_BUY => 'スキル確認') ]}</li>
          <li>@{[ $mydata_button->(UNIT_SELECT => '部隊編成') ]}</li>
          <li>@{[ $mydata_button->(BLOG => '戦闘ログ') ]}</li>
          <li>@{[ $mydata_button->(MYLOG => '行動ログ') ]}</li>
        </ul>
      </li>
      <li>▼手紙
        <ul>
          <li>@{[ $mydata_button->(LETTER => '個人宛手紙') ]}</li>
          <li><form action="@{[ static_file 'log.cgi' ]}" method="post"><input type=hidden name=id value=@{[ $chara->id ]}>
          <input type=hidden name=pass value=@{[ $chara->pass ]}><input type=submit value="・手紙ログ"></form></li>
        </ul>
      </li>
      <li>▼国家情報
        <ul>
          <li>@{[ $mydata_button->(COUNTRY_TALK => '会議室') ]}</li>
          <li>@{[ $mydata_button->(LOCAL_RULE => '国法') ]}</li>
          <li><form action="@{[ static_file 'mycou.cgi' ]}" method="post"><input type=hidden name=id value=@{[ $chara->id ]}>
          <input type=hidden name=pass value=@{[ $chara->pass ]}><input type=submit value="・国データ"></form></li>
          <li><form action="@{[ static_file 'mycou2.cgi' ]}" method="post"><input type=hidden name=id value=@{[ $chara->id ]}>
          <input type=hidden name=pass value=@{[ $chara->pass ]}><input type=submit value="・国の武将データ"></form></li>
          <li>@{[ $mydata_button->(KING_COM => '司令部') ]}</li>
        </ul>
      </li>
      <li>▼都市情報
        <ul>
        <li><form action="@{[ static_file 'mylog.cgi' ]}" method="post"><input type=hidden name=id value=@{[ $chara->id ]}>
        <input type=hidden name=pass value=@{[ $chara->pass ]}><input type=submit value="・滞在武将一覧"></form></li>
        </ul>
      </li>
      <li>▼ゲーム情報
        <ul>
        <li><a href="@{[ static_file 'map.cgi' ]}" target="_blank">・勢力図</a></li>
        <li><a href="@{[ static_file 'ranking.cgi' ]}" target="_blank">・登録武将一覧</a></li>
        <li><a href="@{[ static_file 'ranking2.cgi' ]}" target="_blank">・名将一覧</a></li>
        <li><a href="@{[ static_file 'graph.cgi' ]}" target="_blank">・国力比較</a></li>
        </ul>
      </li>
      </div>
        @{[ $child->() ]}
      };
  };

  $default->($this, $args);
};

