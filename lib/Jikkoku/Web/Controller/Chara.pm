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
    my $country       = $country_model->get( $self->chara->country_id );

    $self->render('chara/battle_map.pl', {
      battle_map => $battle_map,
      country    => $country,
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
