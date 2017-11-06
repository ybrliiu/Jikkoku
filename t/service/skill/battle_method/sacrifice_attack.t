use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Jikkoku::Container;

use constant SacrificeAttack => 'Jikkoku::Service::Skill::BattleMethod::SacrificeAttack';

use_ok SacrificeAttack;

my $container = Test::Jikkoku::Container->new;

my $skill_param = +{
  category => 'BattleMethod',
  id       => 'SacrificeAttack',
};

my $chara_skill = $container->get('test.battle_chara')->skills->get($skill_param);
my $enemy_skill = $container->get('test.battle_enemy')->skills->get($skill_param);

subtest 'not siege' => sub {

  $container->set('service.battle_command.battle.is_siege' => 0);
  my $battle_loop = $container->create('service.battle_command.battle.battle_loop');

  $battle_loop->chara->soldier->num(50);
  $battle_loop->target->soldier->num(50);

  my $service_param = +{
    battle_loop => $battle_loop,
    is_reach    => 1,
    occur_ratio => 1,
  };
  my $chara_service = SacrificeAttack->new(
    %$service_param,
    chara          => $battle_loop->chara,
    target         => $battle_loop->target,
    event_executer => $chara_skill,
  );
  my $enemy_service = SacrificeAttack->new(
    %$service_param,
    chara          => $battle_loop->target,
    target         => $battle_loop->chara,
    event_executer => $enemy_skill
  );

  $battle_loop->chara_events(  [$chara_service] );
  $battle_loop->target_events( [$enemy_service] );

  lives_ok { $battle_loop->start_loop() };

  # スキルがちゃんと発動されていて、かつ正しく効果を発揮しているか確認
  # スキルは発動率100%に設定したので双方毎ターン発動される

  my $get_log_num = ( $battle_loop->current_turn + 1 ) * 3;
  my $chara_logs  = $battle_loop->chara->battle_logger->get($get_log_num);
  my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

  subtest 'confirm_target_skill' => sub {
    my $str = '宋江は自軍の兵士を犠牲にし';
    my @logs = grep { /$str/ } @$target_logs;
    is @logs, grep { /$str/ } @$chara_logs;
    for my $log (@logs) {
      my ( $sacrifice_num, $take_damage ) = $log =~ /\(-(.*?)\).*\(-(.*?)\)/;
      is $sacrifice_num * $enemy_skill->take_damage_ratio, $take_damage;
    }
  };

  subtest 'confirm_enemy_skill' => sub {
    my $str = 'りーう＠管理人は自軍の兵士を犠牲にし、';
    my @logs = grep { /$str/ } @$target_logs;
    is @logs, grep { /$str/ } @$chara_logs;
    for my $log (@logs) {
      my ( $sacrifice_num, $take_damage ) = $log =~ /\(-(.*?)\).*\(-(.*?)\)/;
      is $sacrifice_num * $enemy_skill->take_damage_ratio, $take_damage;
    }
  };

};

subtest 'siege' => sub {

  $container->set('service.battle_command.battle.is_siege' => 1);
  my $battle_loop = $container->create('service.battle_command.battle.battle_loop');

  diag $battle_loop->is_siege;

  $battle_loop->chara->soldier->num(50);
  $battle_loop->target->soldier->num(50);

  my $service_param = +{
    battle_loop => $battle_loop,
    is_reach    => 1,
    occur_ratio => 1,
  };
  my $chara_service = SacrificeAttack->new(
    %$service_param,
    chara          => $battle_loop->chara,
    target         => $battle_loop->target,
    event_executer => $chara_skill,
  );
  my $enemy_service = SacrificeAttack->new(
    %$service_param,
    chara          => $battle_loop->target,
    target         => $battle_loop->chara,
    event_executer => $enemy_skill
  );

  $battle_loop->chara_events(  [$chara_service] );
  $battle_loop->target_events( [$enemy_service] );

  lives_ok { $battle_loop->start_loop() };

  my $get_log_num = ( $battle_loop->current_turn + 1 ) * 3;
  my $chara_logs  = $battle_loop->chara->battle_logger->get($get_log_num);
  my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

  subtest 'confirm_target_skill' => sub {
    my $str = '宋江は自軍の兵士を犠牲にし';
    my @logs = grep { /$str/ } @$target_logs;
    is @logs, grep { /$str/ } @$chara_logs;
    for my $log (@logs) {
      my ( $sacrifice_num, $take_damage ) = $log =~ /\(-(.*?)\).*\(-(.*?)\)/;
      is $sacrifice_num * $enemy_skill->take_damage_ratio_on_siege, $take_damage;
    }
  };

  subtest 'confirm_enemy_skill' => sub {
    my $str = 'りーう＠管理人は自軍の兵士を犠牲にし、';
    my @logs = grep { /$str/ } @$target_logs;
    is @logs, grep { /$str/ } @$chara_logs;
    for my $log (@logs) {
      my ( $sacrifice_num, $take_damage ) = $log =~ /\(-(.*?)\).*\(-(.*?)\)/;
      is $sacrifice_num * $enemy_skill->take_damage_ratio_on_siege, $take_damage;
    }
  };

};

done_testing;

