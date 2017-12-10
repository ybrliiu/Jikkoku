#_/_/_/_/_/_/_/_/#
#     布告      #
#_/_/_/_/_/_/_/_/#

use Storable qw/dclone/;
use Jikkoku::Model::Chara;
use Jikkoku::Model::GameDate;
use Jikkoku::Model::Country;
use Jikkoku::Model::Diplomacy;

sub HUKOKU {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN($kcon);
	&TIME_DATA;

	foreach(@COU_DATA){
	($xcid2,$xname2,$xele2,$xmark2,$xking2,$xmes2,$xsub2,$xpri2)=split(/<>/);
		if($xcid2 ne $kcon){
		$list .= "<option value=$xcid2>$xname2";
		}
	}

  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara       = $chara_model->get( $kid );

	#年月表示(form)
  my $game_date = Jikkoku::Model::GameDate->new->get;

  my $declare_war_game_date = dclone $game_date;
  $declare_war_game_date += Jikkoku::Class::Diplomacy::DeclareWar->REQUIRED_MONTH;
  for (0 .. 53) {
    $hlist .= qq{<option value="@{[ $declare_war_game_date->elapsed_year ]},@{[ $declare_war_game_date->month ]}">}
      . qq{@{[ $declare_war_game_date->date ]}</option>};
    $declare_war_game_date++;
	}

  my $short_game_date = dclone $game_date;
  for (0 .. Jikkoku::Class::Diplomacy::DeclareWar->REQUIRED_MONTH - 1) {
    $tlist .= qq{<option value="@{[ $short_game_date->elapsed_year ]},@{[ $short_game_date->month ]}">}
      . qq{@{[ $short_game_date->date ]}</option>};
    $short_game_date++;
  }

  my $country_model   = Jikkoku::Model::Country->new;
  my $country         = $country_model->get_with_option( $kcon )->get_or_else( $country_model->neutral );
  my $diplomacy_model = Jikkoku::Model::Diplomacy->new;
  my $diplomacy_list  = $diplomacy_model->get_by_country_id( $country->id );

	&HEADER;
	print <<"EOM";
<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 外交関連操作 - </font>
</TH></TR>
<TR><TD>

<TABLE bgcolor=$ELE_BG[$xele]><TBODY bgcolor=$ELE_C[$xele]>
<TR><TH colspan=7 bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>$kname</font></TH></TR>

<TR><TD rowspan=2 width=5><img src=$IMG/$kchara.gif width="64" height="64"></TD><TD>武力</TD><TH>$kstr</TH><TD>知力</TD><TH>$kint</TH><TD>統率力</TD><TH>$klea</TH></TR>
<TR><TD>金</TD><TH>$kgold</TH><TD>米</TD><TH>$krice</TH><TD>貢献</TD><TH>$kcex</TH></TR>
<TR><TD>所属国</TD><TH colspan=2>@{[ $country->name ]}</TH><TD>兵士</TD><TH>$ksol</TH><TD>訓練</TD><TH>$kgat</TH></TR>
</TBODY></TABLE>
</TD></TR>
<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
<font color=white><b>現在:@{[ $game_date->date ]}</b><br>
宣戦布告や、外交関連の操作が行えます。<br>
※いずれの操作も、実行したときに相手国の国宛に通知されます。</font><br>
</TD></TR></TABLE>
</TD></TR>
<TR><TD>

<TABLE bgcolor=$TABLE_C width="100%"><TBODY bgcolor=$TD_C4>

<TR>
  <TH bgcolor=$TABLE_C colspan="5"><font color="#FFFFFF">操作</font></TH>
</TR>
<form action="jikkoku.cgi/chara/country/headquarters/diplomacy/request/declare-war" method="POST">
  <input type=hidden name=to value=0>
  <TR>
    <TH>宣戦布告</TH>
    <TD>対象国:
      <select name=cou>$list</select>
    </TD>
    <TD>開戦年月:
      <select name=sel>$hlist</select>
    </TD>
    <TD>布告文:
      <input type=text name=sei size=45>
    </TD>
    <TH>
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <input type=submit id=input value=\"実行\">
    </TH>
  </TR>
</form>
<TD colspan=5 bgcolor=$TD_C4>
  <font color=red>・宣戦布告を行わないと他国と戦争ができません。
    <br>・宣戦布告は開戦の37ヶ月以上前からしか行えません。
  </font>
  <br>・布告を取り消したい場合は停戦要請を行って下さい。
  <br>・布告返しも可能です。布告返しした際に、相手国から受けた布告よりも早い年月を指定すると、
  戦争開始年月が早い年月の方に変更されます。
</TD>
<form action="jikkoku.cgi/chara/country/headquarters/diplomacy/request/short-declare-war" method=\"post\">
  <input type=hidden name=to value=1>
  <TR>
    <TH>短縮布告(要請)</TH>
    <TD>対象国:
      <select name=cou>$list</select>
    </TD>
    <TD>開戦年月:
      <select name=sel>$tlist</select>
    </TD>
    <TD>布告文:
      <input type=text name=sei size=45>
    </TD>
    <TH>
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <input type=hidden name=mode value=SENSEN>
      <input type=submit id=input value=\"実行\">
    </TH>
  </TR>
</form>
<TD colspan=5 bgcolor=$TD_C4>
  <font color=red>※事前に相手国と相談してから使用してください。</font><br>
  ・宣戦布告から開戦までの猶予時間を37ヶ月未満にして戦争をしたい時はこちらから要請をだしてください。<br>
  　相手国が了承すれば、宣戦布告から開戦までの猶予時間を短縮して開戦できます。<br>
  ・布告を取り消したい場合は停戦要請を行って下さい。<br>
  ・既に要請を出した国にもう一度要請を送れば、要請はキャンセルされます。
</TD>
<form action="jikkoku.cgi/chara/country/headquarters/diplomacy/request/cease-war" method=\"post\">
  <input type=hidden name=to value=2>
  <input type=hidden name=no value=0>
  <TR>
    <TH>停戦要請</TH>
    <TD>対象国:
      <select name=cou>$list</select>
    </TD>
    <TD colspan=2>声明文:
      <input type=text name=sei size=60>
    </TD>
    <TH>
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <input type=hidden name=mode value=SENSEN>
      <input type=submit id=input value=\"実行\">
    </TH>
  </TR>
</form>
<TD colspan=5 bgcolor=$TD_C4>
  <font color=red>※ 事前に相手国と相談してから使用してください。</font><br>
  ・停戦の要請をしたい場合はこちらから。相手国が了承すれば、相手国との交戦状態及び宣戦布告が取り消されます。<br>
  ・既に要請を出した国にもう一度要請を送れば、要請はキャンセルされます。
</TD>
<form action="jikkoku.cgi/chara/country/headquarters/diplomacy/request/cession-or-accept-territory" method=\"post\">
  <input type=hidden name=to value=3>
  <TR>
    <TH>領土割譲・譲受(要請)</TH>
    <TD>対象国:
      <select name=cou>$list</select>
    </TD>
    <TD colspan=2>声明文:
      <input type=text name=sei size=60>
    </TD>
    <TH>
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <input type=hidden name=mode value=SENSEN>
      <input type=submit id=input value=\"実行\">
    </TH>
  </TR>
</form>
<TD colspan=5 bgcolor=$TD_C4>
  <font color=red>※ 事前に相手国と相談してから使用してください。</font><br> 
  ・領土割譲・譲受の要請をしたい場合はこちらから。相手国が了承すれば、領土のやりとりが可能になります。<br>
  　一応相手国との交戦状態になるので、その辺りは注意して下さい。<br>
  ・<font color=red>領土割譲・譲受を利用して相手国の許可がない都市や武将を攻撃することはルール違反で厳しく罰せられます。</font>絶対にしないで下さい。<br>
  ・領土割譲・譲受中は、どちらの国も自由に領土割譲・譲受可能な状態を取り消せます。<br>
  ・既に要請を出した国にもう一度要請を送れば、要請はキャンセルされます。
</TD>
<form action="jikkoku.cgi/chara/country/headquarters/diplomacy/request/allow-passage" method=\"post\">
  <input type=hidden name=to value=4>
  <TR>
    <TH>通行許可(要請)</TH>
    <TD>対象国:
      <select name=cou>$list</select>
    </TD>
    <TD colspan=2>声明文:
      <input type=text name=sei size=60>
    </TD>
    <TH>
      <input type=hidden name=id value=$kid>
      <input type=hidden name=pass value=$kpass>
      <input type=hidden name=mode value=SENSEN>
      <input type=submit id=input value=\"実行\">
    </TH>
  </TR>
</form>
<TD colspan=5 bgcolor=$TD_C4>
  <font color=red>※ 事前に相手国と相談してから使用しましょう。</font><br
  ・他国領土の通行許可がほしい場合はこちらから要請を出してください。相手国が了承すれば、双方とも相手国領土に入れるようになります。<br>
  ・通行許可中は、どちらの国も自由に通行許可を取り消せます。<br>
  ・既に要請を出した国にもう一度要請を送れば、要請はキャンセルされます。
</TD>

</TBODY></TABLE>


<br>
<TABLE bgcolor=$TABLE_C width="100%"><TBODY bgcolor=$TD_C4>

<TR><TH bgcolor=$TABLE_C colspan="2"><font color="#FFFFFF">現在の状況</font></TH></TR>
<tr>
EOM
my $accept_form = sub {
  my ($diplomacy) = @_;
  (my $diplomacy_name = $diplomacy->name_english) =~ s/_/-/g;
  qq{
    <form action="jikkoku.cgi/chara/country/headquarters/diplomacy/accept/$diplomacy_name" method="POST">
      <input type="hidden" name="id" value="@{[ $chara->id ]}">
      <input type="hidden" name="pass" value="@{[ $chara->pass ]}">
      <input type="hidden" name="cou" value="@{[ $diplomacy->request_country_id ]}">
      <input type="radio" name="sen" value="1">許可する
      <input type="radio" name="sen" value="0">断る
      <input type="submit" id="input" value="実行">
    </form>
  };
};
my $withdraw_form = sub {
  my ($diplomacy, $country_id) = @_;
  (my $diplomacy_name = $diplomacy->name_english) =~ s/_/-/g;
  qq{
    <form action="jikkoku.cgi/chara/country/headquarters/diplomacy/withdraw/$diplomacy_name" method="POST">
      <input type="hidden" name="id" value="@{[ $chara->id ]}">
      <input type="hidden" name="pass" value="@{[ $chara->pass ]}">
      <input type="hidden" name="cou" value="@{[ $diplomacy->other_country_id( $country_id ) ]}">
      <input type="submit" id="input" value="@{[ $diplomacy->name ]}を終了する">
    </form>
  };
};
for my $diplomacy (@$diplomacy_list) {
  my $diplomacy_country = $country_model->get( $diplomacy->other_country_id( $country->id ) );
  print <<"EOM";
  <tr>
    <th style="background-color: @{[ $diplomacy_country->color ]}">
      @{[ $diplomacy_country->name ]}
    </th>
    <td>
      @{[ $diplomacy->show_status( $country->id, $country_model ) ]}
EOM
    if ( $diplomacy->can_accept_request( $country->id ) ) {
      print $accept_form->( $diplomacy );
    }
    elsif ( $diplomacy->can_withdraw ) {
      print $withdraw_form->( $diplomacy, $country->id );
    }
print <<"EOM";
    </td>
  </tr>
EOM
}
print <<"EOM";
</tr>
</TBODY></TABLE>
<br>

<form action="./mydata.cgi" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=KING_COM>
<input type=submit id=input value="司令部に戻る"></form>

<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form></CENTER>
</TD></TR></TABLE>
</TD></TR></TABLE>

EOM

	&FOOTER;

	exit;

}
1;
