package Jikkoku::Model::ExtensiveStateRecord {

  use Mouse;
  use Jikkoku;

  use constant {
    FILE_PATH         => 'log_file/extensive_state_record.dat',
    INFLATE_TO        => 'Jikkoku::Class::ExtensiveStateRecord',
    PRIMARY_ATTRIBUTE => 'key',
  };

  with 'Jikkoku::Model::Role::Storable::Integration';

  sub get {
    my ($self, $giver_id, $state_id) = @_;
    Carp::croak 'few arguments($giver_id, $state_id)' if @_ < 3;
    $self->data->{"$giver_id.$state_id"} // Carp::croak "no such data($giver_id, $state_id)";
  }

  sub get_with_option {
    my ($self, $giver_id, $state_id) = @_;
    Carp::croak 'few arguments($giver_id, $state_id)' if @_ < 3;
    Option->new( $self->data->{"$giver_id.$state_id"} );
  }

  around write => sub {
    my ($orig, $self) = @_;
    $self->update;
    Storable::nstore_fd($self->data, $self->fh)
      or Jikkoku::Role::FileHandlerException->throw("nstore_fd error", $!);
  };

  sub update {
    my $self = shift;
    my $time = time;
    for my $state (values %{ $self->data }) {
      if ($state->available_time < $time) {
        $self->delete($state->key);
      }
    }
  }

  __PACKAGE__->meta->add_method(add => \&create);

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# 広範囲に効果を及ぼす症状
* 症状を掛けた人とその周り
  { giver_id, state_id, available_time }
* 指定地点の周り
  { giver_id, state_id, available_time, bm_id, x, y }
