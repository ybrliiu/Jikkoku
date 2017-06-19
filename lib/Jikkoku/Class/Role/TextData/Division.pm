package Jikkoku::Class::Role::TextData::Division {

  use Mouse::Role;
  use Jikkoku;
  use Carp;

  with (
    'Jikkoku::Class::Role::TextData' => {-excludes => 'commit'},
    'Jikkoku::Class::Role::Division' => {},
    'Jikkoku::Role::FileHandler'     => {},
  );

  # $textdata -> $id
  around _buildargs_textdata => sub {
    my ($orig, $class, $id) = @_;
    open(my $fh, '<', $class->file_path($id)) or throw("file open error" . $class->file_path($id), $!);
    my @textdata = <$fh>;
    $fh->close;
    $class->$orig( $textdata[0] );
  };

  sub read {
    my $self = shift;
    my $fh = $self->fh;
    my @textdata = <$fh>;
    my $hash = $self->textdata_to_hash( $textdata[0] );
    $self->set_hash_value($hash);
  }
  
  sub write {
    my $self = shift;
    $self->update_textdata;
    $self->fh->print( ${ $self->textdata } );
  }

  sub save {
    my $self = shift;
    $self->textdata( $self->output );
    open(my $fh, '+<', $self->file_path);
    $self->update_textdata;
    $fh->print( ${ $self->textdata } );
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

