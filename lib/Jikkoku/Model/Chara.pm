package Jikkoku::Model::Chara {

  use Jikkoku;
  use Jikkoku::Util qw/if_test TEST_DIR open_data create_data/;
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

    # for class method ...
    if (not ref $self) {
      return Option->new( $self->get($id) );
    }

    if (exists $self->{data}{$id}) {
      my $chara = $self->{data}{$id};
      return Option->new($chara);
    }

    my $textdata = eval {
      open_data( Jikkoku::Class::Chara->file_path($id) )->[0];
    };

    if (my $e = $@) {
      Option::None->new;
    } else {
      my $chara = Jikkoku::Class::Chara->new($textdata);
      $self->{data}{$id} = $chara;
      Option->new($chara);
    }

  }

  sub get_all {
    my ($self) = @_;

    my $dir_path = Jikkoku::Class::Chara->FILE_DIR_PATH;
    if_test { $dir_path = TEST_DIR . $dir_path };
		opendir(my $dh, $dir_path);
    my @chara_list = map {
      if ( (my $file = $_) =~ /\.cgi/i ) {
        my $id = ($file =~ s/\.cgi//r);
        $self->opt_get($id)->get;
      } else {
        ();
      }
    } readdir $dh;
		closedir $dh;

    return \@chara_list unless ref $self;
    $self->{data} = $self->to_hash(\@chara_list);
    return \@chara_list;
  }

  sub get_same_country {
    my ($self, $country_id) = @_;
    [ grep { $country_id == $_->country_id } @{ $self->get_all } ];
  }

  sub get_same_bm_and_not_same_country {
    my ($self, $chara) = @_;
    [ grep {
      $chara->country_id != $_->country_id
        && $chara->soldier_battle_map('battle_map_id') eq $_->soldier_battle_map('battle_map_id')
    } @{ $self->get_all } ];
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
