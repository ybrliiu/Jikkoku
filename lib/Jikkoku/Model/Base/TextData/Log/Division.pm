package Jikkoku::Model::Base::TextData::Log::Division {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Log';

  use Jikkoku::Util qw/create_data open_data save_data/;

  sub create {
    my ($class, $id) = @_;
    create_data( $class->file_path($id), [] );
  }

  sub file_path {
    my ($class, $id) = @_;
    $class->FILE_DIR_PATH . $id . '.cgi';
  }

  sub new {
    my ($class, $id) = @_;
    my $textdata = open_data( $class->file_path($id) );
    bless {
      id   => $id,
      data => $textdata,
    }, $class;
  }

  sub save {
    my ($self) = @_;
    splice @{ $self->{data} }, $self->MAX;
    save_data( $self->file_path($self->{id}), $self->{data} );
  }

  sub refetch {
    my ($self) = @_;
    my $textdata = open_data( $self->file_path($self->{id}) );
    $self->{data} = $textdata;
  }

}

1;
