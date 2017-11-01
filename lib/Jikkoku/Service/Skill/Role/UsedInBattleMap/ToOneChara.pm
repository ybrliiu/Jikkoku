package Jikkoku::Service::Skill::Role::UsedInBattleMap::ToOneChara {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::Skill::Role::UsedInBattleMap';

  has 'target_id' => ( is => 'ro', isa => 'Str', required => 1 );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
    },
  );

  has 'target' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::ExtChara',
    lazy    => 1,
    builder => '_build_target',
  );

  sub _build_target {
    my $self = shift;

    # 自分自身を指定した場合は target に chara をセット
    return $self->chara if $self->chara->id eq $self->target_id;

    $self->chara_model->get_with_option( $self->target_id )->match(
      Some => sub {
        my $target_orig = shift;
        my $target = $self->class('Chara::ExtChara')->new(chara => $target_orig);

        unless ( $target->soldier->is_sortie ) {
          Jikkoku::Service::Role::BattleActionException
            ->throw($target->name . 'は出撃していません。');
        }

        if ( $target->soldier->battle_map_id ne $self->chara->soldier->battle_map_id ) {
          Jikkoku::Service::Role::BattleActionException->throw('相手と同じBM上にいません。');
        }

        my $distance = $self->chara->soldier->distance_from_point( $target->soldier );
        if ( $distance > $self->skill->range ) {
          Jikkoku::Service::Role::BattleActionException
            ->throw('相手が' . $self->name . 'を使える範囲にいません。');
        }

        $target;
      },
      None => sub {
        Jikkoku::Service::Role::BattleActionException->throw('指定した武将は存在していません。')
      },
    );
  }

  # method
  requires 'ensure_can_use_to_target_chara';

  before ensure_can_exec => sub {
    my $self = shift;

    # call _build_target
    $self->target;

    $self->ensure_can_use_to_target_chara;
  };

}

1;
