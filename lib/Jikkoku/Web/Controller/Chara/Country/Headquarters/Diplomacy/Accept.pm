package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Accept {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base';

  sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    $self->{is_accept}          = $self->param('sen');
    $self->{request_country_id} = $self->param('cou');
    $self->{request_country}    = $self->{country_model}->get( $self->{request_country_id} );

    $self;
  }

  sub short_declare_war {
    my $self = shift;
    $self->_accept( $self->class('Diplomacy')->DECLARE_WAR );
  }

  sub cease_war {
    my $self = shift;
    $self->_accept(
      $self->class('Diplomacy')->CEASE_WAR,
      sub {
        my ($self, $diplomacy) = @_;
        my $declare_war = $self->{diplomacy_model}->get_by_type_and_both_country_id(
          $self->class('Diplomacy')->DECLARE_WAR, $self->{country}->id, $self->{request_country_id} );
        $self->{diplomacy_model}->delete( $declare_war->type_and_both_country_id );
        $self->{diplomacy_model}->delete( $diplomacy->type_and_both_country_id );
      },
    );
  }

  sub cession_or_accept_territory {
    my $self = shift;
    $self->_accept( $self->class('Diplomacy')->CESSION_OR_ACCEPT_TERRITORY );
  }

  sub allow_passage {
    my $self = shift;
    $self->_accept( $self->class('Diplomacy')->ALLOW_PASSAGE );
  }

  sub _accept {
    my ($self, $type, $add_process) = @_;

    my ($diplomacy, $diplomacy_name);
    my $action = $self->{is_accept} ? '承諾' : '拒否';

    eval {
      my $param = {
        type               => $type,
        receive_country_id => $self->{country}->id,
        request_country_id => $self->{request_country_id},
      };
      $diplomacy = $self->{diplomacy_model}->get( $param );
      $diplomacy_name = $diplomacy->name;
      if ( $self->{is_accept} ) {
        $diplomacy->accept;
        $self->$add_process( $diplomacy ) if defined $add_process;
      } else {
        $self->{diplomacy_model}->delete( $param );
      }
    };

    if (my $e = $@) {
      $self->render_error($e);
    } else {
      $self->{diplomacy_model}->save;

      $self->{letter_model}->add_country_letter({
        sender          => $self->{chara},
        receive_country => $self->{request_country},
        message         => qq{<span style="color: #ff6600"><strong>【${diplomacy_name}要請】</strong></span>}
          . qq{@{[ $self->{country}->name ]}は@{[ $self->{request_country}->name ]}の${diplomacy_name}要請を${action}しました。<br>},
      });
      $self->{letter_model}->save;

      if ( $self->{is_accept} ) {
        my $log = qq{<span style="color: #ff6600"><strong>【${diplomacy_name}】</strong></span>}
          . qq{@{[ $self->{request_country}->name ]}は@{[ $self->{country}->name ]}へ${diplomacy_name}を行いました！@{[ $diplomacy->message ]}};
        $self->model('MapLog')->new->add( $log )->save;
        $self->model('HistoryLog')->new->add( $log )->save;
      }
    }

    $self->render('chara/result.pl', {message => "${diplomacy_name}要請を${action}しました。"});
  }

}

1;
