use Test::Jikkoku;

use_ok 'Jikkoku::Model::Role::Class';

package TestModel {

  use Mouse;
  use Jikkoku;

  use constant {
    NAMESPACE => 'Jikkoku::Class::State',
    ROLE      => 'Jikkoku::Class::State::State',
  };

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );

  with 'Jikkoku::Model::Role::Class';

  sub get {
    my ($self, $id) = @_;
    "@{[ $self->NAMESPACE ]}::${id}"->new(chara => $self->chara);
  }

  sub get_all {
    my $self = shift;
    [ map { $self->get($_) } @{ $self->MODULES } ];
  }

  sub get_all_with_result {
    my $self = shift;
    $self->result_class->new(data => $self->get_all);
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

};

package TestModel::Result {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Model::Role::Result';

  __PACKAGE__->meta->make_immutable;

};

is ref(TestModel->MODULES), 'ARRAY';

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
ok( my $model = TestModel->new(chara => $chara) );
ok( my $state = $model->get('Stuck') );
is $state->name, '足止め';
lives_ok { $model->get_all };
lives_ok { $model->get_all_with_result };

done_testing;

