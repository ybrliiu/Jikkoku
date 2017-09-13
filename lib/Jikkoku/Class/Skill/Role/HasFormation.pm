package Jikkoku::Class::Skill::Role::HasFormation {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Service::Chara::Soldier::ChangeFormation;

  around is_acquired => sub {
    my ($orig, $self) = @_;
    $self->$orig()
      && Jikkoku::Service::Chara::Soldier::ChangeFormation->new( chara => $self->chara )
      ->is_arranging;
  };

}

1;

