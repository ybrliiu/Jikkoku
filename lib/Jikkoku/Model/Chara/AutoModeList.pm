package Jikkoku::Model::Chara::AutoModeList {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Integration';

  use constant {
    CLASS     => '',
    FILE_PATH => 'log_file/auto_list.cgi',
  };

  sub add {
    my ($self, $id) = @_;
    $self->{data}{$id} = $id;
  }

  # override
  sub _textdata_list_to_objects_data {
    my $self = shift;
    +{ map { $_ => $_ } @{ $self->{_textdata_list} } };
  }

  # override
  sub _objects_data_to_textdata_list {
    my $self = shift;
    [ values %{ $self->{data} } ];
  }

}

1;
