# 取り急ぎ既存のプログラムをpsgi化

use v5.24;
use warnings;

use File::Basename 'dirname';
use Plack::Builder;
use Plack::App::CGIBin;

my $base_dir = dirname __FILE__;

builder {

  enable 'Plack::Middleware::Static' => (
    path => qr!^/(js|css|image|html|public|REKISI)!,
    root => $base_dir,
  );

  mount '/' => Plack::App::CGIBin->new(
    root    => $base_dir,
    exec_cb => sub { 1 },
  )->to_app;

};

