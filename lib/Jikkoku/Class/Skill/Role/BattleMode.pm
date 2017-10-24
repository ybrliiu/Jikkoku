package Jikkoku::Class::Skill::Role::BattleMode {

  use Mouse::Role;
  use Jikkoku;

  has 'battle_mode' => (
    is      => 'ro',
    does    => 'Jikkoku::Class::BattleMode::BattleMode',
    lazy    => 1,
    builder => '_build_battle_mode',
  );

  sub _build_battle_mode {
    my $self = shift;
    $self->chara->battle_modes->get($self->id);
  }

  around description_of_effect_about_battle_mode => sub {
    my ($orig, $self) = @_;
    "<strong>@{[ $self->battle_mode->name ]}モード</strong> : @{[ $self->battle_mode->description ]}";
  };

  around description_of_status_about_consume_morale => sub {
    my ($orig, $self) = @_;
    '消費士気 : ' . $self->battle_mode->consume_morale;
  };

}

1;

