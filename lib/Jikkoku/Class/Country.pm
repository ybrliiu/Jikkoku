package Jikkoku::Class::Country {

  use Jikkoku;
  use Mouse;

  use Carp qw( croak );
  use List::Util qw( first );
  use Jikkoku::Model::Chara;
  use Jikkoku::Model::Config;

  use constant PRIMARY_KEY => 'id';

  has 'id'       => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'name'     => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'color_id' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'months_after_establish'
    => ( metaclass => 'Column', is => 'rw', isa => 'Int', default => 0 );
  has 'king_id'  => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'command'  => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has 'position' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      strategist_id
      great_general_id cavalry_general_id guard_general_id archery_general_id infantry_general_id
      premier_id
    )],
    validator => sub {},
  );
  has 'not_use' => ( metaclass => 'Column', is => 'rw', isa => 'Str', default => '' );

  with 'Jikkoku::Class::Role::TextData';

  my @HEADQUARTERS   = qw( king strategist premier );
  my @POSITIONS_ID   = ('king_id', @{ __PACKAGE__->meta->get_attribute('position')->keys });
  my @POSITIONS      = map { $_ =~ s/_id//; $_; } @POSITIONS_ID;
  my @POSITIONS_NAME = qw(
    君主
    宰相
    軍師
    大将軍
    騎馬将軍
    護衛将軍
    弓将軍
    将軍
  );
  my %POSITIONS_NAME = map { $POSITIONS[$_] => $POSITIONS_NAME[$_] } 0 .. $#POSITIONS;

  __PACKAGE__->_generate_positions_method();

  sub _generate_positions_method {
    for my $position (@POSITIONS) {
      no strict 'refs';

      *{$position} = sub {
        use strict 'refs';
        my ($self) = @_;
        return $self->{$position} if exists $self->{$position};
        $self->{$position} = eval {
          my $position_id = $position eq 'king' ? $self->{king_id} : $self->{position}{"${position}_id"};
          Jikkoku::Model::Chara->get($position_id);
        };
      };

      for my $attribute (qw/id name icon/) {
        # redefine 回避
        next if $position eq 'king' && $attribute eq 'id';
        __PACKAGE__->_generate_position_chara_attribute_method( $position, $attribute );
      }
    }
  }

  sub _generate_position_chara_attribute_method {
    my ($class, $position, $attribute) = @_;
    my $method_name = "${position}_${attribute}";
    no strict 'refs';
    *{$method_name} = sub {
      use strict 'refs';
      my ($self) = @_;
      return $self->{$method_name} if exists $self->{$method_name};
      $self->{$method_name} = defined $self->$position ? $self->$position->$attribute : undef;
    };
  }

  sub is_headquarters_exist {
    my ($self) = @_;
    grep { defined $self->$_ } @HEADQUARTERS;
  }

  sub is_chara_headquarters {
    my ($self, $chara_id) = @_;
    grep {
      if (defined $self->$_) {
        $self->$_->id eq $chara_id;
      }
    } @HEADQUARTERS;
  }

  sub is_chara_has_position {
    my ($self, $chara_id) = @_;
    my $position_name = first {
      if (defined $self->$_) {
        $self->$_->id eq $chara_id;
      }
    } @POSITIONS;
    defined $position_name ? $POSITIONS_NAME{$position_name} : undef;
  }

  sub total_salary {
    my ($self, $towns) = @_;
    my ($money, $rice);
    for my $town (@$towns) {
      if ($self->id eq $town->country_id) {
        $money += $town->salary_money;
        $rice  += $town->salary_rice;
      }
    }
    ($money, $rice);
  }

  sub members {
    my ($self, $chara_model) = @_;
    croak "引数が足りません" if @_ < 2;
    $chara_model->get_same_country($self->id);
  }

  sub can_participate {
    my ($self, $chara_model, $country_model) = @_;
    croak "引数が足りません" if @_ < 3;
    $chara_model->get_same_country($self->id);
    my $members_num = @{ $self->members($chara_model) };
    $members_num < $self->number_of_chara_participate_available($chara_model, $country_model);
  }

  sub number_of_chara_participate_available {
    my ($class, $chara_model, $country_model) = @_;
    state $config   = Jikkoku::Model::Config->get;
    my $chara_sum   = @{ $chara_model->get_all };
    my $country_sum = @{ $country_model->get_all };
    # 0除算を考慮
    my $result = eval {
      if ($chara_sum <= $config->{game}{participation_restriction_num}) {
        my $available_num = int($chara_sum / $country_sum + 0.9);
        my $amplitude     = int($chara_sum / 10 + 0.5);
        $available_num + $amplitude;
      } else {
        $config->{game}{max_player};
      }
    };
    ($@ || $result < $config->{game}{participation_restriction_min})
      ? $config->{game}{participation_restriction_min}
      : $result;
  }

  {
    my $config = Jikkoku::Model::Config->get;

    for my $method_name (qw/color background_color background_color_rgba/) {
      no strict 'refs';
      *{$method_name} = sub {
        use strict 'refs';
        my $self = shift;
        $config->{"country_$method_name"}[ $self->{color_id} ];
      };
    }
  }

}

1;

