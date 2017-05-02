package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToAlly {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with qw(
    Jikkoku::Class::Skill::Role::ToAlly
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara
  );

  before ensure_can_exec => sub {
    my ($self, $args) = @_;
    if ($self->you->id == $self->chara->id) {
      $self->you( $self->chara );
    }
  };

  sub ensure_can_use_to_target_chara {
    my $self = shift;
    if ( $self->you->country_id != $self->chara->country_id ) {
      Jikkoku::Class::Role::BattleActionException->throw('敵には使用できません。');
    }
  }

}

1;

__END__
