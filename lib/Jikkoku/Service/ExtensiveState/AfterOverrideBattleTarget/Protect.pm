package Jikkoku::Service::ExtensiveState::AfterOverrideBattleTarget::Protect {

  use Mouse;
  use Jikkoku;

  has 'chara'           => ( is => 'ro', isa => 'Jikkoku::Service::BattleCommand::Battle::Chara', required => 1 );
  has 'map_log_model'   => ( is => 'ro', isa => 'Jikkoku::Model::MapLog', required => 1 );
  has 'original_enemy'  => ( is => 'ro', isa => 'Jikkoku::Service::BattleCommand::Battle::Chara', required => 1 );

  has 'result' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::ExtensiveState::BattleTargetOverriderResult',
    handles  => [qw/ giver extensive_state /],
    required => 1,
  );

  has 'increase_giver_contribute_num' => ( is => 'ro', isa => 'Num', default => 4 );

  sub exec {
    my $self = shift;
    $self->take_bonus();
    $self->notice();
  }

  sub take_bonus {
    my $self = shift;
    my $giver = $self->giver;
    $giver->lock;
    $giver->contribute( $giver->contribute + $self->increase_giver_contribute_num );
    $giver->commit;
  }

  sub notice {
    my $self = shift;
    my ($chara, $giver, $original_enemy, $extensive_state)
      = map { $self->$_ } qw( chara giver original_enemy extensive_state );

    my $orig_enemy_log = qq{<span class="red>【@{[ $extensive_state->name ]}】</span>}
      . qq{@{[ $chara->name ]}から攻撃を受けましたが、代わりに@{[ $giver->name ]}が攻撃を受けました！};
    $original_enemy->save_battle_log("<strong>$orig_enemy_log</strong>");

    my $giver_log = qq{<span class="red">【@{[ $extensive_state->name ]}】</span>}
      . qq{@{[ $original_enemy->name ]}が@{[ $chara->name ]}から攻撃を受けたので}
      . qq{@{[ $extensive_state->name ]}を行いました！}
      . qq{貢献値+<span class="red">@{[ $self->increase_giver_contribute_num ]}</span>};
    $giver->save_battle_log("<strong>$giver_log</strong>");
    $giver->save_command_log($giver_log);

    my $chara_log = qq{<span class="blue">【@{[ $extensive_state->name ]}】</span>}
      . qq{@{[ $original_enemy->name ]}は@{[ $giver->name ]}の部隊に守られています！};
    $chara->save_battle_log("<strong>$chara_log</strong>");
    $chara->save_command_log($chara_log);

    $self->map_log_model
      ->add(qq{@{[ $chara->name ]}は@{[ $original_enemy->name ]}を攻撃しましたが、@{[ $giver->name ]}が掩護に入りました！})
      ->save();
  }

  __PACKAGE__->meta->make_immutable;

}

1;

