package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Withdraw {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base';

  sub cession_or_accept_territory {
    my $self = shift;
    $self->_withdraw( $self->class('Diplomacy')->CESSION_OR_ACCEPT_TERRITORY );
  }

  sub allow_passage {
    my $self = shift;
    $self->_withdraw( $self->class('Diplomacy')->ALLOW_PASSAGE );
  }

  sub _withdraw {
    my ($self, $type) = @_;

    my $target_country_id = $self->param('cou');

    my $delete_diplomacy = eval {
      my $delete_diplomacy
        = $self->{diplomacy_model}->get_by_type_and_country_id( $type, $target_country_id );
      $self->{diplomacy_model}->delete( $delete_diplomacy->type_and_both_country_id );
    };
    if (my $e = $@) {
      $self->render_error($e);
    }
    
    $self->{diplomacy_model}->save;

    $self->render('chara/result.pl', {message => $delete_diplomacy->name . 'を取り消しました。'});
  }

}

1;
