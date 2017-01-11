package Jikkoku::Model::Chara {

  use v5.14;
  use warnings;
  use Jikkoku::Util qw/open_data create_data/;
  use Jikkoku::Class::Chara;

  sub new {
    my ($class) = @_;
    bless {
      all_list   => [],
      stock_list => [],
    }, $class;
  }

  sub get {
    my ($class, $id) = @_;
    my $textdata = open_data( Jikkoku::Class::Chara->file_path($id) )->[0];
    Jikkoku::Class::Chara->new($textdata);
  }

  sub get_all {
    my ($self) = @_;

    return $self->{all_list} if ref $self and @{ $self->{all_list} };

		opendir(my $dh, Jikkoku::Class::Chara->FILE_DIR_PATH);
    my @chara_list = map {
      if ( (my $file = $_) =~ /\.cgi/i ) {
        my $id = ($file =~ s/\.cgi//r);
        $self->get($id);
      } else {
        ();
      }
    } readdir $dh;
		closedir $dh;

    return \@chara_list unless ref $self;
    $self->{all_list} = \@chara_list;
  }

  sub first {
    my ($self, $code) = @_;
    my $chara_list = $self->get_all;
    for my $chara (@$chara_list) {
      return $chara if $code->($chara);
    }
    undef;
  }

  sub to_hash {
    my ($class, $list) = @_;
    +{ map { $_->id => $_ } @$list };
  }

  sub delete {
    my ($class, $id) = @_;
    unlink Jikkoku::Class::Chara->file_path($id);
  }

  sub create {
    my ($class, $id) = @_;
    create_data( Jikkoku::Class::Chara->file_path($id), [] );
  }

}

1;
