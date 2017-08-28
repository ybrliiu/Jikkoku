package Jikkoku::Class::GameDate {

  use Mouse;
  use Jikkoku;

  use Time::Piece;
  use Jikkoku::Model::Config;

  use overload (
    '++'     => \&incr,
    '--'     => \&decr,
    '+='     => \&plus_equal,
    '-='     => \&minus_equal,
    fallback => 1,
  );

  use constant {
    FILE_PATH => 'log_file/date_count.cgi',

    # コマンド実行間隔 (秒)
    COMMAND_INTERVAL => 60 * 20,
    ONE_YEAR_MONTH   => 12,
  };

  with 'Jikkoku::Class::Role::TextData::Single';

  has 'elapsed_year' => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'month'        => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1, trigger => \&_month_set );
  has 'time'         => ( metaclass => 'Column', is => 'rw', isa => 'Int', default => sub { time } );
  
  sub _month_set {
    my ($self, $month, $old_month) = @_;
    while ( $self->month > ONE_YEAR_MONTH ) {
      # triger を作動させない為ハッシュに直接代入
      $self->{month} -= ONE_YEAR_MONTH;
      $self->elapsed_year( $self->elapsed_year + 1 );
    }
    while ( $self->month < 1 ) {
      $self->{month} += ONE_YEAR_MONTH;
      $self->elapsed_year( $self->elapsed_year - 1 );
    }
  }

  sub init {
    my ($self, $start_time) = @_;
    Carp::croak '更新開始時間が指定されていません' unless $start_time;

    my $epoch_time = eval {
      # Time::Pieceからインスタンス生成すると、タイムゾーンがずれるので,localtimeの中でする必要がある
      # see also http://d.hatena.ne.jp/hirose31/20110210/1297341952
      my $time = localtime(Time::Piece->strptime(
        "${start_time}00分00秒",
        "%Y年%m月%d日%H時%M分%S秒"
      ));
      $time->epoch();
    };
    Carp::croak '時刻指定の書式が間違っています(書式:xx年xx月xx日xx時)' if $@;

    # triger を作動させない為ハッシュに直接代入
    # (アクセッサを使うと0 < 1により前年に戻るため)
    $self->{month} = 0;
    $self->elapsed_year(0);
    $self->time($epoch_time - COMMAND_INTERVAL);
  }

  sub incr {
    my $self = shift;
    $self->month( $self->month + 1 );
  }

  sub decr {
    my $self = shift;
    $self->month( $self->month - 1 );
  }

  sub plus_equal {
    my ($self, $value) = @_;
    $self->month( $self->month + $value );
    $self;
  }

  sub minus_equal {
    my ($self, $value) = @_;
    $self->month( $self->month - $value );
    $self;
  }

  sub date {
    my $self = shift;
    sprintf("%d年%02d月", $self->year, $self->month);
  }

  {
    my $config    = Jikkoku::Model::Config->get;
    my $base_year = $config->{game}{start_year};

    sub year {
      my ($self) = @_;
      $self->elapsed_year + $base_year;
    }
  }

  sub to_num {
    my ($self) = @_;
    $self->elapsed_year * ONE_YEAR_MONTH + $self->month;
  }

  sub map_bg_color {
    my $self = shift;
    if ($self->month < 4) {
      '#FFFFFF';
    } elsif ($self->month < 7) {
      '#FFE0E0';
    } elsif ($self->month < 10) {
      '#60AF60';
    } else {
      '#884422';
    }
  }

  sub npc_lank {
    my $self = shift;
    if ($self->elapsed_year >= 50) {
      2;
    } elsif ($self->elapsed_year >= 15) {
      1;
    } else {
      0;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;
