package Jikkoku::Model::SkillCategory {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Util 'validate_values';
  use Carp;
  use Option;
  use Module::Load;

  sub get_skill_category_with_option {
    my ($self, $args) = @_;
    validate_values $args => [qw/ id skill_model /];

    my $key = $args->{id};
    my $load_class = "Jikkoku::Class::Skill::${key}";
    state $loaded_class = {};
    unless (exists $loaded_class->{$key}) {
      eval {
        Module::Load::load $load_class;
        $loaded_class->{$key} = 1;
      };
      if (my $e = $@) {
        return Option::None->new;
      }
    }

    my $skill_category = eval {
      $load_class->new({ skill_model => $args->{skill_model} });
    };
    Option->new($skill_category);
  }

  __PACKAGE__->meta->make_immutable;

}

1;

