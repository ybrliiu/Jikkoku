package Jikkoku::Model::SkillCategory {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Util 'validate_values';
  use Carp;
  use Module::Load;

  sub get {
    my ($self, $args) = @_;
    validate_values $args => [qw/ id skills /];

    my $key = $args->{id};
    my $load_class = "Jikkoku::Class::Skill::${key}";
    $load_class->new({ skills => $args->{skills} });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

