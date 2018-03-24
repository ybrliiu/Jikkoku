package Jikkoku::Web::Controller::Root {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller';

  sub root {
    my $self = shift;
    $self->render_error('ばかもの');
  }

  __PACKAGE__->meta->make_immutable;

}

1;
