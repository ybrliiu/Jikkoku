package Jikkoku::Model::Letter {

  use Jikkoku;
  use Jikkoku::Util qw/validate_values/;
  use parent 'Jikkoku::Model::Base::TextData::Letter';

  use constant {
    FILE_PATH => 'log_file/mes_log.cgi',
    MAX       => 1000,

    # letter type
    TOWN => 111,
    UNIT => 333,
  };

  sub COLUMNS {
    state $columns;
    return $columns if defined $columns;

    my $class = shift;
    my @columns = @{ $class->SUPER::COLUMNS };
    push @columns, 'sender_unit_id';
    $columns = \@columns;
  }

  sub add_country_letter {
    my ($self, $args) = @_;
    validate_values $args => [qw/sender receive_country message/];
    my ($sender, $receive_country) = ($args->{sender}, $args->{receive_country});

    $self->SUPER::add({
      letter_type       => $receive_country->id,
      sender_id         => $sender->id,
      sender_town_id    => $sender->town_id,
      sender_name       => $sender->name,
      message           => $args->{message},
      receiver_name     => $receive_country->name,
      sender_icon       => $sender->icon,
      sender_country_id => $sender->country_id,
      sender_unit_id    => '',
    });
  }

  sub get_country_letter {
    my ($self, $country_id, $limit) = @_;
    # letter_type に 国IDがある場合、国宛
    my @letters = grep { $_->{letter_type} eq $country_id } @{ $self->{data} };
    [ @letters[0 .. $limit - 1] ];
  }

  sub get_unit_letter {
    my ($self, $unit_id, $limit) = @_;
    my @letters = grep {
      $_->{letter_type} eq UNIT and $_->{sender_unit_id} == $unit_id
    } @{ $self->{data} };
    [ @letters[0 .. $limit - 1] ];
  }

  sub get_town_letter {
    my ($self, $town_id, $limit) = @_;
    my @letters = grep {
      $_->{letter_type} eq TOWN and $_->{sender_town_id} == $town_id
    } @{ $self->{data} };
    [ @letters[0 .. $limit - 1] ];
  }

  sub get_chara_letter {
    my ($self, $chara_id, $limit) = @_;
    # letter_type にchara id がある場合、個宛
    my @letters = grep {
      $_->{letter_type} eq $chara_id or $_->{sender_id} eq $chara_id
    } @{ $self->{data} };
    [ @letters[0 .. $limit - 1] ];
  }

}

1;

