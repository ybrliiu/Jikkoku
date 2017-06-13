package Jikkoku::Class::Town {

  use Mouse;
  use Jikkoku;

  use Carp;
  use List::Util qw( first );
  use Data::List::CircularlyLinked;
  use Jikkoku::Class::Role::TextData;

  use constant {
    YEAR_COEF           => 5.833,
    MAX_TECHNOLOGY      => 9999,
    MAX_WALL_POWER_MIN  => 1000,
    MAX_WALL_POWER_MAX  => 9999,
    MAX_WALL_POWER_COEF => 125,
  };

  has 'name'         => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'country_id'   => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'farmer'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'farm'         => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'business'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'wall'         => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'farm_max'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'business_max' => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'wall_max'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'loyalty'      => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'x'            => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'y'            => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'price'        => ( metaclass => 'Column', is => 'rw', isa => 'Num', required => 1 );
  has 'wall_power'   => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'technology'   => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'farmer_max'   => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );

  # 旧APIで隣接都市を示すためのデータが格納されていたが, 新APIでは使用しない
  for (0 .. 7) {
    has "not_need$_" => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => '' );
  }

  # 都市データの順番で決められるデータで、元々のテキストデータ自身に含まれない
  # Model::Town からオブジェクト生成時にテキストデータに付加して送られてくる
  # 逆にoutputするときは id を削除した状態で出力する
  has 'id' => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );

  with 'Jikkoku::Class::Role::TextData';

  around output => sub {
    my ($orig, $self) = @_;
    my @columns = map { $_->name } $self->get_column_attributes;
    # 一番最後の id は記録しないので削除
    pop @columns;
    my $textdata = join( '<>', map {
      my $attr = $self->$_;
      # 空文字列からは can が呼び出せないので...
      if ($attr ne '') {
        $attr->can('output') ? $attr->output : $attr
      } else {
        '';
      }
    } @columns ) . "<>\n";
    \$textdata;
  };

  sub distance {
    my ($self, $town) = @_;
    Carp::croak 'few arguments($town)' if @_ < 2;
    abs( $self->x - $town->x ) + abs( $self->y - $town->y );
  }

  {
    # 泉州 <-> 夷州, 夷州 <-> 雷州, 雷州 <-> 広州 移動できるようにする
    # 数字は各都市のID
    my @special_move = (
      Data::List::CircularlyLinked->new(17 => 15),
      Data::List::CircularlyLinked->new(15 => 16),
      Data::List::CircularlyLinked->new(16 => 9),
    );

    sub can_move {
      my ($self, $town) = @_;
      Carp::croak 'few arguments($town)' if @_ < 2;
      my $distance = $self->distance($town);
      # 斜めの時
      my $oblique = $distance == 2 && $self->x != $town->x && $self->y != $town->y;
      # 特殊移動(海をまたいで)
      my $can_special_move = first {
        my $town_id = $_->get($town->id);
        defined $town_id ? $self->id == $town_id->next : undef;
      } @special_move;
      $distance == 1 || $oblique || $can_special_move;
    }
  }

  sub is_neutral {
    my $self = shift;
    $self->country_id == 0;
  }

  sub is_occur_stop_around_time {
    my $self = shift;
    !$self->is_neutral && $self->wall > 0;
  }

  sub _salary {
    my ($self, $attr) = @_;
    int( $self->$attr * 12 * $self->farmer / 12000 );
  }

  sub salary_money {
    my $self = shift;
    $self->_salary('business');
  }

  sub salary_rice {
    my $self = shift;
    $self->_salary('farm');
  }

  sub stop_around_degree {
    my $self = shift;

    if (ref $self) {
      croak ' 引数が足りません ($elapsed_year) ' if @_ < 1;
      my ($elapsed_year) = @_;

      my $coef = 300 + $elapsed_year * YEAR_COEF;
      return do {
        my $stop_around_degree = int( $self->{wall} / $coef * 100 );
        if ($stop_around_degree > 100) {
          my $over_100 = 100 + int( ($self->{wall} - $coef) / ($coef * 3) * 100 );
          $over_100 > 200 ? 200 : $over_100;
        } else {
          $stop_around_degree;
        }
      };

    }
    else {
      croak ' 引数が足りません ($town_wall, $elapsed_year) ' if @_ < 2;
      my ($town_wall, $elapsed_year) = @_;

      my $coef = 300 + $elapsed_year * YEAR_COEF;
      return do {
        my $stop_around_degree = int($town_wall / $coef * 100);
        if ($stop_around_degree > 100) {
          my $left = $town_wall - $coef;
          my $right = $coef * 3;
          my $over_100 = 100 + int($left / $right * 100);
          $over_100 > 200 ? 200 : $over_100;
        } else {
          $stop_around_degree;
        }
      };

    }
  }

  # これを呼ぶ前に Model::Town::set_all_stay_charactors を呼ぶこと
  sub stay_charactors {
    my ($self) = @_;
    $self->{stay_charactors};
  }

  sub stay_charactors_num {
    my ($self) = @_;
    $self->{stay_charactors_num};
  }

  sub stop_around_action_time {
    my $self = shift;
    if (ref $self) {
      my ($elapsed_year, $BMT_REMAKE) = @_;
      $BMT_REMAKE * 10 * $self->stop_around_degree($elapsed_year) / 100;
    }
    else {
      my $class = $self;
      my ($town_wall, $elapsed_year, $BMT_REMAKE) = @_;
      $BMT_REMAKE * 10 * $class->stop_around_degree($town_wall, $elapsed_year) / 100;
    }
  }

  sub stop_around_move_time {
    my $self = shift;
    if (ref $self) {
      my ($elapsed_year, $BMT_REMAKE) = @_;
      $BMT_REMAKE * 20 * $self->stop_around_degree($elapsed_year) / 100;
    }
    else {
      my $class = $self;
      my ($town_wall, $elapsed_year, $BMT_REMAKE) = @_;
      $BMT_REMAKE * 20 * $class->stop_around_degree($town_wall, $elapsed_year) / 100;
    }
  }

  sub defender_list {
    my ($self, $battle_map, $chara_model) = @_;
    my $castle = $battle_map->get_node(sub {
      my $node = shift;
      $node->is_terrain_castle;
    });
    [ grep {
      $_->is_soldier_same_position( $self->id, $castle->x, $castle->y );
    } @{ $chara_model->get_all } ];
  }

  sub wall_power_max {
    my ($class, $elapsed_year) = @_;
    Carp::croak 'few arguments($elapsed_year)' if @_ < 2;
    my $wall_power_max = $elapsed_year * MAX_WALL_POWER_COEF;
    if ($wall_power_max < MAX_WALL_POWER_MIN) {
      MAX_WALL_POWER_MIN;
    } elsif ($wall_power_max > MAX_WALL_POWER_MAX) {
      MAX_WALL_POWER_MAX;
    } else {
      $wall_power_max;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;
