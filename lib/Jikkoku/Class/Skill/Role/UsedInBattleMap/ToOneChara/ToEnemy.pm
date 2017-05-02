package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with qw(
    Jikkoku::Class::Skill::Role::ToEnemy
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara
  );

  sub ensure_can_use_to_target_chara {
    my $self = shift;
    if ( $self->you->country_id == $self->chara->country_id ) {
      Jikkoku::Class::Role::BattleActionException->throw('味方には使用できません。')
    }
  }

}

1;

__END__

