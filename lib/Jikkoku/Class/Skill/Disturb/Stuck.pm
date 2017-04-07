# 足止めスキル

package Jikkoku::Class::Skill::Disturb::Stuck {

  use Mouse;
  use Jikkoku;
  
  use List::Util qw( sum );
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  use constant ACQUIRE_SIGN => 2;

  has 'name'                 => ( is => 'ro', default => '足止め' );
  has 'range'                => ( is => 'rw', default => 5 );
  has 'success_coef'         => ( is => 'rw', default => 0.005 );
  has 'max_success_pc'       => ( is => 'rw', default => 0.8 );
  has 'consume_morale'       => ( is => 'rw', default => 12 );
  has 'min_effect_time_coef' => ( is => 'rw', default => 2.5 );
  has 'max_effect_time_coef' => ( is => 'rw', default => 3.5 );
  has 'action_interval_time' => ( is => 'rw', default => $CONFIG->{game}{action_interval_time} * 0.5 );
  has 'consume_skill_point'  => ( is => 'rw', default => 10 );
  has 'depend_abilities'     => ( is => 'rw', lazy => 1, default => sub { ['intellect'] } );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::UsedInBattleMap
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities
    Jikkoku::Class::Skill::Role::UsedInBattleMap::Purchasable
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy
  );

  around _build_next_skill => sub { [ 'MakingMischief' ] };

  sub _build_items_of_depend_on_abilities {
    []
  }

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('disturb') >= ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    my $chara = $self->chara;
    # ここはメソッドとして切り出すか、混乱クラスのメソッドを呼び出すように変更すべき
    throw("修得条件を満たしていません") if $chara->skill('disturb') < ACQUIRE_SIGN - 1;
    $chara->skill(disturb => ACQUIRE_SIGN);
  }

  # 行動などのタイプは使用しているRoleで判断
  # 依存能力はjapanese.coefで表示させる
  sub explain_effect_simple {
    my $self = shift;
<< "EOS";
相手が移動の際に消費する移Pを@{[ $self->chara->states->get('Stuck')->increase_move_cost_ratio ]}倍にする。<br>
士気$self->{consume_morale}消費。<br>
成功率、消費移P増加時間は知力に依存。(行動)<br>
EOS
  }

  sub explain_effect {
    my $self = shift;
    my $ability_sum = $self->depend_abilities_sum;
    my ($min_effect_time, $max_effect_time) = $self->effect_time($ability_sum);
<< "EOS";
相手が移動の際に消費する移Pを@{[ $self->chara->states->get('Stuck')->increase_move_cost_ratio ]}倍する。<br>
効果持続時間は<strong>${min_effect_time}</strong>秒〜<strong>${max_effect_time}</strong>秒。<br>
成功率、効果時間は知力に依存。(行動)<br>
EOS
  }

  sub explain_acquire {
    my $self = shift;
    '混乱を修得していること。<br>';
  }

  sub explain_status {
    my $self = shift;
    '';
  }

  sub ensure_can_action {
    my ($self, $args) = @_;
    $args->{you}, $args->{time};
  }

  sub action {
    my ($self, $you, $time) = @_;
    my $chara = $self->chara;

    $chara->lock;
    $you->lock;
    my ($is_success, $effect_time, $stuck);
    eval {
      $chara->morale_data(morale => $chara->morale_data('morale') - $self->consume_morale);
      $chara->soldier_battle_map(action_time => $time + $self->action_interval_time);
      my $ability_sum = $self->depend_abilities_sum;
      $is_success = $self->calc_success_pc($ability_sum) > rand(1);
      if ($is_success) {
        $effect_time = $self->calc_effect_time($ability_sum);
        $stuck = $you->states->get_state('Stuck');
        $stuck->set_state_for_chara({
          giver_id       => $chara->id,
          available_time => $time + $ability_sum,
        });
      }
    };

    if (my $e = $@) {
      $chara->abort;
      $you->abort;
      if ( Jikkoku::Class::Role::BattleActionException->caught($e) ) {
        $e->rethrow;
      } else {
        die $e;
      }
    } else {
      $chara->commit;
      $you->commit;
      my $name_tag = qq{<span style="color: yellowgreen">【@{[ $self->name ]}】</span>};
      if ($is_success) {
        my $description_log = qq{<span class="red">$effect_time</span>秒間、@{[ $you->name ]}の@{[ $stuck->description ]}};
        my $chara_log = "${name_tag}@{[ $you->name ]}を@{[ $self->name ]}させました。${description_log}";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
        my $you_log = "${name_tag}@{[ $chara->name ]}に@{[ $self->name ]}させられました。${description_log}";
        $you->save_battle_log($you_log);
        $you->save_command_log($you_log);
        my $bm = $self->battle_map_model->get( $chara->soldier_battle_map('battle_map_id') );
        $self->map_log_model->add("$name_tag@{[ $you->name ]}は@{[ $chara->name ]}に@{[ $self->name ]}させられました。(@{[ $bm->name ]})")->save;
      } else {
        my $chara_log = "$name_tag@{[ $you->name ]}を@{[ $self->name ]}させようとしましたが失敗しました。";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
      }
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;
