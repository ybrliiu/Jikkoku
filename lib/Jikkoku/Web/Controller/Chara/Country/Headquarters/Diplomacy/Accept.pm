package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Accept {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base';

  has 'is_accept'          => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->param('sen') } );
  has 'request_country_id' => ( is => 'ro', isa => 'Str', lazy => 1, default => sub { $_[0]->param('cou') } );

  has 'request_country' => (
    is => 'ro',
    isa => 'Jikkoku::Class::Country',
    lazy => 1,
    default => sub {
      my $self = shift;
      $self->country_model
        ->get_with_option( $self->request_country_id )
        ->match(
          Some => sub { $_ },
          None => sub { $self->render_error('その国はもう存在していないようです。') },
        );
    },
  );

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
        my $declare_war =
        $self->diplomacy_model->get_by_type_and_both_country_id(
          $self->class('Diplomacy')->DECLARE_WAR, $self->country->id, $self->request_country_id
        )->match(
          Some => sub {
            my $declare_war = shift;
            $self->diplomacy_model->delete( $declare_war->type_and_both_country_id );
            $self->diplomacy_model->delete( $diplomacy->type_and_both_country_id );
          },
          None => sub { $self->render_error("停戦できませんでした。") },
        );
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
    my $action = $self->is_accept ? '承諾' : '拒否';

    eval {
      my $param = {
        type               => $type,
        receive_country_id => $self->country->id,
        request_country_id => $self->request_country_id,
      };
      $diplomacy = $self->diplomacy_model->get( $param );
      $diplomacy_name = $diplomacy->name;
      if ( $self->is_accept ) {
        $diplomacy->accept;
        $self->$add_process( $diplomacy ) if defined $add_process;
      } else {
        $self->diplomacy_model->delete( $param );
      }
    };

    if (my $e = $@) {
      $self->render_error($e);
    } else {
      $self->diplomacy_model->save;

      $self->letter_model->add_country_letter({
        sender          => $self->chara,
        receive_country => $self->request_country,
        message         => qq{<span style="color: #ff6600"><strong>【${diplomacy_name}要請】</strong></span>}
          . qq{@{[ $self->country->name ]}は@{[ $self->request_country->name ]}の${diplomacy_name}要請を${action}しました。<br>},
      });
      $self->letter_model->save;

      if ( $self->is_accept ) {
        my $log = qq{<span style="color: #ff6600"><strong>【${diplomacy_name}】</strong></span>}
          . qq{@{[ $self->request_country->name ]}は@{[ $self->country->name ]}と${diplomacy_name}を行いました！@{[ $diplomacy->message ]}};
        $self->model('MapLog')->new->add( $log )->save;
        $self->model('HistoryLog')->new->add( $log )->save;
      }
    }

    $self->render('chara/result.pl', {message => "${diplomacy_name}要請を${action}しました。"});
  }

  __PACKAGE__->meta->make_immutable;

}

1;
