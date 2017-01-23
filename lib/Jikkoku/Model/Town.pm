package Jikkoku::Model::Town {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Integration';

  use Jikkoku::Util qw/open_data save_data/;
  use Jikkoku::Class::Town;

  use constant {
    CLASS          => 'Jikkoku::Class::Town',
    FILE_PATH      => 'log_file/town_data.cgi',
    INIT_FILE_PATH => 'log_file/f_town_data.cgi',
  };

  sub get_by_name {
    my ($self, $name) = @_;
    my ($town) = grep { $_->name eq $name } values %{ $self->{data} };
    $town;
  }
  
  # override
  sub init {
    my ($class) = @_;
    my $init_data = open_data(INIT_FILE_PATH);
    save_data( FILE_PATH, $init_data );
  }

  # override
  sub _objects_data_to_textdata_list {
    my ($self) = @_;
    [ map { ${ $_->output } } sort { $a->id <=> $b->id } values %{ $self->{data} } ];
  }

  # override
  sub _textdata_list_to_objects_data {
    my ($self) = @_;
    my $index = 0;
    my $objects = [ map { $self->CLASS->new($_, $index++) } @{ $self->{_textdata_list} } ];
    $self->to_hash( $objects );
  }

  sub set_all_stay_charactors {
    my ($self, $charactors, $country_id) = @_;
    for my $chara (@$charactors) {
      if ($chara->country_id eq $country_id) {
        my $town = $self->get( $chara->town_id );
        $town->{stay_charactors} .= $chara->name . ' ';
        $town->{stay_charactors_num}++;
      }
    }
  }

}

1;

