package Jikkoku::Model::Country {

  use Jikkoku;
  use Mouse;

  use List::Util qw( max );

  use constant {
    FILE_PATH         => 'log_file/country.cgi',
    INFLATE_TO        => 'Jikkoku::Class::Country',
    PRIMARY_ATTRIBUTE => 'id',
  };

  with 'Jikkoku::Model::Role::TextData::Integration';

  # 無所属国のデータ
  sub neutral {
    my $class = shift;
    state $neutral = $class->INFLATE_TO->new({
      id      => 0,
      name    => '無所属',
      king_id => '',
      command => '無所属です',
    });
  }

  sub create {
    my ($self, $args) = @_;
    my $max_id = max map { $_->id } values %{ $self->data };
    my $country = $self->INFLATE_TO->new($args);
    $self->data->{$max_id + 1} = $country->output;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

