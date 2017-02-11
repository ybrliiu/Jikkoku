use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Model::Role::Storable';

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
    CLASS     => 'Jikkoku::Class::Country',
    FILE_PATH => 'country.dat',
  };

  has 'data' => ( is => 'rw', isa => 'HashRef[' . CLASS . ']', builder => '_default_data' );

  with 'Jikkoku::Model::Role::Storable';

  sub create {
    my ($self, $args) = @_;
    $self->data->{$args->{id}} = CLASS->new($args);
  }

  __PACKAGE__->meta->make_immutable;

}

ok my $country_model = Jikkoku::Model::Country->new;
ok $country_model->lock;
ok $country_model->create({
  id => 5,
  name => '無所属',
  color_id => 0,
  king_id => 'ybrliiu',
});
ok $country_model->commit;

done_testing;

