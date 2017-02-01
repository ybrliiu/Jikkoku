use Jikkoku;
use Test::More;
use Test::Exception;
use Test2::IPC;

use_ok 'Jikkoku::Class::Role::TextData::Division';

package Player {

  use Mouse;
  use Jikkoku;

  use constant {
    DIR_PATH    => 'charalog/main/',
    PRIMARY_KEY => 'id',
  };

  has 'id'               => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'pass'             => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'name'             => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'icon'             => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'force'            => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'intellect'        => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'leadership'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'popular'          => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'soldier_num'      => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'soldier_training' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'country_id'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'money'            => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'rice'             => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'contribute'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'class'            => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'weapon_power'     => ( metaclass => 'Column', is => 'rw', isa => 'Num', default  => 0 );
  has 'book_power'       => ( metaclass => 'Column', is => 'rw', isa => 'Num', default  => 0 );
  has 'loyalty'          => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 100 );
  has 'ability_exp'      => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( force intellect leadership popular soldier_id what_is_this )],
    validator => sub {},
  );
  has 'delete_turn' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'town_id'     => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'guard_power' => ( metaclass => 'Column', is => 'rw', isa => 'Num', default  => 0 );
  has 'host'        => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'update_time' => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'mail'        => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '@' );
  has 'is_authed'   => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 1 );
  has 'win_message' => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has 'skill'       => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      assist
      disturb
      cheer
      move 
      battle_method 
      command 
      auto_gather 
      attack 
      assist_move 
      not_used 
    )],
    validator => sub {},
  );
  has 'config' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( battle_map_hidden font_size config2 config3 config4 config5 config6 )],
    validator => sub {},
  );
  has 'skill_point'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'equipment_skill' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( book guard )],
    validator => sub {},
  );
  has 'last_login_host'    => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has 'weapon_skill'       => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => ',' );
  has 'soldier_battle_map' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      formation 
      is_sortie 
      battle_map_id 
      x 
      y 
      move_point_charge_time 
      action_time 
      move_point 
      keisu_count 
      plus_attack_power 
      plus_defence_power
      change_formation_time 
      not_used
    )],
    validator => sub {},
  );
  has 'enter_to_maze'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'guard_name'        => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'weapon_name'       => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'book_name'         => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'weapon_attr'       => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'weapon_attr_power' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'battle_and_command_record' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      kill_soldier
      die_soldier
      defence_win
      attack_win
      attack_lose
      defence_lose
      training_soldier
      domestic_administration 
      conscription
      draw 
      attack_town
      trick 
      training_self
      conquer_town 
      destroy_wall 
      maybe_not_used 
      maybe_not_used2
    )],
    validator => sub {},
  );
  has 'buffer_and_reward_and_command_skill' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      training_soldier_skill
      kill_soldier_reward
      win_reward
      lose_reward
      attack_town_skill
      kago
      kago_strong
      youdou
      youdou_strong
      kobu
      kobu_strong
      sendou
      sendou_strong
      domestic_administration_skill
      trick_skill
      training_self_skill
      kintoun
      not_used not_used2
    )],
    validator => sub {},
  );
  has 'weapon2_data' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( power name attr attr_power )],
    validator => sub {},
  );
  has 'bought_skill_point' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'interval_time'      => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( protect singeki )],
    validator => sub {},
  );
  has 'not_used'    => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has 'morale_data' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( morale morale_max )],
    validator => sub {},
  );
  has 'debuff' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( stuck )],
    validator => sub {},
  );
  has 'buff' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( not_used )],
    validator => sub {},
  );

  with 'Jikkoku::Class::Role::TextData::Division';

  __PACKAGE__->meta->make_immutable;

}

subtest 'いろんなデータでオブジェクト作成をためす' => sub {
  ok( Player->new('ybrliiu') );
  ok( Player->new('meemee') );
  ok( Player->new('leon333') );
  ok( Player->new('ryuhyo') );
  ok( Player->new('soukou') );
  ok( Player->new('define') );
  ok( Player->new('king') );
};

my $player = Player->new('ybrliiu');
ok $player->lock;

my $pid = fork();
if ($pid == 0) {
  dies_ok { $player->lock('NB_LOCK_SH') };
  exit;
}
waitpid($pid, 0);

ok $player->abort;
$pid = fork();
if ($pid == 0) {
  lives_ok { $player->lock('NB_LOCK_SH') };
  exit;
}
waitpid($pid, 0);

done_testing;
