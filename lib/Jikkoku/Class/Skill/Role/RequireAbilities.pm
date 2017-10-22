package Jikkoku::Class::Skill::Role::RequireAbilities {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Model::Config;

  # constant
  requires qw( REQUIRE_ABILITIES );

  my $JAPANESE = Jikkoku::Model::Config->get->{japanese};

  around description_of_effect_about_require_abilities => sub {
    my ($orig, $self) = @_;
    my @abilities = keys %{ $self->REQUIRE_ABILITIES };
    ( join '、', map {
      my ($key, $value) = ($_, $self->REQUIRE_ABILITIES->{$_});
      $JAPANESE->{$key} . $value . '以上';
    } @abilities )
      . 'で有効。';
  };

}

1;

__END__

=head1 constants

REQUIRE_ABILITIES: HashRef[Str]
ex:
sub REQUIRE_ABILITIES() {
  {force => 130};
}

=cut
