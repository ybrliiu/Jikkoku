use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Config;
use Jikkoku::Model::BattleMap;
use Jikkoku::Model::MapLog;
use Jikkoku::Model::Chara;
use Jikkoku::Model::ExtensiveStateRecord;

my $CLASS = 'Jikkoku::Service::Skill::Protect::Protect';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get_with_option('meemee')->get;
my $extensive_state_record_model = Jikkoku::Model::ExtensiveStateRecord->new;
ok my $protect = $CLASS->new({
  chara                        => $chara,
  extensive_state_record_model => $extensive_state_record_model,
});

# 実行条件を満たすように
$chara->morale_data( morale => $chara->morale_data('morale_max') );
$chara->interval_time(protect => 0);
$chara->save;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

is @{ $extensive_state_record_model->get_all }, 0;
lives_ok { $protect->exec() };
is @{ $extensive_state_record_model->get_all }, 1;

# 元に戻す
$extensive_state_record_model->lock;
$extensive_state_record_model->delete($chara->id, 'Protect');
$extensive_state_record_model->commit;

done_testing;
