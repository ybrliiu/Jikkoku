package Jikkoku::Model::Chara::Protector {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Model::Base::TextData::Integration::Expires';

  use Jikkoku::Model::Chara;
  use Jikkoku::Class::Chara::Protector;

  use constant {
    CLASS        => 'Jikkoku::Class::Chara::Protector',
    FILE_PATH    => 'log_file/engolist.cgi',
    SURVIVE_TIME => 250,
  };

  sub add {
    my ($self, $id) = @_;
    my $protector = CLASS->new( "$id<>" . (time + SURVIVE_TIME) );
    $self->{data}{$id} = $protector;
  }

  sub is_protect {
    my ($self, $id) = @_;
    $self->update;
    exists $self->{data}{$id} ? 1 : undef;
  }

  sub get_id_list_same_bm {
    my ($self, $bm_id) = @_;
    $self->update;
    [ map {
      my $protector = Jikkoku::Model::Chara->get( $_->id );
      $protector->soldier_battle_map('battle_map_id') eq $bm_id ? $protector->id : ();
    } @{ $self->get_all } ];
  }

  sub is_chara_protected {
    my ($self, $chara) = @_;
    $self->update;
    my $time = time;
    my $decided_protector;
    for my $protector (@{ $self->get_all }) {
      if ($protector->time >= $time) {
        my $protector_chara = Jikkoku::Model::Chara->get( $protector->id );
        $decided_protector = $protector_chara if $protector_chara->can_protect( $chara );
        last;
      }
    }
    $decided_protector;
  }

}

1;
