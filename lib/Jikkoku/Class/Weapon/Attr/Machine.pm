package Jikkoku::Class::Weapon::Attr::Machine {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '機' );

  has 'increase_attack_power_ratio_when_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Num', default => 1 );

  has 'increase_attack_power_ratio_when_advantageous_and_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Num', default => 2 );

  has 'is_attr_power_increase_when_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Bool', default => 1 );

  with qw( Jikkoku::Class::Weapon::Attr::Attr );

  sub _build_advantageous_attrs { [] }

  __PACKAGE__->meta->make_immutable;

}

1;

