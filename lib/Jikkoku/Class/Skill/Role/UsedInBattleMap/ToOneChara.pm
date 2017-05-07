package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with 'Jikkoku::Class::Skill::Role::ToOneChara';
  
  # attribute
  requires 'range';

  has 'you' => ( is => 'rw', isa => 'Jikkoku::Class::Chara' );

  # method
  requires 'ensure_can_use_to_target_chara';

  around description_of_status_about_range => sub {
    my ($orig, $self) = @_;
    "リーチ : @{[ $self->range ]}";
  };

  before ensure_can_exec => sub {
    my ($self, $args) = @_;
    Jikkoku::Util::validate_values $args => [qw( target_id chara_model )];
    my $chara = $self->chara;

    $args->{chara_model}->get_with_option( $args->{target_id} )->match(
      Some => sub {
        my $you = shift;
        unless ($you->is_sortie) {
          Jikkoku::Class::Role::BattleActionException->throw($you->name . 'は出撃していません。');
        }
        if ( $you->soldier_battle_map('battle_map_id') ne $chara->soldier_battle_map('battle_map_id') ) {
          Jikkoku::Class::Role::BattleActionException->throw('相手と同じBM上にいません。');
        }
        my $distance = $chara->distance_to_chara_soldier($you);
        if ($distance > $self->range) {
          Jikkoku::Class::Role::BattleActionException->throw('相手が' . $self->name . 'を使える範囲にいません。');
        }
        $self->you( $you );
      },
      None => sub { throw('指定した武将は存在していません。') },
    );

    $self->ensure_can_use_to_target_chara;
  };

}

1;
