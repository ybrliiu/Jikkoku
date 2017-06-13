# 足止めスキル

package Jikkoku::Service::Skill::Disturb::Stuck {

  use Mouse;
  use Jikkoku;

  with qw(
    Jikkoku::Service::Skill::Skill
    Jikkoku::Service::Role::BattleAction::OccurActionTime
    Jikkoku::Service::Skill::Role::UsedInBattleMap::Disturb
    Jikkoku::Service::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy
    Jikkoku::Service::Skill::Role::UsedInBattleMap::DependOnAbilities
  );

  sub ensure_can_exec {}

  sub exec {
    my $self = shift;
    my ($chara, $target, $skill) = ($self->chara, $self->target, $self->skill);

    $chara->lock;
    $target->lock;
    my ($is_success, $effect_time, $stuck);
    eval {
      $chara->morale_data(morale => $chara->morale_data('morale') - $skill->consume_morale);
      $self->chara_soldier->action_time( $self->time + $skill->action_interval_time );
      my $ability_sum = $skill->depend_abilities_sum;
      $is_success = $self->determine_whether_succeed($ability_sum);
      if ($is_success) {
        $effect_time = $self->calc_effect_time($ability_sum);
        $stuck = $target->states->get_state($self->id);
        $stuck->set_state_for_chara({
          giver_id       => $chara->id,
          available_time => $self->time + $effect_time,
        });
      }
    };

    if (my $e = $@) {
      $chara->abort;
      $target->abort;
      if ( Jikkoku::Exception->caught($e) ) {
        $e->rethrow;
      } else {
        die $e;
      }
    } else {
      $chara->commit;
      $target->commit;
      my $name_tag = qq{<span style="color: @{[ $self->log_color ]}">【@{[ $skill->name ]}】</span>};
      if ($is_success) {
        my $description_log = qq{<span class="red">$effect_time</span>秒間、@{[ $target->name ]}の@{[ $stuck->description ]}};
        my $chara_log = "${name_tag}@{[ $target->name ]}を@{[ $skill->name ]}させました。${description_log}";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
        my $target_log = "${name_tag}@{[ $chara->name ]}に@{[ $skill->name ]}させられました。${description_log}";
        $target->save_battle_log($target_log);
        $target->save_command_log($target_log);
        my $bm = $self->battle_map_model->get( $chara->soldier_battle_map('battle_map_id') );
        $self->map_log_model->add("$name_tag@{[ $target->name ]}は@{[ $chara->name ]}に@{[ $skill->name ]}させられました。(@{[ $bm->name ]})")->save;
      } else {
        my $chara_log = "$name_tag@{[ $target->name ]}を@{[ $skill->name ]}させようとしましたが失敗しました。";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
      }
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;
