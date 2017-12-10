#! /usr/bin/perl

use lib './lib', './extlib';
use Jikkoku;
use CGI::Carp qw/ fatalsToBrowser warningsToBrowser /;
use Jikkoku::Web;

my $app = Jikkoku::Web->new;
$app->run;

