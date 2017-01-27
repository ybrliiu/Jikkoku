package Jikkoku::Model::Base::TextData::Letter {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::List';

  use Carp qw/croak/;
  use Jikkoku::Util qw/validate_values datetime/;

  sub FILE_PATH() { croak " 定数 FILE_PATH を宣言してください " }

  use constant COLUMNS => [qw/
    letter_type
    sender_id
    sender_town_id
    sender_name
    message
    receiver_name
    time
    sender_icon
    sender_country_id
  /];

  # override
  sub add {
    my ($self, $args) = @_;
    $args->{time} //= datetime;
    validate_values $args => $self->COLUMNS;
    unshift @{ $self->{data} }, $args;
    $self;
  }

}

1;
