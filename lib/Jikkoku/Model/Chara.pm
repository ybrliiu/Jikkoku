package Jikkoku::Model::Chara {

  use Jikkoku;
  use Jikkoku::Util qw/if_test TEST_DIR open_data create_data validate_values/;
  use Jikkoku::Class::Chara;
  use Option;

  sub new {
    my ($class) = @_;
    bless {
      data   => {},
      result => [],
    }, $class;
  }

  sub get {
    my ($class, $id) = @_;
    Jikkoku::Class::Chara->new($id);
  }

  *opt_get = \&get_with_option;

  sub get_with_option {
    my ($self, $id) = @_;

    # for class method ...
    if (not ref $self) {
      return Option->new( $self->get($id) );
    }

    if (exists $self->{data}{$id}) {
      my $chara = $self->{data}{$id};
      return Option->new($chara);
    }

    eval { Jikkoku::Class::Chara->new($id) };

    if (my $e = $@) {
      warn $e;
      Option::None->new;
    } else {
      my $chara = Jikkoku::Class::Chara->new($id);
      $self->{data}{$id} = $chara;
      Option->new($chara);
    }

  }

  sub get_all {
    my ($self) = @_;

    my $dir_path = Jikkoku::Class::Chara->DIR_PATH;
    if_test { $dir_path = TEST_DIR . $dir_path };
		opendir(my $dh, $dir_path);
    my @chara_list = map {
      if ( (my $file = $_) =~ /.+\.cgi$/i ) {
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

  sub get_same_bm_id_and_same_point_and_enemy_charactors {
    my ($self, $bm_id, $x, $y) = @_;
    Carp::croak 'few argments($bm_id, $x, $y)' if @_ < 4;
    [ grep { $_->is_same_position($bm_id, $x, $y) } @{ $self->get_all } ];
  }

  sub has_enemies_on_the_position {
    my ($self, $args) = @_;
    validate_values $args => [qw/ battle_map_id point country_id /];
    $self->first(sub {
      my $chara = shift;
      $chara->soldier->is_same_position( $args->{battle_map_id}, $args->{point} ) && $chara->country_id != $args->{country_id};
    });
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
