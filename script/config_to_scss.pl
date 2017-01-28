use v5.24;
use warnings;
use lib './lib', './extlib', 'script/lib';

use Config::PL;
use File::Generator;
use Jikkoku::Model::Config;

my $config = Jikkoku::Model::Config->get;

my $generator = File::Generator->new(
  store_path  => 'public/scss/',
  watch_files => [qw(public/scss/_country-color-table-base.scss)],
);
$generator->set_process('country-color-table.scss' => sub {
  my $len = @{ $config->{country_color} };
  <<"EOS";
/* 各国色テーブル */
// このファイルは @{[ __FILE__ ]} によって自動生成されています。

\@import 'country-color-table-base';

@{[ join '', map {
    ".table-$_ { \@include country-table-base("
      . "$config->{country_color}[$_], "
      . "$config->{country_background_color}[$_]"
      . "); }\n";
  } 0 .. $len - 1 ]}
EOS
});
$generator->generate;

