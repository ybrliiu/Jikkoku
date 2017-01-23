package Jikkoku::Model::Unit {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Integration';

  use Jikkoku::Class::Unit;

  use constant {
    CLASS     => 'Jikkoku::Class::Unit',
    FILE_PATH => 'log_file/unit_list.cgi',
  };

  # 無所属
  our $NEUTRAL = CLASS->new("<>無所属");

  sub create {
    my ($self, $args) = @_;
  }

  # override
  sub get {
    my ($self, $id) = @_;
    my $unit = eval {
      $self->SUPER::get($id);
    };
    if (my $e = $@) {
      $unit = $NEUTRAL;
    }
    $unit;
  }

}

1;

