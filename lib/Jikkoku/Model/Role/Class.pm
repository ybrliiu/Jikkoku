package Jikkoku::Model::Role::Class {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Util;
  use Module::Load ();

  sub INFLATE_TO() {}

  sub PRIMARY_ATTRIBUTE() { 'id' }

  # constants
  requires qw( NAMESPACE ROLE );

  with 'Jikkoku::Model::Role::Base';

  around prepare => sub {
    my ($orig, $class) = @_;
    my $dir_name = $class->NAMESPACE =~ s!::!/!gr;
    my @dir_list = map { "${_}/${dir_name}" } @INC;
    my @applied_modules =
      map { $class->_applied_modules_of_dir($_, $class->NAMESPACE . '::') } @dir_list;
    $class->meta->add_method(MODULES => sub { \@applied_modules });
    eval {
      Module::Load::load( $class->result_class )
        unless Jikkoku::Util::is_module_loaded( $class->result_class );
    };
    if (my $e = $@) {
      Carp::croak "you must create @{[ $class->result_class ]}";
    }
  };

  sub _applied_modules_of_dir {
    my ($class, $dir, $name_space) = @_;
    if ( opendir(my $dh, $dir) ) {
      my @files = readdir $dh;
      my @dirs = grep { $_ !~ /^\.{1,2}$/ } grep { -d "${dir}/${_}" } @files;
      my @child_modules = map {
        my $orig_dir = $_;
        my $new_dir        = "${dir}/${orig_dir}";
        my $new_name_space = $name_space . "${orig_dir}::";
        $class->_applied_modules_of_dir($new_dir, $new_name_space);
      } @dirs;
      my @modules =
        map { $_ =~ /(\.pm$)/p ? "${name_space}${^PREMATCH}" : () } @files;
      for my $module (@modules) {
        Module::Load::load($module) unless Jikkoku::Util::is_module_loaded($module);
      }
      @child_modules,
      ( map { $_ =~ s/(??{ $class->NAMESPACE . '::' })//gr }
          grep { $_->DOES( $class->ROLE ) } grep { $_->can('new') } @modules );
    } else {
      ();
    }
  }

  sub delete { q{Can't delete.} }

  sub get_with_option { q{Can't call get_with_option} }

  sub get_all {
    my $self = shift;
    [ map { $self->get($_) } @{ $self->MODULES } ];
  }

  sub get_all_with_result {
    my $self = shift;
    $self->result_class->new(data => $self->get_all);
  }

  sub result_class {
    my $class = ref $_[0] || $_[0];
    $class . '::Result';
  }

}

1;

