package Jikkoku::Class::Chara {

  use Mouse;
  use Jikkoku;
  
  use Module::Load;
  use Jikkoku::Model::State;
  use Jikkoku::Model::Soldier;
  use Jikkoku::Class::Chara::Soldier;
  use Jikkoku::Class::Role::TextData;

  use constant {
    DIR_PATH    => 'charalog/main/',
    PRIMARY_KEY => 'id',

    PROTECT_RANGE          => 3,
    MOVE_POINT_CHARGE_TIME => 60 * 2,
    RECOVER_MORALE         => 30,
  };

  has 'id'               => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'pass'             => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'name'             => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'icon'             => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'force'            => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'intellect'        => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'leadership'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'popular'          => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'soldier_num'      => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'soldier_training' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'country_id'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'money'            => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'rice'             => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'contribute'       => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'class'            => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 1 );
  has 'weapon_power'     => ( metaclass => 'Column', is => 'rw', isa => 'Num', default  => 0 );
  has 'book_power'       => ( metaclass => 'Column', is => 'rw', isa => 'Num', default  => 0 );
  has 'loyalty'          => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 80 );
  # hash_field の先頭には '_'　をつける (make_hash_fields で旧APIと同名のメソッドを作成するため)
  has '_ability_exp'      => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( force intellect leadership popular soldier_id what_is_this )],
    validator => sub {},
  );
  has 'delete_turn' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'town_id'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', required => 1 );
  has 'guard_power' => ( metaclass => 'Column', is => 'rw', isa => 'Num', default  => 0 );
  has 'host'        => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'update_time' => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'mail'        => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '@' );
  has 'is_authed'   => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 1 );
  has 'win_message' => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has '_skill'       => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( assist disturb cheer move battle_method command auto_gather attack assist_move not_used )],
    validator => sub {},
  );
  has '_config' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( battle_map_hidden font_size config2 config3 config4 config5 config6 )],
    validator => sub {},
  );
  has 'skill_point'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has '_equipment_skill' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( book guard )],
    validator => sub {},
  );
  has 'last_login_host'    => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has 'weapon_skill'       => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has '_soldier_battle_map' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      formation is_sortie battle_map_id
      x y
      move_point_charge_time action_time move_point
      keisu_count plus_attack_power plus_defence_power change_formation_time not_used
    )],
    validator => sub {
      my ($self, $key, $value) = @_;
      state $switch = {
        move_point => sub {
          my $value = shift;
          die "0以下にはできません" if $value < 0;
        },
      };
      $switch->{$key}->($value) if exists $switch->{$key};
    },
  );
  has 'enter_to_maze'     => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has 'guard_name'        => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '紙の盾' );
  has 'weapon_name'       => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '竹槍' );
  has 'book_name'         => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '紙切れ' );
  has 'weapon_attr'       => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '無' );
  has 'weapon_attr_power' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has '_battle_and_command_record' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      kill_soldier die_soldier
      defence_win attack_win attack_lose defence_lose
      training_soldier domestic_administration 
      conscription draw attack_town
      trick training_self
      conquer_town destroy_wall 
      maybe_not_used maybe_not_used2
    )],
    validator => sub {},
  );
  has '_buffer_and_reward_and_command_skill' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw(
      training_soldier_skill
      kill_soldier_reward
      win_reward
      lose_reward
      attack_town_skill
      kago
      kago_strong
      youdou
      youdou_strong
      kobu
      kobu_strong
      sendou
      sendou_strong
      domestic_administration_skill
      trick_skill
      training_self_skill
      kintoun
      not_used not_used2
    )],
    validator => sub {},
  );
  has '_weapon2_data' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( power name attr attr_power )],
    validator => sub {},
  );
  has 'bought_skill_point' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default  => 0 );
  has '_interval_time'      => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( protect singeki )],
    validator => sub {},
  );
  has 'not_used'    => ( metaclass => 'Column', is => 'rw', isa => 'Str', default  => '' );
  has '_morale_data' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( morale morale_max )],
    validator => sub {},
  );
  has '_debuff' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( stuck )],
    validator => sub {},
  );
  has '_buff' => (
    metaclass => 'HashField',
    is        => 'rw',
    isa       => 'Jikkoku::Class::Role::TextData::HashField',
    keys      => [qw( not_used )],
    validator => sub {},
  );
  has 'states_data' => (
    metaclass => 'HashContainer',
    is        => 'ro',
    isa       => 'Jikkoku::Class::Role::TextData::HashContainer',
    default   => sub { Jikkoku::Class::Role::TextData::HashContainer->new },
  );

  has 'soldier' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::Soldier', lazy => 1, builder => '_build_soldier' );
  has 'states'  => ( is => 'rw', isa => 'Jikkoku::Model::State', lazy => 1, default => sub { Jikkoku::Model::State->new(chara => $_[0]) } );

  sub _build_soldier {
    my $self = shift;
    my $soldier_data = Jikkoku::Model::Soldier->new->get( $self->ability_exp('soldier_id') );
    Jikkoku::Class::Chara::Soldier->new( $soldier_data );
  }

  with 'Jikkoku::Class::Role::TextData::Division';

  __PACKAGE__->make_hash_fields;

  before money => sub {
    my ($self, $value) = @_;
    if (@_ == 2) {
      die "金が足りません。" if $value < 0;
    }
  };

  before rice => sub {
    my ($self, $value) = @_;
    if (@_ == 2) {
      die "米が足りません。" if $value < 0;
    }
  };

  sub soldier_retreat {
    my $self = shift;

    $self->soldier_battle_map(is_sortie => 0);

    $self->soldier_battle_map($_ => '') for qw( x y battle_map_id );
    $self->soldier_battle_map($_ => 0) for qw( keisu_count plus_attack_power plus_defence_power );

    $self->interval_time($_ => 0) for keys %{ $self->{interval_time} };
    $self->debuff($_ => 0) for keys %{ $self->{debuff} };

    my $protector_model = Jikkoku::Model::Chara::Protector->new;
    $protector_model->delete( $self->id );
    $protector_model->save;
  }

  sub soldier_can_move {
    my ($self, $move_node) = @_;
    $self->soldier_battle_map('move_point') - $move_node->cost($self) >= 0;
  }

  sub recover_morale {
    my ($self) = @_;
    $self->morale_data(morale => $self->morale_data('morale') + RECOVER_MORALE);

    # validator に移動
    $self->morale_data(morale => $self->morale_data('morale_max') )
      if $self->morale_data('morale') > $self->morale_data('morale_max');
  }

  sub distance_to_chara_soldier {
    my ($self, $chara) = @_;
    my $self_bm = $self->_soldier_battle_map;
    my $chara_bm = $chara->_soldier_battle_map;
    abs( $self_bm->_get('x') - $chara_bm->get('x') ) + abs( $self_bm->get('y') - $chara_bm->get('y') );
  }

  sub can_protect {
    my ($self, $chara) = @_;
    $self->id                                  ne $chara->id                                 &&
    $self->country_id                          eq $chara->country_id                         &&
    $self->soldier_battle_map('battle_map_id') eq $self->soldier_battle_map('battle_map_id') &&
    $self->distance_to_chara_soldier( $chara ) <= PROTECT_RANGE;
  }

  sub check_pass {
    my ($self, $pass) = @_;
    $self->pass eq $pass;
  }

  sub is_authed {
    $_[0]->is_authed;
  }

  sub is_protect {
    my ($self) = @_;
    Jikkoku::Model::Chara::Protector->new->is_protect( $self->id );
  }

  sub is_same_country {
    my ($self, $chara) = @_;
    $self->country_id eq $chara->country_id;
  }

  sub is_soldier_same_position {
    my ($self, $battle_map, $x, $y) = @_;
    my $bm = $self->_soldier_battle_map;
    $bm->get('battle_map_id') eq $battle_map && $bm->get('x') == $x && $bm->get('y') == $y;
  }

  sub is_sortie {
    $_[0]->soldier_battle_map('is_sortie');
  }

  sub command_log {
    my ($self, $limit) = @_;
    Jikkoku::Model::Chara::CommandLog->new($self->id)->get($limit);
  }

  sub battle_log {
    my ($self, $limit) = @_;
    Jikkoku::Model::Chara::BattleLog->new($self->id)->get($limit);
  }

  sub move_to {
    my ($self, $node) = @_;
    $self->soldier_battle_map(x => $node->x);
    $self->soldier_battle_map(y => $node->y);
  }

  sub profile {
    my ($self) = @_;
    Jikkoku::Model::Chara::Profile->new($self->id)->get;
  }

  __PACKAGE__->_generate_save_log_method;

  sub _generate_save_log_method {
    my $class = shift;
    my $meta = $class->meta;
    my @method_names = map { "save_${_}_log" } qw/command battle/;
    for my $method_name (@method_names) {
      my $pkg_name = "Jikkoku::Model::Chara::" . ucfirst $method_name =~ s/save_//r;
      $pkg_name =~ s/_log/Log/;
      Module::Load::load($pkg_name);
      $meta->add_method($method_name => sub {
        my ($self, $str) = @_;
        $pkg_name->new( $self->id )->add( $str )->save;
      });
    }
  }

  __PACKAGE__->meta->make_immutable;
}

1;

