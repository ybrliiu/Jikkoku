package Jikkoku::Service::BattleMap::DestinationNodeGetter {
  
  use Mouse;
  use Jikkoku;

  has 'battle_map' => ( is => 'ro', isa => 'Jikkoku::Class::BattleMap',       required => 1 );
  has 'chara'      => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );
  has 'charactors' => ( is => 'ro', isa => 'Jikkoku::Model::Chara::Result',   required => 1 );
  has 'direction'  => ( is => 'ro', isa => 'Str',                             required => 1 );

  has 'town_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Town',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Town')->new;
    },
  );

  with 'Jikkoku::Role::Loader';

  sub get {
    my $self = shift;

    my $soldier      = $self->chara->soldier;
    my $current_node = $self->battle_map->get_node_by_coordinate( $soldier->x, $soldier->y );
    my $next_node    = $self->battle_map->get_adjacent_node( $current_node, $self->direction );
    die "その座標は存在しません" unless defined $next_node;

    if ( $next_node->is_castle ) {
      my $bm_town = $self->town_model->get( $self->battle_map->id );
      die "他国の城の上に移動することはできません" if $bm_town->country_id != $self->chara->country_id;
    }

    my $enemies = $self->charactors
      ->get_not_applicable_charactors_by_country_id_with_result( $self->chara->country_id )
      ->get_charactors_by_soldier_bm_id_with_result( $self->battle_map->id )
      ->get_charactors_by_soldier_point_with_result( $next_node );
    die "そのマスには敵がいるので移動できません" if @$enemies;

    $next_node;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Jikkoku::Service::BattleMap::DestinationNodeGetter
    - 武将がBM上で移動するときの、移動先のNodeを取得するためのfacadeクラス

=cut

