package Jikkoku::Role::FileHandler {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  sub throw { Jikkoku::Exception::FileHandler->throw(@_) }

  has 'fh' => ( is => 'rw', isa => 'FileHandle' );

  requires qw( file_path read write abort );

  around file_path => sub {
    my ($orig, $class) = (shift, shift);
    ( Jikkoku::Util::is_test() ? Jikkoku::Util::TEST_DIR() : '' ) . $class->$orig(@_);
  };

  # ファイルの中身を操作する前に、必ずlockをかけて、commit か abort を行うこと
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

    open(my $fh, '+<', $self->file_path) or throw("fileopen失敗", $!);
    $self->fh($fh);
    flock($fh, $mode->{$lock}) or throw("flock失敗", $!);
    $self->read;
    $self;
  }
  
  sub commit {
    my $self = shift;
    throw("file handle が存在していません。", $!) unless $self->fh;
    truncate($self->fh, 0) or throw("truncate error", $!);
    seek($self->fh, 0, 0) or throw("seek error", $!);
    $self->write or throw("write error", $!);
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

  # close をし忘れても、メモリ解放時にcloseするようにする
  sub DEMOLISH {
    my $self = shift;
    if ($self->fh) {
      warn 'unlock file when destory object.';
      $self->fh->close;
    }
  }

}

package Jikkoku::Exception::FileHandler {

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

