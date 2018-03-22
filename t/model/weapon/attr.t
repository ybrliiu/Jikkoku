use Test::Jikkoku;

use_ok 'Jikkoku::Model::Weapon::Attr';
ok( my $model = Jikkoku::Model::Weapon::Attr->new );
lives_ok { $model->get('無') };
dies_ok { $model->get('笑') };

done_testing;

