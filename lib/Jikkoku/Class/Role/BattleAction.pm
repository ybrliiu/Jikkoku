package Jikkoku::Class::Role::BattleAction {

  use v5.14;
  use warnings;
  use Role::Tiny;

  around new => sub {
    my ($origin, $class, @args) = @_;
    my $self = $class->$origin(@args);
    die " chara attribute がありません " unless exists $self->{chara};
    $self;
  };

  requires qw/ensure_can_action action/;

  before ensure_can_action => sub {
    my ($self, @args) = @_;
    die "出撃していません。\n" unless $self->{chara}->is_sortie;
    if ( $self->{chara}->soldier_num < 0 ) {
      # 退却処理
      die "兵士がいません。\n";
    }
  };

  around action => sub {
    my ($origin, $self, @args) = @_;
    my @ret = $self->ensure_can_action( @args );
    $self->{chara}->commit;
    # ensure_can_action で最後に返された値が引数として渡される
    $self->$origin( @ret );
  };

}

1;
