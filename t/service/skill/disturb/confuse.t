use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Service::Chara::Soldier::Sortie;

my $CLASS = 'Jikkoku::Service::Skill::Disturb::Confuse';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = $chara_model->get_with_option('ybrliiu')->get;
my $meemee      = $chara_model->get_with_option('meemee')->get;

subtest success_case => sub {
  my $stuck = $CLASS->new({
    chara     => $chara,
    target_id => 'meemee',
  });
  eval { $stuck->exec };
  diag $@;
  ok 1;
};

done_testing;
