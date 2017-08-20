package Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerCalculator {

  use Mouse::Role;
  use Jikkoku;
  
  has 'chara_power' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    handles  => [qw/ chara target attack_power_orig defence_power_orig /],
    weak_ref => 1,
    required => 1,
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

  requires qw( _build_attack_power _build_defence_power );

  around _build_defence_power => sub {
    my ($orig, $self) = @_;
    # 元の守備力が負値になっているときは何も値を変化させない
    $self->defence_power_orig < 0 ? 0 : $self->$orig();
  };

}

1;

