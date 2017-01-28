package Jikkoku::Class::BattleCommand::Exit {

  use Moo;
  use Jikkoku;
  with qw(
    Jikkoku::Class::BattleCommand::BattleCommand
    Jikkoku::Class::Role::BattleAction
  );

  sub ensure_can_action {
    my ($self) = @_;
  }

  sub action {
    my ($self) = @_;

    eval {
    };

    if (my $e = $@) {
      $self->chara->abort;
      throw($e);
    }

  }

}

1;
