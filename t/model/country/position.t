use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Country::Position';
use_ok $CLASS;

ok my $model = $CLASS->new;
ok my $position = $model->get('premier');
is $position->name, '宰相';
is @{ $model->get_headquarters }, 3;
dies_ok { $model->get('雑用係') };

done_testing;

