package Jikkoku::Web::Controller::Chara {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Base';

  sub battle_map {
    my $self = shift;

    my $bm_id      = $self->{chara}->soldier_battle_map('battle_map_id');
    my $battle_map = $self->model('BattleMap')->new->get($bm_id);
    if ( $battle_map->is_castle_around_map ) {
      my $bm_town = $self->model('Town')->new->get($bm_id);
      $battle_map->set_town_info($bm_town);
    }
    $battle_map->set_charactors($self->{chara_model}, $self->{chara});
    $battle_map->set_can_move({
      chara       => $self->{chara},
      chara_model => $self->{chara_model},
      town_model  => $self->{town_model},
    });

    $self->render('chara/battle_map.pl', {
      battle_map => $battle_map,
    });
  }

}

1;
