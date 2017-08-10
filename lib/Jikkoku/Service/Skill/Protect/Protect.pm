# 掩護スキル

package Jikkoku::Service::Skill::Protect::Protect {

  use Mouse;
  use Jikkoku;

  has 'log_color' => ( is => 'ro', isa => 'Str', default => '#FF69B4' );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
    },
  );

  has 'extensive_state_record_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::ExtensiveStateRecord',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('ExtensiveStateRecord')->new;
    },
  );

  with qw(
    Jikkoku::Service::Skill::Skill
    Jikkoku::Service::Skill::Role::UsedInBattleMap
    Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities
  );

  sub ensure_can_exec {
    my $self = shift;

    my $sub = $self->chara->interval_time('protect') - $self->time;
    if ($sub > 0) {
      Jikkoku::Service::Role::BattleActionException->throw("あと $sub秒 使用できません。");
    }

    # 暫定制限
    my $enemies = $self->chara_model->get_all_with_result
      ->get_not_applicable_charactors_by_country_id_with_result( $self->chara->country_id )
      ->get_charactors_by_soldier_bm_id_with_result( $self->chara->soldier->battle_map_id );
    unless (@$enemies) {
      Jikkoku::Service::Role::BattleActionException
        ->throw($self->skill->name . "は敵が同じBM上にいる時にしか使用できません！");
    }
  }

  sub exec {
    my $self = shift;
    my ($chara, $skill, $extensive_state_record_model)
      = ($self->chara, $self->skill, $self->extensive_state_record_model);

    $chara->lock;
    $extensive_state_record_model->lock;
    my $is_success;
    eval {
      $chara->soldier->morale( $chara->soldier->morale - $skill->consume_morale );
      $chara->contribute( $chara->contribute + $skill->get_contribute );
      $chara->interval_time( protect => $self->time + $skill->interval_time );
      $is_success = $self->determine_whether_succeed;
      if ($is_success) {
        my $extensive_state_model = $self->model('ExtensiveState')->new({
          chara         => $chara->chara,
          chara_soldier => $chara->soldier,
          record_model  => $extensive_state_record_model,
        });
        my $state = $extensive_state_model->get($skill->id);
        $state->give;
      }
    };

    if (my $e = $@) {
      $chara->abort;
      $extensive_state_record_model->abort;
      Jikkoku::Exception->caught($e) ? $e->rethrow : die($e);
    } else {
      $chara->commit;
      $extensive_state_record_model->commit;
      my $name_tag = qq{<span style="color: @{[ $self->log_color ]}">【@{[ $skill->name ]}】</span>};
      if ($is_success) {
        my $log_base = qq{$name_tag@{[ $chara->name ]}は@{[ $skill->name ]}を行いました！敵の攻撃から味方を守ります。 };
        my $chara_log
          = qq{${log_base}士気-<span class="red">@{[ $skill->consume_morale ]}</span> 貢献値+<span class="red">@{[ $skill->get_contribute ]}</span>};
        $chara->save_command_log( $chara_log );
        $chara->save_battle_log( $chara_log );
        my $bm = $self->battle_map_model->get( $chara->soldier->battle_map_id );
        $self->map_log_model->add( $log_base . '(' . $bm->name . ')' )->save;
      } else {
        $chara->save_battle_log("$name_tagを行おうとしましたが失敗しました。");
      }
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

