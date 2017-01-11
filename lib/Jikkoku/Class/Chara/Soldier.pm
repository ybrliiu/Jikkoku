package Jikkoku::Class::Chara::Soldier {

  use v5.14;
  use warnings;
  use Class::Accessor::Lite;

  {
    my %attributes = (
      id           => undef,
      name         => undef,
      type         => undef,
      attr         => undef,
      price        => undef,
      attack       => undef,
      defence      => undef,
      attack_show  => undef,
      defence_show => undef,
      move_point   => undef,
      reach        => undef,
      technology   => undef,
      class        => undef,
      skill        => [],
      description  => undef,
    );

    Class::Accessor::Lite->mk_accessors(keys %attributes);

    sub new {
      my ($class, $args) = @_;
      bless {%attributes, %$args}, $class;
    }
  }

  sub attack_power {
    my $self = shift;
    $self->{attack}->( @_ );
  }

  sub defence_power {
    my $self = shift;
    $self->{defence}->( @_ );
  }

}

1;
