package Jikkoku::Model::ExtensiveState {

  use Mouse;
  use Jikkoku;
  use Carp ();

  our @EXTENSIVE_STATE_MODULES = _get_extensive_state_modules();

  sub _get_extensive_state_modules {
    my $dir = './lib/Jikkoku/Class/ExtensiveState';
    opendir(my $dh, $dir);
    my @state_list = grep { $_ ne 'ExtensiveState' } map { $_ =~ /(\.pm$)/p ? ${^PREMATCH} : () } readdir $dh;
    close $dh;
    __PACKAGE__->class("ExtensiveState::$_") for @state_list;
    @state_list;
  }

  has 'chara'  => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1, required => 1 );

  has 'record_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::ExtensiveStateRecord', 
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('ExtensiveStateRecord')->new;
    },
  );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
    },
  );

  has 'charactors' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Result',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_model->get_all_with_result;
    },
  );

  with 'Jikkoku::Role::Loader';

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 2;
    "Jikkoku::Class::ExtensiveStateRecord::${id}"->new(
      chara        => $self->chara,
      charactors   => $self->charactors,
      record_model => $self->record_model,
    );
  }

  sub get_all_with_result {
    my $self = shift;
    my $data = [
      map {
        "Jikkoku::Class::ExtensiveStateRecord::$_"->new(
          chara        => $self->chara,
          charactors   => $self->charactors,
          record_model => $self->record_model,
        );
      } @EXTENSIVE_STATE_MODULES
    ];
    Jikkoku::Model::ExtensiveState::Result->new( data => $data );
  }
  
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::ExtensiveState::Result {

  use Mouse;
  use Jikkoku;
  use Option;

  has 'id_map' => (
    is => 'ro',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  with 'Jikkoku::Model::Role::Result';

  sub get_with_option {
    my ($self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 2;
    Option->new( $self->id_map->{$id} );
  }

  sub get_receive_effect_states {
    my ($self, $time) = @_;
    $time //= time;
    [ grep { $_->is_receive_effect($time) } @{ $self->data } ];
  }

  sub get_give_effect_states {
    my ($self, $time) = @_;
    $time //= time;
    [ grep { $_->is_give_effect($time) } @{ $self->data } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

