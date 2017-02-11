use Jikkoku;
use Test::More;
use Test::Exception;
use Test2::IPC;
use Time::HiRes qw( usleep );

use_ok 'Jikkoku::Role::FileHandler';

package Log {

  use Mouse;
  use Jikkoku;

  has 'data'          => ( is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] } );
  has 'textdata_list' => ( is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] } );

  with 'Jikkoku::Role::FileHandler';
  
  sub BUILD {
    my $self = shift;
    open(my $fh, '<', $self->file_path) or throw("file open error", $!);
    $self->fh($fh);
    $self->read;
    $fh->close;
    $self->{fh} = undef;
  }

  sub file_path { 'somethig.txt' }

  sub abort {
    my $self = shift;
    my @textdata_list = @{ $self->textdata_list };
    $self->data([@textdata_list]);
  }

  sub read {
    my $self = shift;
    my $fh = $self->fh;
    my @textdata_list = map { chomp $_; $_; } <$fh>;
    $self->textdata_list( \@textdata_list );
    $self->data([@textdata_list]);
  }

  sub write {
    my $self = shift;
    $self->fh->print( map { "$_\n" } @{ $self->data } );
    my @data = @{ $self->data };
    $self->textdata_list([@data]);
  }

  sub pop {
    my $self = shift;
    pop @{ $self->data };
  }

  sub push {
    my ($self, @args) = @_;
    push @{ $self->data }, @args;
  }

  sub get_all {
    my $self = shift;
    $self->data;
  }

  sub size {
    my $self = shift;
    scalar @{ $self->data };
  }

}

subtest 'lock other object' => sub {
  my $file = Log->new;
  lives_ok { $file->lock };
  my $other = Log->new;
  dies_ok { $other->lock('NB_LOCK_EX') };
};

subtest 'lock other process' => sub {
  my $file = Log->new;
  ok $file->lock;

  my $pid = fork();
  if ($pid == 0) {
    dies_ok { $file->lock('NB_LOCK_EX') };
    exit;
  }
  waitpid($pid, 0);

  ok $file->abort;
  my $pid2 = fork();
  if ($pid2 == 0) {
    lives_ok { $file->lock('NB_LOCK_EX') };
    exit;
  }
  waitpid($pid2, 0);
};

subtest 'commit' => sub {
  my $file = Log->new;
  $file->lock;
  my $before_size = $file->size;
  ok $file->push('message');
  ok $file->commit;
  is $file->size, $before_size + 1;
  my $same_file = Log->new;
  is $same_file->size, $before_size + 1;
};

subtest 'abort' => sub {
  my $file = Log->new;
  $file->lock;
  my $size = $file->size;
  ok $file->push('#####');
  ok $file->abort;
  is $file->size, $size;
  my $same_file = Log->new;
  is $same_file->size, $size;
};

# 他プロセスでlockしているファイルを読み込もうとした時, undefしか読み込まないことがあったので
# そのような事が起きていないか確認
# ぶっちゃけしなくてもいいかも知れない(FileHandle を fork することで生じたバグっぽいし
subtest 'can read from other process when locking' => sub {
  my $pid = fork();
  if ($pid == 0) {
    my $file = Log->new;
    $file->lock;
    usleep(2000);
    $file->push(99);
    ok $file->commit;
    exit;
  } else {
    usleep(1000);
    lives_ok { my $file = Log->new };
    waitpid($pid, 0);
  }
};

# 他プロセスのlockにより最初lockをとれていなかったプロセスが、
# データを読み込み始めた時, 変更されたデータも読み込めるか確認
subtest 'check commit integrity' => sub {
  my $pid = fork();
  if ($pid == 0) {
    {
      my $file = Log->new;
      ok $file->lock;
      usleep(2000);
      $file->push('COMMIT');
      ok $file->commit;
    }
    exit;
  } else {
    {
      my $file = Log->new;
      usleep(1000);
      ok $file->lock;
      is $file->pop, 'COMMIT';
    }
    waitpid($pid, 0);
  }
};

# abort が他プロセスにも反映されているか
subtest 'check abort integrity' => sub {
  my $pid = fork();
  if ($pid == 0) {
    {
      my $file = Log->new;
      ok $file->lock;
      usleep(2000);
      $file->push('ABORT');
      ok $file->abort;
    }
    exit;
  } else {
    {
      my $file = Log->new;
      usleep(1000);
      ok $file->lock;
      isnt $file->pop, 'ABORT';
    }
    waitpid($pid, 0);
  }
};

done_testing;
