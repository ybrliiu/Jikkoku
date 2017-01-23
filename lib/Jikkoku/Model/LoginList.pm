package Jikkoku::Model::LoginList {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Integration::Expires';

  use Jikkoku::Class::LoginList;

  use constant {
    CLASS       => 'Jikkoku::Class::LoginList',
    FILE_PATH   => 'log_file/guest.cgi',
    EXPIRE_TIME => 180,
  };

  sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@_);
    $self->update;
    $self;
  };

  sub add {
    my ($self, $chara) = @_;
    my $obj = CLASS->new("@{[ time + EXPIRE_TIME ]}<>@{[ $chara->name ]}<>@{[ $chara->country_id ]}<>@{[ $chara->town_id ]}");
    my $primary_key = CLASS->PRIMARY_KEY;
    $self->{data}{ $chara->$primary_key } = $obj;
  }

  sub get_by_country_id {
    my ($self, $country_id) = @_;
    [ grep { $_->country_id eq $country_id } values %{ $self->{data} } ];
  }

}

1;
