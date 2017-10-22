package Jikkoku::Class::BattleMode::AttackInWaves {

  use Mouse;
  use Jikkoku;

  has 'name'             => ( is => 'ro', isa => 'Str', default => '波状攻撃' );
  has 'range'            => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );
  has 'occur_ratio'      => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_occur_ratio' );
  has 'max_occur_ratio'  => ( is => 'ro', isa => 'Num', default => 0.3 );
  has 'occur_ratio_coef' => ( is => 'ro', isa => 'Num', default => 0.001 );
  has 'consume_morale'   => ( is => 'ro', isa => 'Int', default => 7 );

  with qw(
    Jikkoku::Class::BattleMode::BattleMode
    Jikkoku::Service::BattleCommand::Battle::OccurActionTimeOverwriter
    Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter
  );

  sub _build_occur_ratio {
    my $self = shift;
    my $ratio = $self->chara->force * $self->occur_ratio_coef;
    $ratio > $self->max_occur_ratio ? $self->max_occur_ratio : $ratio;
  }

  sub event_execute_service_class_name {
    my $self = shift;
    my $class = ref $self || $self;
    $class =~ s/Class/Service/gr;
  }

  sub can_use {
    my $self = shift;
    $self->skills->get({category => 'Invasion', id => $self->id})->is_acquired;
  }

  sub description {
    my $self = shift;
    << "EOS"
行動待機時間が通常の戦闘の2/3になる。<br>
さらに戦闘中に波状攻撃イベント発生。敵に数ダメージ与える。城壁戦にも有効。<br>
波状攻撃イベントの発動率は武力に依存。
EOS
  }

  has 'overwrite_ratio'  => ( is => 'ro', isa => 'Num', default => 2 / 3 );

  sub overwrite_battle_occur_action_time {
    my ($self, $orig_time) = @_;
    $orig_time * $self->overwrtie_ratio;
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

