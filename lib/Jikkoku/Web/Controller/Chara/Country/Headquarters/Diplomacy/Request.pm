package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Request {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base';

  sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    $self->{diplomacy_model}    = $self->model('Diplomacy')->new;
    $self->{receive_country_id} = $self->param('cou');
    $self->{receive_country}    = $self->{country_model}->get( $self->{receive_country_id} );

    $self;
  }

  sub declare_war {
    my $self = shift;
  
    my $now_game_date = $self->model('GameDate')->new->get;
    my ($select_year, $select_month) = split /,/, $self->param('sel');
    my $start_game_date = $self->class('GameDate')->new({
      elapsed_year => $select_year,
      month        => $select_month,
    });
  
    if ( $start_game_date->to_num < $now_game_date->to_num + $self->class('Diplomacy::DeclareWar')->REQUIRED_MONTH ) {
      $self->render_error("開戦時間が異常です。");
    }
  
    eval {
      $self->{diplomacy_model}->add({
        type               => $self->{diplomacy_model}->CLASS->DECLARE_WAR,
        request_country_id => $self->{country}->id,
        receive_country_id => $self->{receive_country_id},
        now_game_date      => $now_game_date,
        start_game_date    => $start_game_date,
      });
    };
  
    if (my $e = $@) {
      $self->render_error( $e );
    } elsif ($e =~ '既に相手国から外交要請が届いています。') {
    } else {
      $self->{diplomacy_model}->save;
    }
  
    my $log = qq{<span style="color: #ff6600"><strong>【宣戦布告】</strong></span>}
      . qq{@{[ $self->{country}->name ]}は@{[ $self->{receive_country}->name ]}へ宣戦布告を行いました！「@{[ $self->param('sei') ]}」}
      . qq{開戦時間 : @{[ $start_game_date->year ]}年@{[ $start_game_date->month ]}月}
      . qq{( @{[ $self->{country}->name ]}$self->{position_name} : @{[ $self->{chara}->name ]}より ) };
    $self->model('MapLog')->new->add( $log )->save;
    $self->model('HistoryLog')->new->add( $log )->save;
    $self->{letter_model}->add_country_letter({
      sender          => $self->{chara},
      receive_country => $self->{receive_country},
      message         => "$log<br>司令部の外交操作からご確認ください。",
    });
    $self->{letter_model}->save;
  
    $self->render('chara/result.pl', {message => "宣戦布告を行いました。"});
  }

  sub short_declare_war {
    my $self = shift;
  
    my $now_game_date = $self->model('GameDate')->new->get;
    my ($select_year, $select_month) = split /,/, $self->param('sel');
    my $start_game_date = $self->class('GameDate')->new({
      elapsed_year => $select_year,
      month        => $select_month,
    });
  
    if ( $start_game_date->to_num < $now_game_date->to_num
      or $start_game_date->to_num >= $now_game_date->to_num + $self->class('Diplomacy::DeclareWar')->REQUIRED_MONTH ) {
      $self->render_error("開戦時間が異常です。");
    }
  
    my $add_diplomacy = eval {
      $self->{diplomacy_model}->add({
        type               => $self->{diplomacy_model}->CLASS->DECLARE_WAR,
        request_country_id => $self->{country}->id,
        receive_country_id => $self->{receive_country_id},
        now_game_date      => $now_game_date,
        start_game_date    => $start_game_date,
        message            => "「@{[ $self->param('sei') ]}」"
          . "開戦時間 : @{[ $start_game_date->year ]}年@{[ $start_game_date->month ]}月 "
          . "( @{[ $self->{country}->name ]}君主 : @{[ $self->{chara}->name ]}より )",
      });
    };

    if (my $e = $@) {

      if ($e =~ '既に外交要請を出しています。') {

        my $delete_diplomacy = $self->{diplomacy_model}->delete({
          type               => $self->{diplomacy_model}->CLASS->DECLARE_WAR,
          request_country_id => $self->{country}->id,
          receive_country_id => $self->{receive_country_id},
        });
        $self->{diplomacy_model}->save;

        $self->{letter_model}->add_country_letter({
          sender          => $self->{chara},
          receive_country => $self->{receive_country},
          message         => qq{<span style="color: #ff6600"><strong>【@{[ $delete_diplomacy->name ]}要請】</strong></span>}
            . qq{@{[ $self->{country}->name ]}は@{[ $self->{receive_country}->name ]}への@{[ $delete_diplomacy->name ]}要請を取り消しました。<br>}
        });
        $self->{letter_model}->save;

        $self->render('chara/result.pl', {message => $delete_diplomacy->name . '要請を取り下げました。'});
      }
      else {
        $self->render_error($e);
      }

    } else {

      $self->{diplomacy_model}->save;
      $self->{letter_model}->add_country_letter({
        sender          => $self->{chara},
        receive_country => $self->{receive_country},
        message         => qq{<span style="color: #ff6600"><strong>【@{[ $add_diplomacy->name ]}要請】</strong></span>}
          . qq{@{[ $self->{country}->name ]}は@{[ $self->{receive_country}->name ]}へ@{[ $add_diplomacy->name ]}要請を行いました。<br>}
          . qq{「@{[ $self->param('sei') ]} 」<br>}
          . qq{( 開戦希望時間 : @{[ $start_game_date->year ]}年@{[ $start_game_date->month ]}月 )<br>}
          . qq{司令部の外交関連操作からご確認ください。},
      });
      $self->{letter_model}->save;

      $self->render('chara/result.pl', {message => $add_diplomacy->name . "要請を行いました。"});
    }

  }

  sub cease_war {
    my $self = shift;
    $self->_request( $self->class('Diplomacy')->CEASE_WAR );
  }

  sub cession_or_accept_territory {
    my $self = shift;
    $self->_request( $self->class('Diplomacy')->CESSION_OR_ACCEPT_TERRITORY );
  }

  sub allow_passage {
    my $self = shift;
    $self->_request( $self->class('Diplomacy')->ALLOW_PASSAGE );
  }

  sub _request {
    my ($self, $type) = @_;

    my %diplomacy_param = (
      type               => $type,
      request_country_id => $self->{country}->id,
      receive_country_id => $self->{receive_country_id},
    );

    my %letter_param = (
      sender          => $self->{chara},
      receive_country => $self->{receive_country},
    );
  
    my $add_diplomacy = eval {
      $self->{diplomacy_model}->add({
        %diplomacy_param,
        message => "「@{[ $self->param('sei') ]}」( @{[ $self->{country}->name ]}君主 : @{[ $self->{chara}->name ]}より )",
      });
    };

    if (my $e = $@) {

      if ($e =~ '既に外交要請を出しています。') {

        my $delete_diplomacy = $self->{diplomacy_model}->delete( \%diplomacy_param );
        $self->{diplomacy_model}->save;

        $self->{letter_model}->add_country_letter({
          %letter_param,
          message => qq{<span style="color: #ff6600"><strong>【@{[ $delete_diplomacy->name ]}要請】</strong></span>}
            . qq{@{[ $self->{country}->name ]}は@{[ $self->{receive_country}->name ]}への@{[ $delete_diplomacy->name ]}要請を取り消しました。<br>}
        });
        $self->{letter_model}->save;

        $self->render('chara/result.pl', {message => $delete_diplomacy->name . '要請を取り下げました。'});
      }
      else {
        $self->render_error($e);
      }

    } else {

      $self->{diplomacy_model}->save;
      $self->{letter_model}->add_country_letter({
        %letter_param,
        message => qq{<span style="color: #ff6600"><strong>【@{[ $add_diplomacy->name ]}要請】</strong></span>}
          . qq{@{[ $self->{country}->name ]}は@{[ $self->{receive_country}->name ]}へ@{[ $add_diplomacy->name ]}要請を行いました。<br>}
          . qq{「@{[ $self->param('sei') ]} 」<br>}
          . qq{司令部の外交関連操作からご確認ください。},
      });
      $self->{letter_model}->save;

      $self->render('chara/result.pl', {message => $add_diplomacy->name . "要請を行いました。"});
    }

  }

}

1;
