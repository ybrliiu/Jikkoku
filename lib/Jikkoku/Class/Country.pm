package Jikkoku::Class::Country {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Class::Base::TextData';

  use List::Util qw/first/;
  use Jikkoku::Model::Chara;
  use Jikkoku::Model::Config;

  use constant {
    PRIMARY_KEY     => 'id',
    # not_need は旧APIを正常に動作させるために必要なもの
    # 完全に切り替え終わったら削除する
    COLUMNS         => [qw/
      id name color_id months_after_establish king_id command position
      not_use
      not_need
    /],
    SUBDATA_COLUMNS => {
      # strategist = 軍師 infantry = 歩兵
      position => [qw/
        strategist_id
        great_general_id cavalry_general_id guard_general_id archery_general_id infantry_general_id
        premier_id
      /],
    },
  };

  __PACKAGE__->make_accessors( COLUMNS );
    
  my @HEADQUARTERS   = qw/king strategist premier/;
  my @POSITIONS_ID   = ('king_id', @{ SUBDATA_COLUMNS->{position} });
  my @POSITIONS      = map { $_ =~ s/_id//; $_; } @POSITIONS_ID;
  my @POSITIONS_NAME = qw/
    君主
    宰相
    軍師
    大将軍
    騎馬将軍
    護衛将軍
    弓将軍
    将軍
  /;
  my %POSITIONS_NAME = map { $POSITIONS[$_] => $POSITIONS_NAME[$_] } 0 .. $#POSITIONS;

  __PACKAGE__->_generate_positions_method();

  sub _generate_positions_method {
    for my $position (@POSITIONS) {
      no strict 'refs';

      *{$position} = sub {
        use strict 'refs';
        my ($self) = @_;
        return $self->{$position} if exists $self->{$position};
        $self->{$position} = eval {
          my $position_id = $position eq 'king' ? $self->{king_id} : $self->{position}{"${position}_id"};
          Jikkoku::Model::Chara->get($position_id);
        };
      };

      for my $attribute (qw/id name icon/) {
        __PACKAGE__->_generate_position_chara_attribute_method( $position, $attribute );
      }
    }
  }

  sub _generate_position_chara_attribute_method {
    my ($class, $position, $attribute) = @_;
    my $method_name = "${position}_${attribute}";
    no strict 'refs';
    *{$method_name} = sub {
      use strict 'refs';
      my ($self) = @_;
      return $self->{$method_name} if exists $self->{$method_name};
      $self->{$method_name} = defined $self->$position ? $self->$position->$attribute : undef;
    };
  }

  sub is_headquarters_exist {
    my ($self) = @_;
    grep { defined $self->$_ } @HEADQUARTERS;
  }

  sub is_chara_headquarters {
    my ($self, $chara_id) = @_;
    grep {
      if (defined $self->$_) {
        $self->$_->id eq $chara_id;
      }
    } @HEADQUARTERS;
  }

  sub is_chara_has_position {
    my ($self, $chara_id) = @_;
    my $position_name = first {
      if (defined $self->$_) {
        $self->$_->id eq $chara_id;
      }
    } @POSITIONS;
    defined $position_name ? $POSITIONS_NAME{$position_name} : undef;
  }

  sub total_salary {
    my ($self, $towns) = @_;
    my ($money, $rice);
    for my $town (@$towns) {
      if ($self->id eq $town->country_id) {
        $money += $town->salary_money;
        $rice  += $town->salary_rice;
      }
    }
    ($money, $rice);
  }

  {
    my $config = Jikkoku::Model::Config->get;

    for my $method_name (qw/color background_color background_color_rgba/) {
      no strict 'refs';
      *{$method_name} = sub {
        use strict 'refs';
        my $self = shift;
        $config->{"country_$method_name"}[ $self->{color_id} ];
      };
    }
  }

}

1;

