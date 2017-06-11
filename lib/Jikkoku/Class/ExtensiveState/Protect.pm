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
    my $soldier = $self->chara->soldier;
    my $charactors = $self->charactors
      ->get_charactors_by_soldier_bm_id_with_result( $soldier->battle_map_id )
      ->get_charactors_by_soldier_distance_less_than_with_result( $soldier, $self->range );
    my $giver;
    for my $chara (@$charactors) {
      $self->record_model
        ->get_with_option($chara->id, $self->id)
        ->foreach(sub {
          $giver = shift;
          last;
        });
    }
    $giver;
  }

  __PACKAGE__->meta->add_method(get_giver => \&is_receive_effect);

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

  sub give {
    my $self = shift;
    $self->record_model->lock;
    $self->record_model->add({
      giver_id       => $self->chara->id,
      state_id       => $self->id,
      available_time => time,
    });
    $self->record_model->commit;
  }

  sub description { '' }

  __PACKAGE__->meta->make_immutable;

}

1;

