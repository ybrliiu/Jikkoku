package Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::CharaPower {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util qw( sign );

  has [qw/ chara target /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    required => 1,
  );

  has 'adjuster' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster',
    required => 1,
  );

  has 'orig_attack_power'  => ( is => 'ro', isa => 'Num', required => 1 );
  has 'orig_defence_power' => ( is => 'ro', isa => 'Num', required => 1 );

  has 'adjust_attack_power'  => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_adjust_attack_power' );
  has 'adjust_defence_power' => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_adjust_defence_power' );

  sub _build_adjust_attack_power {
    my $self = shift;
    int $self->adjuster->adjust_attack_power($self);
  }

  sub _build_adjust_defence_power {
    my $self = shift;
    int $self->adjuster->adjust_defence_power($self);
  }

  requires qw( write_to_log );

}

1;

