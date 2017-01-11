package Jikkoku::Model::Base::TextData::Command {

  use Jikkoku;
  use Carp qw/croak/;
  use Jikkoku::Util qw/create_data open_data save_data validate_values daytime/;

  sub MAX() { croak " 定数 MAX を宣言してください " }

  sub FILE_PATH() { croak " 定数 FILE_PATH を宣言してください " }

  sub COLUMNS() { croak " 定数 COLUMNS を宣言してください " }

  sub EMPTY_DATA() {croak " 定数 EMPTY_DATA を宣言してください " }

  sub create {
    my ($class, $id) = @_;
    my $empty_string = join '<>', map { $class->EMPTY_DATA->{$_} } @{ $class->COLUMNS };
    create_data $class->file_path($id), [ ($empty_string) x $class->MAX ];
  }

  sub file_path {
    my ($class, $id) = @_;
    $class->FILE_DIR_PATH . $id . '.cgi';
  }

  sub new {
    my ($class, $id) = @_;
    my $textdata_list = open_data $class->file_path($id);
    no warnings 'uninitialized';
    my @data = map {
      my @data_array = split /<>/, $_;
      +{ map { $class->COLUMNS->[$_] => $data_array[$_] } 0 .. $#data_array };
    } @$textdata_list;
    bless {
      id   => $id,
      data => \@data,
    }, $class;
  }

  sub remove {
    my ($self) = @_;
    my $file_path = $self->file_path($self->{id});
    if (-f $file_path) {
      unlink $self->file_path($self->{id});
    } else {
      croak " ファイルが存在しないので削除できませんでした($file_path) ";
    }
  }
  
  sub delete {
    my ($self, $delete_list) = @_;
    # コマンドリストの削除するコマンドに目印をつけ、目印がついていない物のみ抽出
    my @command = grep { $_ ne 'delete' } @{ $self->input('delete', $delete_list)->{data} };
    my @empty   = map { $self->EMPTY_DATA } 0 .. @$delete_list;
    push @command, @empty;
    $self->{data} = \@command;
    return $self;
  }

  sub get {
    my ($self, $limit) = @_;
    [ @{ $self->{data} }[0 .. $limit - 1] ];
  }

  sub get_all {
    my ($self) = @_;
    $self->{data};
  }

  sub input {
    my ($self, $input_data, $input_list) = @_;
    validate_values($input_data => $self->COLUMNS);

    splice( @{ $self->{data} }, $_, 1, $input_data ) for @$input_list;
    $self;
  }
  
  sub insert {
    my ($self, $insert_list, $num) = @_;
    my %insert_list = map { $_ => 1 } @$insert_list;
    my @insert = map { $self->EMPTY_DATA } 0 .. $num - 1;
    my @command = @{ $self->{data} };
    my @new_command = map { exists($insert_list{$_}) ? (@insert, $command[$_]) : $command[$_] } 0 .. $#command;
    $self->{data} = \@new_command;
    $self;
  } 

  sub save {
    my ($self) = @_;
    my @columns = @{ $self->COLUMNS };
    my @data = map {
      my $data = $_;
      join '<>', map { $data->{$_} } @columns;
    } @{ $self->{data} };
    splice @data, $self->MAX;
    save_data $self->file_path($self->{id}), \@data;
  }

}

1;
