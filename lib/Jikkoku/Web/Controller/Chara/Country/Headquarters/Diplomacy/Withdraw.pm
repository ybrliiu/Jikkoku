package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Withdraw {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base';

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
    $self->diplomacy_model
      ->get_by_type_and_both_country_id( $type, $self->country->id, $target_country_id )
      ->match(
        Some => sub {
          my $delete_diplomacy = shift;
          $self->diplomacy_model->delete( $delete_diplomacy->type_and_both_country_id );
          $delete_diplomacy_name = $delete_diplomacy->name;
        },
        None => sub { $self->render_error("外交状況を終了できませんでした。") },
      );
    
    $self->diplomacy_model->save;

    my $target_country = $self->country_model->get_with_option( $target_country_id )->get;
    $self->letter_model->add_country_letter({
      sender          => $self->chara,
      receive_country => $target_country,
      message         => qq{<span style="color: #ff6600"><strong>【${delete_diplomacy_name}</strong></span>}
        . "@{[ $self->country->name ]}は@{[ $target_country->name ]}との${delete_diplomacy_name}を終了しました。<br>",
    });
    $self->letter_model->save;

    $self->render('chara/result.pl', {message => $delete_diplomacy_name . 'を取り消しました。'});
  }

  __PACKAGE__->meta->make_immutable;

}

1;
