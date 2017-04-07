use v5.24;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Plack::Loader;
use Plack::Util ();

my $app = Plack::Util::load_psgi('to_psgi.psgi');


test_psgi $app => sub {
  my ($cb) = @_;

  # テスト用のファイルの使用を HARNESS_ACTIVE で区別しているので
  # ここでのみ無効化する
  local $ENV{HARNESS_ACTIVE} = 0;

  my %form_info = (id => 'ybrliiu', pass => 'doodoo5');

  subtest 'index.cgi' => sub {
    my $res = $cb->(GET 'index.cgi');
    is $res->code, 200;
    like $res->content, qr/十国志NET/;
  };

  subtest 'status.cgi' => sub {
    my $err_res = $cb->(POST 'status.cgi');
    is $err_res->code, 200;
    like $err_res->content, qr/ERROR/;

    my $res = $cb->(POST 'status.cgi', [%form_info, mode => 'STATUS']);
    is $res->code, 200;
    like $res->content, qr/りーう＠管理人/;
  };

  subtest 'newbm.cgi' => sub {
    my $res = $cb->(POST 'newbm.cgi', [%form_info, mode => 'STATUS']);
    is $res->code, 200;
    like $res->content, qr/りーう＠管理人/;
  };

  subtest 'mydata.cgi' => sub {
    my $mydata_res = $cb->(POST 'mydata.cgi', [%form_info, mode => 'MYDATA']);
    is $mydata_res->code, 200;
    like $mydata_res->content, qr/順位/;
  };

};

done_testing;
