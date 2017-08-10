use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Country::Position';
use_ok $CLASS;

ok my $model = $CLASS->new;
ok my $position = $model->get('premier');
is $position->name, '宰相';
dies_ok { $model->get('雑用係') };

done_testing;

