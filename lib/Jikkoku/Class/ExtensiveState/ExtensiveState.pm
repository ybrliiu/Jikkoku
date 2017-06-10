package Jikkoku::Class::ExtensiveState::ExtensiveState {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Class::ExtensiveStateRecord;

  # attribute
  requires qw( name );

  has 'id'         => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_id' );
  has 'icon'       => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_icon' );
  has 'chara'      => ( is => 'ro', isa => 'Jikkoku::Class::Chara',         weak_ref => 1, required => 1 );
  has 'charactors' => ( is => 'ro', isa => 'Jikkoku::Model::Chara::Result', weak_ref => 1, required => 1 );

  has 'record_model' => (
    is       => 'ro',
    isa      => 'Jikkoku::Model::ExtensiveStateRecord', 
    lazy     => 1,
    weak_ref => 1,
    required => 1,
  );

  with 'Jikkoku::Role::Loader';

  sub _build_id {
    my $self = shift;
    my $class = ref $self;
    (split /::/, $class)[-1];
  }

  sub _build_icon {
    my $self = shift;
    lc($self->id) . '.png';
  }

  # method
  requires qw( description is_receive_effect is_give_effect );

  sub output {
    my $self = shift;
    Jikkoku::Class::ExtensiveStateRecord->new(
      giver_id       => $self->chara->id,
      state_id       => $self->id,
      available_time => time,
    );
  }

}

1;

