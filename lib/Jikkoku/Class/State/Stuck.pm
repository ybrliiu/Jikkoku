package Jikkoku::Class::State::Stuck {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;

  use Carp qw/croak/;
  use Scalar::Util qw/weaken/;
  use Jikkoku::Util qw/validate_values/;

  {
    my %attributes = (
      name            => '足止め',
      icon            => 'stuck.png',
      effect_multiple => 1.7,
    );
    Class::Accessor::Lite->mk_accessors(keys %attributes);

    sub new {
      my ($class, $args) = @_;
      validate_values $args => [qw/chara/];
      my $self = bless {
        %attributes,
        %$args,
      }, $class;
      weaken $self->{chara};
      $self;
    }
  }

  sub is_in_the_state {
    my ($self, $time) = @_;
    croak "引数が足りません" if @_ < 2;
    $self->{chara}->debuff('stuck') > $time;
  }

  sub move_cost {
    my ($self, $origin_cost) = @_;
    $self->{effect_multiple} * $origin_cost;
  }

}

1;
