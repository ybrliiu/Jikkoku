package Jikkoku::Class::State::State {
  
  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  # attribute
  requires qw( name );

  has 'id'    => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_id' );
  has 'icon'  => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_icon' );
  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );

  sub _build_id {
    my $self = shift;
    my $class = ref $self;
    (split /::/, $class)[-1];
  }

  sub _build_icon {
    my $self = shift;
    Jikkoku::Util::decamelize($self->id) . '.png';
  }

  # method
  requires qw( description is_available );
  
  sub state_data_keys {
    [];
  }

  sub image_tag {
    my ($self, $dir) = @_;
    Carp::croak 'Too few arguments (required: $dir)' if @_ < 2;
    qq{<img src="${dir}/@{[ $self->icon ]}">};
  }

  sub set_state_for_chara {
    my ($self, $args) = @_;
    Jikkoku::Util::validate_values $args => $self->state_data_keys;
    $self->chara->states_data->set($self->id => +{ map { $_ => $args->{$_} } @{ $self->state_data_keys } });
  }

}

1;

=encoding utf8

=head1 STATE ROLES

* 攻撃力や守備力を上下させる
  - 加護などの状態系
  - 状態を掛けた人へボーナス付与

=cut
