package Jikkoku::Class::Role::TextData::HashContainer {

  use Mouse;
  use Jikkoku;

  use Option;
  use Data::Dumper ();
  use Jikkoku::Util 'validate_values';

  has 'data' => ( is => 'rw', isa => 'HashRef', default => sub { +{} } );

  with 'Jikkoku::Class::Role::TextData::Generic';

  sub exists :method {
    my ($self, $key) = @_;
    exists $self->data->{$key};
  }

  sub get {
    die "you must call get_with_option method.";
  }

  sub get_with_option {
    my ($self, $key) = @_;
    option $self->data->{$key};
  }

  sub set {
    my ($self, $key, $value) = @_;
    $self->data->{$key} = $value;
  }

  sub each {
    my ($self, $code) = @_;
    my $data = $self->data;
    my @keys = keys %$data;
    for my $key (@keys) {
      # sub { my ($key, $vlue) = @_; }
      $code->($key, $data->{$key});
    }
  }

  sub output {
    my $self = shift;
    my $dumper = Data::Dumper->new([$self->data]);
    $dumper->Terse(1);
    $dumper->Indent(0);
    $dumper->Dump;
  }

  sub inflate_textdata {
    my ($class, $args) = @_;
    validate_values $args => [qw/ textdata /];
    # 空文字列の場合は空HashRefを返す
    $args->{textdata} ? (eval $args->{textdata} // {}) : {};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
