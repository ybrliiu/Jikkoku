package Jikkoku::Class::Skill::Role::Practice {

  use Mouse::Role;
  use Jikkoku;

  requires qw( acquire_conditions_of_practice_skill );

  around acquire => sub {
    my ($orig, $self) = @_;
    if ( $self->acquire_conditions_of_practice_skill ) {
      $self->$orig();
      $self->chara->save_command_log(qq{【<span class="red">修得</span>】スキル : @{[ $self->name ]}を修得しました。});
    }
  };

}

1;

__END__

コマンド実行後に修得するスキル

