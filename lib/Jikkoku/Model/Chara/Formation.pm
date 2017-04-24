package Jikkoku::Model::Chara::Formation {

  use Mouse;
  use Jikkoku;
  extends 'Jikkoku::Model::Formation';

  use Jikkoku::Class::Chara::Formation;

  has '+get_all_formations' => ( isa => 'ArrayRef[Jikkoku::Class::Chara::Formation]' );

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    weak_ref => 1,
    required => 1,
  );

  override generate_treat_class => sub {
    my ($self, $args) = @_;
    Jikkoku::Class::Chara::Formation->new(
      %$args,
      chara           => $self->chara,
      formation_model => $self,
    );
  };

  sub get_available_formations {
    my $self = shift;
    [ grep { $_->is_available } @{ $self->get_all_formations } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

