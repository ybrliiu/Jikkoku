package Jikkoku::Class::BattleCommand::Base {

  use Jikkoku;

  sub new {
    my ($class, $args) = @_;
    bless {%$args}, $class;
  }

}

1;
