package Jikkoku::Class::Role::TextData::Division {

  use Mouse::Role;
  use Jikkoku;
  use Carp;
  use Jikkoku::Util qw( is_test TEST_DIR _open_data );

  requires 'DIR_PATH';

  around DIR_PATH => sub {
    my ($orig, $class) = @_;
    if ( is_test ) {
      TEST_DIR . $class->$orig();
    } else {
      $class->$orig();
    }
  };

  has 'fh' => ( is => 'rw', isa => 'FileHandle' );

  with 'Jikkoku::Class::Role::TextData';

  sub throw {
    Jikkoku::Class::Role::TextData::Division::Exception->throw(@_);
  }

  sub file_path {
    my ($class, $id) = @_;
    $class->DIR_PATH . "$id.cgi";
  }

  # $textdata -> $id
  around _buildargs_textdata => sub {
    my ($orig, $class, $id) = @_;
    my $textdata = _open_data( $class->file_path($id) )->[0];
    $class->$orig($textdata);
  };

  sub lock {
    my ($self, $lock) = @_;
    $lock //= 'LOCK_EX';

    # file lock モード
    state $mode = {
      LOCK_SH    => 1, # 共有ロック
      LOCK_EX    => 2, # 排他ロック
      NB_LOCK_SH => 5, # ノンブロックな共有ロック(ノンブロックの場合、ロックできなければdie）
      NB_LOCK_EX => 6, # ノンブロックな排他ロック
    };

    open(my $fh, '+<', $self->file_path($self->id)) or throw("fileopen失敗", $!);
    $self->fh($fh);
    flock($fh, $mode->{$lock}) or throw("flock失敗", $!);
    my $textdata = <$fh>;
    my $hash = $self->textdata_to_hash($textdata);
    $self->set_hash_value($hash);
    $self;
  }
  
  sub commit {
    my $self = shift;
    throw("file handle が存在していません。", $!) unless $self->fh;
    truncate($self->fh, 0) or throw("truncate error", $!);
    seek($self->fh, 0, 0) or throw("seek error", $!);
    $self->update_textdata;
    $self->fh->print( ${ $self->textdata } . "\n" ) or throw("nstore_fd失敗", $!);
    $self->fh->close or throw("close error", $!);
    $self->{fh} = undef;
    $self;
  }

  around abort => sub {
    my ($orig, $self) = @_;
    $self->fh->close;
    $self->{fh} = undef;
    $self->$orig();
    $self;
  };

  sub DEMOLISH {
    my $self = shift;
    if ($self->fh) {
      $self->fh->close;
    }
  }

}

package Jikkoku::Class::Role::TextData::Division::Exception {

  use Jikkoku;
  use parent 'Jikkoku::Exception';
  use Class::Accessor::Lite (
    new => 0,
    ro  => ['reason'],
  );

  # override
  sub throw {
    my ($class, $message, $reason) = @_;
    $class->SUPER::throw(
      message => $message,
      reason  => $reason,
    );
  }

  # override
  sub as_string {
    my $self = shift;
<< "EOS";
[reason]
  $self->{reason}

[stack_trace]
  @{[ $self->SUPER::as_string ]}
EOS
  }

}

1;

