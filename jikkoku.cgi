use lib './etc', './lib', './extlib';
use Jikkoku;
use Jikkoku::Web;
my $app = Jikkoku::Web->new;
$app->run;
