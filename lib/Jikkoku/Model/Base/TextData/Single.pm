package Jikkoku::Model::Base::TextData::Single {
  
  use Jikkoku;
  use Carp qw/croak/;
  use Jikkoku::Util qw/open_data save_data/;

  sub FILE_PATH() { croak "定数 FILE_PATH を宣言してください" }

  sub CLASS() { croak " 定数 CLASS を宣言してください " }

  sub _new {
    my ($self) = @_;
    my $textdata = open_data( $self->FILE_PATH )->[0];
    $self->{data} = $self->CLASS->new($textdata);
  }

  sub new {
    my ($class) = @_;
    my $self = bless {data => undef}, $class;
    $self->_new;
    $self;
  }

  sub get {
    my ($self) = @_;
    $self->{data};
  }

  sub refetch {
    my ($self) = @_;
    $self->_new;
  }

  sub save {
    my ($self) = @_;
    my $textdata = ${ $self->{data}->output };
    save_data( $self->FILE_PATH, [$textdata] );
  }

}

1;
