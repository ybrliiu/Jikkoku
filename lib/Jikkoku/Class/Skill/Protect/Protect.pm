package Jikkoku::Class::Skill::Protect::Protect {

  use v5.14;
  use warnings;
  use Class::Accessor::Lite new => 0;

  use Jikkoku::Model::MapLog;
  use Jikkoku::Model::BattleMap;
  use Jikkoku::Model::Chara::Protector;

  {
    my %my_attributes = (
      chara => undef,
    );

    my %attributes = (
      name           => '掩護',
      consume_morale => 10,
      get_contribute => 5,
      effect_reach   => 3,
      effect_time    => 250,
      child_skill    => [],
    );

    Class::Accessor::Lite->mk_accessors(keys %attributes);

    sub new {
      my ($class, $args) = @_;
      validate_values $args => ['chara'];

      my $self = bless {
        %my_attributes,
        %$args
      }, $class;

      weaken $self->{chara};

      $self;
    }
  }

  sub explain_action {
    my ($self) = @_;
    "使用後$self->{effect_time}秒間、自分の周囲$self->{effect_reach}マス以内にいる味方が敵の攻撃を受けた時、身代わりになって攻撃を受ける。";
  }

  sub explain_learning_terms {
    my ($self) = @_;
    "歩兵属性兵科を使用時。";
  }

  sub explain_status {
    my ($self) = @_;
    "消費士気 : $self->{consume_morale}";
  }

  sub action {
    my ($self) = @_;

    eval {
      die "出撃していません。" unless $self->{chara}->is_sortie;
      die "歩兵を雇っていません。" if $self->{chara}->soldier->type ne '歩';
      $self->{chara}->morale_data( morale => $self->{chara}->morale_data('morale') - $self->{consume_morale} );
      $self->{chara}->contribute( $self->{chara}->contribute + $self->{get_contribute} );
    };

    if (my $e = $@) {
      $self->{chara}->abort;
      die " $self->{name} を実行できませんでした ($@) ";
    } else {
      $self->{chara}->save;

      my $protector_model = Jikkoku::Model::Chara::Protector->new;
      $protector_model->add( $self->{chara}->id );
      $protector_model->save;

      my $log_base  = qq{<font color="#FF69B4">【掩護】</font>@{[ $self->{chara}->name ]}は掩護態勢を取りました！敵の攻撃から味方を守ります。 };
      my $self->{chara}_log = $log_base . qq{士気-<font color="red">$self->{consume_morale}</font> 貢献値+<font color=red>$self->{get_contribute}</font>};
      $self->{chara}->save_command_log( $self->{chara}_log );
      $self->{chara}->save_battle_log( $self->{chara}_log );

      my $bm_id = $self->{chara}->soldier_battle_map('battle_map_id');
      my $bm_name = Jikkoku::Model::BattleMap->new->get( $bm_id )->name;
      Jikkoku::Model::MapLog->new->add( $log_base . "($bm_name)" )->save;
    }

  }

}

1;
