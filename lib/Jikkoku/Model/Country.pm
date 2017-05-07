package Jikkoku::Model::Country {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Integration';

  use List::Util qw/max/;
  use Jikkoku::Class::Country;

  use constant {
    CLASS     => 'Jikkoku::Class::Country',
    FILE_PATH => 'log_file/country.cgi',
  };

  # 無所属
  our $NEUTRAL = CLASS->new({
    id      => 0,
    name    => '無所属',
    king_id => '',
    command => '無所属へようこそー！',
  });

  sub neutral { $NEUTRAL; }

  # override
  sub get {
    my ($self, $id) = @_;
    my $country = eval {
      $self->SUPER::get($id);
    };
    if (my $e = $@) {
      $country = $NEUTRAL;
    }
    $country;
  }

  sub create {
    my ($self, $args) = @_;

    my $max_id = max map { $_->{id} } values %{ $self->{data} };
    my $country = CLASS->new;
    $self->{data}{$max_id + 1} = $country->output;
  }

  # 新しい CLASS の output method は改行付きのため、取り除く
  sub _objects_data_to_textdata_list {
    my ($self) = @_;
    [
      map {
        my $output = ${ $_->output };
        chomp $output;
        $output;
      } values %{ $self->{data} }
    ];
  }

}

1;

