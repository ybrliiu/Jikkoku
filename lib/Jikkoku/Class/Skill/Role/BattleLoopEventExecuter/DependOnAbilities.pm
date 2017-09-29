package Jikkoku::Class::Skill::Role::BattleLoopEventExecuter::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use List::Util;

  # Role適用時にエラー出さないように
  use subs qw( occur_ratio event_execute_service_class_name range );

  # attributes
  requires qw( occur_ratio_coef max_occur_ratio );

  has 'occur_ratio'   => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_occur_ratio' );
  has 'abilities_sum' => ( is => 'ro', isa => 'Int', lazy => 1, builder => '_build_abilities_sum' );
  has 'event_execute_service_class_name' 
    => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_event_execute_service_class_name' );

  sub _build_abilities_sum {
    my $self = shift;
    List::Util::sum( map { $self->chara->$_ } @{ $self->depend_abilities } );
  }

  sub _build_occur_ratio {
    my $self = shift;
    my $ratio = $self->abilities_sum * $self->occur_ratio_coef;
    $ratio > $self->max_occur_ratio ? $self->max_occur_ratio : $ratio;
  }

  sub _build_event_execute_service_class_name {
    my $self = shift;
    my $pkg_name = ref $self;
    $pkg_name =~ s/Class/Service/gr;
  }

  with qw(
    Jikkoku::Class::Skill::Role::DependOnAbilities
    Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter
  );

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

