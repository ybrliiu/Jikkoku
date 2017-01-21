package BattleMap::Middle {

  use v5.24;
  use Mouse;
  use feature qw/signatures/;
  no warnings 'experimental::signatures';

  use Carp qw/croak confess/;

  with 'BattleMap';

  sub get_entry_node($self, $map_id) {
    my ($entry) = grep { $map_id eq $_->{target_bm_id} } values $self->check_points->%*;
    confess " 関所が見つかりませんでした。 : $map_id" unless defined $entry;
    my $node = $self->get_node(sub ($node) {
      $node->terrain eq Node->ENTRY &&
      $node->x       eq $entry->{x} &&
      $node->y       eq $entry->{y};
    });
  }

  sub get_start_node($self, $start_map_id) {
    my $node = $self->get_entry_node($start_map_id);
  }

  sub get_end_node($self, $end_map_id) {
    my $node = $self->get_entry_node($end_map_id);
  }

  __PACKAGE__->meta->make_immutable;
}

1;

