package Jikkoku::Role::FileHandler {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  sub throw { Jikkoku::Role::FileHandlerException->throw(@_) }

  # inside-out
  # シリアライズ化の時にファイルハンドルが混じっているとややこしいため
  my $fh = {};

  sub fh {
    my $self = shift;
    if (@_) {
      $fh->{$self + 0} = shift;
    } else {
      $fh->{$self + 0};
    }
  }

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

    open(my $fh, '+<', $self->file_path) or throw("fileopen failed", $!);
    $self->fh($fh);
    flock($fh, $mode->{$lock}) or throw("flock failed", $!);
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
    $self->fh(undef);
    $self;
  }

  around abort => sub {
    my ($orig, $self) = @_;
    $self->fh->close;
    $self->$orig();
    $self->fh(undef);
    $self;
  };

  # close をし忘れても、メモリ解放時にcloseするようにする
  sub DEMOLISH {
    my $self = shift;
    if ($self->fh) {
      warn 'unlock file when destory object.';
      $self->fh->close;
    }

    # destroy inside-out object
    delete $fh->{$self + 0};
  }

}

package Jikkoku::Role::FileHandlerException {

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

