use Test::Jikkoku;
use aliased 'Jikkoku::Service::Skill::BattleMethod::DestroyAttack';

use_ok DestroyAttack;

my $container = Test::Jikkoku::Container->new;
my $battle_loop = $container->get('service.battle_command.battle.battle_loop');
$battle_loop->chara->soldier->num(50);
$battle_loop->target->soldier->num(50);

my $skill_param = +{
  category => 'BattleMethod',
  id       => 'DestroyAttack',
};
my $service_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 1,
};
my $chara_skill = $battle_loop->chara->skills->get($skill_param);
my $chara_service = DestroyAttack->new(
  %$service_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_skill = $battle_loop->target->skills->get($skill_param);
my $enemy_service = DestroyAttack->new(
  %$service_param,
  chara          => $battle_loop->target,
  target         => $battle_loop->chara,
  event_executer => $enemy_skill
);

$battle_loop->chara_events([$chara_service]);
$battle_loop->target_events([$enemy_service]);

lives_ok { $battle_loop->start_loop() };

# スキルがちゃんと発動されていて、かつ正しく効果を発揮しているか確認
# スキルは発動率100%に設定したので双方毎ターン発動される

my $get_log_num = ($battle_loop->current_turn + 1) * 3;
my $chara_logs = $battle_loop->chara->battle_logger->get($get_log_num);
my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

subtest 'confirm_target_skill' => sub {
  my @logs = grep { $_ =~ /(??{ $battle_loop->chara->name })が破壊攻撃を行いました。/ } @$chara_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /(??{ $battle_loop->chara->name })が破壊攻撃を行いました。/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
  # スキル効果で与えているダメージが正しいか確認
  for my $log (@logs) {
    like $log, qr/(??{ $chara_service->TAKE_DAMAGE_NUM })/;
  }
};

subtest 'confirm_enemy_skill' => sub {
  my @logs = grep { $_ =~ /(??{ $battle_loop->target->name })が破壊攻撃を行いました。/ } @$target_logs;
  is @logs, $battle_loop->current_turn + 1;
  @logs = grep { $_ =~ /(??{ $battle_loop->target->name })が破壊攻撃を行いました。/ } @$chara_logs;
  for my $log (@logs) {
    like $log, qr/(??{ $enemy_service->TAKE_DAMAGE_NUM })/;
  }
};

done_testing;

