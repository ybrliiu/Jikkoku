package Jikkoku::Class::Diplomacy::DeclareWar {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Class::GameDate;

  # 布告から開戦に必要な時間 (ヶ月)
  use constant REQUIRED_MONTH => 12 * 3 + 1;

  extends 'Jikkoku::Class::Diplomacy';

  has '+type' => ( required => 0, default => 0 );

  has 'now_game_date'   => ( is => 'ro', isa =>'Jikkoku::Class::GameDate' );
  has 'start_game_date' => ( is => 'ro', isa =>'Jikkoku::Class::GameDate', builder => '_build_start_game_date' );

  sub _build_start_game_date {
    my $self = shift;
    Jikkoku::Class::GameDate->new({
      elapsed_year => $self->start_year,
      month        => $self->start_month,
    });
  }

  # attributesのoverrideにより取得順が異なるようになってしまうため
  override get_column_attributes => sub { Jikkoku::Class::Diplomacy->get_column_attributes };

  around _buildargs_hash => sub {
    my ($orig, $class, $args) = @_;
    validate_values $args => [qw/ start_game_date now_game_date /];
    $args->{start_year}  = $args->{start_game_date}->elapsed_year;
    $args->{start_month} = $args->{start_game_date}->month;
    # 短縮布告 -> 許可待ち
    if ( $args->{start_game_date}->to_num < $args->{now_game_date}->to_num + REQUIRED_MONTH ) {
      $args->{is_accepted} = 0;
    }
    # 通常布告
    else {
      $args->{is_accepted} = 1;
    }
  };

  sub can_invation {
    my ($self, $now_game_date) = @_;
    Carp::croak 'few arguments($now_game_date)' if @_ < 2;
    my $is_passed = $now_game_date->to_num >= $self->start_game_date->to_num;
    $self->is_accepted && $is_passed;
  }

  override show_status => sub {
    my ($self, $country_id, $country_model) = @_;
    Carp::croak 'few arguments($country_id, $country_model)' if @_ < 3;
    my $message = super( $country_id, $country_model );
    if ( $self->is_accepted ) {
      $message = chop_utf8($message);
      "@{[ $self->start_game_date->date ]}から$message";
    } else {
      "$message (@{[ $self->start_game_date->date ]}より開戦)";
    }
  };

  override show_already_accepted_error => sub {
    my $self = shift;
    "その国とは既に@{[ $self->name ]}中です。";
  };

  override show_hope_start_game_date => sub {
    my $self = shift;
    '開戦希望時間 : ' . $self->start_game_date->date;
  };

  # use utf8じゃないと辛い
  sub chop_utf8 {
    my $str = shift;
    use utf8;
    use Encode;
    $str = Encode::decode_utf8 $str;
    chop $str;
    Encode::encode_utf8 $str;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
