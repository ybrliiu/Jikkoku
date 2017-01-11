package Jikkoku::Web::Controller::Chara::Country::Headquarters {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller';

  sub root {
    my $self = shift;
    $self->render('error.pl' => {message => "ディプロマしー"});
  }

}

1;
