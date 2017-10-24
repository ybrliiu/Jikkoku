package Jikkoku::Class::Skill::Role::BattleLoopEventExecuter::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use List::Util;

  # attributes
  requires qw( occur_ratio_coef max_occur_ratio );

  # Role適用時にエラー出さないように
  sub occur_ratio;
  has 'occur_ratio'   => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_occur_ratio' );

  has 'abilities_sum' => ( is => 'ro', isa => 'Int', lazy => 1, builder => '_build_abilities_sum' );

  sub _build_abilities_sum {
    my $self = shift;
    List::Util::sum( map { $self->chara->$_ } @{ $self->depend_abilities } );
  }

  sub _build_occur_ratio {
    my $self = shift;
    my $ratio = $self->abilities_sum * $self->occur_ratio_coef;
    $ratio > $self->max_occur_ratio ? $self->max_occur_ratio : $ratio;
  }

  sub event_execute_service_class_name {
    my $self = shift;
    my $class = ref $self || $self;
    $class =~ s/Class/Service/gr;
  }

  with qw( Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter );

  around description_of_effect_before_body => sub { '戦闘中にイベント発生。' };

  around description_of_status_about_occur_ratio => sub {
    my ($orig, $self) = @_;
    '発動率 : ' . $self->occur_ratio;
  };

  around description_of_status_about_range => sub {
    my ($orig, $self) = @_;
    'リーチ : ' . $self->range;
  };

}

1;

