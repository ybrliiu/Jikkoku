package Jikkoku::Class::BattleCommand::Retreat {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '退却' );

  with 'Jikkoku::Class::BattleCommand::BattleCommand';

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Jikkoku::Class::BattleCommand::Retreat - 退却

=cut

