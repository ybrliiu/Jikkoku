package Jikkoku::Class::Role::TextData::HashField {

  use Mouse;
  use Jikkoku;
  use Carp;
  use Jikkoku::Util 'validate_values';

  has 'keys'       => ( is => 'ro', isa => 'ArrayRef', required => 1 );
  has 'data'       => ( is => 'rw', isa => 'HashRef', required => 1 );
  has 'validators' => ( is => 'ro', isa => 'HashRef[CodeRef]', default => sub { +{} } );

  with 'Jikkoku::Class::Role::TextData::Generic';

  sub get {
    my ($self, $key) = @_;
    my $data = $self->data;
    Carp::croak("$key というフィールドは存在しません。") unless exists $data->{$key};
    $data->{$key};
  }

  sub set {
    my ($self, $key, $value) = @_;
    my $data = $self->data;
    Carp::croak("$key というフィールドは存在しません。") unless exists $data->{$key};
    if (exists $self->validators->{$key}) {
      $self->validators->{$key}->($value, $data);
    }
    $data->{$key} = $value;
  }

  sub init {
    my $self = shift;
    for my $key (@{ $self->keys }) {
      $self->data->{$key} = 0;
    }
  }

  sub output {
    my $self = shift;
    no warnings 'uninitialized';
    join( ',', map { $self->data->{$_} } @{ $self->keys } ) . ',';
  }

  sub inflate_textdata {
    my ($class, $args) = @_;
    validate_values $args => [qw/ textdata keys /];
    # 空データがあった時の警告が鬱陶しいので消す
    no warnings 'uninitialized';
    my @subdata = split /,/, $args->{textdata};
    +{ map { $args->{keys}->[$_] => $subdata[$_] } 0 .. @{ $args->{keys} } };
  }

  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Class::Role::TextData::SetHashFieldException {

  use Jikkoku;
  use parent 'Jikkoku::Exception';

}

1;
