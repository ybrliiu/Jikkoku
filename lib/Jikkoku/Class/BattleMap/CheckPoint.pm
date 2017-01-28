package Jikkoku::Class::BattleMap::CheckPoint {

  use Moo;
  use Jikkoku;

  has 'x'                => ( is => 'ro', required => 1 );
  has 'y'                => ( is => 'ro', required => 1 );
  has 'target_bm_id'     => ( is => 'ro', required => 1 );
  has 'target_bm_name'   => ( is => 'ro', required => 1 );
  has 'target_town_name' => ( is => 'ro', required => 1 );

  __PACKAGE__->meta->make_immutable;

}

1;
