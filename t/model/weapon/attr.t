use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Model::Weapon::Attr';
ok( my $model = Jikkoku::Model::Weapon::Attr->new );
lives_ok { $model->get('無') };
dies_ok { $model->get('笑') };

done_testing;

