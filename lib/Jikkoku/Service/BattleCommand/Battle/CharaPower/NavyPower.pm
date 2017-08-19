package Jikkoku::Service::BattleCommand::Battle::NavyPower {

  use Mouse;
  use Jikkoku;

  use constant NOT_SUITABLE_DECREASE_RATIO => 0.25;
  
  has 'chara_power' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    handles  => [qw/ chara target attack_power_orig defence_power_orig /],
    weak_ref => 1,
    required => 1,
  );

  has 'battle_map_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('BattleMap')->new;
    },
  );

  has 'current_node' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::BattleMap::Node',
    lazy    => 1,
    builder => '_build_current_node',
  );

  has 'attack_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_attack_power',
  );

  has 'defence_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_defence_power',
  );
  
  with 'Jikkoku::Role::Loader';

  sub _build_current_node {
    my $self = shift;
    my $soldier = $self->chara->soldier;
    my $battle_map   = $self->battle_map_model->get( $soldier->battle_map_id );
    $battle_map->get_node_by_point($soldier);
  }

  sub _build_attack_power {
    my $self = shift;
    $self->current_node->is_water ? 0 : $self->attack_power_orig * NOT_SUITABLE_DECREASE_RATIO;
  }

  sub _build_defence_power {
    my $self = shift;
    $self->current_node->is_water ? 0 : $self->defence_power_orig * NOT_SUITABLE_DECREASE_RATIO;
  }

  sub exec {
    my $self = shift;
    unless ( $self->current_node->is_water ) {
      my $log = qq{<span class="lightblue">【水軍不適応地形】</span>@{[ $self->chara->name ]}の}
              . qq{攻撃力が<span clasS="red">@{[ $self->attack_power ]}</span>、}
              . qq{守備力が<span class="red">@{[ $self->defence_power ]}</span>されました。};
      $self->chara->battle_logger->add($log);
      $self->target->battle_logger->add($log);
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

