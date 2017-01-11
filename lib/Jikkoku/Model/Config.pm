package Jikkoku::Model::Config {

  use v5.14;
  use warnings;

  use constant DIR_PATH => 'etc/';

  my @CONFIG_FILES = qw/
    game
    country_color
    country_background_color
    country_background_color_rgba
  /;
  my %Config;

  __PACKAGE__->load( @CONFIG_FILES );

  sub load {
    my ($class, @config_files) = @_;
    for (@config_files) {
      %Config = (
        %Config,
        %{ do(DIR_PATH() . "$_.conf") },
      );
    }
  }

  sub get {
    \%Config;
  }

}

1;

=encoding utf8

=head1 NAME
  
  Jikkoku::Model::Config - 設定値コンテナクラス
                           アプリケーション中で使用する様々な設定ファイルを読み込み、その設定値を保持、公開するクラス

=head1 SYNOPSIS

  use Jikkoku::Model::Config;

  my $config = Jikkoku::Model::Config;
  $config->{game}{start_year};           # ゲーム開始年

=head1 メソッド
  
=head2 load
  
  設定ファイルが置かれているディレクトリから設定ファイルをロードします。
  このクラスが読み込まれた時に呼ばれます。

=head2 get 
  
  設定ファイルから読み込んだ設定値を保持したハッシュを外部から参照できるようにするメソッド

=cut
