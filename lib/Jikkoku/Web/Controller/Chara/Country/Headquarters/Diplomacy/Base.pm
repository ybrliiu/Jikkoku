package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara';

  use Jikkoku::Template;

  use constant {
    MESSAGE_MAX_LEN => 240,
  };

  sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    $self->{return_url}  = static_file 'mydata.cgi';
    $self->{return_mode} = 'HUKOKU';

    $self->render_error("無所属には送れません") unless $self->param('cou');
    $self->render_error("メッセージは" . MESSAGE_MAX_LEN / 3 . "文字以内にしてください。")
      if length $self->param('sei') > MESSAGE_MAX_LEN;

    $self->{country_model} = $self->model('Country')->new;
    $self->{country}       = $self->{country_model}->get( $self->{chara}->country_id );

    $self->render_error("君主、軍師、宰相でなければ実行できません。")
      unless $self->{country}->is_chara_headquarters( $self->{chara}->id );

    $self->{diplomacy_model} = $self->model('Diplomacy')->new;
    $self->{letter_model}    = $self->model('Letter')->new;

    $self;
  }

}

1;
