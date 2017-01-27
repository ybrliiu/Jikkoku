package Jikkoku::Model::Base::TextData::Command {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::List';

  use Carp qw/croak/;
  use Jikkoku::Util qw( create_data open_data save_data remove_data );

  sub EMPTY_DATA() {croak " 定数 EMPTY_DATA を宣言してください " }

  # override
  sub create {
    my ($class, $id) = @_;
    my $empty_string = join '<>', map { $class->EMPTY_DATA->{$_} } @{ $class->COLUMNS };
    create_data $class->file_path($id), [ ($empty_string) x $class->MAX ];
  }

  sub file_path {
    my ($class, $id) = @_;
    $class->FILE_DIR_PATH . $id . '.cgi';
  }

  # override
  sub new {
    my ($class, $id) = @_;
    my $self = $class->SUPER::new($id);
    $self->{id} = $id;
    $self;
  }
  
  # override
  sub _open {
    my ($class, $id) = @_;
    open_data $class->file_path($id);
  }

  # override
  sub remove {
    my $self = shift;
    remove_data $self->file_path($self->{id});
  }

  # override
  sub save {
    my $self = shift;
    save_data $self->file_path($self->{id}), $self->_hash_list_to_textdata_list;
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

}

1;
