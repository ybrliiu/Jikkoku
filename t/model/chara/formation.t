use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Model::Chara::Formation';
use_ok $CLASS;

require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = $chara_model->get_with_option('ybrliiu')->get;
ok my $formation_model = $CLASS->new(chara => $chara);

done_testing;

