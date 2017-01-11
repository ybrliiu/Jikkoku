package Jikkoku::Model::Base::TextData::Letter {

  use Jikkoku;
  use Carp qw/croak/;
  use Jikkoku::Util qw/validate_values create_data open_data save_data datetime/;

  sub MAX() { croak " 定数 MAX を宣言してください " }

  sub FILE_PATH() { croak " 定数 FILE_PATH を宣言してください " }

  use constant COLUMNS => [qw/
    letter_type
    sender_id
    sender_town_id
    sender_name
    message
    receiver_name
    time
    sender_icon
    sender_country_id
  /];

  sub create {
    my ($class) = @_;
    create_data $class->FILE_PATH, [];
  }

  sub new {
    my ($class) = @_;
    my $textdata_list = open_data $class->FILE_PATH;
    no warnings 'uninitialized';
    my @data = map {
      my @data_array = split /<>/, $_;
      +{ map { $class->COLUMNS->[$_] => $data_array[$_] } 0 .. $#data_array };
    } @$textdata_list;
    bless {data => \@data}, $class;
  }

  sub add {
    my ($self, $args) = @_;
    $args->{time} //= datetime;
    validate_values $args => $self->COLUMNS;
    unshift @{ $self->{data} }, $args;
    $self;
  }

  sub get {
    my ($self, $limit) = @_;
    [ @{ $self->{data} }[0 .. $limit - 1] ];
  }

  sub get_all {
    my ($self) = @_;
    $self->{data};
  }

  sub save {
    my ($self) = @_;
    my @columns = @{ $self->COLUMNS };
    my @data = map {
      my $data = $_;
      no warnings 'uninitialized';
      join '<>', map { $data->{$_} } @columns;
    } @{ $self->{data} };
    splice @data, $self->MAX;
    save_data $self->FILE_PATH, \@data;
  }

  sub remove {
    my ($self) = @_;
    if (-f $self->FILE_PATH) {
      unlink $self->FILE_PATH;
    } else {
      croak " ファイルが存在しないので削除できませんでした(@{[ $self->FILE_PATH ]}) ";
    }
  }

}

1;
