#!/usr/bin/perl

# 国情報

use Time::HiRes;
my $start_time;
BEGIN { $start_time = Time::HiRes::time; }

require './ini_file/index.ini';
require 'suport.pl';

use lib './lib', './extlib';
use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use Jikkoku::Model::Chara;
use Jikkoku::Model::Country;
use Jikkoku::Model::Town;
use Jikkoku::Model::GameDate;

if($MENTE) { ERR("メンテナンス中です。しばらくお待ちください。"); }
TOP();

sub TOP {

  my $cgi = CGI->new;
  my $chara_model = Jikkoku::Model::Chara->new;

  my $chara = $chara_model
    ->get_with_option( $cgi->param('id') )
    ->match(
      Some => sub { $_ },
      None => sub { ERR2("ID, もしくは パスワードが間違っています。") },
    );
  ERR2("ID, もしくはパスワードが間違っています。") unless $chara->check_pass( $cgi->param('pass') );

  my $country_model   = Jikkoku::Model::Country->new;
  my $country         = $country_model
                          ->get_with_option( $chara->country_id )
                          ->get_or_else( $country_model->neutral );
  my $town_model      = Jikkoku::Model::Town->new;
  my $town            = $town_model->get( $chara->town_id );
  my $game_date_model = Jikkoku::Model::GameDate->new;
  my $game_date       = $game_date_model->get;

  my $charactors = $chara_model->get_all;
  $town_model->set_all_stay_charactors( $charactors, $chara->country_id );

	my $t_list = "<TR><TH>都市</TH><TH>農民</TH><TH>農業</TH><TH>商業</TH><TH>技術力</TH><TH>城</TH><TH>城壁耐久力</TH><TH>迂回阻止度</TH><TH>民忠</TH><TH>相場</TH><TH>滞在武将</TH><TH>城の守備</TH></TR>";

  my $towns = $town_model->get_all;
  my @def_list;
  for my $town (@$towns) {

		if ($town->country_id eq $chara->country_id) {

      #バトルマップ読み込み
      require "./log_file/map_hash/" . $town->id . ".pl";

			KILL: for (my $y = 0; $y < $BM_Y; $y++) {
				for (my $x = 0; $x < $BM_X; $x++) {
					if ( $BM_TIKEI[$y][$x] == 18 ) {
						foreach (@$charactors) {
							if ( $_->is_soldier_same_position( $town->id, $x, $y ) ) {
							  $def_list[$town->id] .= $_->name . '(' . $_->soldier_num . ') ';
							}
						}
					  last KILL;
					}
				}
			}

		$t_list .= << "EOM";
<TR>
  <Th>@{[ $town->name ]}</Th>
  <TD>@{[ $town->farmer ]}/@{[ $town->farmer_max ]}</TD>
  <TD>@{[ $town->farm ]}/@{[ $town->farm_max ]}</TD>
  <TD>@{[ $town->business ]}/@{[ $town->business_max ]}</TD>
  <TD>@{[ $town->technology ]}/@{[ $town->MAX_TECHNOLOGY ]}</TD>
  <TD>@{[ $town->wall ]}/@{[ $town->wall_max ]}</TD>
  <TD>@{[ $town->wall_power ]}/@{[ $town->wall_power_max( $game_date->elapsed_year ) ]}</TD>
  <TD>@{[ $town->stop_around_degree( $game_date->elapsed_year ) ]}% (足止め効果 : @{[ $town->stop_around_move_time(  $game_date->elapsed_year, $BMT_REMAKE ) ]}秒)</TD>
  <TD>@{[ $town->loyalty ]}</TD>
  <TD>@{[ $town->price ]}</TD>
  <TD>(@{[ $town->stay_charactors_num ]}人) @{[ $town->stay_charactors ]}</TD>
  <TD>$def_list[$town->id]</TD>
</TR>
EOM

    }
	}

  # 後で消す
  ($kid, $kpass, $kname) = ($chara->id, $chara->pass, $chara->name);
  $menuneed = 1;
	$b_js = 1;
	&HEADER;
	print <<"EOM";

<style>

#chara-profile {
  display: none;
  position: fixed;
  border: 1px #888888 solid;
  width: 600px;
  height: 400px;
  left:50%;
  top:50%;
  border-radius:8px;
  box-shadow:3px 3px 3px 3px rgba(0,0,0,0.3);
  margin:-200px 0 0 -300px;
}

#chara-profile table, tbody {
  border:0;
  width:100%;
  height:100%;
}
  
#chara-profile-title {
  text-align: right;
  width: 100%;
  height: 5px !important;
}

#chara-profile-load {
  width: 100%;
  height: 100%;
}

#chara-profile-load div {
  box-sizing: border-box;
  width: 100%;
  height: 100%;
  overflow: scroll;
  padding: 5px;
  background-color: rgba(255, 255, 255, 0.6);
}

#chara-profile-load table, tbody {
  width: initial;
  height: initial;
}

</style>

