package Jikkoku::Class::BattleCommand::Entry {

  use v5.14;
  use warnings;
  use Role::Tiny::With;
  use parent 'Jikkoku::Class::BattleCommand::Base';
  with 'Jikkoku::Class::Role::BattleAction';

  sub ensure_can_action {
    my ($self) = @_;
  }

  sub action {
    my ($self) = @_;

    eval {
    };

    if (my $e = $@) {
      $self->{chara}->abort;
      die " $@ \n";
    }

  }

}

1;
