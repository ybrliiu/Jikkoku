package Jikkoku::Class::Base::TextData::Division {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Class::Base::TextData';

  use Carp qw/croak/;
  use Jikkoku::Util qw/save_data/;

  sub FILE_DIR_PATH() { croak "You must be specify constant value FILE_DIR_PATH. " }

  sub file_path {
    my ($class, $id) = @_;
    return $class->FILE_DIR_PATH . "$id.cgi";
  }

  sub save {
    my ($self) = @_;
    $self->{_textdata} = $self->output;
    save_data( $self->file_path( $self->{id}), [ ${ $self->{_textdata} } ] );
    $self->set_data;
  }

}

1;

=head1 使い方メモ

  # 例外が発生しそうな処理を行う前に
  $chara->cimmit

  eval {
    ...
  };

  if (my $e = $@) {
    # 例外があった時
    $chara = $chara->abort;
  }

  ...

  $chara->save;

=cut

