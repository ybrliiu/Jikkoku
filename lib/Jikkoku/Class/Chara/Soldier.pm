package Jikkoku::Class::Chara::Soldier {

  use Mouse;
  use Jikkoku;

  # by etc/soldier.conf
  has 'id'           => ( is => 'ro', isa => 'Int',      required => 1 );
  has 'name'         => ( is => 'ro', isa => 'Str',      required => 1 );
  has 'type'         => ( is => 'ro', isa => 'Str',      required => 1 );
  has 'attr'         => ( is => 'ro', isa => 'Str',      required => 1 );
  has 'price'        => ( is => 'ro', isa => 'Int',      required => 1 );
  has 'attack'       => ( is => 'ro', isa => 'CodeRef',  required => 1 );
  has 'defence'      => ( is => 'ro', isa => 'CodeRef',  required => 1 );
  has 'attack_show'  => ( is => 'ro', isa => 'Str',      required => 1 );
  has 'defence_show' => ( is => 'ro', isa => 'Str',      required => 1 );
  has 'move_point'   => ( is => 'ro', isa => 'Int',      required => 1 );
  has 'reach'        => ( is => 'ro', isa => 'Int',      required => 1 );
  has 'technology'   => ( is => 'ro', isa => 'Int',      required => 1 );
  has 'class'        => ( is => 'ro', isa => 'Int',      required => 1 );
  has 'skill'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
  has 'description'  => ( is => 'ro', isa => 'Str',      required => 1 );
  
  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1 );

  sub attack_power {
    my $self = shift;
    $self->attack->( @_ );
  }

  sub defence_power {
    my $self = shift;
    $self->defence->( @_ );
  }

}

1;
