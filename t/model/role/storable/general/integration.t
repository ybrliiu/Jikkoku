use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Model::Role::Storable::General::Integration';

package Jikkoku::Class::Country {

  use Mouse;

  has 'id'                     => ( is => 'ro', isa => 'Int', required => 1 );
  has 'name'                   => ( is => 'rw', isa => 'Str', required => 1 );
  has 'color_id'               => ( is => 'rw', isa => 'Int', required => 1 );
  has 'months_after_establish' => ( is => 'rw', isa => 'Int', default  => 0 );
  has 'king_id'                => ( is => 'rw', isa => 'Str', required => 1 );
  has 'command'                => ( is => 'rw', isa => 'Str', default  => '' );
  has 'position'               => ( is => 'rw', isa => 'Str', default  => ',,,,,, ' );

  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Country {

  use Mouse;

  use constant {
    INFLATE_TO        => 'Jikkoku::Class::Country',
    FILE_PATH         => 'country.dat',
    PRIMARY_ATTRIBUTE => 'id',
  };

  with 'Jikkoku::Model::Role::Storable::General::Integration';

  __PACKAGE__->meta->make_immutable;

}

ok my $country_model = Jikkoku::Model::Country->new;
ok $country_model->lock;
my $country = Jikkoku::Class::Country->new({
  id => 5,
  name => '無所属',
  color_id => 0,
  king_id => 'ybrliiu',
});
ok $country_model->create($country);
ok $country_model->commit;

done_testing;

