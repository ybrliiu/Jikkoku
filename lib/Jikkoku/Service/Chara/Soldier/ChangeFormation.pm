package Jikkoku::Service::Chara::Soldier::ChangeFormation {

  use Mouse;
  use Jikkoku;

  has 'chara'               => ( is => 'ro', isa => 'Jikkoku::Class::Chara', required => 1 );
  has 'change_formation_id' => ( is => 'ro', isa => 'Int', required => 1 );

  has 'formation_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Formation',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Formation')->new;
    },
  );

  with 'Jikkoku::Role::Loader';

  sub exec {
    my $self = shift;
    my $formation = $self->formation_model->get( $self->change_formation_id );
    my $chara = $self->chara;
    $chara->lock;
    $chara->soldier->change_formation( $formation );
    $chara->commit;
    $formation;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

