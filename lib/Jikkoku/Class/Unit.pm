package Jikkoku::Class::Unit {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;
  use parent 'Jikkoku::Class::Base::TextData';

  use constant {
    PRIMARY_KEY => 'member_id',
    COLUMNS     => [qw/
      id name country_id
      member_is_leader member_id member_name member_icon
      message join_permit base_town auto_gather
    /],
  };

  sub is_leader {
    my ($self) = @_;
    $self->{member_is_leader};
  }

  Class::Accessor::Lite->mk_accessors(@{ COLUMNS() });

}

1;
