package Jikkoku::Class::ExtensiveState::Protect {

  use Mouse;
  use Jikkoku;
  use Carp ();

  has 'name'  => ( is => 'ro', isa => 'Str', default => '掩護' );
  has 'range' => ( is => 'ro', isa => 'Int', default => 3 );

  with 'Jikkoku::Class::ExtensiveState::ExtensiveState';

  sub is_receive_effect {
    my ($self, $time) = @_;
    Carp::croak 'few arguments($time)' if @_ < 2;
  }

  sub is_give_effect {
    my ($self, $time) = @_;
    Carp::croak 'few arguments($time)' if @_ < 2;
    $self->record_model->get_with_option($self->chara->id, $self->id)->match(
      Some => sub {
        my $state_record = shift;
        $state_record->is_available($time);
      },
      None => sub { 0 },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

