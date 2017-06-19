use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Class::Role::Storable::Division';

package Chara {

  use Mouse;
  use Jikkoku;

  use constant {
    DIR_PATH          => '',
    PRIMARY_ATTRIBUTE => 'id',
  };

  has 'id'   => ( is => 'ro', isa => 'Str' );
  has 'name' => ( is => 'rw', isa => 'Str' );

  with 'Jikkoku::Class::Role::Storable::Division';

  __PACKAGE__->meta->make_immutable;

}

{
  my $chara = Chara->new({id => 'liiu', name => 'りーう'});
  ok $chara->make;

  is $chara->name, 'りーう';
  ok $chara->lock;
  ok $chara->name('れいう');
  ok $chara->commit;
  ok $chara->name, 'れいう';

  ok $chara->lock;
  ok $chara->name('あああ');
  ok $chara->abort;
  is $chara->name, 'れいう';

  ok $chara->remove;
}

done_testing;
