package Jikkoku::Class::Chara::Formation {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Class::Formation';

  has 'chara'  => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );
  has 'skills' => ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_skills' );

  sub _build_skills {
    my $self = shift;
    [
      map {
        my $id = $_;
        $self->chara->skills->get({
          category => 'HasFormation',
          id       => $id
        })
      } @{ $self->skill_id_list }
    ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

