package Jikkoku::Model::Chara {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

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

  use Carp;
  use Option;

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Chara]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  has 'name_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Chara]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->name => $_ } @{ $self->data } };
    },
  );

  with 'Jikkoku::Model::Role::Result';

  sub get_with_option {
    my ($self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 2;
    Option->new( $self->id_map->{$id} );
  }

  sub get_by_name_with_option {
    my ($self, $name) = @_;
    Carp::croak 'few arguments($name)' if @_ < 2;
    Option->new( $self->name_map->{$name} );
  }

  sub get_charactors_by_country_id_with_result {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    $self->create_result([ grep { $country_id == $_->country_id } @{ $self->data } ]);
  }

  sub get_not_applicable_charactors_by_country_id_with_result {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    $self->create_result([ grep { $country_id != $_->country_id } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_bm_id_with_result {
    my ($self, $bm_id) = @_;
    Carp::croak 'few arguments($bm_id)' if @_ < 2;
    $self->create_result([ grep { $bm_id eq $_->soldier->battle_map_id } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_distance_less_than_with_result {
    my ($self, $point, $distance) = @_;
    Carp::croak 'few arguments($point, $distance)' if @_ < 3;
    $self->create_result([ grep { $_->soldier->distance_from_point($point) <= $distance } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_point_with_result {
    my ($self, $point) = @_;
    Carp::croak 'few arguments($point)' if @_ < 2;
    $self->create_result([ grep { $_->soldier->is_same_point($point) } @{ $self->data } ]);
  }

  sub get_charactors_by_soldier_point_as_coordinate_with_result {
    my ($self, $x, $y) = @_;
    Carp::croak 'few arguments($x, $y)' if @_ < 3;
    $self->create_result([ grep { $_->soldier->is_same_point_as_coordinate($x, $y) } @{ $self->data } ]);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