<div id="chara-profile">
  <table>
    <tbody>
      <tr>
        <td id="chara-profile-title">
          <span id="chara-profile-close" class="black"><b>×閉じる</b></span>
        </td>
      </tr>
      <tr><td id="chara-profile-load"></td></tr>
    </tbody>
  </table>
</div> 

EOM
print <<'EOS';
<script src="./public/js/sangoku.js"></script>
<script src="./public/js/sangoku/base.js"></script>
<script>

"use strict";

window.addEventListener('load', function () {

  sangoku.namespace('CharaProfile');

  sangoku.CharaProfile = function () {
    sangoku.base.apply(this, arguments);
  };

  var CLASS = sangoku.CharaProfile;
  sangoku.inherit(sangoku.base, CLASS);

  var PROTOTYPE = CLASS.prototype;

  PROTOTYPE.send = function (args) {
    var self = this;
    $.ajax({
      'url' : args.uri,
      'cache' : false,
      'data' : args.data,
      'contentType' : 'application/x-www-form-urlencoded',
      'type' : 'post',
    }).done(function(data, textStatus, jqXHR) {
      args.doneFunc.call(self, data);
    }).fail(function(jqXHR, textStatus, errorThrown) {
      args.failFunc.apply(self, arguments);
    });
  };

  PROTOTYPE.registFunctions = function () {
    var self = this;
    var charaProfile = document.getElementById('chara-profile');
    var profileField = document.getElementById('chara-profile-load');

    document.getElementById('chara-profile-close').addEventListener(self.eventType('click'), function () {
      charaProfile.style.display = 'none';
    });
    window.addEventListener(self.eventType('click'), function () {
      if (charaProfile.style.display === 'block') {
        charaProfile.style.display = 'none';
      }
    });
    charaProfile.addEventListener(self.eventType('click'), function (eve) {
      eve.stopPropagation();
    });

    Array.prototype.forEach.call(document.getElementsByClassName('show-chara-profile'), function(element) {
      element.addEventListener(self.eventType('click'), function (eve) {
        eve.stopPropagation();
        charaProfile.style.display = 'block';
        charaProfile.style.backgroundColor = "rgba(" + element.dataset.color + "0.7)";
        profileField.innerHTML = '';
        self.send({
          uri : './profile.cgi',
          data : {id : element.dataset.id},
          doneFunc : function (data) {
            console.log(data);
            profileField.innerHTML = data;
          },
          failFunc : function () {},
        });
      });
    });
  };

  var c = new sangoku.CharaProfile();
  c.registFunctions();

});

</script>
EOS
print <<"EOM";

<TABLE WIDTH="100%" height=100% cellpadding="0" cellspacing="0" border=0><tr><td align=center>
<B>@{[ $country->name ]}都市データ</b>：
<TABLE border=0 cellspacing=1 bgcolor="$TABLE_C" class="kaku">
    <TBODY bgcolor=FFFFFF>
$t_list
</TBODY></TABLE>
<BR>
<B>@{[ $country->name ]}役職データ</b>：
<TABLE width=50% border=0 cellspacing=2 bgcolor=$ELE_BG[$country->color_id]>
<TBODY bgcolor=$ELE_C[$country->color_id]>
<tr><th>役職</th><th colspan=2>名前</th></tr>
<tr>
  <th nowrap> - 君主 - </th>
  <th width=100%>
    <span class="show-chara-profile"
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->king_id ]}">
      @{[ $country->king_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->king_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 軍 師 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->strategist_id ]}">
      @{[ $country->strategist_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->strategist_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 宰 相 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->premier_id ]}">
      @{[ $country->premier_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->premier_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 大 将 軍 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->great_general_id ]}">
      @{[ $country->great_general_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->great_general_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 騎 馬 将 軍 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->cavalry_general_id ]}">
      @{[ $country->cavalry_general_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->cavalry_general_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 護 衛 将 軍 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->guard_general_id ]}">
      @{[ $country->guard_general_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->guard_general_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 弓 将 軍 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->archery_general_id ]}">
      @{[ $country->archery_general_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->archery_general_icon ]}.gif"></th>
</tr>
<tr>
  <th nowrap> 将 軍 </th>
  <th>
    <span class="show-chara-profile" 
      data-color="$ELE_RGBA[$country->color_id]" data-id="@{[ $country->infantry_general_id ]}">
      @{[ $country->infantry_general_name ]}
    </span>
  </th>
  <th><img class="icon" src="$IMG/@{[ $country->infantry_general_icon ]}.gif"></th>
</tr>
</tbody>
</table>


</TD></TR>
</TBODY></TABLE>
<center>
<BR>
<form action="$FILE_STATUS" method="post">
  <input type=hidden name=id value="@{[ $chara->id ]}">
  <input type=hidden name=pass value="@{[ $chara->pass ]}">
  <input type=hidden name=mode value=STATUS>
  <input type=submit id=input value="街へ戻る">
</form>

</TD></TR>
</TBODY></TABLE>

EOM

printf("%0.3f",Time::HiRes::time - $start_time);

	&FOOTER;
	exit;

}
