package Jikkoku::Class::State::AdvanceDecreaseDefencePower {

  use Mouse;
  use Jikkoku;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '進撃' );
  has 'defence_power'       => ( is => 'ro', isa => 'Int', default => 0 );
  has 'defence_power_ratio' => ( is => 'ro', isa => 'Num', default => -0.5 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::DefencePowerAdjuster
  );

  # メモ 守備力が下がり始める時間, 効果時間は進撃スキル側で定義する
  around state_data_keys => sub {
    my ($orig, $self) = @_;
    [ @{ $self->$orig() }, 'start_time' ];
  };

  sub description {
    my $self = shift;
    '進撃スキルの効果で守備力が' . $self->defence_power_ratio * -100 . '%低下している状態です。';
  }

  sub start_time {
    my $self = shift;
    $self->chara->states_data->get_with_option($self->id)->match(
      Some => sub { $_->{start_time} },
      None => sub { 0 },
    );
  }

  around is_available => sub {
    my ($orig, $self, $time) = @_;
    $time //= time;
    if ( $self->chara->is_invasion ) {
      $self->start_time <= $time && $self->$orig($time);
    }
    else {
      0;
    }
  };

  __PACKAGE__->meta->make_immutable;

}

1;

