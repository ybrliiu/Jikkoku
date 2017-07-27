package Jikkoku::Class::Weapon::Attr::Attr {

  use Mouse::Role;
  use Jikkoku;

  has 'increase_attack_power_coef_when_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Num', default => 0 );

  has 'increase_attack_power_coef_when_advantageous'
    => ( is => 'ro', isa => 'Num', default => 0.5 );

  has 'increase_attack_power_coef_when_advantageous_and_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Num', default => 1 );

  has 'is_attr_power_increase_when_advantageous'
    => ( is => 'ro', isa => 'Bool', default => 1 );

  has 'is_attr_power_increase_when_soldier_has_same_attr'
    => ( is => 'ro', isa => 'Bool', default => 0 );

  has 'advantageous_attrs' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_advantageous_attrs',
  );

  # attributes
  requires qw( name );

  # methods
  requires qw( _build_advantageous_attrs );

}

1;

__END__

=encoding utf8

=head1 NAME

=head1 DESCRIPTION

  武器属性クラス
  武器属性に関する情報, 処理がかなり複雑化していたので作成

=cut

