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

    my $delete_diplomacy_name;
    eval {
      my $delete_diplomacy
        = $self->{diplomacy_model}->get_by_type_and_both_country_id( $type, $self->{country}->id, $target_country_id );
      $self->{diplomacy_model}->delete( $delete_diplomacy->type_and_both_country_id );
      $delete_diplomacy_name = $delete_diplomacy->name;
    };
    if (my $e = $@) {
      $self->render_error($e);
    }
    
    $self->{diplomacy_model}->save;

    my $target_country = $self->{country_model}->get( $target_country_id );
    $self->{letter_model}->add_country_letter({
      sender          => $self->{chara},
      receive_country => $target_country,
      message         => qq{<span style="color: #ff6600"><strong>【${delete_diplomacy_name}</strong></span>}
        . "@{[ $self->{country}->name ]}は@{[ $target_country->name ]}との${delete_diplomacy_name}を終了しました。<br>",
    });

    $self->render('chara/result.pl', {message => $delete_diplomacy_name . 'を取り消しました。'});
  }

}

1;
