package Jikkoku::Model::Base::TextData::Log::Integration {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Model::Base::TextData::Log';

  use Jikkoku::Util qw/open_data save_data/;

  sub new {
    my ($class) = @_;
    my $textdata = open_data( $class->FILE_PATH );
    bless {data => $textdata}, $class;
  }

  sub save {
    my ($self) = @_;
    splice @{ $self->{data} }, $self->MAX;
    save_data( $self->FILE_PATH, $self->{data} );
  }

  sub refetch {
    my ($self) = @_;
    my $textdata = open_data( $self->FILE_PATH );
    $self->{data} = $textdata;
  }

}

1;

