package Jikkoku::Class::Role::TextData::Division {

  use Mouse::Role;
  use Jikkoku;
  use Carp;
  use Jikkoku::Util qw( is_test TEST_DIR _open_data );

  requires 'DIR_PATH';

  with qw(
    Jikkoku::Class::Role::TextData
    Jikkoku::Role::FileHandler
  );

  sub file_path {
    my ($self, $id) = @_;
    if (ref $self) {
      $self->DIR_PATH . $self->id . '.cgi';
    } else {
      my $class = $self;
      $class->DIR_PATH . "$id.cgi";
    }
  }

  # $textdata -> $id
  around _buildargs_textdata => sub {
    my ($orig, $class, $id) = @_;
    my $textdata = _open_data( $class->file_path($id) )->[0];
    $class->$orig($textdata);
  };

  sub read {
    my $self = shift;
    my $fh = $self->fh;
    my $textdata = <$fh>;
    my $hash = $self->textdata_to_hash($textdata);
    $self->set_hash_value($hash);
  }
  
  sub write {
    my $self = shift;
    $self->update_textdata;
    $self->fh->print( ${ $self->textdata } . "\n" );
  }

  sub save {
    my $self = shift;
    $self->textdata( $self->output );
    open(my $fh, '+<', $self->file_path);
    $self->update_textdata;
    $fh->print( $self->textdata . "\n" );
    $fh->close;
  }

  # 旧APIとの互換性を持つメソッドを作成
  # hash_field の先頭1文字を削除したメソッド名(ex: _buff -> buff)
  sub make_hash_fields {
    my $class = shift;
    my $meta = $class->meta;
    my @hash_field_attrs = grep {
      $_->isa('Jikkoku::Class::Role::TextData::Attribute::HashField')
    } $meta->get_all_attributes;
    for (@hash_field_attrs) {
      my $orig_name = $_->name;
      my $name = substr($orig_name, 1);
      $meta->add_method($name => sub {
        my ($self, $key, $value) = @_;
        if (@_ == 2) {
          $self->$orig_name->get($key);
        } else {
          $self->$orig_name->set($key => $value);
        }
      });
    }
  }

}

1;

