package Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter {

  use Mouse::Role;
  use Jikkoku;

  use Module::Load;
  use Jikkoku::Util;

  requires qw(
    event_execute_service_class_name
    occur_ratio
    range
  );

  sub prepare {
    my $class = shift;
    eval {
      Module::Load::load($class->event_execute_service_class_name)
        unless Jikkoku::Util::is_module_loaded($class->event_execute_service_class_name);
    };
    if (my $e = $@) {
      Carp::confess "event execute service class is undefined.($e)";
    }
  }

}

1;

__END__

# 必ずRoleを消費するクラスでは__PACKAGE__->prepareを呼び出して下さい。

