package Jikkoku::Class::BattleMap {

  use v5.14;
  use warnings;
  use Class::Accessor::Lite new => 0;

  use Carp qw/croak/;

  use Jikkoku::Class::BattleMap::Node;
  use Jikkoku::Class::BattleMap::CheckPoint;

  {
    my %attributes = (
      id           => undef,
      name         => undef,
      width        => undef,
      height       => undef,
      map_data     => [],
      check_points => {},
    );

    Class::Accessor::Lite->mk_accessors( keys %attributes );

    sub new {
      my ($class, $args) = @_;
      my $self = bless {%attributes, %$args}, $class;
      $self->set_nodes;
      # $self->set_edges_node;
      $self->set_check_points;
      $self;
    }
  }

  sub set_nodes {
    my ($self) = @_;
    $self->loop(sub {
      my ($terrain, $y, $x) = @_;
      # 第1引数 は まだNode Obj でない( terrain )
      my $new_node = Jikkoku::Class::BattleMap::Node->new({
        x       => $x,
        y       => $y,
        terrain => $terrain,
      });
      $self->{map_data}[$y][$x] = $new_node;
    });
  }

  sub set_edges_node {
    my ($self) = @_;
    $self->loop(sub {
      my ($node) = @_;
      my %around_nodes = (
        up    => $self->get_up_node( $node ),
        down  => $self->get_down_node( $node ),
        right => $self->get_right_node( $node ),
        left  => $self->get_left_node( $node ),
      );
      $node->edges_node( [ map { $_ // () } values %around_nodes ] );
    });
  }

  sub set_check_points {
    my ($self) = @_;
    for my $point (keys %{ $self->{check_points} }) {
      $self->{check_points}{$point} = Jikkoku::Class::BattleMap::CheckPoint->new( $self->{check_points}{$point} );
    }
  }

  sub loop {
    my ($self, $code) = @_;
    for my $i (0 .. $self->{height} - 1) {
      for my $j (0 .. $self->{width} - 1) {
        my $node = $self->{map_data}[$i][$j];
        $code->($node, $i, $j) unless $node eq '';
      }
    }
  }

  sub get_node_by_point {
    my ($self, $x, $y) = @_;
    $self->{map_data}[$y][$x];
  }

  sub get_node {
    my ($self, $code) = @_;
    for my $i (0 .. $self->{height} - 1) {
      for my $j (0 .. $self->{width} - 1) {
        my $node = $self->{map_data}[$i][$j];
        unless ($node eq '') {
          my $ret = $code->($node);
          return $node if $ret;
        }
      }
    }
  }

  sub get_up_node {
    my ($self, $node) = @_;
    return undef if $node->y - 1 < 0;
    my $result_node = $self->{map_data}[ $node->y - 1 ][ $node->x ];
    return $result_node eq '' ? undef : $result_node;
  }
  
  sub get_down_node {
    my ($self, $node) = @_;
    return undef if $node->y + 1 >= $self->{height};
    my $result_node = $self->{map_data}[ $node->y + 1 ][ $node->x ];
    return $result_node eq '' ? undef : $result_node;
  }
  
  sub get_right_node {
    my ($self, $node) = @_;
    return undef if $node->x + 1 >= $self->{width};
    my $result_node = $self->{map_data}[ $node->y ][ $node->x + 1 ];
    return $result_node eq '' ? undef : $result_node;
  }
  
  sub get_left_node {
    my ($self, $node) = @_;
    return undef if $node->x - 1 < 0;
    my $result_node = $self->{map_data}[ $node->y ][ $node->x - 1 ];
    return $result_node eq '' ? undef : $result_node;
  }

  sub get_check_point {
    my ($self, $node) = @_;
    my $point = $node->y . ',' . $node->x;
    $self->check_points->{$point} // croak "関所が見つかりませんでした (y,x) = ($point)";
  }

}

1;
