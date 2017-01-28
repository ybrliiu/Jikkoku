package Jikkoku::Class::BattleCommand::Base {

  use Jikkoku;
  use Moo;

  sub new {
    my ($class, $args) = @_;
    bless {%$args}, $class;
  }

}

1;
