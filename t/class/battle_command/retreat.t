use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::BattleCommand::Retreat';
use_ok $CLASS;

use Jikkoku::Model::Chara;
my $c_m = Jikkoku::Model::Chara->new;
my $chara = $c_m->get('ybrliiu');

ok( my $retreat = $CLASS->new({chara => $chara}) );
dies_ok { $retreat->action };

done_testing;
