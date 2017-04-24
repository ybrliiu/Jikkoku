use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Class::Skill::Disturb::Stuck';
use_ok $CLASS;

{
  require Jikkoku::Model::Chara;
  my $chara_model = Jikkoku::Model::Chara->new;
  require Jikkoku::Model::BattleMap;
  my $battle_map_model = Jikkoku::Model::BattleMap->new;
  my $chara = $chara_model->get('ybrliiu');
  ok my $skill = $CLASS->new({ chara => $chara });
  $chara->intellect(100);
  ok !$chara->states->get('Stuck')->is_available(time);
  dies_ok { $skill->acquire };
  is $@->message, '修得条件を満たしていません(混乱を修得していないため)';

  diag $skill->explain_effect;
  diag $skill->explain_effect_simple;
}

done_testing;
