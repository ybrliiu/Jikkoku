package CalcAroundCastleNode {

  use v5.24;
  use Mouse;
  extends 'Node';
  use feature qw/signatures/;
  no warnings 'experimental::signatures';

  override cost => sub ($self) {
    ($self->is_terrain_castle || $self->NOTHING) ? $self->TEMP_INF : 1;
  };

  sub init_calc($self) {
    $self->is_calced(0);
    $self->distance( $self->TEMP_INF );
  }

}

1;

=encoding utf8

=head1 NAME
  
  CalcAroundCastleNode - 城周囲のルート作成時に使用するNodeオブジェクト

=cut
