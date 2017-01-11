package BattleMap::Middle {

  use v5.24;
  use Mouse;
  use feature qw/signatures/;
  no warnings 'experimental::signatures';

  use Carp qw/croak/;

  with 'BattleMap';

  sub start_map_id($self) {
    my @tmp = split /-/, $self->id;
    croak " start_map_id を求められませんでした" if @tmp < 2;
    $tmp[0];
  }

  sub end_map_id($self) {
    my @tmp = split /-/, $self->id;
    croak " start_map_id を求められませんでした" if @tmp < 2;
    $tmp[1];
  }

  sub get_entry_node($self, $map_id) {
    my ($entry) = grep { $map_id eq $_->{target_bm_id} } values $self->check_points->%*;
    die " 関所が見つかりませんでした。" unless defined $entry;
    my $node = $self->get_node(sub ($node) {
      $node->terrain eq Node->ENTRY &&
      $node->x       eq $entry->{x} &&
      $node->y       eq $entry->{y};
    });
  }

  sub get_start_node($self, @) {
    my $start_map_id = $self->start_map_id;
    my $node = $self->get_entry_node($start_map_id);
  }

  sub get_end_node($self, @) {
    my $end_map_id = $self->end_map_id;
    my $node = $self->get_entry_node($end_map_id);
  }

  __PACKAGE__->meta->make_immutable;
}

1;

