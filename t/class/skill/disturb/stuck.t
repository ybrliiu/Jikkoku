use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Devel::Peek;

my $CLASS = 'Jikkoku::Class::Skill::Disturb::Stuck';
use_ok $CLASS;

{
  require Jikkoku::Model::Chara;
  my $chara_model = Jikkoku::Model::Chara->new;
  require Jikkoku::Model::BattleMap;
  my $battle_map_model = Jikkoku::Model::BattleMap->new;
  my $chara = $chara_model->get('ybrliiu');
  ok(my $skill = $CLASS->new({chara => $chara, battle_map_model => $battle_map_model}));
  $chara->intellect(100);
  diag $skill->explain_effect;
  diag $skill->explain_status;
  diag $skill->explain_acquire;
  ok !$chara->states->get('Stuck')->is_in_the_state(time);
  dies_ok { $skill->acquire };
  ok $@ =~ /修得条件を満たしていません/;
}

done_testing;
