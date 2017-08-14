package Jikkoku::Model::ExtensiveStateRecord {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  use constant {
    FILE_PATH         => 'log_file/extensive_state_record.dat',
    INFLATE_TO        => 'Jikkoku::Class::ExtensiveStateRecord',
    PRIMARY_ATTRIBUTE => 'key',
  };

  with 'Jikkoku::Model::Role::Storable::Integration';

  sub add {
    my $self = shift;
    if (ref $_[0] eq 'HASH') {
      my $args = shift;
      validate_values $args => [qw/ giver_id state_id available_time /];
      $self->data->{"$args->{giver_id}.$args->{state_id}"} = $self->INFLATE_TO->new($args);
    }
    else {
      my $primary_attribute_value = shift;
      $self->create($primary_attribute_value);
    }
  }

  around delete => sub {
    my ($orig, $self) = (shift, shift);
    if (@_ == 1) {
      my $primary_attribute_value = shift;
      $self->$orig($primary_attribute_value);
    }
    elsif (@_ == 2) {
      my ($giver_id, $state_id) = @_;
      delete $self->data->{"$giver_id.$state_id"};
    }
    else {
      Carp::croak "invalid arguments (" . (join ', ', @_) .")";
    }
  };

  around get => sub {
    my ($orig, $self) = (shift, shift);
    if (@_ == 1) {
      my $primary_attribute_value = shift;
      $self->$orig($primary_attribute_value);
    }
    elsif (@_ == 2) {
      my ($giver_id, $state_id) = @_;
      $self->data->{"$giver_id.$state_id"} // Carp::croak "no such data($giver_id, $state_id)";
    }
    else {
      Carp::croak "invalid arguments (" . (join ', ', @_) .")";
    }
  };

  sub get_extensive_state_records_by_extensive_state_id {
    my ($self, $state_id) = @_;
    Carp::croak 'few arguments($state_id)' if @_ < 2;
    [ grep { $_->state_id eq $state_id } values %{ $self->data } ];
  }
  
  around get_with_option => sub {
    my ($orig, $self) = (shift, shift);
    if (@_ == 1) {
      my $primary_attribute_value = shift;
      $self->$orig($primary_attribute_value);
    }
    elsif (@_ == 2) {
      my ($giver_id, $state_id) = @_;
      Option->new( $self->data->{"$giver_id.$state_id"} );
    }
    else {
      Carp::croak "invalid arguments (" . (join ', ', @_) .")";
    }
  };

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

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# 広範囲に効果を及ぼす症状
* 症状を掛けた人とその周り
  { giver_id, state_id, available_time }
* 指定地点の周り
  { giver_id, state_id, available_time, bm_id, x, y }
