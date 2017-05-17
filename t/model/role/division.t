use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Role::Division';
use_ok $CLASS;

package Jikkoku::Model::Player {

  use Mouse;
  use Jikkoku;

  use constant {
    INFLATE_TO        => 'Jikkoku::Class::Chara',
    PRIMARY_ATTRIBUTE => 'id',
  };

  with 'Jikkoku::Model::Role::Division';

  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Player::Result {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Model::Role::Result';

  sub get_charactors_by_country_id {
    my ($self, $country_id) = @_;
    Carp::croak 'few arguments($country_id)' if @_ < 2;
    [ grep { $_->country_id eq $country_id } @{ $self->data } ];
  }

  __PACKAGE__->meta->make_immutable;

}

ok my $model = Jikkoku::Model::Player->new;

subtest get_with_option => sub {
  dies_ok { $model->get_with_option };
  ok my $chara = $model->get_with_option('ybrliiu')->get;
  ok $chara->isa( $model->INFLATE_TO );
  ok my $none = $model->get_with_option('HOHOHOHO');
  ok $none->isa('Option::None');
};

subtest get_all => sub {
  ok my $charactors = $model->get_all;
  is @$charactors, 7;
};

subtest get_all_with_result => sub {
  ok my $charactors_result = $model->get_all_with_result;
  ok my $same_country = $charactors_result->get_charactors_by_country_id(1);
  is @$same_country, 2;
};

subtest foreach => sub {
  lives_ok { $model->foreach(sub { my $chara = shift }) };
  $model->foreach(sub {
    my $chara = shift;
    ok $chara->isa('Jikkoku::Class::Chara');
  });
};

done_testing;
