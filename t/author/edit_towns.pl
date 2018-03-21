use Test::Jikkoku;
use Jikkoku::Model::Town;

my $town_model = Jikkoku::Model::Town->new;
for my $town ($town_model->get_all->@*) {
  diag $town->name;
  $town->farm_max( int( rand( $town->farm_max ) ) + $town->farm_max );
  $town->farm( int( rand( $town->farm_max ) ) + $town->farm );
  diag $town->farm;
  $town->business_max( int( rand( $town->business_max ) ) + $town->business_max );
  $town->business( int( rand( $town->business_max ) ) + $town->business );
  diag $town->business;
  $town->wall_max( int( rand( $town->wall_max ) ) + $town->wall_max );
  $town->wall( int( rand( $town->wall_max ) ) + $town->wall );
  diag $town->wall;
  $town->loyalty( 50 + int rand 50 );
  diag $town->loyalty;
  $town->technology( int( rand( $town->technology / 2 ) ) + ($town->technology || 300) );
  diag $town->technology;
  $town->wall_power(1000);
}
ok $town_model->save;

ok 1;

done_testing;
