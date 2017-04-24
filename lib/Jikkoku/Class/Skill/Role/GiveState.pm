package Jikkoku::Class::Skill::Role::GiveState {

  use Mouse::Role;
  use Jikkoku;

  around explain_effect_about_state => sub {
    my ($orig, $self) = @_;
    my $state = $self->state;
    $self->TARGET_TYPE . $self->TARGET_NUM . "に@{[ $state->name ]}を付与する。(効果 : @{[ $state->description ]})";
  };

  sub state {
    my $self = shift;
    $self->chara->states->get_state($self->id);
  }

}

1;

__END__

ToAlly 味方
ToEnemy 敵
ToOneChara 1人に
ToMultipleChara 複数人に
GiveState $state->nameを付与する。(効果 : $state->description)

ToAlly.pm

sub target_type {
  "味方";
}

ToOneChara.pm

sub target_num {
  "1人";
}

GiveState.pm

sub explain_effect {
  my $self = shift;
  my $state = $self->state;
  $self->target_type . $self->target_num . "に" . $state->name . "を付与する。(効果 : " . $state->description . ")";
}

