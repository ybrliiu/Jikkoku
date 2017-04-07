# 混乱スキル

package Jikkoku::Class::Skill::Disturb::Confuse {

  use Mouse;
  use Jikkoku;
  
  use List::Util qw( sum );
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  use constant ACQUIRE_SIGN => 1;

  has 'name'                 => ( is => 'ro', default => '混乱' );
  has 'range'                => ( is => 'rw', default => 5 );
  has 'sucess_coef'          => ( is => 'rw', default => 0.005 );
  has 'max_sucess_pc'        => ( is => 'rw', default => 0.8 );
  has 'consume_morale'       => ( is => 'rw', default => 12 );
  has 'min_effect_time_coef' => ( is => 'rw', default => 2.5 );
  has 'max_effect_time_coef' => ( is => 'rw', default => 3.5 );
  has 'action_interval_time' => ( is => 'rw', default => $CONFIG->{game}{action_interval_time} * 0.5 );
  has 'consume_skill_point'  => ( is => 'rw', default => 10 );
  has 'depend_abilities'     => ( is => 'rw', lazy => 1, default => sub { ['intellect'] } );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::UsedInBattleMap
    Jikkoku::Class::Skill::Role::Purchasable
  );

  around _build_next_skill => sub { ['Stuck'] };

  sub _build_items_of_depend_on_abilities {
    [];
  }

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('disturb') >= ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill(disturb => ACQUIRE_SIGN);
  }

  sub explain_effect_simple {
    my $self = shift;
<< "EOS";
相手が移動の際に消費する移Pを@{[ $self->chara->states->get('Stuck')->effect_multiple ]}倍にする。<br>
士気$self->{consume_morale}消費。<br>
成功率、消費移P増加時間は知力に依存。(行動)<br>
EOS
  }

  sub explain_effect {
    my $self = shift;
    my ($min_effect_time, $max_effect_time) = $self->effect_time;
<< "EOS";
相手が移動の際に消費する移Pを@{[ $self->chara->states->get('Stuck')->effect_multiple ]}倍する。<br>
効果持続時間は<strong>${min_effect_time}</strong>秒〜<strong>${max_effect_time}</strong>秒。<br>
成功率、効果時間は知力に依存。(行動)<br>
EOS
  }

  sub explain_acquire { '' }

  sub explain_status { '' }

  sub ensure_can_action {
    my ($self, $args) = @_;
    $args->{you}, $args->{time};
  }

  sub action {
    my ($self, $you, $time) = @_;
    my $chara = $self->chara;

    my ($is_success, $effect_time, $get_contribute);
    eval {
      $chara->morale_data(morale => $chara->morale_data('morale') - $self->consume_morale);
      $chara->soldier_battle_map(action_time => $time + $self->action_interval_time);
      $is_success = $self->calc_success_pc > rand(1);
      if ($is_success) {
        $effect_time = $self->calc_effect_time;
        $you->debuff(stuck => $time + $effect_time);
        $get_contribute = int $effect_time * $self->get_contribute_coef;
        $chara->contribute( $chara->contribute + $get_contribute );
        $chara->book_power( $chara->book_power + $self->add_book_power );
      }
    };

    if (my $e = $@) {
      $chara->abort;
      $you->abort;
      $e->rethrow;
    } else {
      $chara->save;
      $you->save;
      my $name_tag = qq{<span style="color: yellowgreen">【@{[ $self->name ]}】</span>};
      if ($is_success) {
        my $state     = Jikkoku::Class::State::Stuck->new({chara => $chara});
        my $chara_log = qq{$name_tag@{[ $you->name ]}を足止めさせました。}
          . qq{<span class="red">$effect_time</span>秒間、@{[ $you->name ]}の消費移Pが@{[ $state->effect_multiple ]}倍されます。}
          . qq{ 貢献値+<span class="red">$get_contribute</span> 書物威力+<span class="red">@{[ $self->add_book_power ]}</span>};
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
        my $you_log = qq{$name_tag@{[ $chara->name ]}に足止めさせられました。}
          . qq{<span class="red">$effect_time</span>秒間、消費移Pが@{[ $state->effect_multiple ]}倍されます。};
        $you->save_battle_log($you_log);
        $you->save_command_log($you_log);
        my $bm = $self->battle_map_model->get( $chara->soldier_battle_map('battle_map_id') );
        $self->map_log_model->add("$name_tag@{[ $you->name ]}は@{[ $chara->name ]}に$self->{name}させられました。(@{[ $bm->name ]})")->save;
      } else {
        my $chara_log = "$name_tag@{[ $you->name ]}を足止めさせようとしましたが失敗しました。";
        $chara->save_battle_log($chara_log);
        $chara->save_command_log($chara_log);
      }
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;
