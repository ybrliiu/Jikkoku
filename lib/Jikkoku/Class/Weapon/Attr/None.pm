package Jikkoku::Class::Weapon::Attr::None {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '無' );

  has 'increase_attack_power_coef_when_advantageous'
    => ( is => 'ro', isa => 'Num', default => 0 );

  has 'increase_attack_power_coef_when_advantageous_and_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Num', default => 0 );

  has 'is_attr_power_increase_when_advantageous'
    => ( is => 'ro', isa => 'Bool', default => 0 );

  with qw( Jikkoku::Class::Weapon::Attr::Attr );

  sub _build_advantageous_attrs { [] }

  __PACKAGE__->meta->make_immutable;

}

1;

