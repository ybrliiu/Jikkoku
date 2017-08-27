package Jikkoku::Service::State::AdjustBattleActionSuccessRatio::TakeBonusForGiver {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Class::Chara::ExtChara;

  has 'state'       => ( is => 'ro', does => 'Jikkoku::Class::State::State', required => 1 );
  has 'chara_model' => ( is => 'ro', isa => 'Jikkoku::Model::Chara', required => 1 );

  sub exec {
    my $self = shift;
    my $state = $self->state;
    $self->chara_model->get_with_option($state->giver_id)->match(
      Some => sub {
        my $_giver = shift;
        my $giver  = Jikkoku::Class::Chara::ExtChara->new(chara => $_giver);
        $giver->lock;
        eval {
          $giver->contribute( $giver->contribute + $state->increase_giver_contribute_num );
          $giver->book_power( $giver->book_power + $state->increase_giver_book_power_num );
        };
        if (my $e = $@) {
          $giver->abort;
          my $log = Jikkoku::Exception->caught($e) ? $e->message : $e;
          $giver->save_battle_log($log);
        } else {
          $giver->commit;
          my $chara = $state->chara;
          my $log   = "【@{[ $state->name ]}】@{[ $giver->name ]}の付与した@{[ $state->name ]}が効果を発動しました。"
                    . qq{貢献値+<span class="red">@{[ $state->increase_giver_contribute_num ]}</span>、}
                    . qq{書物威力+<span class="red">@{[ $state->increase_giver_book_power_num ]}</span>};
          $giver->save_battle_log($log);
        }
      },
      # キャラデータが見つからないときは状態掛けた人に何もせず終了
      None => sub { warn "ID : @{[ $state->giver_id ]} のキャラデータが見つかりませんでした" },
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

