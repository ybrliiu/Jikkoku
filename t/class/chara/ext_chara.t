use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Chara;

my $CLASS = 'Jikkoku::Class::Chara::ExtChara';
use_ok $CLASS;

my $chara = Jikkoku::Model::Chara->new->get_with_option('ybrliiu')->get;
ok( my $ext_chara = $CLASS->new(chara => $chara) );
is $ext_chara->id, 'ybrliiu';
is $ext_chara->soldier->name, '雑兵';
is $ext_chara->formation->name, '陣形なし';
is $ext_chara->weapon->name, '針金';
ok !$ext_chara->is_invasion;
lives_ok { $ext_chara->morale_data('morale') };
lives_ok { $ext_chara->save_battle_log("aaaaaaa") }

subtest 'file handler' => sub {
  my $orig = $ext_chara->soldier->num;
  $ext_chara->lock;
  $ext_chara->soldier->num(100);
  $ext_chara->commit;
  is $ext_chara->soldier->num, 100;
  $ext_chara->soldier->num($orig);
  $ext_chara->save;
  is $ext_chara->soldier->num, $orig;
};

is $ext_chara->country->name, '梁山泊';
diag $ext_chara->attack_power;
diag $ext_chara->defence_power;

done_testing;
