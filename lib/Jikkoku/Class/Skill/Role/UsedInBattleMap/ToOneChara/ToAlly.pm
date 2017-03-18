package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToAlly {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with 'Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara';

  before ensure_can_action => sub {
    my ($self, $args) = @_;
    if ($args->{you}->id == $self->chara->id) {
      $self->{you} = $self->chara;
    }
  };

  sub ensure_can_use_to_target_chara {
    my ($self, $args) = @_;
    Jikkoku::Util::validate_values $args => ['you'];
    throw('敵には使用できません。') if $args->{you}->country_id != $chara->country_id;
  }

}

1;

__END__
