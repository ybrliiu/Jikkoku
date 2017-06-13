use Jikkoku;
use Jikkoku::Template;

my $layout = take_in 'templates/layouts/chara.pl';

sub {
  my $args = shift;
  my ($chara, $battle_map, $formation, $time, $available_formations)
    = map { $args->{$_} } qw( chara battle_map formation time available_formations );
  my $soldier = $chara->soldier;

  push @{ $args->{JS_FILES} }, (
    'jikkoku/timer/timer',
    'jikkoku/timer/timer-manager',
  );

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
    url   => url_for('/chara/battle-action/move'),
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
          min-width: 40px;
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
    } . do {
    qq{
      <div class="grid-right width-40pc padding-top">
        <table class="width-100pc table-@{[ $args->{country}->color_id ]}">
          <tbody>
            <tr>
              <th colspan="4">BMコマンド<br></th>
            </tr>
            <tr>
              <td>兵士</td>
              <td class="middle">
                @{[ $soldier->name ]}(@{[ $soldier->attr ]})
                @{[ $soldier->num ]}人
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
                @{[ $soldier->move_point ]} / @{[ $soldier->max_move_point ]}
              </td>
    } . do {
      my $sub = $soldier->move_point_charge_time - $time;
      qq{
              <td colspan="2" class="middle @{[ $sub > 0 ? 'timer' : '' ]}">
      } . do {
        if ($sub > 0) {
          qq{
                <span class="show-time">
                  後 <span class="time">$sub</span> 秒で補充可能です
                </span>
          };
        }
      };
    } . qq{
                @{[ $button_generator->({
                  url   => url_for('/chara/battle-action/charge-move-point'),
                  name  => '移動ポイント補充',
                  chara => $chara,
                  class => ['hidden-contents'],
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
    } . ( join "\n", map {
      qq{
            <tr>
              <td>@{[ $_->target_bm_name ]}へ</td>
              <td colspan="3">
                @{[ $button_generator->({
                  url   => url_for('/chara/battle-action/' . ($battle_map->is_castle_around_map ? 'exit' : 'entry')),
                  name  => $battle_map->is_castle_around_map ? '出城' : '入城',
                  chara => $chara,
                })->({
                  check_point_x => $_->x,
                  check_point_y => $_->y,
                }) ]}
              </td>
            </tr>
      };
    } @{ $args->{adjacent_check_points } } ) . qq{
            <tr>
              <td>待機時間</td>
              <td colspan="3"></td>
            </tr>
            <tr>
              <td>陣形</td>
              <td class="middle">@{[ $formation->name ]}</td>
              <td colspan="2">@{[ $formation->description ]}</td>
            </tr>
            <tr>
              <td>陣形変更</td>
              <form action="@{[ url_for '/chara/battle-action/change-formation' ]}" method="POST">
              <td>
                <select name="formation-id">
                  @{[ map {
                    qq{<option value="@{[ $_->id ]}">@{[ $_->name ]}</option>\n}
                  } @$available_formations ]}
                </select>
              </td>
    } . do {
      my $reforming_time = $soldier->change_formation_time - $time;
      qq{
              <td colspan="2" class="middle @{[ $reforming_time > 0 ? "timer" : "" ]}">
                <input type="hidden" name="id" value="@{[ $chara->id ]}">
                <input type="hidden" name="pass" value="@{[ $chara->pass ]}">
      } . do {
        if ($reforming_time > 0) {
          qq{
                <span class="show-time">
                  陣形変更が可能になるまで後
                  <span class="time">@{[ $reforming_time ]}</span>
                  秒
                </span>
          }
        }
      }
    } . qq{
                <input class="hidden-contents" type="submit" value="変更">
              </td>
              </form>
            </tr>
            <tr>
              <td>BM行動予約</td>
              <td class="middle">
                @{[ $button_generator->({
                  url   => '',
                  name  => '表示',
                  chara => $chara,
                })->() ]}
              </td>
              <td class="middle">BM自動モード : OFF</td>
              <td class="middle">
                @{[ $button_generator->({
                  url   => '',
                  name  => 'ONにする',
                  chara => $chara,
                })->() ]}
              </td>
            </tr>
            <tr>
              <td colspan="4">[戦闘の説明]</td>
            </tr>
          </tbody>
        </table>
      </div>
    } } . q{
      <script>
        "use strict";
        (function () {
          var timerManager = new jikkoku.timer.TimerManager();
          timerManager.registFunctions();
          timerManager.init();
          timerManager.loop();
        }());
      </script>
    };
  };

  $layout->($this, $args);
};

