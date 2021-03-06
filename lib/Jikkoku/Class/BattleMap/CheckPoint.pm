package Jikkoku::Class::BattleMap::CheckPoint {

  use Mouse;
  use Jikkoku;

  has 'x'                => ( is => 'ro', isa => 'Int', required => 1 );
  has 'y'                => ( is => 'ro', isa => 'Int', required => 1 );
  has 'target_bm_id'     => ( is => 'ro', isa => 'Str', required => 1 );
  has 'target_bm_name'   => ( is => 'ro', isa => 'Str', required => 1 );
  has 'target_town_name' => ( is => 'ro', isa => 'Str', required => 1 );

  __PACKAGE__->meta->make_immutable;

}

1;
