use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use_ok 'Jikkoku::Util';
use Jikkoku::Util qw/escape unescape/;

subtest 'escape' => sub {
  is escape('<h1>not allow</h1>'), '&lt;h1&gt;not allow&lt;/h1&gt;';
  is escape("<a>url:http://google.com name:リンク</a>"),
    '<a href="http://google.com">リンク</a>';
  is escape(qq{<a href="url>name</a>}),
    '&lt;a href=&quot;url&gt;name&lt;/a&gt;';
  is escape('<red>赤文字</red>'), '<span style="color:red">赤文字</span>';
  is escape('<b>太文字</b>'), '<b>太文字</b>';
  is escape('<black>失敗'), '&lt;black&gt;失敗';
  is escape('head<blue>青文字</blue>tail'),
    'head<span style="color:blue">青文字</span>tail';
  is escape('1<red>赤</red>2<blue><sub>青</sub></blue>3'),
    '1<span style="color:red">赤</span>2<span style="color:blue"><sub>青</sub></span>3';
};

subtest 'unescape' => sub {
  is unescape('<a href="http://google.com">リンク</a>'),
    '<a>url:http://google.com name:リンク</a>';
  is unescape('<span style="color:red">赤文字</span>'),
    '<red>赤文字</red>';
  is unescape('&lt;a href=&quot;url&gt;name&lt;/a&gt;'),
    '&lt;a href=&quot;url&gt;name&lt;/a&gt;';
  is unescape('1<span style="color:red">赤</span>2<span style="color:blue"><sub>青</sub></span>3'),
    '1<red>赤</red>2<blue><sub>青</sub></blue>3';
  is unescape('head<a href="url"><red>name</red></a>middle'
    . '<blue><a href="url">name</a></blue>end'),
     'head<a>url:url name:<red>name</red></a>middle'
    . '<blue><a>url:url name:name</a></blue>end';
};

subtest 'is hour in basic' => sub {
  ok not Jikkoku::Util::is_hour_in(19, 20, 24);
  ok Jikkoku::Util::is_hour_in(20, 20, 24);
  ok Jikkoku::Util::is_hour_in(22, 20, 24);
  ok Jikkoku::Util::is_hour_in(23, 20, 24);
  ok not Jikkoku::Util::is_hour_in(24, 20, 24);
};

subtest 'is hour in overdated' => sub {
  ok not Jikkoku::Util::is_hour_in(18, 19, 1);
  ok Jikkoku::Util::is_hour_in(19, 19, 1);
  ok Jikkoku::Util::is_hour_in(23, 19, 1);
  ok Jikkoku::Util::is_hour_in(0, 19, 1);
  ok not Jikkoku::Util::is_hour_in(1, 19, 1);
};

SKIP : {
  skip "時間により結果が変わるので", 1;
  ok Jikkoku::Util::is_game_update_hour();
};

done_testing;
