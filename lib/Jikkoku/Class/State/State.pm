package Jikkoku::Class::State::State {
  
  use Mouse::Role;
  use Jikkoku;
  
  use Carp;
  use Jikkoku::Util;

  # attribute
  requires qw( name );

  has 'id'             => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_id' );
  has 'icon'           => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_icon' );
  has 'chara'          => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1, required => 1 );
  has 'giver_id'       => ( is => 'ro', isa => 'Str', required => 1 );
  has 'available_time' => ( is => 'ro', isa => 'Int', required => 1 );

  sub _build_id {
    my $self = shift;
    my $class = ref $self;
    (split /::/, $class)[-1];
  }

  sub _build_icon {
    my $self = shift;
    lc($self->id) . '.png';
  }

  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
    $args->{giver_id} = '' if $args->{no_giver};
    $class->$orig($args);
  };

  sub giver_id {
    my $self = shift;
    $self->chara->states_data->get_with_option($self->id)->match(
      Some => sub { $_->{giver_id} },
      None => sub { Carp::confess $self->name . 'にかかっていません' },
    );
  }

  sub available_time {
    my $self = shift;
    $self->chara->states_data->get_with_option($self->id)->match(
      Some => sub { $_->{available_time} },
      None => sub { 0 },
    );
  }

  sub is_available {
    my ($self, $time) = @_;
    $time //= time;
    $self->available_time >= $time;
  }

  sub 症状にかける {
    my ($self, $args) = @_;
    Jikkoku::Util::validate_values $args => [qw/ giver_id available_time /];
    $self->chara->states_data->set($self->id => {
      giver_id       => $args->{giver_id},
      available_time => $args->{available_time},
    });
  }

  sub take_bonus_for_giver {
  }

}

1;

=encoding utf8

=head1 STATE ROLES

* 戦闘開始前のフック(広範囲)
  - 掩護
  - フィールド設置型の攻撃力や兵数上昇装置など
* 攻撃力や守備力を上下させる
  - 加護などの状態系
  - 状態を掛けた人へボーナス付与

=cut
