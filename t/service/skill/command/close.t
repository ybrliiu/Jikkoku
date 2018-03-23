use Test::Jikkoku;
use aliased 'Jikkoku::Service::Skill::Command::Close';

# 戦闘中にテストするために作った event
package Tester {

  use Mouse;
  use Jikkoku;
  use Test::More;

  use Jikkoku::Class::Skill::Command::Close;
  use Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara;

  use constant {
    BattleLoop => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara',
    Close      => 'Jikkoku::Class::Skill::Command::Close',
  };

  use constant MAX_TEST_NUM =>
    Close->INCREASE_DEFENCE_POWER_LIMIT / Close->INCREASE_DEFENCE_POWER;

  use constant DECREASE_DAMAGE => Close->INCREASE_DEFENCE_POWER / BattleLoop->DIVISION_POWER_NUM;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  has 'count' => ( is => 'rw', default => 0 );
  has 'before_take_damage' => ( is => 'rw' );

  sub BUILD {
    my $self = shift;
    $self->before_take_damage( $self->target->_orig_max_take_damage );
  }

  sub exec_event {
    my $self = shift;

    # 密集イベントの効果によりダメージが下がったかを検証
    # ダメージが上昇するのは MAX_TEST_NUM 回までなので、MAX_TEST_NUM回以上はテストしないようにする
    if ( $self->count < MAX_TEST_NUM ) {
      is $self->before_take_damage - DECREASE_DAMAGE, $self->target->_orig_max_take_damage;
      $self->before_take_damage( $self->target->_orig_max_take_damage );
      $self->count( $self->count + 1 );
    }

  }

  __PACKAGE__->meta->make_immutable;

}

use_ok Close;

my $container = Test::Jikkoku::Container->new;

my $battle_loop = $container->get('service.battle_command.battle.battle_loop');

$battle_loop->chara->soldier->num(50);
$battle_loop->target->soldier->num(50);

my $skill_param = +{
  category => 'Command',
  id       => 'Close',
};
my $service_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 1,
};
my $chara_skill = $battle_loop->chara->skills->get($skill_param);
my $chara_service = Close->new(
  %$service_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_skill = $battle_loop->target->skills->get($skill_param);
my $enemy_service = Close->new(
  %$service_param,
  chara          => $battle_loop->target,
  target         => $battle_loop->chara,
  event_executer => $enemy_skill
);

my $tester_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 1,
};
my $chara_tester = Tester->new(
  %$tester_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_tester = Tester->new(
  %$tester_param,
  chara          => $battle_loop->target,
  target         => $battle_loop->chara,
  event_executer => $enemy_skill,
);

$battle_loop->chara_events([$chara_service, $chara_tester]);
$battle_loop->target_events([$enemy_service, $enemy_tester]);

# 戦闘中に Tester event が密集の効果の検証を行う

lives_ok { $battle_loop->start_loop() };

# スキルがちゃんと発動されているか確認
# スキルは発動率100%に設定したので双方毎ターン発動される

my $get_log_num = ($battle_loop->current_turn + 1) * 3;
my $chara_logs = $battle_loop->chara->battle_logger->get($get_log_num);
my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

subtest 'confirm_target_skill' => sub {
  my $str = $battle_loop->chara->name . 'の部隊が密集しました！';
  my @logs = grep { $_ =~ /$str/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /$str/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
};

subtest 'confirm_enemy_skill' => sub {
  my $str = $battle_loop->target->name . 'の部隊が密集しました！';
  my @logs = grep { $_ =~ /$str/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /$str/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
};

done_testing;

