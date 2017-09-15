package Jikkoku::Service::BattleCommand::Battle::NavyPower {

  use Mouse;
  use Jikkoku;

  use constant NOT_SUITABLE_DECREASE_RATIO => 0.25;

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
  
  with qw( Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerCalculator );

  sub _build_current_node {
    my $self = shift;
    my $soldier = $self->chara->soldier;
    my $battle_map   = $self->battle_map_model->get( $soldier->battle_map_id );
    $battle_map->get_node_by_point($soldier);
  }

  sub _build_attack_power {
    my $self = shift;
    $self->current_node->is_water ? 0 : $self->orig_attack_power * NOT_SUITABLE_DECREASE_RATIO;
  }

  sub _build_defence_power {
    my $self = shift;
    $self->current_node->is_water ? 0 : $self->orig_defence_power * NOT_SUITABLE_DECREASE_RATIO;
  }

  sub write_to_log {
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

