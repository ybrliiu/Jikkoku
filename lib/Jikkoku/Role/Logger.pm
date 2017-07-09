package Jikkoku::Role::Logger {

  use Mouse::Role;
  use Jikkoku;

  use Carp;
  use Jikkoku::Util;

  has 'data' => ( is => 'rw', isa => 'ArrayRef', required => 1 );

  with qw( Jikkoku::Role::FileHandler );

  requires qw( MAX );

  sub init {
    my $class = shift;
    open my $fh, '>', $class->file_path;
    $fh->print('');
    $fh->close;
  }

  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    if (ref $_[0] eq 'HASH' || @_ >= 2) {
      $class->$orig(@_);
    }
    else {
      open(my $fh, '<', $class->file_path(@_)) or throw("file open failed", $!);
      my @log = <$fh>;
      $fh->close or throw("file close failed", $!);
      $class->$orig( data => \@log, $class->hook_logger_build_args(@_) );
    }
  };

  sub hook_logger_build_args {
    my $class = shift;
    ();
  }

  sub abort {
    my $self = shift;
    open(my $fh, '<', $self->file_path) or throw("file open failed", $!);
    $self->fh( $fh );
    $self->read;
    $fh->close or throw("file close failed", $!);
  }

  sub add {
    my ($self, $str) = @_;
    Carp::croak 'few arguments($str)' if @_ < 2;
    unshift @{ $self->data }, "$str (@{[ Jikkoku::Util::daytime ]})\n";
    $self;
  }

  sub get {
    my ($self, $limit) = @_;
    Carp::croak 'few arguments($limit)' if @_ < 2;
    [ @{ $self->data }[0 .. $limit - 1] ];
  }

  sub get_all {
    my $self = shift;
    $self->data;
  }

  sub read {
    my $self = shift;
    my $fh = $self->fh;
    my @textdata_list = <$fh>;
    $self->data( \@textdata_list );
  }

  sub save {
    my $self = shift;
    open(my $fh, '+<', $self->file_path) or throw("file open failed", $!);
    $self->fh( $fh );
    $self->write;
    $self->fh(undef);
    $fh->close or throw("file close failed", $!);
  }

  sub write {
    my $self = shift;
    splice @{ $self->data }, $self->MAX;
    $self->fh->print( @{ $self->data } );
  }

}

1;
