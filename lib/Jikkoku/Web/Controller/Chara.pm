package Jikkoku::Web::Controller::Chara {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Base';

  use Jikkoku::Model::Formation;

  sub battle_map {
    my $self = shift;

    $self->render_error('出撃していません。') unless $self->{chara}->is_sortie;

    my $bm_id      = $self->{chara}->soldier_battle_map('battle_map_id');
    my $battle_map = $self->model('BattleMap')->new->get($bm_id);
    if ( $battle_map->is_castle_around_map ) {
      $self->model('Town')->new->get_with_option($bm_id)->foreach(sub {
        $battle_map->set_town_info($_);
      });
    }
    $battle_map->set_charactors($self->{chara_model}, $self->{chara});
    $battle_map->set_can_move({
      chara       => $self->{chara},
      chara_model => $self->{chara_model},
      town_model  => $self->{town_model},
    });

    my $country_model = $self->model('Country')->new;
    my $country       = $country_model->get( $self->{chara}->country_id );

    $self->render('chara/battle_map.pl', {
      battle_map => $battle_map,
      country    => $country,
    });
  }

}

1;
