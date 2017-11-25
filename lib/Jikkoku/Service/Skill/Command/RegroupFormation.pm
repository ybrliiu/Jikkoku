# 陣形再編スキル処理

package Jikkoku::Service::Skill::Command::RegroupFormation {

  use Mouse;
  use Jikkoku;

  has 'log_color' => ( is => 'ro', isa => 'Str', default => '#FF7F50' );

  with qw(
    Jikkoku::Service::Skill::Skill
    Jikkoku::Service::Role::BattleAction::OccurActionTime
    Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities
  );

  sub ensure_can_exec {
    my $self = shift;
    if ( $self->chara->soldier->change_formation_time < $self->time ) {
      Jikkoku::Service::Role::BattleActionException
        ->throw('陣形は既に整っています。');
    }
  }

  sub exec {
    my $self = shift;
    my ($chara, $skill) = ($self->chara, $self->skill);

    $chara->lock;
    my $is_success;
    eval {
      $chara->soldier->morale( $chara->soldier->morale - $skill->consume_morale );
      $chara->soldier->action_time( $self->time + $skill->action_interval_time );
      $is_success = $self->determine_whether_succeed;
      if ($is_success) {
        my $remain_time = $chara->soldier->change_formation_time - $self->time;
        $chara->soldier->change_formation_time( $self->time + ($remain_time / $skill->num_of_divide_regroup_time) );
      }
    };

    if (my $e = $@) {
      $chara->abort;
      Jikkoku::Exception->caught($e) ? $e->rethrow : die $e;
    } else {
      $chara->commit;
      my $name_tag = qq{<span style="color: @{[ $self->log_color ]}">【@{[ $skill->name ]}】</span>};
      if ($is_success) {
        my $chara_log = "${name_tag}陣形を再編しました。";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
        my $bm = $self->battle_map_model->get( $chara->soldier->battle_map_id );
        $self->map_log_model->add("$name_tag@{[ $chara->name ]}は@{[ $skill->name ]}を行いました。(@{[ $bm->name ]})")->save;
      } else {
        my $chara_log = "${name_tag}{[ $skill->name ]}を行おうとしましたが失敗しました。";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
      }
    }
  }

  __PACKAGE__->meta->make_immutable;
}

1;
