package Jikkoku::Class::Skill::Skill {

  use Jikkoku;
  use Role::Tiny;
  use Jikkoku::Util qw( validate_values );

  requires qw(
    explain_effect
    explain_status
    explain_acquire
  );

  sub new {
    my ($class, $args) = @_;
    validate_values $args => ['name'];
    bless {%$args}, $class;
  }

}

1;
