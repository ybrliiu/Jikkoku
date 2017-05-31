package Jikkoku::Role::Loader {

  use Mouse::Role;
  use Jikkoku;
  use Module::Load;

  for my $method_name (qw/ class model service /) {
    __PACKAGE__->meta->add_method($method_name => sub {
      my ($self, $module_name) = @_;
      my $full_module_name = "Jikkoku::@{[ ucfirst $method_name ]}::${module_name}";
      state $is_module_loaded = {};
      if ($is_module_loaded->{$full_module_name}) {
        $full_module_name;
      } else {
        Module::Load::load $full_module_name;
        $is_module_loaded->{$full_module_name} = 1;
        $full_module_name;
      }
    });
  }

}

1;

