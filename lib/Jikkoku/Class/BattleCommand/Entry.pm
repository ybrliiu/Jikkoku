package Jikkoku::Class::BattleCommand::Entry {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util 'validate_values';

  use Jikkoku::Model::Unite;
  
  has 'diplomacy_model' => ( is => 'rw', isa => 'Jikkoku::Model::Diplomacy' );

  with 'Jikkoku::Class::BattleCommand::PassCheckPoint';

  before ensure_can_action => sub {
    my ($self, $args) = @_;
    validate_values $args => [qw/ diplomacy_model /];
    $self->diplomacy_model( $args->{diplomacy_model} );
  };

  sub ensure_can_action_about_target_town {
    my $self = shift;
    my ($chara, $target_town) = ($self->chara, $self->target_town);
    my $can_passage = $self->diplomacy_model->can_passage(
      $chara->country_id,
      $target_town->country_id,
      $self->now_game_date
    );
    if ( $target_town->is_neutral || $target_town->country_id == $chara->country_id ) {
      $can_passage = 1;
    }
		if (!$can_passage && !Jikkoku::Model::Unite->is_unite) {
      Jikkoku::Class::Role::BattleActionException
        ->throw('宣戦布告をしていないか、まだ開戦時間ではありません。※他国と戦争するには、国の幹部の人が司令部から宣戦布告をしないとできません。');
    }
  }

  around action_log => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . 'に入城しました！';
  };

}

1;
