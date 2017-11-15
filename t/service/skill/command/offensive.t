use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Jikkoku::Container;

# 戦闘中にテストするために作った event
package Tester {

  use Mouse;
  use Jikkoku;
  use Test::More;

  use Jikkoku::Class::Skill::Command::Offensive;
  use Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara;

  use constant {
    BattleLoop     => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara',
    Offensive => 'Jikkoku::Class::Skill::Command::Offensive',
  };

  use constant MAX_TEST_NUM =>
    Offensive->INCREASE_ATTACK_POWER_LIMIT / Offensive->INCREASE_ATTACK_POWER;

  use constant INCREASE_DAMAGE => Offensive->INCREASE_ATTACK_POWER / BattleLoop->DIVISION_POWER_NUM;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  has 'count' => ( is => 'rw', default => 0 );
  has 'before_take_damage' => ( is => 'rw' );
  has 'before_enemy_soldier' => ( is => 'rw', default => 0 );

  sub BUILD {
    my $self = shift;
    $self->before_take_damage( $self->chara->_orig_max_take_damage );
  }

  sub exec_event {
    my $self = shift;

    # 攻勢イベントの効果によりダメージが上がったかを検証
    # ダメージが上昇するのは MAX_TEST_NUM 回までなので、MAX_TEST_NUM回以上はテストしないようにする
    if ( $self->count < MAX_TEST_NUM ) {
      is $self->before_take_damage + INCREASE_DAMAGE, $self->chara->_orig_max_take_damage;
      $self->before_take_damage( $self->chara->_orig_max_take_damage );
      $self->count( $self->count + 1 );
    }

    # 攻勢によって敵が受けたダメージを計算, 正しくダメージを受けているか検証
    if ( $self->battle_loop->current_turn > 0 ) {
      my $take_damage = ($self->before_enemy_soldier - $self->chara->take_damage) - $self->target->soldier->num;
      ok $take_damage <= Jikkoku::Service::Skill::Command::Offensive->MAX_TAKE_DAMAGE && $take_damage > 0;
    }
    $self->before_enemy_soldier( $self->target->soldier->num );

  }

  __PACKAGE__->meta->make_immutable;

}

use constant Offensive => 'Jikkoku::Service::Skill::Command::Offensive';

use_ok Offensive;

my $container = Test::Jikkoku::Container->new;

my $battle_loop = $container->get('service.battle_command.battle.battle_loop');

$battle_loop->chara->soldier->num(50);
$battle_loop->target->soldier->num(50);

my $skill_param = +{
  category => 'Command',
  id       => 'Offensive',
};
my $service_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 1,
};
my $chara_skill = $battle_loop->chara->skills->get($skill_param);
my $chara_service = Offensive->new(
  %$service_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_skill = $battle_loop->target->skills->get($skill_param);
my $enemy_service = Offensive->new(
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

# 戦闘中に Tester event が攻勢の効果の検証を行う

lives_ok { $battle_loop->start_loop() };

# スキルがちゃんと発動されているか確認
# スキルは発動率100%に設定したので双方毎ターン発動される

my $get_log_num = ($battle_loop->current_turn + 1) * 3;
my $chara_logs = $battle_loop->chara->battle_logger->get($get_log_num);
my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

subtest 'confirm_target_skill' => sub {
  my $str = 'りーう＠管理人が攻勢を行いました！';
  my @logs = grep { $_ =~ /$str/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /$str/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
};

subtest 'confirm_enemy_skill' => sub {
  my $str = '宋江が攻勢を行いました！';
  my @logs = grep { $_ =~ /$str/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /$str/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
};

done_testing;

