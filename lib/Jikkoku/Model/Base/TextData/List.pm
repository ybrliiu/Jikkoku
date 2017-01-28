package Jikkoku::Model::Base::TextData::List {

  use Jikkoku;
  use Carp qw( croak );
  use Jikkoku::Util qw( create_data open_data save_data remove_data );

  sub MAX() { croak " 定数 MAX を宣言してください " }

  sub COLUMNS() { croak " 定数 COLUMNS を宣言してください " }

  sub create {
    my $class = shift;
    create_data $class->FILE_PATH, [];
  }

  sub new {
    my $class = shift;
    my $self = bless +{ _textdata_list => $class->_open(@_) }, $class;
    $self->{data} = $class->_textdata_list_to_hash_list( $self->{_textdata_list} );
    $self;
  }

  sub _open {
    open_data shift->FILE_PATH;
  }

  sub _textdata_list_to_hash_list {
    my ($class, $textdata_list) = @_;
    no warnings 'uninitialized';
    [ map {
      my @data_array = split /<>/, $_;
      +{ map { $class->COLUMNS->[$_] => $data_array[$_] } 0 .. $#data_array };
    } @$textdata_list ];
  }

  sub abort {
    my $self = shift;
    $self->{data} = $self->_textdata_list_to_hash_list( $self->{_textdata_list} );
  }

  sub get {
    my ($self, $limit) = @_;
    [ @{ $self->{data} }[0 .. $limit - 1] ];
  }

  sub get_all {
    my $self = shift;
    $self->{data};
  }

  sub init {
    my $self = shift;
    $self->{data} = [];
  }

  sub save {
    my $self = shift;
    save_data $self->FILE_PATH, $self->_hash_list_to_textdata_list;
  }

  sub _hash_list_to_textdata_list {
    my $self = shift;
    my @columns = @{ $self->COLUMNS };
    my @data = map {
      my $data = $_;
      no warnings 'uninitialized';
      join('<>', map { $data->{$_} } @columns) . '<>';
    } @{ $self->{data} };
    splice @data, $self->MAX;
    \@data;
  }

  sub refetch {
    my $self = shift;
    my $textdata_list = $self->_open(@_);
    $self->{data} = $self->_textdata_list_to_hash_list($textdata_list);
  }

  sub remove {
    my $self = shift;
    remove_data $self->FILE_PATH;
  }

}

1;
