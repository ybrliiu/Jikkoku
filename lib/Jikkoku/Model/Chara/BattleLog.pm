package Jikkoku::Model::Chara::BattleLog {

  use Mouse;
  use Jikkoku;

  use constant INFLATE_TO => 'Jikkoku::Class::Chara::BattleLog';

  with qw( Jikkoku::Model::Role::Logger::Division );

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Chara::BattleLog::Result {

  use Mouse;
  use Jikkoku;
  use Option;

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Chara::BattleLog]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  with qw( Jikkoku::Model::Role::Result );

  sub get_with_option {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    option $self->id_map->{$id};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
