# 足止めスキル

package Jikkoku::Class::Skill::Disturb::Stuck {

  use Mouse;
  use Jikkoku;
  
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  use constant ACQUIRE_SIGN => 2;

  has 'name'                 => ( is => 'ro', default => '足止め' );
  has 'range'                => ( is => 'rw', default => 5 );
  has 'success_coef'         => ( is => 'rw', default => 0.005 );
  has 'max_success_ratio'    => ( is => 'rw', default => 0.8 );
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
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities
    Jikkoku::Class::Skill::Role::UsedInBattleMap::Purchasable
    Jikkoku::Class::Skill::Role::GiveState
  );

  # around _build_next_skills_id => sub { [ 'MakingMischief' ] };

  sub _build_items_of_depend_on_abilities {
    [qw/ 成功率 効果時間 /];
  }

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('disturb') >= ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill(disturb => ACQUIRE_SIGN);
  }

  sub ensure_can_exec {
    my ($self, $args) = @_;
    $args->{you}, $args->{time};
  }

  sub exec {
    my ($self, $you, $time) = @_;
    my $chara = $self->chara;

    $chara->lock;
    $you->lock;
    my ($is_success, $effect_time, $stuck);
    eval {
      $chara->morale_data(morale => $chara->morale_data('morale') - $self->consume_morale);
      $chara->soldier_battle_map(action_time => $time + $self->action_interval_time);
      my $ability_sum = $self->depend_abilities_sum;
      $is_success = $self->determine_whether_succeed;
      if ($is_success) {
        $effect_time = $self->calc_effect_time($ability_sum);
        $stuck = $you->states->get_state($self->id);
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
