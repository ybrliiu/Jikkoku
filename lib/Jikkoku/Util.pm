package Jikkoku::Util {

  use v5.14;
  use warnings;

  use Exporter 'import';
  our @EXPORT_OK = qw/
    open_data save_data create_data
    validate_values
    daytime datetime
  /;
  use Carp qw/croak/;
  use Time::Piece;

  use constant CHARA_DATA_DIR_PATH => 'charalog/main';

  sub open_data {
    my ($file_name) = @_;
    open(my $fh, '<', $file_name) or croak "$file_nameを開けませんでした";
    my @file_data = map { chomp $_; $_; } <$fh>;
    $fh->close();
    return \@file_data;
  }

  sub save_data {
    my ($file_name, $file_data) = @_;
		open(my $fh, '+<', $file_name) or croak "$file_nameを開けませんでした";
    flock($fh, 2);
    truncate($fh, 0);
    seek($fh, 0, 0);
    $fh->print( map { "$_\n" } @$file_data );
    $fh->close;
  }

  sub create_data {
    my ($file_name, $file_data) = @_;
    croak "$file_name というファイルは既に存在しています" if -f $file_name;
    open(my $fh, '>', $file_name);
    $fh->print( map { "$_\n" } @$file_data );
    $fh->close;
  }

  sub validate_values {
    my ($args, $keys, $name) = @_;
    $name = defined $name ? "$name\の" : '';

    croak 'HashRefが渡されていません' if ref $args ne 'HASH';

    my @not_exists = grep { not exists $args->{$_} } @$keys;
    if (@not_exists) {
      my ($file, $line) = (caller 1)[1 .. 2];
      # die関数の最後に\nを入れるとdieした時にファイル名と行が出力されなくなる
      die "$name キーが足りません(@{[ join(', ', @not_exists) ]}) at $file line $line\n";
    }
  }

  sub daytime {
    my ($time) = @_;
    my $t = localtime($time);
    $t->strftime('%d日%H時%M分%S秒');
  } 
  
  sub datetime {
    my ($time) = @_;
    my $t = localtime($time);
    $t->strftime('%Y/%m/%d(%a) %H:%M:%S');
  }

  sub open_all_chara_data {
		opendir(my $dh, CHARA_DATA_DIR_PATH);
    my @all_data = map {
      if ((my $file = $_) =~ m!.cgi!i) {
        my @data = @{ open_data(CHARA_DATA_DIR_PATH . "/$file") };
        "@data<br>";
      } else {
        ();
      }
    } readdir $dh;
		closedir($dh);
    return \@all_data;
  }

  sub average_loyalty {
    my ($country_id, $all_chara_data) = @_;
    return 0 if $country_id eq '0' || $country_id eq '';
    $all_chara_data //= open_all_chara_data();

    my $average_loyalty = do {
      my $country_sum = 0;
      my $loyalty_sum = 0;
      for (@$all_chara_data) {
        my (
          $id, $pass,     $name, $chara, $str, $int,   $lea, $cha,  $sol,
          $gat, $country, $gold, $rice,  $cex, $class, $arm, $book, $loyalty,
        ) = split(/<>/);
        if ($country_id eq $country) {
          $loyalty_sum += $loyalty;
          $country_sum++;
        }
      }
      croak "指定された国IDの武将が存在しません(country_id : $country_id)" if $country_sum == 0;
      int $loyalty_sum / $country_sum;
    };
    return $average_loyalty;
  }

}

1;
