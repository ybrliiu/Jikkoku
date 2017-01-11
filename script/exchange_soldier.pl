# 旧兵士データから新兵士データに変換

use v5.24;
use warnings;
use Path::Tiny;

our (@SOL_TYPE, @SOL_PRICE, @SOL_ATUP, @SOL_DFUP, @SOL_TEC, @SOL_MOVE, @SOL_AT, @SOL_ZOKSEI, @SOL_LANK, @SOL_SETUMEI);
require 'tmp/soldier.pl';

my $soldier_data = "[\n";
for (0 .. $#SOL_TYPE) {
  $soldier_data .= <<"EOM";
  {
    id           => $_,
    name         => '$SOL_TYPE[$_]',
    type         => '@{[ soldier_id( $SOL_ATUP[$_] ) ]}',
    attr         => '$SOL_ZOKSEI[$_]',
    price        => $SOL_PRICE[$_],
    attack       => @{[ show_to_code( $SOL_ATUP[$_] ) ]},
    defence      => @{[ show_to_code( $SOL_DFUP[$_] ) ]},
    attack_show  => '$SOL_ATUP[$_]',
    defence_show => '$SOL_DFUP[$_]',
    move_point   => $SOL_MOVE[$_],
    reach        => $SOL_AT[$_],
    technology   => $SOL_TEC[$_],
    class        => $SOL_LANK[$_],
    skill        => [],
    description  => '$SOL_SETUMEI[$_]',
  },
EOM
}
$soldier_data .= "]\n";

my $file = path('tmp/new_soldier.pl');
$file->touch;
$file->spew( $soldier_data );

sub soldier_id {
  my ($attack_show) = @_;
  return do {
    if ($attack_show =~ /知力/) {
      '文官用';
    } elsif ($attack_show =~ /統率力/) {
      '統率官用';
    } elsif ($attack_show =~ /人望/) {
      '仁官用';
    } elsif ($attack_show =~ /武力/) {
      '武官用';
    } else {
      '武官用';
    }
  };
}

sub show_to_code {
  my ($show) = @_;
  $show =~ s/×/ * /g;
  $show =~ s/武力/\$_[0]->force/g;
  $show =~ s/知力/\$_[0]->intellect/g;
  $show =~ s/統率力/\$_[0]->leadership/g;
  $show =~ s/人望/\$_[0]->popular/g;

  $show =~ s/武器/\$_[0]->weapon_power/g;
  $show =~ s/書物/\$_[0]->book_power/g;
  $show =~ s/\+/ \+ /g;
  $show =~ s/＋/ \+ /g;

  $show =~ s/\(攻城時/, ('攻城時'/;
  "sub { $show }";
}

