package Jikkoku::Class::BattleCommand::ChargeMovePoint {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;
  use parent 'Jikkoku::Class::BattleCommand::Base';
  use Role::Tiny::With;
  with 'Jikkoku::Class::Role::BattleAction';

  use Jikkoku::Model::Config;

  {
    my $config = Jikkoku::Model::Config->get;
    my %attributes = (
      move_point_charge_time => $config->{game}{action_interval_time},
    );
    Class::Accessor::Lite->mk_accessors(keys %attributes);

    sub new {
      my ($class, $args) = @_;
      bless {
        %attributes,
        %$args,
      }, $class;
    }
  }

  sub ensure_can_action {
    my $self = shift;
    my $time = time;
    my $sub  = $self->{chara}->soldier_battle_map('move_point_charge_time') - $time;
    die "あと $sub 秒移動Pは補充できません。" if $sub > 0;
    $time;
  }

  sub action {
    my ($self, $time) = @_;

    eval {
      $self->{chara}->soldier_battle_map(move_point => $self->{chara}->soldier->move_point);
      $self->{chara}->soldier_battle_map(move_point_charge_time => $time + $self->{move_point_charge_time});
    };

    if (my $e = $@) {
      $self->{chara}->abort;
      die "$@ \n";
    } else {
      $self->{chara}->save;
    }

  }

}

1;
