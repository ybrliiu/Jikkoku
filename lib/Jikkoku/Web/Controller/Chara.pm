package Jikkoku::Web::Controller::Chara {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller::Chara::Base';

  sub battle_map {
    my $self = shift;

    my $soldier = $self->chara->soldier;
    $self->render_error('出撃していません。') unless $soldier->is_sortie;
    my $battle_map = $self->model('BattleMap')->new->get( $soldier->battle_map_id );
    my $town_model = $self->model('Town')->new;
    if ( $battle_map->is_castle_around_map ) {
      $town_model->get_with_option( $soldier->battle_map_id )->foreach(sub {
        my $town = shift;
        $battle_map->set_town_info($town);
      });
    }
    $battle_map->set_charactors($self->chara_model, $self->chara);
    $battle_map->set_can_move({
      chara       => $self->chara,
      chara_model => $self->chara_model,
      town_model  => $town_model,
    });

    my $country_model = $self->model('Country')->new;
    my $country       = $country_model
      ->get_with_option( $self->chara->country_id )
      ->get_or_else( $country_model->neutral );

    my $chara_soldier         = $self->chara->soldier;
    my $formation_model       = $self->model('Formation')->new;
    my $formation             = $formation_model->get( $chara_soldier->formation_id );
    my $available_formations  = $formation_model->get_available_formations( $self->chara );
    my $adjacent_check_points = $battle_map->get_adjacent_check_points($chara_soldier);

    $self->render('chara/battle_map.pl', {
      time                  => time,
      country               => $country,
      formation             => $formation,
      battle_map            => $battle_map,
      auto_mode_list_model  => $self->model('Chara::AutoModeList')->new,
      available_formations  => $available_formations,
      adjacent_check_points => $adjacent_check_points,
    });

  }

  __PACKAGE__->meta->make_immutable;

}

1;
