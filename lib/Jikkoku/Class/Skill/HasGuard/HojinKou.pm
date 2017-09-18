package Jikkoku::Class::Skill::HasGuard::HojinKou {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN => 3,
    GUARD_NAME   => '歩人甲',
  };

  has 'name'                   => ( is => 'ro', isa => 'Str', default => GUARD_NAME );
  has 'increase_defence_power' => ( is => 'ro', isa => 'Int', default => 30 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasGuard
    Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster
  );

  sub description {
    my $self = shift;
    '歩兵使用時、守備力+' . $self->increase_defence_power . '。';
  }

  sub adjust_defence_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $self->soldier->attr eq '歩' ? $self->increase_defence_power : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

