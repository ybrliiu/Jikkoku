package Jikkoku::Class::Skill::Role::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Model::Config;

  has 'items_of_depend_on_abilities'
    => ( is => 'ro', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_items_of_depend_on_abilities' );

  # attribute
  requires qw( depend_abilities );

  # method
  requires qw( _build_items_of_depend_on_abilities );

  my $JAPANESE = Jikkoku::Model::Config->get->{japanese};
  
  around explain_effect_simple => sub {
    my ($orig, $self) = (shift, shift);
    warn "explain_effect_simple";
    $self->$orig(@_)
      . join('', @{ $self->items_of_depend_on_abilities })
      . 'は' . join('', map { $JAPANESE->{$_} . '及び' } @{ $self->depend_abilities })
      . 'に依存。';
  };

}

1;

