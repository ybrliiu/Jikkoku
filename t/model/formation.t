use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Model::Formation';
use_ok $CLASS;

ok my $formation_model = $CLASS->new;

ok my $formation = $formation_model->get(10);
is $formation->id, 10;

ok my $formation_2 = $formation_model->get_by_name('円陣');
is $formation_2->name, '円陣';
is $formation_2->description, '守備力+10%+5。彎月陣、鶴翼陣に強い。得意陣形の場合は更に守備力+10%。';

ok my $hou_jin = $formation_model->get_by_name('方陣');
is $hou_jin->description, '攻撃力+10%。彎月陣、鶴翼陣に強い。得意陣形の場合は更に攻撃力+10%。';

ok my $gankou_jin = $formation_model->get_by_name('雁行陣');
is $gankou_jin->name, '雁行陣';
is $gankou_jin->description, '攻撃力+10%、守備力+10%。方陣、錘行陣、玄襄陣に強い。得意陣形の場合は更に攻撃力+10%、守備力+10%。';

done_testing;
