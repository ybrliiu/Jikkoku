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

  around explain_effect_about_depend_abilities => sub {
    my ($orig, $self) = @_;
    my @depend_abilities = @{ $self->depend_abilities };
    my $connect_word     = @depend_abilities == 1 ? '' : '及び';
    join('、', @{ $self->items_of_depend_on_abilities })
      . 'は' . join('', map { $JAPANESE->{$_} . $connect_word } @depend_abilities)
      . 'に依存。';
  };

}

1;

