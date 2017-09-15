use v5.24;
use warnings;
use utf8;
use Encode;
use Path::Tiny;
use lib './lib', './extlib';
use Jikkoku::Model::Announce;

use constant {
  ORIGIN_PATH => 'script/tmp/announce_log.txt',
};

my $log = Encode::decode_utf8( path( ORIGIN_PATH )->slurp );
$log =~ s/\n/<br>\n/g;
my @logs = split /\n/, $log;
my @new_logs = ();
my $tmp = '';
for (@logs) {
  if ($_ =~ /●/) {
    push @new_logs, $tmp;
    $tmp = substr($_, 1);
  } else {
    $tmp .= $_;
  }
}

my @hash_list = map {
  my @splits = split /　/, $_;
  @splits = map { Encode::encode_utf8($_) } @splits;
  +{
    time    => $splits[0],
    message => $splits[1],
  }
} @new_logs;

shift @hash_list;

my $model = Jikkoku::Model::Announce->new;
@hash_list = reverse @hash_list;
$model->init;
$model->add($_) for @hash_list;
$model->save;

