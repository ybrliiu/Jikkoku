package Jikkoku::Model::Town {

  use Mouse;
  use Jikkoku;

  use Carp;
  use Jikkoku::Util;

  use constant {
    INFLATE_TO        => 'Jikkoku::Class::Town',
    FILE_PATH         => 'log_file/town_data.cgi',
    INIT_FILE_PATH    => 'log_file/f_town_data.cgi',
    PRIMARY_ATTRIBUTE => 'id',
  };

  has 'name_map' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->name => $_ } values %{ $self->data } };
    },
  );

  has 'map_data' => (
    is      => 'ro',
    isa     => 'ArrayRef[ArrayRef]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      my $map_data = [];
      for my $town (@{ $self->get_all }) {
        $map_data->[ $town->y ][ $town->x ] = $town;
      }
      $map_data;
    },
  );

  with 'Jikkoku::Model::Role::TextData::General::Integration';

  around _objects_data_to_textdata_list => sub {
    my ($orig, $self) = @_;
    [ map { ${ $_->textdata } } sort { $a->id <=> $b->id } values %{ $self->data } ];
  };

  around _textdata_list_to_objects_data => sub {
    my ($orig, $class, $textdata_list) = @_;
    my $index = 0;
    my @objects = map {
      my $textdata = $_ . $index++ . '<>';
      $class->INFLATE_TO->new($textdata);
    } @$textdata_list;
    $class->to_hash( \@objects );
  };
  
  around init => sub {
    my ($orig, $class) = @_;
    my $init_data = Jikkoku::Util::open_data($class->INIT_FILE_PATH);
    Jikkoku::Util::save_data($class->FILE_PATH, $init_data);
  };

  sub get_by_name {
    my ($self, $name) = @_;
    Carp::croak 'Too few arguments (required: $name)' if @_ < 2;
    $self->name_map->{$name};
  }

  sub get_by_coordinate {
    my ($self, $x, $y) = @_;
    Carp::croak 'Too few arguments (required: $x, $y)' if @_ < 3;
    $self->map_data->[$y][$x];
  }

  sub get_towns_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'Too few arguments (required: $country_id)' if @_ < 2;
    [ grep { $_->country_id == $country_id } @{ $self->get_all } ];
  }

  sub set_all_stay_charactors {
    my ($self, $charactors, $country_id) = @_;
    for my $chara (@$charactors) {
      if ($chara->country_id eq $country_id) {
        my $town = $self->get( $chara->town_id );
        $town->{stay_charactors} .= $chara->name . ' ';
        $town->{stay_charactors_num}++;
      }
    }
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

