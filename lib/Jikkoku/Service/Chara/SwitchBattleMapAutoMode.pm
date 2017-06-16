package Jikkoku::Service::Chara::SwitchBattleMapAutoMode {

  use Mouse;
  use Jikkoku;

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara', required => 1 );

  has 'auto_mode_list_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::AutoModeList',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara::AutoModeList')->new;
    },
  );

  with 'Jikkoku::Role::Loader';

  sub on {
    my $self = shift;
    my $auto_mode_list_model = $self->auto_mode_list_model;
    $auto_mode_list_model->lock;
    $auto_mode_list_model->add( $self->chara->id );
    $auto_mode_list_model->commit;
  }

  sub off {
    my $self = shift;
    my $auto_mode_list_model = $self->auto_mode_list_model;
    $auto_mode_list_model->lock;
    $auto_mode_list_model->delete( $self->chara->id );
    $auto_mode_list_model->commit;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

