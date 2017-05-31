package Jikkoku::Model::Role::Division {

  use Mouse::Role;
  use Jikkoku;

  use Carp;
  use Option;
  use Module::Load;
  use Jikkoku::Util;

  with 'Jikkoku::Model::Role::Base';

  sub dir_path {
    my $class = shift;
    ( Jikkoku::Util::is_test ? Jikkoku::Util::TEST_DIR : '' ) . $class->INFLATE_TO->DIR_PATH;
  }

  around BUILDARGS => sub {
    my ($orig, $class) = @_;
    state $load_flag = {};
    if (!$load_flag->{$class}) {
      Module::Load::load $class->INFLATE_TO   unless is_module_loaded($class->INFLATE_TO);
      Module::Load::load $class->result_class unless is_module_loaded($class->result_class);
      $load_flag->{$class} = 1;
    }
    $class->$orig();
  };

  sub is_module_loaded {
    my $module_name = shift;
    no strict 'refs';
    grep { $_ !~ /::$/ } keys %{$module_name . '::'};
  }

  sub result_class {
    my $self = shift;
    my $class = ref $self || $self;
    $class . '::Result';
  }

  sub get {
    my ($self, $primary_attribute_value) = @_;
    Carp::croak 'few arguments($primary_attribute_value)' if @_ < 2;
    $self->INFLATE_TO->new($primary_attribute_value);
  }

  sub get_with_option {
    my ($self, $primary_attribute_value) = @_;
    Carp::croak 'few arguments($primary_attribute_value)' if @_ < 2;

    # inline 展開しているためか, eval を二重にいないと例外を補足できない
    my $obj = eval {
      eval { $self->INFLATE_TO->new($primary_attribute_value) };
    };
    if (my $e = $@) {
      warn $e;
      Option::None->new;
    } else {
      Option->new($obj);
    }
  }

  sub get_all {
    my $self = shift;
		opendir(my $dh, $self->dir_path);
    my @chara_list = map {
      if ( (my $file = $_) =~ /.+\.cgi$/i ) {
        my $primary_attribute_value = ($file =~ s/\.cgi//r);
        $self->get($primary_attribute_value);
      } else {
        ();
      }
    } readdir $dh;
		closedir $dh;
    \@chara_list;
  }

  sub get_all_with_result {
    my $self = shift;
    $self->result_class->new( data => $self->get_all );
  }

  sub foreach {
    my ($self, $code) = @_;
    Carp::croak 'few arguments($code)' if @_ < 2;
    opendir(my $dh, $self->dir_path);
    for (readdir $dh) {
      if ( (my $file = $_) =~ /.+\.cgi$/i ) {
        my $primary_attribute_value = ($file =~ s/\.cgi//r);
        $code->( $self->get($primary_attribute_value) );
      }
    }
    closedir $dh;
  }

  sub first {
    my ($self, $code) = @_;
    Carp::croak 'few arguments($code)' if @_ < 2;
    my $chara_list = $self->get_all;
    for my $chara (@$chara_list) {
      return $chara if $code->($chara);
    }
  }

  sub delete {
    my ($self, $primary_attribute_value) = @_;
    Carp::croak 'few arguments($primary_attribute_value)' if @_ < 2;
    my $chara = $self->get($primary_attribute_value);
    unlink $chara->file_path;
  }

  sub create {
    my $self = shift;
    my %args = ref $_[0] eq 'HASH' ? $_[0] : @_;
    $self->INFLATE_TO->new(\%args);
  }

}

1;

