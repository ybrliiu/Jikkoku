package Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity {

  use Mouse;
  use Jikkoku;

  has [qw/ chara target /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    required => 1,
  );

  has 'is_advantage' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    builder => '_build_is_advantage',
  );

  has 'is_weapon_and_soldier_same_attr' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    builder => '_build_is_weapon_and_soldier_same_attr',
  );

  sub _build_is_advantage {
    my $self = shift;
    grep { $self->target->soldier->attr eq $_ } @{ $self->chara->weapon->attr->advantageous_attrs };
  }

  sub _build_is_weapon_and_soldier_same_attr {
    my $self = shift;
    $self->chara->soldier->attr eq $self->chara->weapon->attr->name;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=head1

  対戦相手を引数に受け取り自分の武器属性が相手の兵士に対して有利かどうかを調べるクラス

=cut

