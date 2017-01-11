package Jikkoku::Class::Chara {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Class::Base::TextData::Division';

  use Carp qw/croak/;
  use Module::Load;
  use Jikkoku::Class::Chara::Soldier;
  use Jikkoku::Model::Soldier;
  map { load "Jikkoku::Model::Chara::$_" } qw/Protector BattleLog CommandLog Profile/;

  use constant {
    FILE_DIR_PATH   => 'charalog/main/',
    PRIMARY_KEY     => 'id',
    COLUMNS         => [qw/
      id pass name icon
      force intellect leadership popular
      soldier_num training
      country_id
      money rice
      contribute class
      weapon_power book_power
      loyalty
      ability_exp
      delete_turn
      town_id
      guard_power
      host
      update_time
      mail
      is_authed
      win_message
      skill
      config
      skill_point
      equipment_skill
      last_login_host
      weapon_skill
      soldier_battle_map
      enter_to_maze
      guard_name weapon_name book_name
      weapon_attr weapon_attr_power
      battle_and_command_record buffer_and_reward_and_command_skill
      weapon2_data
      bought_skill_point
      skill_data skill_data2
      morale_data
      sub7 sub8
    /],
    SUBDATA_COLUMNS => {
      ability_exp       => [qw/force intellect leadership popular soldier_id what_is_this/],
      # command = 指揮スキル
      skill             => [qw/assist disturb cheer move battle_method command auto_gather attack assist_move not_used/],
      config            => [qw/battle_map_hidden font_size config2 config3 config4 config5 config6/],
      # is_sortie = 出撃
      soldier_battle_map => [qw/
        formation is_sortie 
        battle_map_id x y 
        move_point_charge_time action_time move_point 
        keisu_count plus_attack_power plus_defence_power
        change_formation_time not_used
      /],
      equipment_skill   => [qw/book guard/],
      # domestic_administration = 内政, conscription = 徴兵、
      battle_and_command_record => [qw/
        kill_soldier die_soldier
        defence_win attack_win attack_lose defence_lose
        training_soldier domestic_administration conscription
        draw attack_town
        trick training_self
        conquer_town destroy_wall maybe_not_used maybe_not_used2
      /], 
      buffer_and_reward_and_command_skill => [qw/
        training_soldier_skill kill_soldier_reward win_reward lose_reward attack_town_skill
        kago kago_strong youdou youdou_strong kobu kobu_strong sendou sendou_strong
        domestic_administration_skill trick_skill training_self_skill
        kintoun
        not_used not_used2
      /],
      weapon2_data => [qw/power name attr attr_power/],
      skill_data   => [qw/singeki_time not_used/],
      morale_data  => [qw/morale morale_max/],
    },

    PROTECT_RANGE          => 3,
    MOVE_POINT_CHARGE_TIME => 60 * 2,
    RECOVER_MORALE         => 30,
  };

  __PACKAGE__->make_hash_accessors( [ keys %{ SUBDATA_COLUMNS() } ] );
  __PACKAGE__->make_accessors( COLUMNS );

  __PACKAGE__->after(money => sub {
    my ($self) = @_;
    if (@_ != 1) {
      die "金が足りません。\n" if $self->{money} < 0;
    }
  });

  __PACKAGE__->after(rice => sub {
    my ($self) = @_;
    if (@_ != 1) {
      die "米が足りません。\n" if $self->{rice} < 0;
    }
  });

  __PACKAGE__->after(soldier_battle_map => sub {
    my ($self, $key) = @_;
    if (@_ != 2) {
      if ($key eq 'move_point') {
        die "移動ポイントが足りません。\n" if $self->{soldier_battle_map}{$key} < 0;
      }
    }
  });

  __PACKAGE__->after(morale_data => sub {
    my ($self, $key) = @_;
    if (@_ != 2) {
      if ($key eq 'morale') {
        die "士気が足りません。\n" if $self->{morale_data}{$key} < 0;
      }
    }
  });

  sub charge_move_point {
    my ($self) = @_;
    $self->{soldier_battle_map}{move_point} = $self->soldier->move_point;
  }

  sub occur_move_point_charge_time {
    my ($self) = @_;
    $self->{soldier_battle_map}{move_point_charge_time} = time + MOVE_POINT_CHARGE_TIME;
    # スキルによって移動P補充時間を調整
  }

  sub soldier_retreat {
    my ($self) = @_;
    $self->{soldier_battle_map}{is_sortie} = 0;
    (
      $self->{soldier_battle_map}{x},
      $self->{soldier_battle_map}{y},
      $self->{soldier_battle_map}{battle_map_id},
    )
      = ('') x 3;

    (
      $self->{soldier_battle_map}{keisu_count},
      $self->{soldier_battle_map}{plus_attack_power},
      $self->{soldier_battle_map}{plus_defence_power},
      $self->{skill_data}{singeki_time},
    )
      = (0) x 4;

    my $protector_model = Jikkoku::Model::Chara::Protector->new;
    $protector_model->delete( $self->{id} );
    $protector_model->save;
  }

  sub recover_morale {
    my ($self) = @_;
    $self->{morale_data}{morale} += RECOVER_MORALE;
    $self->{morale_data}{morale} = $self->{morale_data}{morale_max}
      if $self->{morale_data}{morale} > $self->{morale_data}{morale_max};
  }

  sub distance_of_chara_soldiers {
    my ($self, $chara) = @_;
    my $self_bm = $self->{soldier_battle_map};
    my $chara_bm = $chara->{soldier_battle_map};
    abs( $self_bm->{x} - $chara_bm->{x} ) + abs( $self_bm->{y} - $chara_bm->{y} );
  }

  sub can_protect {
    my ($self, $chara) = @_;
    $self->{id}                                 ne $chara->{id}                               &&
    $self->{country_id}                         eq $chara->{country_id}                       &&
    $self->{soldier_battle_map}{battle_map_id}  eq $self->{soldier_battle_map}{battle_map_id} &&
    $self->distance_of_chara_soldiers( $chara ) <= PROTECT_RANGE;
  }

  sub check_pass {
    my ($self, $pass) = @_;
    $self->{pass} eq $pass;
  }

  # $_[0] = self
  sub is_authed {
    $_[0]->{is_authed};
  }

  sub is_protect {
    my ($self) = @_;
    Jikkoku::Model::Chara::Protector->new->is_protect( $self->{id} );
  }

  sub is_same_country {
    my ($self, $chara) = @_;
    $self->{country_id} eq $chara->{country_id};
  }

  sub is_soldier_same_position {
    my ($self, $battle_map, $x, $y) = @_;
    my $bm = $self->{soldier_battle_map};
    $bm->{battle_map_id} eq $battle_map && $bm->{x} == $x && $bm->{y} == $y;
  }

  sub is_sortie {
    $_[0]->{soldier_battle_map}{is_sortie};
  }

  sub command_log {
    my ($self, $limit) = @_;
    Jikkoku::Model::Chara::CommandLog->new($self->{id})->get($limit);
  }

  sub battle_log {
    my ($self, $limit) = @_;
    Jikkoku::Model::Chara::BattleLog->new($self->{id})->get($limit);
  }

  sub move_to {
    my ($self, $node) = @_;
    $self->{soldier_battle_map}{x} = $node->x;
    $self->{soldier_battle_map}{y} = $node->y;
  }

  sub profile {
    my ($self) = @_;
    Jikkoku::Model::Chara::Profile->new($self->{id})->get;
  }

  sub soldier {
    my ($self, $key) = @_;
    return $self->{soldier} if exists $self->{soldier};
    my $soldier_data = Jikkoku::Model::Soldier->new->get( $self->{ability_exp}{soldier_id} );
    $self->{soldier} = Jikkoku::Class::Chara::Soldier->new( $soldier_data );
  }

  __PACKAGE__->_generate_save_log_method;

  sub _generate_save_log_method {
    my ($class) = @_;
    my @method_names = map { "save_${_}_log" } qw/command battle/;
    for my $method_name (@method_names) {
      my $pkg_name = "Jikkoku::Model::Chara::" . ucfirst $method_name =~ s/save_//r;
      $pkg_name =~ s/_log/Log/;
      no strict 'refs';
      *{$method_name} = sub {
        use strict 'refs';
        my ($self, $str) = @_;
        $pkg_name->new( $self->id )->add( $str )->save;
      };
    }
  }

}

1;
