package Jikkoku::Model::Diplomacy {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Integration';

  use Jikkoku::Class::Diplomacy;
  use Jikkoku::Class::Diplomacy::DeclareWar;

  use Carp qw/croak/;
  use List::Util qw/first/;
  use Scalar::Util qw/blessed/;
  use Jikkoku::Util qw/validate_values/;

  use constant {
    CLASS             => 'Jikkoku::Class::Diplomacy',
    DECLARE_WAR_CLASS => 'Jikkoku::Class::Diplomacy::DeclareWar',
    ROLE              => 'Jikkoku::Class::Role::Diplomacy',
    FILE_PATH         => 'log_file/kousen.cgi',
  };
  
  # override
  sub _textdata_list_to_objects_data {
    my ($self) = @_;
    my $objects = [ map {
      my $diplomacy = CLASS->new($_);
      $diplomacy->type == $diplomacy->DECLARE_WAR ? DECLARE_WAR_CLASS->new($_) : $diplomacy;
    } @{ $self->{_textdata_list} } ];
    $self->to_hash( $objects );
  }
  
  # override
  sub get {
    my ($self, $id) = @_;
    if (ref $id eq 'HASH') {
      my $args = $id;
      validate_values $args => [qw/type request_country_id receive_country_id/];
      $id = "$args->{type}.$args->{request_country_id}.$args->{receive_country_id}";
    }
    my $object = $self->{data}{$id};
    blessed $object && $object->DOES( ROLE ) ? $object : Carp::croak " データが見つかりませんでした ($id) ";
  }

  # override
  sub delete {
    my ($self, $id) = @_;
    if (ref $id eq 'HASH') {
      my $args = $id;
      validate_values $args => [qw/type request_country_id receive_country_id/];
      $id = "$args->{type}.$args->{request_country_id}.$args->{receive_country_id}";
    }
    $self->SUPER::delete($id);
  }

  sub get_by_country_id {
    my ($self, $country_id) = @_;
    [
      sort {
        $a->type_and_both_country_id cmp $b->type_and_both_country_id
      } grep { 
        $_->has_country_id( $country_id )
      } values %{ $self->{data} }
    ];
  }

  sub get_by_type_and_both_country_id {
    my ($self, $type, $country_id, $country_id2) = @_;
    croak "引数が足りません" if @_ < 4;
    my $diplomacy = first {
      $_->has_type_and_both_country_id( $type, $country_id, $country_id2 )
    } values %{ $self->{data} };
    blessed $diplomacy && $diplomacy->DOES( ROLE ) ? Option::Some->new($diplomacy) : Option::None->new;
  }

  sub add {
    my ($self, $args) = @_;
    $args->{message} //= '';
    validate_values $args => [qw/type request_country_id receive_country_id message/];

    croak "自国に外交要請を出すことはできません"
      if $args->{request_country_id} == $args->{receive_country_id};

    croak "type に不正な値が指定されています。" if CLASS->validate_type( $args->{type} );

    my $new_diplomacy = do {
      if ( $args->{type} == CLASS->DECLARE_WAR ) {
        validate_values $args => [qw/now_game_date start_game_date/];
        DECLARE_WAR_CLASS->new($args);
      } else {
        CLASS->new($args);
      }
    };

    my $diplomacy = eval {
      $self->get( $new_diplomacy->type_and_replace_country_id );
    };
    die "既に相手国から外交要請が届いています。\n" if blessed $diplomacy && $diplomacy->DOES( ROLE );

    $diplomacy = eval {
      $self->get( $new_diplomacy->type_and_both_country_id );
    };
    die "既に外交要請を出しています。\n" if blessed $diplomacy && $diplomacy->DOES( ROLE );

    $self->{data}{ $new_diplomacy->type_and_both_country_id } = $new_diplomacy;
  }

  sub delete_by_country_id {
    my ($self, $country_id) = @_;
    $self->{data} = +{
      map {
        my $diplomacy = $_;
        $diplomacy->has_country_id( $country_id ) ? () : ($diplomacy->type_and_both_country_id => $diplomacy);
      } values %{ $self->{data} }
    };
  }

  sub can_attack {
    my ($self, $country_id, $target_country_id, $now_game_date) = @_;
    croak "引数が足りません" if @_ < 4;
    my $is_territory_trading = $self
      ->get_by_type_and_both_country_id( CLASS->CESSION_OR_ACCEPT_TERRITORY, $country_id, $target_country_id )
      ->foreach( sub { shift->is_accepted } );
    my $is_war_started = $self
      ->get_by_type_and_both_country_id( CLASS->DECLARE_WAR, $country_id, $target_country_id )
      ->foreach( sub { shift->can_invation( $now_game_date ) } );
    $is_territory_trading || $is_war_started;
  }

  sub can_passage {
    my ($self, $country_id, $target_country_id, $now_game_date) = @_;
    croak "引数が足りません" if @_ < 4;
    my $can_attack = $self->can_attack( $country_id, $target_country_id, $now_game_date );
    my $is_passage_allowed = $self
      ->get_by_type_and_both_country_id( CLASS->ALLOW_PASSAGE, $country_id, $target_country_id )
      ->foreach( sub { shift->is_accepted } );
    $can_attack || $is_passage_allowed;
  }

}

1;
