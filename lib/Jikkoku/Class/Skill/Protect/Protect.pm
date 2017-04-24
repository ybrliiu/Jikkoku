package Jikkoku::Class::Skill::Protect::Protect {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Util qw( validate_values );

  has 'name'           => ( is => 'ro', default => '掩護' );
  has 'consume_morale' => ( is => 'rw', default => 10 );
  has 'get_contribute' => ( is => 'rw', default => 2 );
  has 'effect_range'   => ( is => 'rw', default => 3 );
  has 'effect_time'    => ( is => 'rw', default => 250 );
  has 'interval_time'  => ( is => 'rw', default => 240 );
  has 'success_ratio'  => ( is => 'rw', default => 1 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::UsedInBattleMap
    Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities
  );

  sub is_acquired {
    my $self = shift;
    $self->chara->soldier->attr eq '歩';
  }

  sub acquire {}

  sub explain_effect_body {
    my $self = shift;
<< "EOS";
使用後@{[ $self->effect_time ]}秒間、
自分の周囲@{[ $self->effect_range ]}マス以内にいる味方が敵の攻撃を受けた時、
身代わりになって攻撃を受ける。(行動)
EOS
  }

  sub explain_acquire { "歩兵属性兵科を使用時。" }

  sub explain_status {
    my ($self) = @_;
<< "EOS";
消費士気 : @{[ $self->consume_morale ]}<br>
再使用時間 : @{[ $self->interval_time ]}秒<br>
EOS
  }

  sub ensure_can_action {
    my ($self, $args) = @_;
    validate_values $args => [qw/ protector_model chara_model /];

    my $time = time;
    my $sub = $self->chara->interval_time('protect') - $time;
    throw("あと $sub秒 使用できません。") if $sub > 0;

    # 暫定制限
    my $enemy_num = @{ $args->{chara_model}->get_same_bm_and_not_same_country( $self->chara ) };
    throw($self->name . "は敵が同じBM上にいる時にしか使用できません！") unless $enemy_num;

    $args->{protector_model}, $time;
  }

  sub action {
    my ($self, $protector_model, $time) = @_;
    my $chara = $self->chara;

    $chara->lock;

    my $is_success;
    eval {
      $chara->morale_data( morale => $chara->morale_data('morale') - $self->consume_morale );
      $chara->contribute( $chara->contribute + $self->get_contribute );
      $chara->interval_time( protect => $time + $self->interval_time );
      $is_success = $self->determine_whether_succeed;
      if ($is_success) {
        $protector_model->add( $chara->id );
      }
    };

    if (my $e = $@) {
      $chara->abort;
      throw("$e \n");
    } else {
      $chara->commit;
      $protector_model->save;
      my $name_tag = qq{<span style="color: #FF69B4">【@{[ $self->name ]}】</font>};
      if ($is_success) {
        my $log_base = qq{$name_tag@{[ $chara->name ]}は@{[ $self->name ]}を行いました！敵の攻撃から味方を守ります。 };
        my $chara_log
          = qq{${log_base}士気-<span class="red">@{[ $self->consume_morale ]}</span> 貢献値+<span class="red">@{[ $self->get_contribute ]}</span>};
        $chara->save_command_log( $chara_log );
        $chara->save_battle_log( $chara_log );
        my $bm = $self->battle_map_model->get( $chara->soldier_battle_map('battle_map_id') );
        $self->map_log_model->add( $log_base . '(' . $bm->name . ')' )->save;
      } else {
        $chara->save_battle_log("$name_tagを行おうとしましたが失敗しました。");
      }
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;
