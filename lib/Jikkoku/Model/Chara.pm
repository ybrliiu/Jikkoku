package Jikkoku::Model::Chara {

  use Jikkoku;
  use Jikkoku::Util qw/open_data create_data/;
  use Jikkoku::Class::Chara;
  use Option;

  sub new {
    my ($class) = @_;
    bless {
      data  => {},
      stock => [],
    }, $class;
  }

  sub get {
    my ($class, $id) = @_;
    my $textdata = open_data( Jikkoku::Class::Chara->file_path($id) )->[0];
    Jikkoku::Class::Chara->new($textdata);
  }

  sub opt_get {
    my ($self, $id) = @_;

    if (exists $self->{data}{$id}) {
      my $chara = $self->{data}{$id};
      return Option->new($chara);
    }

    my $textdata = eval {
      open_data( Jikkoku::Class::Chara->file_path($id) )->[0];
    };
    if (defined $textdata) {
      my $chara = Jikkoku::Class::Chara->new($textdata);
      $self->{data}{$id} = $chara;
      Option->new($chara);
    } else {
      Option::None->new;
    }
  }

  sub get_all {
    my ($self) = @_;

    return [ values %{ $self->{data} } ] if ref $self and %{ $self->{data} };

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
    $self->{data} = $self->to_hash(\@chara_list);
    return \@chara_list;
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
