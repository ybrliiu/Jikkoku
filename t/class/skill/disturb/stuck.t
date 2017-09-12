use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Model::BattleMap;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::Skill::Disturb::Stuck';
use_ok $CLASS;

{
  my $chara_model = Jikkoku::Model::Chara->new;
  my $battle_map_model = Jikkoku::Model::BattleMap->new;
  my $chara = $chara_model->get('ybrliiu');
  ok my $skill = $CLASS->new({ chara => $chara });
  $chara->intellect(100);
  ok !$chara->states->get('Stuck')->is_available(time);
  dies_ok { $skill->acquire };
  is $@->message, '修得条件を満たしていません(混乱を修得していないため)';

  my $description_of_effect = <<'EOS';
敵1人に足止めを付与する。(効果 : 消費移動Pが元の消費移動Pの0.7倍増加します。)<br>
効果持続時間は<strong>250</strong>秒〜<strong>350</strong>秒。<br>
成功率、効果時間は知力に依存。
EOS
  chomp $description_of_effect;
  is $skill->description_of_effect, $description_of_effect;

  my $description_of_effect_simple = <<'EOS';
敵1人に足止めを付与する。(効果 : 消費移動Pが元の消費移動Pの0.7倍増加します。)<br>
成功率、効果時間は知力に依存。<br>
消費士気12。
EOS
  chomp $description_of_effect_simple;
  is $skill->description_of_effect_simple, $description_of_effect_simple;

  my $description_of_acquire = <<'EOS';
混乱を修得していること。<br>
スキル修得ページでSPを10消費して修得。
EOS
  chomp($description_of_acquire);
  is $skill->description_of_acquire, $description_of_acquire;

}

done_testing;
