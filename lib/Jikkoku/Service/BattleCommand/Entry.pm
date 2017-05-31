package Jikkoku::Service::BattleCommand::Entry {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Model::Unite;
  
  has 'diplomacy_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Diplomacy',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Diplomacy')->new;
    },
  );

  with 'Jikkoku::Service::BattleCommand::PassCheckPoint';

  sub ensure_can_exec_about_target_town {
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
      Jikkoku::Service::Role::BattleActionException
        ->throw('宣戦布告をしていないか、まだ開戦時間ではありません。※他国と戦争するには、国の幹部の人が司令部から宣戦布告をしないとできません。');
    }
  }

  around exec_log => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . 'に入城しました！';
  };

  __PACKAGE__->meta->make_immutable;

}

1;
