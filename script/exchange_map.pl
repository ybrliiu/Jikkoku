# 旧マップデータから新マップデータに変換

use v5.24;
use warnings;
use Path::Tiny;
use Data::Dumper;
local $Data::Dumper::Sortkeys = 1;
use Perl::Tidy;

my $BM_DATA_DIR = '~/perl5/dev/sangokuframe/log_file/map_hash/';

my $iter = path( $BM_DATA_DIR )->iterator;
while ( my $path = $iter->() ) {
  if ($path =~ /.pl$/) {
    stock_data( $path );
  }
}

our ($battkemapname, $BM_X, $BM_Y, @BM_TIKEI, $BM_TIKEI);
sub stock_data {
  my ($path) = @_;
  # localiaze global value
  local ($battkemapname, $BM_X, $BM_Y, @BM_TIKEI, $BM_TIKEI);
  my $id = (split /\//, $path)[-1];
  $id =~ s/.pl//;
  require $path;

  my %sekisyo;
  for my $i ( 0 .. $BM_Y - 1 ) {
    for my $j ( 0 .. $BM_X - 1 ) {
      if ( defined $BM_TIKEI->[$i][$j]{sekisyo} ) {
        my ($target_bm_id, $target_town_name, $target_bm_name) = split /,/, $BM_TIKEI->[$i][$j]{sekisyo};
        $sekisyo{"$i,$j"} = +{
          y                => $i,
          x                => $j,
          target_town_name => $target_town_name,
          target_bm_id     => $target_bm_id,
          target_bm_name   => $target_bm_name,
        };
      }
    }
  }

  my $map_data = {
    $id => {
      id           => $id,
      name         => $battkemapname,
      width        => $BM_X,
      height       => $BM_Y,
      map_data     => \@BM_TIKEI,
      check_points => \%sekisyo,
    }
  };
  my $dump = Dumper $map_data;
  $dump =~ s/\$VAR1 = //;
  output_tidy($id, $dump);
}

sub output_tidy {
  my ($id, $source_string) = @_;
  my ($dest_string, $stderr_string, $errorfile_string);
  my $error = perltidy(
      argv        => '-l=140',
      source      => \$source_string,
      destination => \$dest_string,
      stderr      => \$stderr_string,
  );

  say $dest_string;
  path("../etc/battle_map_data/${id}.pl")->spew($dest_string);
}

