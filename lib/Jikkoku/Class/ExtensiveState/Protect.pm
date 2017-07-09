package Jikkoku::Class::ExtensiveState::Protect {

  use Mouse;
  use Jikkoku;
  use Carp ();
  use Jikkoku::Class::ExtensiveState::BattleTargetOverriderResult;

  has 'name'  => ( is => 'ro', isa => 'Str', default => '掩護' );
  has 'range' => ( is => 'ro', isa => 'Int', default => 3 );

  with qw(
    Jikkoku::Class::ExtensiveState::ExtensiveState
    Jikkoku::Class::ExtensiveState::Role::OverrideBattleTarget
  );

  sub override_battle_target {
    my ($self, $time) = @_;
    Carp::croak 'few arguments($time)' if @_ < 2;
    my $soldier = $self->chara_soldier;
    my $candidates = $self->charactors
      ->get_charactors_by_else_id_with_result( $self->chara->id )
      ->get_charactors_by_soldier_bm_id_with_result( $soldier->battle_map_id )
      ->get_charactors_by_soldier_distance_less_than_with_result( $soldier, $self->range );
    my $giver;
    for my $candidate (@$candidates) {
      $self->record_model
        ->get_with_option($candidate->id, $self->id)
        ->foreach(sub {
          my $state_record = shift;
          if ( $state_record->is_available($time) ) {
            $giver = $candidate;
            last;
          }
        });
    }

    if (defined $giver) {
      Jikkoku::Class::ExtensiveState::BattleTargetOverriderResult->new({
        giver           => $giver,
        extensive_state => $self,
      });
    } else {
      ();
    }
  }

  sub is_receive_effect;
  __PACKAGE__->meta->add_method(is_receive_effect => \&override_battle_target);

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
    $self->record_model->add({
      giver_id       => $self->chara->id,
      state_id       => $self->id,
      available_time => time,
    });
  }

  sub description { '' }

  __PACKAGE__->meta->make_immutable;

}

1;

