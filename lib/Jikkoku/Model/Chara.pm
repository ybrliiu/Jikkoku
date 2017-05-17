package Jikkoku::Model::_Chara {

  use Mouse;
  use Jikkoku;

  use constant {
    INFLATE_TO        => 'Jikkoku::Class::Chara',
    PRIMARY_ATTRIBUTE => 'id',
  };

  with 'Jikkoku::Model::Role::Division';

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

  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Chara::Result {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Model::Role::Result';

  sub get_charactors_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    $self->create_result([ grep { $country_id == $_->country_id } @{ $self->data } ]);
  }

  sub get_not_applicable_charactors_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    $self->create_result([ grep { $country_id != $_->country_id } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_bm_id {
    my ($self, $bm_id) = @_;
    Carp::croak 'few arguments($bm_id)' if @_ < 2;
    $self->create_result([ grep { $bm_id eq $_->soldier->battle_map_id } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_coordinate {
    my ($self, $x, $y) = @_;
    Carp::croak 'few arguments($x, $y)' if @_ < 3;
    $self->create_result([ grep { $_->soldier->is_same_point_as_coordinate($x, $y) } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_position_as_coordinate {
    my ($self, $bm_id, $x, $y) = @_;
    Carp::croak 'few arguments($bm_id, $x, $y)' if @_ < 4;
    $self->create_result([
      grep {
        $_->soldier->is_same_position_as_coordinate($bm_id, $x, $y)
      } @{ $self->data }
    ]);
  }

  sub has_charactors_on_the_position {
    my ($self, $bm_id, $point) = @_;
    Carp::croak 'few arguments($bm_id, $point)' if @_ < 3;
    $self->first(sub {
      my $chara = shift;
      $chara->soldier->is_same_position($bm_id, $point);
    });
  }

  __PACKAGE__->meta->make_immutable;

}

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
    my ($self, $id) = @_;
    Jikkoku::Class::Chara->new($id);
  }

  sub get_with_option {
    my ($self, $id) = @_;

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
    my $self = shift;

    my $dir_path = Jikkoku::Class::Chara->DIR_PATH;
    if_test { $dir_path = TEST_DIR . $dir_path };
		opendir(my $dh, $dir_path);
    my @chara_list = map {
      if ( (my $file = $_) =~ /.+\.cgi$/i ) {
        my $id = ($file =~ s/\.cgi//r);
        $self->get_with_option($id)->get;
      } else {
        ();
      }
    } readdir $dh;
		closedir $dh;

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
