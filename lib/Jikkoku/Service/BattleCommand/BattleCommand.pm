package Jikkoku::Service::BattleCommand::BattleCommand {

  use Mouse::Role;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    required => 1,
  );

  has 'battle_command' => (
    is      => 'ro',
    does    => 'Jikkoku::Class::BattleCommand::BattleCommand',
    lazy    => 1,
    default => sub {
      my $self = shift;
      my $last = ( split /::/, ref $self )[-1];
      $self->class("BattleCommand::$last")->new;
    },
  );

  with qw( Jikkoku::Service::Role::BattleAction );

  sub calc_success_ratio() { 1 }

}

1;

