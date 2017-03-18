package Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires qw(
    success_pc
    effect_time
  );

  sub calc_success_pc { shift->success_pc }

  sub calc_effect_time { shift->effect_time }

  around explain_status => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . <<"EOS";
消費士気 : @{[ $self->consume_morale ]}<br>
成功率 : <strong>@{[ $self->success_pc * 100 ]}</strong>%<br>
EOS
  };

}

1;
