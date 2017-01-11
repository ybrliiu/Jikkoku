package Jikkoku::Class::BattleCommand::Base {

  use v5.14;
  use warnings;

  use Scalar::Util qw/weaken/;
  use Jikkoku::Util qw/validate_values/;

  {
    my %my_attributes = (
      chara => undef,
    );

    sub new {
      my ($class, $args) = @_;
      validate_values $args => ['chara'];

      my $self = bless {
        %my_attributes,
        %$args
      }, $class;
      weaken $self->{chara};
      # キャラスキルによってステータスを調整
      $self;
    }
  }

}

1;
