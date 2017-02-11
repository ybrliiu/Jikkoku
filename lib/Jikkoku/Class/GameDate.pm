package Jikkoku::Class::GameDate {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;
  use parent 'Jikkoku::Class::Base::TextData';

  use Time::Piece;
  use Carp qw/croak/;
  use Jikkoku::Util qw/validate_values/;

  use Jikkoku::Model::Config;

  use overload (
    '++'     => \&incr,
    '--'     => \&decr,
    '+='     => \&plus_equal,
    '-='     => \&minus_equal,
    fallback => 1,
  );

  use constant {
    COLUMNS     => [qw/elapsed_year month time/],
    PRIMARY_KEY => undef,

    # コマンド実行間隔 (秒)
    COMMAND_INTERVAL => 60 * 20,

    ONE_YEAR_MONTH   => 12,
  };

  __PACKAGE__->make_accessors( COLUMNS );

  __PACKAGE__->after(month => sub {
    my ($self) = @_;
    if (@_ != 1) {
      while ( $self->{month} > ONE_YEAR_MONTH ) {
        $self->{month}        -= ONE_YEAR_MONTH;
        $self->{elapsed_year} += 1;
      }
      while ( $self->{month} < 1 ) {
        $self->{month}        += ONE_YEAR_MONTH;
        $self->{elapsed_year} -= 1;
      }
    }
  });

  sub _new_by_args {
    my ($class, $args) = @_;
    validate_values $args => [qw/elapsed_year month/];
    $args->{time} //= time;
    $class->SUPER::_new_by_args( $args );
  }

  sub init {
    my ($self, $start_time) = @_;
    croak '更新開始時間が指定されていません' unless $start_time;

    my $epoch_time = eval {
      # Time::Pieceからインスタンス生成すると、タイムゾーンがずれるので,localtimeの中でする必要がある
      # see also http://d.hatena.ne.jp/hirose31/20110210/1297341952
      my $time = localtime( Time::Piece->strptime(
        "${start_time}00分00秒",
        "%Y年%m月%d日%H時%M分%S秒"
      ));
      $time->epoch();
    };
    croak "時刻指定の書式が間違っています(書式:xx年xx月xx日xx時)" if $@;

    $self->{month}        = 0;
    $self->{elapsed_year} = 0;
    $self->{time}         = $epoch_time - COMMAND_INTERVAL;
  }

  sub incr {
    my $self = shift;
    $self->month( $self->{month} + 1 );
  }

  sub decr {
    my $self = shift;
    $self->month( $self->{month} - 1 );
  }

  sub plus_equal {
    my ($self, $value) = @_;
    $self->month( $self->{month} + $value );
    $self;
  }

  sub minus_equal {
    my ($self, $value) = @_;
    $self->month( $self->{month} - $value );
    $self;
  }

  sub date {
    my ($self) = @_;
    sprintf("%02d年%02d月", $self->year, $self->{month});
  }

  {
    my $config    = Jikkoku::Model::Config->get;
    my $base_year = $config->{game}{start_year};

    sub year {
      my ($self) = @_;
      $self->{elapsed_year} + $base_year;
    }
  }

  sub map_bg_color {
    my ($self) = @_;
    return $self->{map_bg_color} if exists $self->{map_bg_color};
    $self->{map_bg_color} = do {
      if ($self->{month} < 4) {
        "#FFFFFF";
      } elsif ($self->{month} < 7) {
        "#FFE0E0";
      } elsif ($self->{month} < 10) {
        "#60AF60";
      } else {
        "#884422";
      }
    };
  }

  sub to_num {
    my ($self) = @_;
    $self->{elapsed_year} * ONE_YEAR_MONTH + $self->{month};
  }

  sub npc_lank {
    my $self = shift;
    if ($self->{elapsed_year} >= 50) {
      2;
    } elsif ($self->{elapsed_year} >= 15) {
      1;
    } else {
      0;
    }
  }

}

1;
