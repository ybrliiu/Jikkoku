package Jikkoku::Model::Diplomacy {

  use Mouse;
  use Jikkoku;

  use Option;
  use List::Util qw( first );
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Class::Diplomacy::DeclareWar;

  use constant {
    FILE_PATH         => 'log_file/kousen.cgi',
    INFLATE_TO        => 'Jikkoku::Class::Diplomacy',
    PRIMARY_ATTRIBUTE => 'type_and_both_country_id',
  };

  with 'Jikkoku::Model::Role::TextData::General::Integration';
  
  around _textdata_list_to_objects_data => sub {
    my ($orig, $class, $textdata_list) = @_;
    my @objects = map {
      my $diplomacy = $class->INFLATE_TO->new($_);
      $diplomacy->type == $diplomacy->DECLARE_WAR ? Jikkoku::Class::Diplomacy::DeclareWar->new($_) : $diplomacy;
    } @$textdata_list;
    $class->to_hash(\@objects);
  };

  sub make_id {
    my $args = shift;
    validate_values $args => [qw/ type request_country_id receive_country_id /];
    "$args->{type}.$args->{request_country_id}.$args->{receive_country_id}";
  }

  around get => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig( ref $_[0] eq 'HASH' ? make_id($_[0]) : $_[0] );
  };

  around get_with_option => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig( ref $_[0] eq 'HASH' ? make_id($_[0]) : $_[0] );
  };

  around delete => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig( ref $_[0] eq 'HASH' ? make_id($_[0]) : $_[0] );
  };

  sub get_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    [
      sort { $a->type_and_both_country_id cmp $b->type_and_both_country_id }
      grep { $_->has_country_id( $country_id ) } values %{ $self->data }
    ];
  }

  sub get_by_type_and_both_country_id {
    my ($self, $type, $country_id, $country_id2) = @_;
    Carp::croak 'few arguments($type, $country_id, $country_id2)' if @_ < 4;
    my $diplomacy = first {
      $_->has_type_and_both_country_id( $type, $country_id, $country_id2 )
    } values %{ $self->data };
    option $diplomacy;
  }

  sub add {
    my ($self, $args) = @_;
    validate_values $args => [qw/ type request_country_id receive_country_id /];

    my $new_diplomacy = do {
      if ( $args->{type} == $self->INFLATE_TO->DECLARE_WAR ) {
        validate_values $args => [qw/ start_game_date now_game_date /];
        Jikkoku::Class::Diplomacy::DeclareWar->new(%$args);
      } else {
        $self->INFLATE_TO->new($args);
      }
    };

    $self->get_with_option( $new_diplomacy->type_and_replace_country_id )
      ->foreach( sub { die "既に相手国から外交要請が届いています。\n" } );

    $self->get_with_option( $new_diplomacy->type_and_both_country_id )
      ->foreach( sub { die "既に外交要請を出しています。\n" } );

    $self->data->{ $new_diplomacy->type_and_both_country_id } = $new_diplomacy;
  }

  sub delete_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    $self->data(+{
      map {
        my $diplomacy = $_;
        $diplomacy->has_country_id( $country_id ) ? () : ($diplomacy->type_and_both_country_id => $diplomacy);
      } values %{ $self->data }
    });
  }

  sub can_attack {
    my ($self, $country_id, $target_country_id, $now_game_date) = @_;
    Carp::croak 'few arguments($country_id, $target_country_id, $now_game_date)' if @_ < 4;
    my $is_territory_trading = $self
      ->get_by_type_and_both_country_id( $self->INFLATE_TO->CESSION_OR_ACCEPT_TERRITORY, $country_id, $target_country_id )
      ->exists( sub { $_->is_accepted } );
    my $is_war_started = $self
      ->get_by_type_and_both_country_id( $self->INFLATE_TO->DECLARE_WAR, $country_id, $target_country_id )
      ->exists( sub { $_->can_invation( $now_game_date ) } );
    $is_territory_trading || $is_war_started;
  }

  sub can_passage {
    my ($self, $country_id, $target_country_id, $now_game_date) = @_;
    Carp::croak 'few arguments($country_id, $target_country_id, $now_game_date)' if @_ < 4;
    my $can_attack = $self->can_attack( $country_id, $target_country_id, $now_game_date );
    my $is_passage_allowed = $self
      ->get_by_type_and_both_country_id( $self->INFLATE_TO->ALLOW_PASSAGE, $country_id, $target_country_id )
      ->exists( sub { $_->is_accepted } );
    $can_attack || $is_passage_allowed;
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;
