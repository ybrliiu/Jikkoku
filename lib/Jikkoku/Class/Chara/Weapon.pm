package Jikkoku::Class::Chara::Weapon {

  use Mouse;
  use Jikkoku;

# service で使う専用のクラスにしても良いかも

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    required => 1,
    handles => +{
      name       => 'weapon_name',
      power      => 'weapon_power',
      attr       => 'weapon_attr',
      attr_power => 'weapon_attr_power',
    },
  );

  has 'chara_soldier' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::Soldier', required => 1 );

  has 'target_soldier' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::Soldier', required => 1 );

  {

   # key => arrayref で有利属性を並べ連ねる

    my %advantage_attrs = (
      '歩'   => '弓',
      '弓'   => '騎',
      '騎'   => '歩',
      '水'   => '機',
      '機'   => '',
      '弓騎' => [],
    );

    sub advantage_attr {
      my $self = shift;
      $self->target_soldier->attr =~ $advantage_attrs{ $self->chara_soldier->attr };
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;
