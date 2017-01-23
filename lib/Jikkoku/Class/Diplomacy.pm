package Jikkoku::Class::Diplomacy {

  use Jikkoku;
  use parent 'Jikkoku::Class::Base::TextData';
  use Role::Tiny::With;
  with 'Jikkoku::Class::Role::Diplomacy';

  use Carp qw/croak/;
  use Jikkoku::Util qw/validate_values/;

  __PACKAGE__->make_accessors( COLUMNS() );

  sub _new_by_args {
    my ($class, $args) = @_;
    $args->{message} //= '';
    validate_values $args => [qw/type request_country_id receive_country_id message/];

    croak "type の指定が不正です" if $args->{type} < CEASE_WAR() || $args->{type} > ALLOW_PASSAGE();

    my $become_self = {
      %$args,
      start_year  => '',
      start_month => '',
      is_accepted => 0,
    };
    $class->SUPER::_new_by_args( $become_self );
  }

}

1;
