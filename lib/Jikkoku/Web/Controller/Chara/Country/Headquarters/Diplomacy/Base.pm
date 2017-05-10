package Jikkoku::Web::Controller::Chara::Country::Headquarters::Diplomacy::Base {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller::Chara::Base';

  use Jikkoku::Template;

  use constant MESSAGE_MAX_LEN => 240;

  has 'return_url'    => ( is => 'ro', isa => 'Str', default => sub { static_file 'mydata.cgi' } );
  has 'return_mode'   => ( is => 'ro', isa => 'Str', default => 'HUKOKU' );

  has 'country_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Country',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Country')->new;
    },
  );

  has 'country' => (
    is => 'ro',
    isa => 'Jikkoku::Class::Country',
    lazy => 1,
    default => sub {
      my $self = shift;
      $self->country_model
        ->get_with_option( $self->chara->country_id )
        ->get_or_else( $self->country_model->neutral );
    },
  );

  has 'diplomacy_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Diplomacy',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Diplomacy')->new;
    },
  );

  has 'letter_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Letter',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Letter')->new;
    },
  );

  sub BUILD {
    my $self = shift;

    $self->render_error("無所属には送れません") unless $self->param('cou');
    $self->render_error("メッセージは" . MESSAGE_MAX_LEN / 3 . "文字以内にしてください。")
      if length $self->param('sei') > MESSAGE_MAX_LEN;

    $self->render_error("君主、軍師、宰相でなければ実行できません。")
      unless $self->country->is_chara_headquarters( $self->chara->id );

  }

  __PACKAGE__->meta->make_immutable;

}

1;
