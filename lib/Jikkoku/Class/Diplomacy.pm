package Jikkoku::Class::Diplomacy {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Class::Role::TextData;

  use constant {
    DECLARE_WAR                 => 0,
    CEASE_WAR                   => 1,
    CESSION_OR_ACCEPT_TERRITORY => 2,
    ALLOW_PASSAGE               => 3,
  };

  has 'type'               => ( metaclass => 'Column', is => 'ro', isa => 'Int',  required => 1 );
  has 'is_accepted'        => ( metaclass => 'Column', is => 'rw', isa => 'Bool', default  => 0 );
  has 'request_country_id' => ( metaclass => 'Column', is => 'ro', isa => 'Int',  required => 1 );
  has 'receive_country_id' => ( metaclass => 'Column', is => 'ro', isa => 'Int',  required => 1 );
  has 'start_year'         => ( metaclass => 'Column', is => 'ro', isa => 'Int',  default  => 0 );
  has 'start_month'        => ( metaclass => 'Column', is => 'ro', isa => 'Int',  default  => 0 );
  has 'message'            => ( metaclass => 'Column', is => 'ro', isa => 'Str',  default  => '' );

  with 'Jikkoku::Class::Role::TextData';

  sub BUILD {
    my $self = shift;
    Carp::croak '自国に外交要請を出すことはできません' if $self->request_country_id == $self->receive_country_id;
    Carp::croak 'typeの値が不正です' if $self->type < DECLARE_WAR || $self->type > ALLOW_PASSAGE;
  }

  sub accept {
    my $self = shift;
    die "既に要請を承諾しています\n" if $self->is_accepted;
    $self->is_accepted(1);
  }

  sub can_accept_request {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    !$self->is_accepted && $self->receive_country_id == $country_id;
  }

  sub can_withdraw {
    my $self = shift;
    $self->is_accepted && ($self->type == CESSION_OR_ACCEPT_TERRITORY() || $self->type == ALLOW_PASSAGE());
  }

  sub has_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    $self->request_country_id == $country_id || $self->receive_country_id == $country_id;
  }

  sub has_both_country_id {
    my ($self, $country_id, $country_id2) = @_;
    Carp::croak 'few arguments($country_id, $country_id2)' if @_ < 3;
    $self->has_country_id( $country_id ) && $self->has_country_id( $country_id2 );
  }

  sub has_type_and_both_country_id {
    my ($self, $type, $country_id, $country_id2) = @_;
    Carp::croak 'few arguments($type, $country_id, $country_id2)' if @_ < 4;
    $self->type == $type && $self->has_both_country_id( $country_id, $country_id2 );
  }

  sub name {
    my $self = shift;
    my $message = {
      DECLARE_WAR                 ,=> $self->is_accepted ? '戦争' : '短縮布告',
      CEASE_WAR                   ,=> '停戦',
      CESSION_OR_ACCEPT_TERRITORY ,=> '領土割譲・譲受',
      ALLOW_PASSAGE               ,=> '通行許可',
    };
    $message->{ $self->type };
  }

  sub name_english {
    my $self = shift;
    my $message = {
      DECLARE_WAR                 ,=> $self->is_accepted ? 'declare-war' : 'short-declare-war',
      CEASE_WAR                   ,=> 'cease_war',
      CESSION_OR_ACCEPT_TERRITORY ,=> 'cession_or_accept_territory',
      ALLOW_PASSAGE               ,=> 'allow_passage',
    };
    $message->{ $self->type };
  }

  sub show_status {
    my ($self, $country_id, $country_model) = @_;
    if ( $self->request_country_id == $country_id ) {
      my $country = $country_model->get_with_option( $self->receive_country_id )->get_or_else( $country_model->neutral );
      $self->is_accepted
        ? $country->name . 'と' . $self->name . '中'
        : $country->name . 'へ' . $self->name . 'を要請中';
    } else {
      my $country = $country_model->get_with_option( $self->request_country_id )->get_or_else( $country_model->neutral );
      $self->is_accepted
        ? $country->name . 'と' . $self->name . '中'
        : qq{<span style="color: red">【外交要請】</span>} . $country->name . 'から' . $self->name . '要請が来ています';
    }
  }

  # 以下3つ 宣戦布告オブジェクトの時は上書きしていく
  sub show_already_accepted_error {
    my $self = shift;
    "既に@{[ $self->name ]}要請は受理されています";
  }

  sub show_hope_start_game_date { q{} }

  sub other_country_id {
    my ($self, $country_id) = @_;
    $self->request_country_id == $country_id ? $self->receive_country_id : $self->request_country_id;
  }

  sub type_and_both_country_id {
    my $self = shift;
    $self->type . '.' . $self->request_country_id . '.' . $self->receive_country_id;
  }

  sub type_and_replace_country_id {
    my $self = shift;
    $self->type . '.' . $self->receive_country_id . '.' . $self->request_country_id;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
