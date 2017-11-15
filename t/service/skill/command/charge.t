use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Jikkoku::Container;

# 戦闘中にテストするために作った event
package Tester {

  use Mouse;
  use Jikkoku;
  use Test::More;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  has 'before_enemy_soldier' => ( is => 'rw', default => 0 );

  sub exec_event {
    my $self = shift;

    # 前ターン突撃で与えたダメージを算出, 敵に正しくダメージが与えられたか確認
    if ( $self->battle_loop->current_turn > 0 ) {
      my $take_damage = ($self->before_enemy_soldier - $self->chara->take_damage) - $self->target->soldier->num;
      ok $take_damage <= Jikkoku::Service::Skill::Command::Charge->MAX_TAKE_DAMAGE && $take_damage > 0;
    }
    $self->before_enemy_soldier( $self->target->soldier->num );

  }

  __PACKAGE__->meta->make_immutable;

}

use constant Charge => 'Jikkoku::Service::Skill::Command::Charge';

use_ok Charge;

my $container = Test::Jikkoku::Container->new;

my $battle_loop = $container->get('service.battle_command.battle.battle_loop');

$battle_loop->chara->soldier->num(50);
$battle_loop->target->soldier->num(50);

my $skill_param = +{
  category => 'Command',
  id       => 'Charge',
};
my $service_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 1,
};
my $chara_skill = $battle_loop->chara->skills->get($skill_param);
my $chara_service = Charge->new(
  %$service_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_skill = $battle_loop->target->skills->get($skill_param);
my $enemy_service = Charge->new(
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

# 戦闘中に Tester event が突撃の効果の検証を行う

lives_ok { $battle_loop->start_loop() };

# スキルがちゃんと発動されているか確認
# スキルは発動率100%に設定したので双方毎ターン発動される

my $get_log_num = ($battle_loop->current_turn + 1) * 3;
my $chara_logs = $battle_loop->chara->battle_logger->get($get_log_num);
my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

subtest 'confirm_target_skill' => sub {
  my $str = 'りーう＠管理人の部隊は敵部隊に突撃しました！';
  my @logs = grep { $_ =~ /$str/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /$str/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
};

subtest 'confirm_enemy_skill' => sub {
  my $str = '宋江の部隊は敵部隊に突撃しました！';
  my @logs = grep { $_ =~ /$str/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /$str/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
};

done_testing;

