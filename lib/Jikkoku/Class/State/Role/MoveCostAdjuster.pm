package Jikkoku::Class::State::Role::MoveCostAdjuster {

  use Mouse::Role;
  use Jikkoku;
  use Scalar::Util;

  with 'Jikkoku::Class::BattleMap::Node::MoveCostAdjuster';

  # attributes
  requires qw( increase_giver_contribute_num increase_giver_book_power_num );

  # 削除予定
  sub take_bonus_for_giver {
    my ($self, $chara_model) = @_;
    $chara_model->get_with_option($self->giver_id)->match(
      Some => sub {
        my $giver = shift;
        $giver->lock;
        eval {
          $giver->contribute( $giver->contribute + $self->increase_giver_contribute_num );
          $giver->book_power( $giver->book_power + $self->increase_giver_book_power_num );
        };
        if (my $e = $@) {
          $giver->abort;
          my $log = Scalar::Util::blessed($e) ? $e->message : $e;
          $giver->save_battle_log($log);
        } else {
          $giver->commit;
          my $chara = $self->chara;
          my $log   = "【@{[ $self->name ]}】@{[ $giver->name ]}の付与した@{[ $self->name ]}が効果を発動しました。"
                    . qq{貢献値+<span class="red">@{[ $self->increase_giver_contribute_num ]}</span>、}
                    . qq{書物威力+<span class="red">@{[ $self->increase_giver_book_power_num ]}</span>};
          $giver->save_battle_log($log);
        }
      },
      # キャラデータが見つからないときは状態掛けた人に何もせず終了
      None => sub { warn "ID : @{[ $self->giver_id ]} のキャラデータが見つかりませんでした" },
    );
  }

}

1;
