package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with 'Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara';

  sub ensure_can_use_to_target_chara {
    my ($self, $args) = @_;
    Jikkoku::Util::validate_values $args => ['you'];
    throw('味方には使用できません。') if $args->{you}->country_id == $self->chara->country_id;
  }

}

1;

__END__

