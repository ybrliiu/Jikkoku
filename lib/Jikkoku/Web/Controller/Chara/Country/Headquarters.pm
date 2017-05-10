package Jikkoku::Web::Controller::Chara::Country::Headquarters {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller';

  sub root {
    my $self = shift;
    $self->render('error.pl' => {message => "ディプロマしー"});
  }

  __PACKAGE__->meta->make_immutable;

}

1;
