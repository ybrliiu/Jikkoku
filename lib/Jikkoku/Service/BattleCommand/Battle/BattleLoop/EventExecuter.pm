package Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter {

  use Mouse::Role;
  use Jikkoku;

  requires qw(
    event_execute_service_class_name
    occur_ratio
    range
  );

}

1;

__END__

