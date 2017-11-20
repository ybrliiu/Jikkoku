package Jikkoku::Service::Chara::Soldier::ChangeFormation {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Exception;

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );

  has 'time' => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { time } );

  has 'remaining_time' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_remaining_time',
  );

  has 'is_arranging' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    builder => '_build_is_arranging',
  );

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

  sub _build_remaining_time {
    my $self = shift;
    $self->chara->soldier->change_formation_time - $self->time;
  }

  sub _build_is_arranging {
    my $self = shift;
    $self->remaining_time > 0;
  }

  sub exec {
    my ($self, $change_formation_id) = @_;
    Carp::croak 'Too few arguments (required: $formation_id)' if @_ < 2;
    my $chara = $self->chara;
    my $soldier = $chara->soldier;
    my $formation = $self->formation_model->get($change_formation_id);
    $chara->lock;
    if ( $self->is_arranging ) {
      Jikkoku::Exception->throw("あと @{[ $self->remaining_time ]} 秒陣形を変更できません");
    }
    $soldier->formation_id($formation->id);
    if ( $soldier->is_sortie ) {
      $soldier->change_formation_time($self->time + $formation->reforming_time);
    }
    $chara->commit;
    $chara->formation;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

