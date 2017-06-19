package Jikkoku::Service::Chara::Soldier::JudgeInvasionOrDefence {

  use Mouse;
  use Jikkoku;

  has 'chara'         => ( is => 'ro', isa => 'Jikkoku::Class::Chara',          required => 1 );
  has 'town_model'    => ( is => 'ro,' isa => 'Jikkoku::Model::Town',           required => 1 );
  has 'chara_soldier' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::Soldier', required => 1 );

  with qw( Jikkoku::Role::Loader );

  sub is_invasion {
    my $self = shift;
    my $bm_id = $self->chara_soldier->battle_map_id;
    my $country_id = $self->chara->country_id;
    if ( $bm_id =~ /-/ ) {
      my @town = map { $self->town_model->get($_) } ( split /-/, $bm_id );
      $town[0]->country_id != $country_id || $town[1]->country_id != $country_id;
    } else {
      my $town = $self->town_model->get($bm_id);
      $town->country_id != $country_id;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

