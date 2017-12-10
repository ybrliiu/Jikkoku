use lib './lib', './extlib';
use Jikkoku;
use Plack::App::WrapCGI;

my $app = Plack::App::WrapCGI->new(script => 'jikkoku.cgi', execute => 1)->to_app;

