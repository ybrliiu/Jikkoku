package Jikkoku::Class::Role::Division {

  use Mouse::Role;
  use Jikkoku;

  requires qw( PRIMARY_ATTRIBUTE DIR_PATH );

  sub file_path {
    my ($self, $id) = @_;
    if (ref $self) {
      my $primary_attr = $self->PRIMARY_ATTRIBUTE;
      $self->DIR_PATH . $self->$primary_attr . '.cgi';
    } else {
      my $class = $self;
      $class->DIR_PATH . "$id.cgi";
    }
  }

}

1;

