package Jikkoku::Service::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Service::Skill::Role::UsedInBattleMap::ToOneChara );

  sub ensure_can_use_to_target_chara {
    my $self = shift;
    if ( $self->target->country_id == $self->chara->country_id ) {
      Jikkoku::Service::Role::BattleActionException->throw('味方には使用できません。')
    }
  }

}

1;

__END__

