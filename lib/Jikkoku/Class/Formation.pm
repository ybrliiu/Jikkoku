package Jikkoku::Class::Formation {

  use Mouse;
  use Jikkoku;

  # from etc/formation.conf
  has 'id'   => ( is => 'ro', isa => 'Str', required => 1 );
  has 'name' => ( is => 'ro', isa => 'Str', required => 1 );
  has 'increase_attack_power_ratio'  => ( is => 'ro', isa => 'Num', default  => 0 );
  has 'increase_defence_power_ratio' => ( is => 'ro', isa => 'Num', default  => 0 );
  has 'increase_attack_power_ratio_when_advantageous'  => ( is => 'ro', isa => 'Num', default => 0 );
  has 'increase_defence_power_ratio_when_advantageous' => ( is => 'ro', isa => 'Num', default => 0 );
  has 'increase_attack_power_num'  => ( is => 'ro', isa => 'Int', default  => 0 );
  has 'increase_defence_power_num' => ( is => 'ro', isa => 'Int', default  => 0 );
  has 'reforming_time'             => ( is => 'ro', isa => 'Int', required => 1 );
  has 'class'                      => ( is => 'ro', isa => 'Int', default  => 0 );
  has 'advantageous_formations_id' => ( is => 'ro', isa => 'ArrayRef[Int]', default => sub { [] } );
  has 'skills'                     => ( is => 'ro', isa => 'ArrayRef',      default => sub { [] } );
  has 'description'                => ( is => 'ro', isa => 'Str',           default => 1 );
  has 'acquire_condition'          => ( is => 'ro', isa => 'CodeRef',       default => sub { 1 } );

  has 'formation_model' => (
    is       => 'ro',
    isa      => 'Jikkoku::Model::Formation',
    weak_ref => 1,
    required => 1,
  );

  around description => sub {
    my ($orig, $self) = @_;
    $self->description_about_increase_power
      . $self->description_about_advantageous_formations
      . $self->description_about_increase_power_when_advantageous
      . $self->$orig();
  };

  sub description_about_advantageous_formations {
    my $self = shift;
    if ( @{ $self->advantageous_formations_id } ) {
      my @formation_names = map {
        $self->formation_model->get($_)->name;
      } @{ $self->advantageous_formations_id };
      join('、', @formation_names) . 'に強い。';
    } else {
      '';
    }
  }

  sub description_about_increase_power {
    my $self = shift;
    my $description = q{};
    if ( $self->is_increase_power ) {
      if ( $self->is_increase_attack_power ) {
        $description .= '攻撃力'
          . ($self->increase_attack_power_ratio != 0 ? "+@{[ $self->increase_attack_power_ratio * 100 ]}%" : '')
          . ($self->increase_attack_power_num   != 0 ? "+@{[ $self->increase_attack_power_num ]}" : '');
      }
      if ( $self->is_increase_defence_power ) {
        $description .= '、' if $self->is_increase_attack_power;
        $description .= '守備力'
          . ($self->increase_defence_power_ratio != 0 ? "+@{[ $self->increase_defence_power_ratio * 100 ]}%" : '')
          . ($self->increase_defence_power_num   != 0 ? "+@{[ $self->increase_defence_power_num ]}" : '');
      }
      $description .= "。";
    }
    $description;
  }

  sub description_about_increase_power_when_advantageous {
    my $self = shift;
    my $description = q{};
    if ( $self->is_increase_power_when_advantageous ) {
      $description .= '得意陣形の場合は更に';
      if ( $self->increase_attack_power_ratio_when_advantageous != 0 ) {
        $description .= "攻撃力+@{[ $self->increase_attack_power_ratio_when_advantageous * 100 ]}%";
      }
      if ( $self->increase_defence_power_ratio_when_advantageous != 0 ) {
        $description .= '、' if $self->increase_attack_power_ratio_when_advantageous != 0;
        $description .= "守備力+@{[ $self->increase_defence_power_ratio_when_advantageous * 100 ]}%";
      }
      $description .= '。';
    }
    $description;
  } 

  sub is_increase_power {
    my $self = shift;
    $self->is_increase_attack_power || $self->is_increase_defence_power;
  }

  sub is_increase_attack_power {
    my $self = shift;
    $self->increase_attack_power_ratio != 0 || $self->increase_attack_power_num != 0;
  }

  sub is_increase_defence_power {
    my $self = shift;
    $self->increase_defence_power_ratio != 0 || $self->increase_defence_power_num != 0;
  }

  sub is_increase_power_when_advantageous {
    my $self = shift;
    $self->increase_attack_power_ratio_when_advantageous != 0
      || $self->increase_defence_power_ratio_when_advantageous != 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

