package Jikkoku::Model::Base::TextData::Log {

  use Jikkoku;
  use Carp qw/croak/;
  use Jikkoku::Util qw/daytime/;

  sub MAX()       { croak " 定数 MAX を宣言してください " }

  sub FILE_PATH() { croak " 定数 FILE_PATH を宣言してください " }

  sub get {
    my ($self, $limit) = @_;
    [ @{ $self->{data} }[0 .. $limit - 1] ];
  }

  sub get_all {
    my ($self) = @_;
    $self->{data};
  }

  sub add {
    my ($self, $str) = @_;
    unshift @{ $self->{data} }, "$str (@{[ daytime() ]})";
    $self;
  }

}

1;
