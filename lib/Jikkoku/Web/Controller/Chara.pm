package Jikkoku::Web::Controller::Chara {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Base';

  sub battle_map {
    my $self = shift;

    my $bm_id      = $self->{chara}->soldier_battle_map('battle_map_id');
    my $battle_map = $self->model('BattleMap')->new->get($bm_id);
    my $town       = $self->model('Town')->new->get( $self->{chara}->town_id );
    $battle_map->set_town_info($town);

    $self->render('chara/battle_map.pl', {
      battle_map => $battle_map,
    });
  }

}

1;
