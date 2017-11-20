package Jikkoku::Class::Country::ExtCountry {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Class::Country;

  {
    my @delegations = (
      ( map { $_->name } Jikkoku::Class::Country->get_column_attributes ),
      qw/ is_neutral color background_color background_color_rgba /,
      qw/ position_name_of_chara position_of_chara_with_option /,
      qw/ is_chara_has_position /,
      qw/ remaining_month_until_can_invasion can_invasion /,
      qw/ commit abort /,
    );

    has 'country' => (
      is       => 'ro',
      isa      => 'Jikkoku::Class::Country',
      handles  => \@delegations,
      required => 1,
    );
  }

  has 'charactors' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Result',
    lazy    => 1,
    default => sub { $_[0]->chara_model->get_all_with_result },
  );

  for my $name (qw/ chara town country /) {
    has "${name}_model" => (
      is      => 'ro',
      isa     => 'Jikkoku::Model::' . ucfirst $name,
      lazy    => 1,
      default => sub { $_[0]->model(ucfirst $name)->new },
    );
  }

  with 'Jikkoku::Role::Loader';

  my $POSITION_MODEL = Jikkoku::Model::Country::Position->instance;

  sub is_headquarters_exist {
    my $self = shift;
    grep { !$self->$_->is_dummy } map { $_->id } @{ $POSITION_MODEL->get_headquarters };
  }

  sub is_chara_headquarters {
    my ($self, $chara) = @_;
    Carp::croak 'Too few arguments (required: $chara)' if @_ < 2;
    grep { $self->$_ eq $chara->id } map { $_->id . '_id' } @{ $POSITION_MODEL->get_headquarters };
  }

  sub total_salary {
    my $self = shift;
    my ($money, $rice) = (0, 0);
    for my $town (@{ $self->town_model->get_all }) {
      if ($self->id eq $town->country_id) {
        $money += $town->salary_money;
        $rice  += $town->salary_rice;
      }
    }
    ($money, $rice);
  }

  sub members {
    my $self = shift;
    $self->charactors->get_charactors_by_country_id_with_result( $self->id )->get_all;
  }

  sub dominating_towns {
    my $self = shift;
    $self->town_model->get_towns_by_country_id($self->id);
  }

  sub can_participate {
    my $self = shift;
    my $members_num = @{ $self->members };
    $members_num < $self->number_of_chara_participate_available;
  }

  {
    my $config = Jikkoku::Model::Config->get;

    # 別クラスに持って行くべき
    sub number_of_chara_participate_available {
      my $self = shift;
      my $chara_sum   = @{ $self->charactors->get_all };
      my $country_sum = @{ $self->country_model->get_all };
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
  }

  {
    my $meta = __PACKAGE__->meta;

    {
      my @method_names = map { $_->id . '_id' } grep { $_->id ne 'king' } @{ $POSITION_MODEL->get_all };
      for my $method_name (@method_names) {
        $meta->add_method($method_name => sub {
          my $self = shift;
          @_ ? $self->position->set( $method_name => shift ) : $self->position->get($method_name);
        });
      }
    }

    {
      my @method_names = map { $_->id } @{ $POSITION_MODEL->get_all };
      for my $method_name (@method_names) {
        my $attr_name = "${method_name}_id";
        has $method_name => (
          is      => 'ro',
          isa     => 'Jikkoku::Class::Chara',
          lazy    => 1,
          default => sub {
            my $self = shift;
            $self->chara_model
              ->get_with_option( $self->$attr_name )
              ->get_or_else( $self->chara_model->dummy );
          },
        );
      }
    }

    $meta->make_immutable;
  }

}

1;

