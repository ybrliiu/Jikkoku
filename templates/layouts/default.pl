use Jikkoku;

sub {
  my ($child, $args) = @_;

  my $font_size = $args->{font_size} || '9pt';
  my @JS_FILES = @{ $args->{JS_FILES} };
  my @CSS_FILES = @{ $args->{CSS_FILES} };

qq{
<!DOCTYPE html>
<html>
  <head>
    <meta name="description" content="戦略シミュレーションゲーム、十国志NETです。三国志NETの大幅改造版です。国を作り仲間と協力して大陸の統一を目指します。" />
    <meta name="keywords" content="十国志NET, 十国志, 三国志NET, ブラウザゲーム, オンラインゲーム, CGIゲーム, 無料, 戦略シミュレーションゲーム" />
    <link rel="shortcut icon" href="@{[  'favicon.ico' ]}" >
    <meta http-equiv="Content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <title>十国志NET</title>

    <script src="@{[  'js/jikkoku.js' ]}"></script>
    @{[ map { qq{<script src="} .  "public/js/$_.js" . qq{"></script>\n} } @JS_FILES ]}
    <link rel="stylesheet" href="@{[  'css/base.css' ]}">
    @{[ map { qq{<link rel="stylesheet" href="} .  "css/$_.css" . qq{">\n} } @CSS_FILES ]}
  
    <style type="text/css">
      table, table *, input, input *, button, button *, p, span, div, div * { font-size: $font_size; }
    </style>
        
  </head>
  <body>
    
    @{[ $child->() ]}

    <footer class="footer">
      <div>
        <p class="silver"> $args->{config}{game}{title} 第$args->{config}{game}{term}期 </p>
        <p class="silver">Jikkoku ver.$Jikkoku::VERSION</p>
        <p class="silver">開発者兼管理人 <a href="https://twitter.com/mp0liiu" target="_blank">liiu</a></p>
        <p><a href="@{[  'index.cgi' ]}">GAME TOP</a></p>
      </div>
    </footer>
  </body>
</html>
};
};

