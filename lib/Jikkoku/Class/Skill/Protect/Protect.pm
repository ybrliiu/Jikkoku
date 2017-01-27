package Jikkoku::Class::Skill::Protect::Protect {

  use Jikkoku;
  use Class::Accessor::Lite::Lazy new => 0;
  use Role::Tiny::With;
  with 'Jikkoku::Class::Skill::Role::BattleAction';

  use Jikkoku::Util qw/validate_values/;

  {
    my %attributes = (
      name           => '掩護',
      consume_morale => 10,
      get_contribute => 2,
      effect_range   => 3,
      effect_time    => 250,
      interval_time  => 240,
    );

    Class::Accessor::Lite::Lazy->mk_accessors(keys %attributes);
    Class::Accessor::Lite::Lazy->mk_lazy_accessors('next_skill');

    sub new {
      my ($class, $args) = @_;
      bless {
        %attributes,
        %$args,
      }, $class;
    }
  }
  
  sub _build_next_skill { [] }

  sub is_acquired {
    my $self = shift;
    $self->{chara}->soldier->attr eq '歩';
  }

  sub acquire {}

  sub explain_effect {
    my ($self) = @_;
    "使用後$self->{effect_time}秒間、自分の周囲$self->{effect_range}マス以内にいる味方が敵の攻撃を受けた時、身代わりになって攻撃を受ける。(行動)";
  }

  sub explain_effect_simple {}

  sub explain_acquire {
    "歩兵属性兵科を使用時。";
  }

  sub explain_status {
    my ($self) = @_;
<< "EOS";
消費士気 : $self->{consume_morale}<br>
再使用時間 : $self->{interval_time}秒<br>
EOS
  }

  sub ensure_can_action {
    my ($self, $args) = @_;
    validate_values $args => ['protector_model'];

    my $time = time;
    my $sub = $self->{chara}->interval_time('protect') - $time;
    EXCEPTION()->throw("あと $sub秒 使用できません。") if $sub > 0;

    $args->{protector_model}, $time;
  }

  sub action {
    my ($self, $protector_model, $time) = @_;
    my $chara = $self->{chara};

    eval {
      $chara->morale_data( morale => $chara->morale_data('morale') - $self->{consume_morale} );
      $chara->contribute( $chara->contribute + $self->{get_contribute} );
      $chara->interval_time( protect => $time + $self->{interval_time} );
      $protector_model->add( $chara->id );
    };

    if (my $e = $@) {
      $chara->abort;
      EXCEPTION()->throw("$e \n");
    } else {
      $chara->save;
      $protector_model->save;
      my $log_base  = qq{<font color="#FF69B4">【$self->{name}】</font>@{[ $chara->name ]}は$self->{name}を行いました！敵の攻撃から味方を守ります。 };
      my $chara_log = $log_base . qq{士気-<font color="red">$self->{consume_morale}</font> 貢献値+<font color=red>$self->{get_contribute}</font>};
      $chara->save_command_log( $chara_log );
      $chara->save_battle_log( $chara_log );
      my $bm = $self->{battle_map_model}->get( $chara->soldier_battle_map('battle_map_id') );
      $self->{map_log_model}->add( $log_base . '(' . $bm->name . ')' )->save;
    }

  }

}

1;
