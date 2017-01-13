package Jikkoku::Class::Role::Diplomacy {

  use v5.14;
  use warnings;
  use Role::Tiny;

  use Carp;

  sub DECLARE_WAR() { 0 }

  sub CEASE_WAR() { 1 }

  sub CESSION_OR_ACCEPT_TERRITORY() { 2 }

  sub ALLOW_PASSAGE() { 3 }

  sub PRIMARY_KEY() { 'type_and_both_country_id' }

  sub COLUMNS() { [qw/type is_accepted request_country_id receive_country_id start_year start_month message/] }

  sub accept {
    my ($self) = @_;
    die "既に要請を承諾しています\n" if $self->{is_accepted};
    $self->{is_accepted} = 1;
  }

  sub can_accept_request {
    my ($self, $country_id) = @_;
    !$self->{is_accepted} && $self->{receive_country_id} == $country_id;
  }

  sub can_withdraw {
    my $self = shift;
    $self->{is_accepted} && ($self->{type} == CESSION_OR_ACCEPT_TERRITORY() || $self->{type} == ALLOW_PASSAGE());
  }

  sub has_country_id {
    my ($self, $country_id) = @_;
    Carp::croak "引数が足りません" if @_ < 2;
    $self->{request_country_id} == $country_id || $self->{receive_country_id} == $country_id;
  }

  sub has_both_country_id {
    my ($self, $country_id, $country_id2) = @_;
    Carp::croak "引数が足りません" if @_ < 3;
    $self->has_country_id( $country_id ) && $self->has_country_id( $country_id2 );
  }

  sub has_type_and_both_country_id {
    my ($self, $type, $country_id, $country_id2) = @_;
    Carp::croak "引数が足りません" if @_ < 4;
    $self->{type} == $type && $self->has_both_country_id( $country_id, $country_id2 );
  }

  sub name {
    my ($self) = @_;
    my $message = {
      DECLARE_WAR                 ,=> $self->{is_accepted} ? '戦争' : '短縮布告',
      CEASE_WAR                   ,=> '停戦',
      CESSION_OR_ACCEPT_TERRITORY ,=> '領土割譲・譲受',
      ALLOW_PASSAGE               ,=> '通行許可',
    };
    $message->{ $self->{type} };
  }

  sub name_english {
    my ($self) = @_;
    my $message = {
      DECLARE_WAR                 ,=> $self->{is_accepted} ? 'declare-war' : 'short-declare-war',
      CEASE_WAR                   ,=> 'cease_war',
      CESSION_OR_ACCEPT_TERRITORY ,=> 'cession_or_accept_territory',
      ALLOW_PASSAGE               ,=> 'allow_passage',
    };
    $message->{ $self->{type} };
  }

  # change name
  sub show_status {
    my ($self, $country_id, $country_model) = @_;
    if ( $self->{request_country_id} == $country_id ) {
      my $country = $country_model->get( $self->{receive_country_id} );
      $self->{is_accepted}
        ? $country->name . 'と' . $self->name . '中'
        : $country->name . 'へ' . $self->name . 'を要請中';
    } else {
      my $country = $country_model->get( $self->{request_country_id} );
      $self->{is_accepted}
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
    $self->{request_country_id} == $country_id ? $self->{receive_country_id} : $self->{request_country_id};
  }

  sub type_and_both_country_id {
    my ($self) = @_;
    "$self->{type}.$self->{request_country_id}.$self->{receive_country_id}";
  }

  sub type_and_replace_country_id {
    my ($self) = @_;
    "$self->{type}.$self->{receive_country_id}.$self->{request_country_id}";
  }

  sub validate_type {
    my ($class, $type) = @_;
    $type < DECLARE_WAR || $type > ALLOW_PASSAGE;
  }

}

1;

=encoding utf8

=head1 NAME
  
  Jikkoku::Class::Role::Diplomacy - 外交オブジェクトのロール

=cut

