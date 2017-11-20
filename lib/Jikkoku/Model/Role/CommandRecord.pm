package Jikkoku::Model::Role::CommandRecord {

  use Mouse::Role;
  use Jikkoku;

  # constants
  requires qw( EMPTY_DATA );

  with 'Jikkoku::Model::Role::List';
  
  sub delete {
    my ($self, $delete_num_list) = @_;
    Carp::croak 'Too few arguments (required: $delete_num_list)' if @_ < 2;
    # コマンドリストの削除するコマンドに目印をつけ、目印がついていない物のみ抽出
    $self->input('delete', $delete_num_list);
    my @command = grep { $_ ne 'delete' } @{ $self->data };
    my @empty   = map { $self->EMPTY_DATA } 0 .. @$delete_num_list;
    push @command, @empty;
    $self->data(\@command);
    $self;
  }

  sub input {
    my ($self, $input_data, $input_num_list) = @_;
    Carp::croak 'Too few arguments (required: $input_data, $input_num_list)' if @_ < 3;
    splice( @{ $self->data }, $_, 1, $input_data ) for @$input_num_list;
    $self;
  }
  
  sub insert {
    my ($self, $insert_num_list, $num) = @_;
    my %insert_num_list = map { $_ => 1 } @$insert_num_list;
    my @insert = map { $self->EMPTY_DATA } 0 .. $num - 1;
    my @command = @{ $self->data };
    my @new_command = map { exists($insert_num_list{$_}) ? (@insert, $command[$_]) : $command[$_] } 0 .. $#command;
    $self->data(\@new_command);
    $self;
  } 

}

1;

