package Jikkoku::Model::Base::TextData::Integration::Expires {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Model::Base::TextData::Integration';
  use Carp;

  sub EXPIRE_TIME() { Carp::croak " 定数 EXPIRE_TIME を宣言してください " }

  sub update {
    my ($self) = @_;
    my $time  = time;
    my $p_key = $self->CLASS->PRIMARY_KEY;
    for my $obj (@{ $self->get_all }) {
      $self->delete( $obj->$p_key ) if $obj->time < $time;
    }
    $self->save;
  }

}

1;
