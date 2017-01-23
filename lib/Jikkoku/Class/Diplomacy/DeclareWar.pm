package Jikkoku::Class::Diplomacy::DeclareWar {

  use Jikkoku;
  use parent 'Jikkoku::Class::Base::TextData';
  use Class::Method::Modifiers;
  use Role::Tiny::With;
  with 'Jikkoku::Class::Role::Diplomacy';

  use Jikkoku::Class::GameDate;
  use Carp qw/croak/;
  use Jikkoku::Util qw/validate_values/;

  use constant {
    # 布告から開戦に必要な時間 (ヶ月)
    REQUIRED_MONTH => 12 * 3 + 1,
  };

  __PACKAGE__->make_accessors( COLUMNS() );

  sub _new_by_args {
    my ($class, $args) = @_;
    $args->{message} //= '';
    validate_values $args => [qw/request_country_id receive_country_id now_game_date start_game_date message/];

    my $become_self = do {
      my $become_self = {
        type               => DECLARE_WAR(),
        request_country_id => $args->{request_country_id},
        receive_country_id => $args->{receive_country_id},
        start_year         => $args->{start_game_date}->elapsed_year,
        start_month        => $args->{start_game_date}->month,
        message            => $args->{message},
      };
      # 短縮布告 -> 許可待ち
      if ( $args->{start_game_date}->to_num < $args->{now_game_date}->to_num + REQUIRED_MONTH ) {
        $become_self->{is_accepted} = 0;
      }
      # 通常布告
      else {
        $become_self->{is_accepted} = 1;
      }
      $become_self;
    };
    $class->SUPER::_new_by_args( $become_self );
  }

  sub can_invation {
    my ($self, $now_game_date) = @_;
    my $is_passed = $now_game_date->to_num >= $self->start_game_date->to_num;
    $self->{is_accepted} && $is_passed;
  }

  sub start_game_date {
    my ($self) = @_;
    return $self->{start_game_date} if exists $self->{start_game_date};
    $self->{start_game_date} = Jikkoku::Class::GameDate->new({
      elapsed_year => $self->{start_year},
      month        => $self->{start_month},
    });
  }

  around show_status => sub {
    my ($origin, $self, $country_id, $country_model) = @_;
    my $message = $self->$origin( $country_id, $country_model );
    if ( $self->{is_accepted} ) {
      $message = chop_utf8($message);
      "@{[ $self->start_game_date->date ]}から$message";
    } else {
      "$message (@{[ $self->start_game_date->date ]}より開戦)";
    }
  };

  around show_already_accepted_error => sub {
    my ($origin, $self) = @_;
    "その国とは既に@{[ $self->name ]}中です。";
  };

  around show_hope_start_game_date => sub {
    my ($origin, $self) = @_;
    '開戦希望時間 : ' . $self->start_game_date->date;
  };

  # use utf8じゃないと辛いね
  sub chop_utf8 {
    my $str = shift;
    use utf8;
    use Encode;
    $str = Encode::decode_utf8 $str;
    chop $str;
    Encode::encode_utf8 $str;
  }

}

1;
