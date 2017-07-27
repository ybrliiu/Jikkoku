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

done_testing;
