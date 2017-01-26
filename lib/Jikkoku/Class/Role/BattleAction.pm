package Jikkoku::Class::Role::BattleAction {

  use Jikkoku;
  use Role::Tiny;

  use Jikkoku::Class::Role::BattleActionException;
  use Jikkoku::Model::Config;
  use Scalar::Util qw/weaken/;
  use Jikkoku::Util qw/validate_values is_game_update_hour/;

  my $EXCEPTION = 'Jikkoku::Class::Role::BattleActionException';

  requires qw/ensure_can_action action/;

  around new => sub {
    my ($origin, $class, $args) = @_;
    validate_values $args => [qw/chara/];
    my $self = $class->$origin($args);
    weaken $self->{chara};
    $self;
  };

  before ensure_can_action => sub {
    my ($self) = @_;
    $EXCEPTION->throw("BM上で行動可能な時間帯ではありません。") unless is_game_update_hour;
    $EXCEPTION->throw("出撃していません。") unless $self->{chara}->is_sortie;
    if ( $self->{chara}->soldier_num < 0 ) {
      $self->{chara}->soldier_retreat;
      $self->{chara}->save;
      $EXCEPTION->throw("兵士がいません。");
    }
  };

  around action => sub {
    my ($origin, $self, $args) = @_;
    my @ret = $self->ensure_can_action($args);
    $self->{chara}->commit;
    # ensure_can_action で最後に返された値が引数として渡される
    $self->$origin( @ret );
  };

}

1;
