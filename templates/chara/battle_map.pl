use Jikkoku;
use Jikkoku::Template;

my $layout = take_in 'templates/layouts/chara.pl';

sub {
  my $args = shift;
  my ($chara, $battle_map) = ($args->{chara}, $args->{battle_map});

  my $show_allies = sub {
    my ($allies) = @_;
    my @allies = @$allies;
    if (@allies) {
      qq{
        <span class="ally">
          <br>味方 (@{[ scalar @allies ]})
          <br>@{[ map { $_->name . ' ' } @allies ]}
        </span>
      };
    } else {
      '';
    }
  };

  my $show_enemies = sub {
    my ($enemies) = @_;
    my @enemies = @$enemies;
    if (@enemies) {
      qq{
        <span class="enemy">
          <br>敵 (@{[ scalar @enemies ]})
          <br>@{[ map { $_->name . ' ' } @enemies ]}
        </span>
      };
    } else {
      '';
    }
  };

  my $button_generator = take_in 'templates/chara/parts/button.pl';
  my $move_button = $button_generator->({
    url   => url_for('/chara/battle-command/move'),
    name  => '移動',
    chara => $chara,
  });

  my $this = sub {
    qq{
      <style>
        .battle-map {
          border-collapse: separate;
          border-spacing: 1px;
        }
        .battle-map th {
          font-size: 13pt;
          padding: 4px;
          color: #fff;
          background-color: #420;
        }
        .battle-map .node {
          color: #fff;
          font-size: 10pt;
          font-weight: bold;
          text-align: center;
          min-width: 60px;
          height: 40px;
        }
        .battle-map .num {
          font-size: 10pt;
          max-width: 15px;
          background-color: #d0c088;
        }
        .ally {
          color: #11d;
        }
        .enemy {
          color: #d11;
        }
      </style>
      <table class="battle-map grid padding-top width-60pc">
        <tbody>
          <tr><th colspan="@{[ $battle_map->width + 1 ]}">@{[ $battle_map->name ]}マップ</th></tr>
          <tr><td class="num">-</td>@{[ map { qq{<td class="num">$_</td>} } 0 .. $battle_map->width - 1 ]}</tr>
    } . do {
      my $output;
      $battle_map->loop(sub {
        my $node = shift;
        $output .= qq{<tr><td class="num">@{[ $node->y ]}</td>\n} if $node->x == 0;
        $output .= qq{
          <td class="node" style="background-color: @{[ $node->color ]}">
            @{[ $node->name ]}
            @{[ $node->is_current ? '<br><span class="red">(現在地)</span>' : '' ]}
            @{[ $node->can_move_direction ? $move_button->({direction => $node->can_move_direction}) : '' ]}
            @{[ $show_allies->( $node->allies ) ]}
            @{[ $show_enemies->( $node->enemies ) ]}
          </td>
        };
        $output .= "</tr>\n" if $node->x == $battle_map->width - 1;
      });
      $output;
    } . qq{
        </tbody>
      </table>

      <div class="grid-right width-40pc padding-top">
        <table class="width-100pc table-@{[ $args->{country}->color_id ]}">
          <tbody>
            <tr>
              <th colspan="4">BMコマンド<br></th>
            </tr>
            <tr>
              <td>兵士</td>
              <td class="middle">
                @{[ $chara->soldier->name ]}(@{[ $chara->soldier->attr ]})
                @{[ $chara->soldier_num ]}人
              </td>
              <td>訓練</td>
              <td class="middle">@{[ $chara->soldier_training ]}</td>
            </tr>
            <tr>
              <td>状態</td>
              <td class="middle"></td>
              <td>士気</td>
              <td class="middle">
                @{[ $chara->morale_data('morale') ]} / @{[ $chara->morale_data('morale_max') ]}
              </td>
            </tr>
            <tr>
              <td>移動P</td>
              <td class="middle">
                @{[ $chara->soldier_battle_map('move_point') ]} / @{[ $chara->soldier->move_point ]}
              </td>
              <td colspan="2" class="middle">
                @{[ $button_generator->({
                  url   => url_for('/chara/battle-command/charge-move-point'),
                  name  => '移動ポイント補充',
                  chara => $chara,
                })->() ]}
              </td>
            </tr>
            <tr>
              <td>行動</td>
              <td colspan="3">
                <select name="battle_command" size="5">
                  <optgroup label="== 戦闘 ==">
                    <option value="">戦闘</option>
                  </optgroup>
                  <optgroup label="== 支援、妨害系 ==">
                  </optgroup>
                </select>
              </td>
            </tr>
            <tr>
              <td>待機時間</td>
              <td colspan="3"></td>
            </tr>
            <tr>
              <td>陣形</td>
              <td class="middle"></td>
              <td colspan="2"></td>
            </tr>
            <tr>
              <td colspan="2">BM行動予約</td>
              <td colspan="2">BMを別窓で表示</td>
            </tr>
            <tr>
              <td colspan="4">[戦闘の説明]</td>
            </tr>
          </tbody>
        </table>
      </div>
    };
  };

  $layout->($this, $args);
};

