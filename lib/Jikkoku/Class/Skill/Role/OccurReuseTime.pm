package Jikkoku::Class::Skill::Role::OccurReusetime {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires 'reuse_time';

  around description_of_status_about_reuse_time => sub {
    my ($orig, $self) = @_;
    "再使用時間 : @{[ $self->reuse_time ]}秒";
  };

}

1;

