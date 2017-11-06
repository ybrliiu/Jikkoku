use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Jikkoku::Container;

# 戦闘中の最大ダメージを記録するために作ったevent
package Peeper {
  use Mouse;
  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';
  sub exec_event {
    my $self = shift;
    $self->chara->battle_logger->add(qq{@{[ $self->chara->name ]}の最大ダメージ <@{[ $self->chara->max_take_damage ]}>, @{[ $self->target->name ]}の最大ダメージ : <@{[ $self->target->max_take_damage ]}>});
  }
  __PACKAGE__->meta->make_immutable;

}

use constant KaisinAttack => 'Jikkoku::Service::Skill::BattleMethod::KaisinAttack';

use_ok KaisinAttack;

my $container = Test::Jikkoku::Container->new;

my $battle_loop = $container->get('service.battle_command.battle.battle_loop');

$battle_loop->chara->soldier->num(100);
$battle_loop->target->soldier->num(100);

my $skill_param = +{
  category => 'BattleMethod',
  id       => 'KaisinAttack',
};
my $service_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 0.5,
};
my $chara_skill = $battle_loop->chara->skills->get($skill_param);
my $chara_service = KaisinAttack->new(
  %$service_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_skill = $battle_loop->target->skills->get($skill_param);
my $enemy_service = KaisinAttack->new(
  %$service_param,
  chara          => $battle_loop->target,
  target         => $battle_loop->chara,
  event_executer => $enemy_skill
);

my $peeper_param = +{
  battle_loop => $battle_loop,
  is_reach    => 1,
  occur_ratio => 1,
};

my $chara_peeper = Peeper->new(
  %$peeper_param,
  chara          => $battle_loop->chara,
  target         => $battle_loop->target,
  event_executer => $chara_skill,
);
my $enemy_peeper = Peeper->new(
  %$peeper_param,
  chara          => $battle_loop->target,
  target         => $battle_loop->chara,
  event_executer => $enemy_skill,
);

$battle_loop->chara_events( [$chara_service, $chara_peeper] );
$battle_loop->target_events( [$enemy_service, $enemy_peeper] );

lives_ok { $battle_loop->start_loop() };

# スキルがちゃんと発動されていて、かつ正しく効果を発揮しているか確認
my $get_log_num = $battle_loop->current_turn * 4;
my $chara_logs = $battle_loop->chara->battle_logger->get($get_log_num);
my $target_logs = $battle_loop->target->battle_logger->get($get_log_num);

subtest 'confirm chara skill' => sub {
  my @logs = reverse @$chara_logs;
  my $str = 'りーう＠管理人が会心攻撃を仕掛けました';
  if ( grep { /$str/ } @logs ) {
    for my $i (0 .. $#logs) {
      if ($logs[$i] =~ /$str/) {
        my ($chara_damage, $target_damage) = $logs[$i + 1] =~ /<(.*?)>.*<(.*?)>/;
        my $v = int $battle_loop->chara->_orig_max_take_damage * $chara_skill->increase_damage_ratio;
        is $chara_damage, $v;
      }
    }
  } else {
    ok 1;
  }
};

subtest 'confirm enemy skill' => sub {
  my @logs = reverse @$target_logs;
  my $str = '宋江が会心攻撃を仕掛けました';
  if ( grep { /$str/ } @logs ) {
    for my $i (0 .. $#logs) {
      if ($logs[$i] =~ /$str/) {
        my ($target_damage, $chara_damage) = $logs[$i + 1] =~ /<(.*?)>.*<(.*?)>/;
        my $v = int $battle_loop->target->_orig_max_take_damage * $enemy_skill->increase_damage_ratio;
        is $target_damage, $v;
      }
    }
  } else {
    ok 1;
  }
};

done_testing;

