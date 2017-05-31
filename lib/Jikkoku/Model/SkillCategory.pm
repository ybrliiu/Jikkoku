package Jikkoku::Model::SkillCategory {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Util 'validate_values';
  use Carp;
  use Module::Load;

  sub get {
    my ($self, $args) = @_;
    validate_values $args => [qw/ id skill_model /];

    my $key = $args->{id};
    my $load_class = "Jikkoku::Class::Skill::${key}";
    state $loaded_class = {};
    unless (exists $loaded_class->{$key}) {
      Module::Load::load $load_class;
      $loaded_class->{$key} = 1;
    }

    $load_class->new({ skill_model => $args->{skill_model} });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

