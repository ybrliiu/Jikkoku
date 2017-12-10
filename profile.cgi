#!/usr/bin/perl

use v5.14;
use warnings;

use lib './lib', './extlib';
use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use Jikkoku::Model::Chara;
use Jikkoku::Model::Country;

controller();

sub controller {
  my $cgi = CGI->new;

  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = $chara_model->get_with_option( $cgi->param('id') )->match(
    Some => sub { $_ },
    None => sub { error("武将情報を取得できませんでした。") },
  );
  my $country_model = Jikkoku::Model::Country->new;
  $country_model->get_with_option( $chara->country_id )->get_or_else( $country_model->neutral );

  render($cgi, $chara, $country);
}

sub error {
  my ($message) = @_;
  my $cgi = CGI->new;
  print $cgi->header(
	  -cache_control => 'no-cache',
    -pragma        => 'no-cache',
    -charset       => 'UTF-8',
  );
  print <<"EOS";
<!DOCTYPE html>
  <head>
    <title> ERROR! </title>
  </head>
  <body>
    <h1 class="red">ERROR!</h1>
    $message
  </body>
</html>
EOS
  exit;
}

sub render {
  my ($cgi, $chara, $country) = @_;

  print $cgi->header(-charset => 'UTF-8');

  print <<"EOS";
  <div>
    <table border="0">
      <tr>
        <td rowspan=6 width=5><img class="icon" src="image/@{[ $chara->icon ]}.gif" width="64" height="64"></td>
        <td><font size="+0.5">・名前:@{[ $chara->name ]}</td>
      </tr>
      <tr><td><font size="+0.5">・所属国 : @{[ $country->name ]}</td></tr>
      <tr><td><font size="+0.5">・武力 : @{[ $chara->force ]}</td></tr>
      <tr><td><font size="+0.5">・知力 : @{[ $chara->intellect ]}</td></tr>
      <tr><td><font size="+0.5">・統率力 : @{[ $chara->leadership ]}</td></tr>
      <tr><td><font size="+0.5">・人望 : @{[ $chara->popular ]}</td></tr>
      <tr><td colspan=2><font size="+0.5">・プロフィール : <br>@{[ $chara->profile ]}</td></tr>
    </table>
  </div>
EOS
}

