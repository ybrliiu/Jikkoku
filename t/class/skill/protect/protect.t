use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Class::Skill::Protect::Protect';
use_ok $CLASS;

require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->opt_get('meemee')->get;
ok my $protect = $CLASS->new({ chara => $chara });

my $description_of_status = <<'EOS';
消費士気 : 10<br>
再使用時間 : 240秒<br>
成功率 : 100%
EOS
chomp($description_of_status);
is $protect->explain_status, $description_of_status;

diag $protect->explain_acquire;

# 実行条件を満たすように
$chara->morale_data( morale => $chara->morale_data('morale_max') );
$chara->interval_time(protect => 0);
$chara->save;

# 設定ファイル通りの時間だといつでもテストできないので
require Jikkoku::Model::Config;
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

require Jikkoku::Model::BattleMap;
require Jikkoku::Model::MapLog;
require Jikkoku::Model::Chara;
require Jikkoku::Model::Chara::Protector;
my $protector_model = Jikkoku::Model::Chara::Protector->new;
is @{ $protector_model->get_all }, 0;
ok $protect->exec({
  chara_model      => Jikkoku::Model::Chara->new,
  battle_map_model => Jikkoku::Model::BattleMap->new,
  map_log_model    => Jikkoku::Model::MapLog->new,
  protector_model  => $protector_model,
});
is @{ $protector_model->get_all }, 1;
diag explain $protector_model->get_all;

# 元に戻す
$protector_model->delete('meemee');
$protector_model->save;

done_testing;
