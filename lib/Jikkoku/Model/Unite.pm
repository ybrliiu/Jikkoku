package Jikkoku::Model::Unite {

  use v5.14;
  use warnings;
  use Jikkoku::Util qw/open_data save_data/;

  use constant FILE_PATH => "log_file/touitu_flag.cgi";

  sub is_unite {
    my $is_unite = open_data( FILE_PATH )->[0];
    return $is_unite + 0;
  }

  sub unite {
    save_data(FILE_PATH, [1]);
  }

  sub separete {
    save_data(FILE_PATH, [0]);
  }

}

1;

__END__

=encoding utf8

=head1 NAME

  Jikkoku::Model::Unite - ゲームが統一されているかどうかを記録するファイルを扱うモジュール

=cut

