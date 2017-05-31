package Jikkoku::Model::Role::Result {

  use Mouse::Role;
  use Jikkoku;

  use overload (
    '@{}'      => sub { $_[0]->data },
    'bool'     => sub () { 1 },
    'fallback' => 1,
  );

  has 'data' => ( is => 'ro', isa => 'ArrayRef', required => 1 );

  sub create_result {
    my ($self, $data) = @_;
    (ref $self)->new(data => $data);
  }

  sub get_all {
    my $self = shift;
    $self->data;
  }

  sub first {
    my ($self, $code) = @_;
    my $chara_list = $self->get_all;
    for my $chara (@$chara_list) {
      return $chara if $code->($chara);
    }
  }

}

1;

