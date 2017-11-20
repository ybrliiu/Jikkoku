package Jikkoku::Model::LoginList {

  use Mouse;
  use Jikkoku;

  use constant {
    FILE_PATH         => 'log_file/guest.cgi',
    INFLATE_TO        => 'Jikkoku::Class::LoginList',
    EXPIRE_TIME       => 180,
    PRIMARY_ATTRIBUTE => 'name',
  };

  with qw(
    Jikkoku::Model::Role::TextData::General::Integration
    Jikkoku::Model::Role::Integration::Expires
  );

  sub add {
    my ($self, $chara) = @_;
    Carp::croak 'Too few arguments (required: $chara)' if @_ < 2;
    my $obj = $self->INFLATE_TO->new({
      time         => time + $self->EXPIRE_TIME,
      name         => $chara->name,
      country_id   => $chara->country_id,
      town_id      => $chara->town_id,
    });
    $self->data->{ $chara->name } = $obj;
  }

  sub get_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'Too few arguments (required: $country_id)' if @_ < 2;
    [ grep { $_->country_id eq $country_id } values %{ $self->data } ];
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;
