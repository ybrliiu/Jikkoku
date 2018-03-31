use lib './etc', './lib', './extlib';
use Jikkoku;
use Jikkoku::Web;
use Plack::Builder;

my $app = Jikkoku::Web->new;
my $builder = Plack::Builder->new;
$builder->add_middleware('Static', path => qr/(.*?)\.(js|css|png|gif)/, root => './public');
$builder->wrap($app->run);
