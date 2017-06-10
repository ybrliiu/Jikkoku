package Jikkoku::Model::State {
  
  use Mouse;
  use Jikkoku;

  use Jikkoku::Util 'validate_values';
  use List::Util 'sum';
  use Module::Load 'load';
  use Carp;
  use Jikkoku::Model::Chara;

  our @STATE_MODULES = _get_state_module_list();

  sub _get_state_module_list {
    my $dir = './lib/Jikkoku/Class/State';
    opendir(my $dh, $dir);
    my @state_list = grep { $_ ne 'State' } map { $_ =~ /(\.pm$)/p ? ${^PREMATCH} : () } readdir $dh;
    close $dh;
    @state_list;
  }

  has 'chara'  => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1, required => 1 );
  has '_cache' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  with 'Jikkoku::Role::Loader';

  sub get_state_with_option {
    my ($self, $args) = @_;
    validate_values $args => [qw/ id /];

    my $key = $args->{id};
    my $load_class = "Jikkoku::Class::State::${key}";
    state $loaded_class = {};
    unless (exists $loaded_class->{$key}) {
      eval {
        load $load_class;
        $loaded_class->{$key} = 1;
      };
      if (my $e = $@) {
        return Option::None->new;
      }
    }

    my $state = eval {
      $load_class->new(chara => $self->chara);
    };
    if (my $e = $@) {
      return Option::None->new;
    }

    Option->new($state);
  }

  sub get {
    my ($self, $id) = @_;
    my $load_class = "Jikkoku::Class::State::${id}";
    load $load_class;
    $load_class->new(chara => $self->chara);
  }

  __PACKAGE__->meta->add_method(get_state => \&get);

  sub get_all_states {
    my $self = shift;
    [ map { $self->get_state($_) } @STATE_MODULES ];
  }

  sub get_available_states {
    my ($self, $time) = @_;
    $time //= time;
    [
      grep { $_->is_available($time) }
      grep { $_->DOES('Jikkoku::Class::State::Role::Expires') } @{ $self->get_all_states }
    ];
  }

  my $adjust_move_cost = sub {
    my ($self, $origin_cost, $code, $time) = @_;
    Carp::croak 'few argments' if @_ < 3;
    $time //= time;
    my @states = grep {
      $_->DOES('Jikkoku::Class::State::Role::MoveCostAdjuster');
    } @{ $self->get_available_states($time) };
    $self->$code(\@states);
    sum map { $_->adjust_move_cost($origin_cost) } @states;
  };

  __PACKAGE__->meta->add_method(adjust_move_cost => sub {
    my ($self, $origin_cost, $time) = @_;
    $self->$adjust_move_cost($origin_cost, sub {}, $time);
  });

  __PACKAGE__->meta->add_method(adjust_move_cost_and_take_bonus_for_giver => sub {
    my ($self, $origin_cost, $time) = @_;
    $self->$adjust_move_cost($origin_cost, sub {
      my ($self, $states) = @_;
      my $chara_model = Jikkoku::Model::Chara->new;
      for my $state (@$states) {
        $state->take_bonus_for_giver($chara_model);
      }
    }, $time);
  });

  sub adjust_battle_action_success_ratio {
    my ($self, $origin_success_ratio, $time) = @_;
    Carp::croak 'few arguments' if @_ < 2;
    $time //= time;
    my @states = grep {
      $_->DOES('Jikkoku::Class::State::Role::BattleActionSuccessRatioAdjuster');
    } @{ $self->get_available_states($time) };
    my $chara_model = Jikkoku::Model::Chara->new;
    sum map {
      $_->take_bonus_for_giver($chara_model);
      $_->adjust_battle_action_success_ratio($origin_success_ratio);
    } @states;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

