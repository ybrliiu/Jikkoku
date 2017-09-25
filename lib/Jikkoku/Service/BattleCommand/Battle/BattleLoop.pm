package Jikkoku::Service::BattleCommand::Battle::BattleLoop {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Service::BattleCommand::Battle::Result;
  use Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara;

  use constant Result => 'Jikkoku::Service::BattleCommand::Battle::Result';

  for my $name (qw/ _chara _target /) {
    has $name => (
      is       => 'ro',
      isa      => 'Jikkoku::Service::BattleCommand::Battle::Chara',
      init_arg => $name,
      required => 1,
    );
  }

  has [qw/ chara_power target_power /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    required => 1,
  );

  has [qw/ chara target /] => (
    is         => 'ro',
    isa        => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara',
    lazy_build => 1,
  );

  has 'end_turn'     => ( is => 'ro', isa => 'Int', required => 1 );
  has 'current_turn' => ( is => 'rw', isa => 'Int', init_arg => undef, default => 0 );
  has 'result'       => ( is => 'rw', isa => 'Int', default => Result::None );

  # スキルが戦闘中に記録しておきたいデータを記録しておくためのattribute
  # +{ skill_id => { count => 0 }, skill_id2 => {} ... } みたいな感じで使う
  has 'skills_record' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  sub _build_chara {
    my $self = shift;
    Jikkoku::Service::BattleCommand::Battle::BattleLoopChara->new({
      %{ $self->_chara },
      power        => $self->chara_power,
      target_power => $self->target_power,
    });
  }

  sub _build_target {
    my $self = shift;
    Jikkoku::Service::BattleCommand::Battle::BattleLoopChara->new({
      %{ $self->_target },
      power        => $self->target_power,
      target_power => $self->chara_power,
    });
  }

  sub battle_result {
    my $self = shift;
    my $ksol = $self->chara->soldier->num;
    my $esol = $self->target->soldier->num;
    if ($ksol <= 0 && $esol <= 0) {
      Result::DRAW;
    }
    elsif ($ksol <= 0) {
      Result::LOSE;
    }
    elsif ($esol <= 0) {
      Result::WIN;
    }
    else {
      Result::NONE;
    }
  }

  sub init_loop {
    my $self = shift;
    $self->chara->set_new_take_damage();
    $self->target->set_new_take_damage();
  }

  sub _end {
    my $self = shift;
    $self->chara->record_increase_contribute( $self->target );
    $self->target->record_increase_contribute( $self->chara );
    $self->result( $self->battle_result );
  }

  sub exec_skill {
    my ($self, $chara) = @_;
    for my $executer (@{ $chara->event_executers }) {
      $executer->exec_event($self);
    }
  }

  sub exec_skills {
    my $self = shift;
    $self->exec_skill($self->chara);
    $self->exec_skill($self->target);
    $self->_end();
  }

  sub battle {
    my $self = shift;
    my ($chara, $target) = ($self->chara, $self->target);
    $target->soldier -= $self->chara_take_damage;
    $chara->soldier  -= $self->target_take_damage;
    my $log = qq{ターン<span class="red">@{[ $self->current_turn ]}</span> : }
      . qq{@{[ $chara->soldier_status ]} ↓(-@{[ $self->target_take_damage ]}) | }
      . qq{@{[ $target->soldier_status ]} ↓(-@{[ $self->chara_take_damage ]})};
    $chara->battle_logger->add($log);
    $target->battle_logger->add($log);
    $self->_end();
  }

  sub start_loop {
    my $self = shift;
    my $log = $self->chara->power_status . '|' . $self->target->power_status;
    for my $turn (0 .. $self->end_turn - 1) {
      $self->current_turn($turn);
      $self->init_loop();
      $self->exec_skills();
      last if $self->result != Result::NONE;
      $self->battle();
      last if $self->result != Result::NONE;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;
