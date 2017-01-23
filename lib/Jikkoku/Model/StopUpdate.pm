package Jikkoku::Model::StopUpdate {

  use Jikkoku;
  use Jikkoku::Util qw/open_data save_data/;

  use constant {
    FILE_PATH        => "log_file/stop_con.cgi",
    MAX_UPDATE_COUNT => 18,
  };

  sub count { open_data(FILE_PATH)->[0] }

  sub update_end_until {
    my ($class, $plus) = @_;
    $plus //= 0;
    my $stop_count = do {
      my $count = $class->count;
      # 登録期間(更新停止中)
      if ($count == 0) {
        MAX_UPDATE_COUNT;
      }
      # 1日の更新開始直後かつ、自分の更新時間前
      elsif ($count == 1 && $plus) {
        MAX_UPDATE_COUNT + 1;
      } else {
        $count;
      }
    };
    MAX_UPDATE_COUNT - $stop_count + $plus;
  }

}

1;

__END__

=encoding utf8

=head1 NAME

  Jikkoku::Model::StopUpdate - 更新停止処理のためのカウントを行うモジュール

=cut

