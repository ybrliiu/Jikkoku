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

  {
    my %escape_table = (
      q{&} => '&amp;',
      q{<} => '&lt;',
      q{>} => '&gt;',
      q{"} => '&quot;',
      q{'} => '&#39;',
      q{,} => '&#44;',
    );

    my @colors      = qw/red blue darkblue lightblue black green/;
    my @decorations = qw/b s u i sub/;
    my @tags        = (@colors, @decorations, 'a');

    sub escape {
      my $str = shift;

      # そのままテキストデータとして保存すると危険な文字を特殊文字に変換
      # <>と,はデータの区切りとして使っている
      # 他の文字はそのままhtmlとして出力すると危険(インジェクション)
      for (keys %escape_table) {
        $str =~ s/$_/$escape_table{$_}/g;
      }

      # 改行文字 -> 改行タグ
      $str =~ s/(\n|\r\n|\r)/<br>/g;

      # 使用可能なタグの変換
      for (0 .. $#tags) {
        my $tag = $tags[$_];
        if ($str =~ /&lt;$tag&gt;/) {
          if ($_ < @colors + @decorations) {
            return $str if _validate($str, $tag);
            if ($_ < @colors) {
              $str = _make_color($str, $tag);
            } elsif ($_ < @colors + @decorations) {
              $str = _make_decoration($str, $tag);
            }
          } else {
            $str = _make_link($str);
          }
        }
      }
      
      $str;
    }
      
    # 不正な形のタグが含まれていないか検査
    sub _validate {
      my ($str, $tag) = @_;
      return 1 if $str =~ qr/&lt;$tag&gt;$/;     # 末尾に開始タグがあればアウト
      
      my @validate = split /&lt;$tag&gt;/, $str; # 開始タグで分割し、全てのタグに閉じタグがあるか検査
      for (1 .. @validate - 1) {
        return 1 if $validate[$_] !~ m!&lt;/$tag&gt;!;
      }
      return 0;
    }
    
    # 色タグの作成
    sub _make_color {
      my ($str, $tag) = @_;
      $str =~ s/&lt;$tag&gt;/<span style="color:$tag">/g;
      $str =~ s!&lt;/$tag&gt;!</span>!g;  
      $str;
    }
    
    # 装飾タグの作成
    sub _make_decoration {
      my ($str, $tag) = @_;
      $str =~ s/&lt;$tag&gt;/<$tag>/g;
      $str =~ s!&lt;/$tag&gt;!</$tag>!g;
      $str;
    }   
    
    # リンクタグの検査、作成
    sub _make_link {
      my $str = shift;
      return $str if $str =~ /&lt;a&gt;$/;
      
      my @validate = split(/&lt;a&gt;/, $str);
      my (@url, @name);
      for(1 .. @validate-1){
        ($url[$_])  = $validate[$_] =~ /url:(.*?) name:/;          # URL抽出
        ($name[$_]) = $validate[$_] =~ / name:(.*?)&lt;\/a&gt;/;   # リンク名抽出
        return $str unless $name[$_] && $url[$_];                  # URLかリンク名、閉じタグがなければアウト
        ($validate[$_]) = $validate[$_] =~ /(?<=&lt;\/a&gt;)(.*)/; # 閉じタグより後ろの部分を抽出
      }
      
      my $result = $validate[0];
      $result .= qq{<a href="$url[$_]">$name[$_]</a>$validate[$_]} for 1 .. @validate - 1;
      $result;
    }

    sub unescape {
      my $str = shift;
      $str = _restore_color($str, $_) for @colors;
      _restore_link($str);
    }

    sub _restore_color {
      my ($str, $tag) = @_;
      my $start_tag = qq{<span style="color:$tag">};
      my @restore = split /$start_tag/, $str;
      my $head = shift @restore;
      @restore = map {
        my $tmp = $start_tag . $_;
        $tmp =~ s/$start_tag/<$tag>/;
        $tmp =~ s!</span>!</$tag>!;
        $tmp;
      } @restore;
      $head . join '', @restore;
    }
    
    sub _restore_link {
      my ($str) = @_;
      my $start_tag = "<a";
      my @restore = split /$start_tag/, $str;
      my $head    = shift @restore;
      @restore = map {
        my $tmp = $start_tag . $_;
        my ($url, $name) = $tmp =~ m!<a href="(.*)">(.*)</a>!;
        $tmp =~ s/ href="$url"//;
        $tmp =~ s/<a>/<a>url:$url name:$name/;
        $tmp;
      } @restore;
      $head . join '', @restore;
    }
  }
  
}

1;
