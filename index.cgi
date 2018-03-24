#!/home/sandbox/.plenv/shims/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################

require './ini_file/index.ini';
require './suport.pl';
require './check_com.cgi';

use lib './lib', './extlib';
use CGI::Carp qw/fatalsToBrowser/;
use Jikkoku::Util qw/open_data save_data/;
use Jikkoku::Model::Announce;

if($MENTE) { &ERR2("めんてなんすちう"); }
&DECODE;
$date = time();

#スマホレイアウト（げっそり） トップ画面のテーブル左右比率をPCと変えます
if($agent =~ /iPhone/ || $agent =~ /iPod/ || $agent =~ /Android/){
  $TOPRIGHT = "35%";
  $TOPLEFT  = "65%";
}else{
  $TOPRIGHT = "20%";
  $TOPLEFT  = "80%";
}

#更新時間、BM行動可能時間
$timemess = "<b>更新時間、BM行動可能時間：19:00～24:59</b>";

my $announce_model = Jikkoku::Model::Announce->new;
$sirase = join( '', map {
  qq{
    <hr class="kugiri">                                                                   
    <table cellspacing="0">
      <tr>
        <td style="vertical-align: top; margin-right: 5px;">
          ●@{[ $_->time ]}
        </td>
        <td>@{[ $_->message ]}</td>
      </tr>
    </table>
  }
} @{ $announce_model->get_all } );
$sirase .= qq{
  <hr class="kugiri">
  <table cellspacing="0">
    <tr>
      <td></td>
      <td>・これ以上前のお知らせは<a href="003.html" target="_blank">こちら</a>。</td>
    </tr>
  </table>
  <hr class="kugiri">
};

#_/_/_/_/_/_/_/_/_/#
#_/  INDEX画面   _/#
#_/_/_/_/_/_/_/_/_/#

&INDEX;

sub INDEX {

  $month_read = "$LOG_DIR/date_count.cgi";
  open(IN,"$month_read") or &ERR2("Can\'t file open!:month_read");
  @MONTH_DATA = <IN>;
  close(IN);
  &TIME_DATA;

  open(IN,"$MAP_LOG_LIST");
  @S_MOVE = <IN>;
  close(IN);
  $p=0;
  while($p<11){$S_MES .= "<font color=008800>●</font>$S_MOVE[$p]<BR>";$p++;}

  open(IN,"$MAP_LOG_LIST2");
  @S_MOVE = <IN>;
  close(IN);
  $p=0;
  while($p<11){$D_MES .= "<font color=000088>●</font>$S_MOVE[$p]<BR>";$p++;}

  $hit = 0;
  @month_new=();

  ($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
  $old_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);

  if($ACT_LOG){
    $actfile = "$LOG_DIR/act_log.cgi";
    open(IN,"$actfile");
    @ACT_DATA = <IN>;
    close(IN);
    ($qsec,$qmin,$qhour,$qday) = localtime($date);
    $p=0;
    while($p<5){$A_MES .= "<font color=880000>●</font>$ACT_DATA[$p]<BR>";$p++;}
    $ACT_MES = "<TR><TD bgcolor=#EFE0C0 colspan=\"2\" width=80% height=20><font color=#8E4C28 size=2>$A_MES</font></TD></TR>";

  }

  open(IN,"$TOWN_LIST") or &ERR2('Can\'t file open!:month_read:TOWN_LIST');
  @TOWN_DATA = <IN>;
  close(IN);
  ($zwname,$wzc)=split(/<>/,$TOWN_DATA[0]);
  $zzhit=0;
  foreach(@TOWN_DATA){
    ($zwname,$zwcon)=split(/<>/);
    if($wzc ne $zwcon){$zzhit=1;}
    $wzc = $zwcon;
  }


  #25時～19時更新停止処理ファイル読み込み
  my $stop_update_date = open_data("./log_file/stop_con.cgi");
  my $stopcount = $stop_update_date->[0];


  # PLAYER DATA UPDATE
  &CHECK_COM;


  # PLAYER DATA BACKUP
  $btime = time ;
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime(time);

  my $count_data = open_data("./log_file/b_con.cgi");
  $count = $count_data->[0];

  if($hour == 21 && !$count){
    require './backup.pl';
    &BACKUP;
  }elsif($hour == 0 && !$count){
    require './backup.pl';
    &BACKUP;
  }elsif($hour != 21 && $hour != 0 && $count){
    $count = 0;
    save_data("./log_file/b_con.cgi", [$count]);
  }

  # 時間制限
  if($hour < 19 && $hour >= 1){
  $timemess .= "<br><font color=red>現在は更新時間外、BM上で行動可能な時間帯外です。</font>";
  }

  # MASTER DATA UPDATE
  if ($mtime + $TIME_REMAKE < $date) {

      if($stopcount == 18){
        $stopcount=0;
      }

      $stopcount++;

      if ($stopcount < 18) {  #25時～19時更新停止処理
        $mtime += $TIME_REMAKE;
      } else {
        $mtime += $TIME_REMAKE*55;
      }

      save_data("./log_file/stop_con.cgi", [$stopcount]);

    $mmonth++;
    if($mmonth > 12){
      $myear++;
      $mmonth=1;
    }
    unshift(@month_new,"$myear<>$mmonth<>$mtime<>\n");
    if($ACT_LOG){
      ($qsec,$qmin,$qhour,$qday) = localtime($mtime);
      unshift(@ACT_DATA,"===============\[$myear年$mmonth月\]=================\n");
    }

    open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
    @COU_DATA = <IN>;
    close(IN);
    @NEW_COU_DATA=();
    foreach(@COU_DATA){
      ($xvcid,$xvname,$xvele,$xvmark,$xvking,$xvmes,$xvsub,$xvpri)=split(/<>/);
      $xvmark++;
      push(@NEW_COU_DATA,"$xvcid<>$xvname<>$xvele<>$xvmark<>$xvking<>$xvmes<>$xvsub<>$xvpri<>\n");
    }
    open(OUT,">$COUNTRY_LIST") or &ERR2('COUNTRY データを書き込めません。');
    print OUT @NEW_COU_DATA;
    close(OUT);

    $b_hit = 0;
    if($mmonth eq "1"){
      &MAP_LOG("$mmonth月:<font color=orange>税金</font>で各武将に給与が支払われました。");
      $b_hit = 1;
    }elsif($mmonth eq "7"){
      &MAP_LOG("$mmonth月:<font color=orange>収穫</font>で各武将に米が支払われました。");
      $b_hit = 1;
    }

    # EVENT ACTION
    $eve_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
    $ihit=0;
    if(!int(rand(60))){
      $ihit=1;
      $ino = int(rand(6));
      if($ino eq 0){
        &MAP_LOG("<font color=red>【イベント】</font>\[$eve_date\]いなごの大群が畑を襲いました！");
        &MAP_LOG2("<font color=red>【イベント】</font>\[$eve_date\]いなごの大群が畑を襲いました！");
      }elsif($ino eq 1){
        &MAP_LOG("<font color=red>【イベント】</font>\[$eve_date\]洪水がおこりました！各地で被害が出ています！");
        &MAP_LOG2("<font color=red>【イベント】</font>\[$eve_date\]洪水がおこりました！各地で被害が出ています！");
      }elsif($ino eq 2){
        &MAP_LOG("<font color=red>【イベント】</font>\[$eve_date\]疫病が流行っているようです。街の人々も苦しんでいます。。");
        &MAP_LOG2("<font color=red>【イベント】</font>\[$eve_date\]疫病が流行っているようです。街の人々も苦しんでいます。。");
      }elsif($ino eq 3){
        &MAP_LOG("<font color=red>【イベント】</font>\[$eve_date\]今年は豊作になりそうです。");
        &MAP_LOG2("<font color=red>【イベント】</font>\[$eve_date\]今年は豊作になりそうです。");
      }elsif($ino eq 4){
        &MAP_LOG("<font color=red>【イベント】</font>\[$eve_date\]大地震がおこりました！");
        &MAP_LOG2("<font color=red>【イベント】</font>\[$eve_date\]大地震がおこりました！");
      }elsif($ino eq 5){
        &MAP_LOG("<font color=red>【イベント】</font>\[$eve_date\]各町の商店が賑わっています。");
        &MAP_LOG2("<font color=red>【イベント】</font>\[$eve_date\]各町の商店が賑わっています。");
      }
    }
    if($b_hit){
      @NEW_TOWN_DATA=();$zi=0;
      foreach(@TOWN_DATA){
        ($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/);

        $stwon[$zcon]++;

        # 相場変動
        if(!int(rand(2.0))){
          $zsouba += int(rand(0.5)*100)/100;
          if($zsouba > 1.2){
            $zsouba = 1.2;
          }
        }else{
          $zsouba -= int(rand(0.5)*100)/100;
          if($zsouba < 0.8){
            $zsouba = 0.8;
          }
        }
        if($zpri >= 50){
          $znum_add = int(80 * ($zpri - 50));
          if($znum_add < 500){$znum_add=500;}
          $znum += $znum_add;
          if($znum > $zsub2){$znum=$zsub2;}
        }else{
          $znum -= int(70 * (50 - $zpri));
          if($znum < 0){$znum=0;}
        }
        # EVENT
        if($ihit){
          if($ino eq 0){
            $znou = int($znou * 0.9);
          }elsif($ino eq 1){
            $znou = int($znou * 0.95);
            $zsyo = int($zsyo * 0.95);
            $zshiro = int($zshiro * 0.95);
          }elsif($ino eq 2){
            $znum = int($znum * 0.9);
          }elsif($ino eq 3){
            $znou = int($znou * 1.1);
            if($znou > $znou_max){$znou=$znou_max;}
          }elsif($ino eq 4){
            $znou = int($znou * 0.95);
            $zsyo = int($zsyo * 0.95);
            $zshiro = int($zshiro * 0.95);
            $znum = int($znum * 0.95);
          }elsif($ino eq 5){
            $zsyo = int($zsyo * 1.1);
            if($zsyo > $zsyo_max){$zsyo=$zsyo_max;}
            $znum = int($znum * 1.1);
            if($znum > $zsub2){$znum=$zsub2;}
          }
        }

          if($zpri < 16 && $zshiro < 1 && $stwon[$zcon] > 1){
            if ( int(rand 20) == 1 ) {
            $zcon = 0;
            $zshiro = $zshiro_max;
            &MAP_LOG("<font color=\"#666666\">【反乱】</font>\[$eve_date\]$znameは農民の反乱軍に支配されました。");
            &MAP_LOG2("<font color=\"#666666\">【反乱】</font>\[$eve_date\]$znameは農民の反乱軍に支配されました。");

            require './lib/noumin_npc.pl';
            &NOUMIN_NPC;
            }
          }

      $zi++;
      push(@NEW_TOWN_DATA,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
      }
      &SAVE_DATA($TOWN_LIST,@NEW_TOWN_DATA);
    }
    &SAVE_DATA($month_read,@month_new);
  }
  if($ACT_LOG){
    if(@ACT_DATA > 800) { splice(@ACT_DATA,800); }
    open(OUT,">$actfile");
    print OUT @ACT_DATA;
    close(OUT);
  }

  $MESS2 = "<A href=\"$FILE_ENTRY\">【新規登録】</a>";
  if($OSIRASE){$osiment = OSIRASE;}else{$osiment = STATUS;}
  &COUNTER;
  $new_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
  $next_time = int(($mtime + $TIME_REMAKE - $date) / 60);


  #ログイン人数
  my @login_list = @{ open_data($GUEST_LIST) };
  @login_list = map {
    my ($time, $name, $country, $opos) = split /<>/, $_;
    if ($date - 180 > $time) {
      ();
    } else {
      "$time<>$name<>$country<>$opos<>\n";
    }
  } @login_list;
  save_data($GUEST_LIST, \@login_list);


  $ksettei = "";

  &GET_COOKIE;

  $meta = 1;
  &HEADER;

  print <<"EOM";
<table WIDTH="100%" cellpadding="0" cellspacing="0" border="0" style="margin-top: 5px">
<tr><td valign="top" align="left">[<a href=./i-index.cgi>携帯用</a>]</td><td align="right">

  <!-- twitter -->
  <a href="https://twitter.com/share" class="twitter-share-button">Tweet</a>
  <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

  <!-- hatena! -->
  <a href="http://b.hatena.ne.jp/entry/lunadraco.sakura.ne.jp/sangokuframe/index.cgi" class="hatena-bookmark-button" data-hatena-bookmark-title="十国志NET" data-hatena-bookmark-layout="simple-balloon" title="このエントリーをはてなブックマークに追加"><img src="https://b.st-hatena.com/images/entry-button/button-only@2x.png" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="https://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>

  <!-- google plus -->
  <script src="https://apis.google.com/js/platform.js" async defer>
    {lang: 'ja'}
  </script>
  <div class="g-plusone" data-size="medium"></div>

  <!-- twitter link -->
  <a href="https://twitter.com/jikkokunet" class="twitter-follow-button" data-show-count="false">Follow \@jikkokunet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>

</td></tr></table>

<CENTER>
<TABLE WIDTH="100%" height=100% cellpadding="0" cellspacing="0" border=0><tr><td align=center valign=top>
<br>
<br>
<TABLE border=0 width=90% height=100% cellspacing=1><TBODY>
<TR><TD align=center width=$TOPRIGHT>


<table cellspacing=5 class="midasi2"><tr><td align="center">
■メニュー■</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="$HOME_URL">【$HOME】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●$MESS2　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="$BBS1_URL" target="_blank">【$BBS1】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="$FILE_RANK" target="_blank">【登録武将一覧】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="$LINK2_URL" target="_blank">【$LINK2】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="./graph.cgi" target="_blank">【国力比較】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="./map.cgi" target="_blank">【勢力図】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="./manual.html" target="_blank">【説明書】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="./REKISI/index.html" target="_blank">【歴代統一国】</A>　</td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="https://github.com/ybrliiu/Jikkoku/blob/master/spec_change_log.md" target="_blank">【改造履歴】</A></td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="../sangokuframe2/index.cgi" target="_blank">【テスト面】</A></td></tr>
<tr><td bgcolor="#ffffff" class="maru2">●<A href="http://www9.atwiki.jp/jikkokusinet/pages/1.html" target="_blank">【十国志NETwiki】</A></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center">ログイン人数：@{[ scalar @login_list ]}人</font></td></tr>
<tr><td align="center">最大登録人数($ENTRY_MAX人)</font></td></tr>
</tr></td></table>
<br>
<br>


<table bgcolor=#6d614a align=center border=0><form action="$FILE_STATUS" method="POST">
<input type="hidden" name="mode" value="$osiment">
<TR><TH bgcolor=$TD_C2 height=5>USER ID</TH><td><input type="text" size="10" name="id" value="$_id"></td></TR>
<TR><TH bgcolor=$TD_C2 height=5>PASS WORD</tH><td><input type="password" size="10" name="pass" value="$_pass"></TD></TR>
<TR><td colspan="2" align="left"><input type=\"checkbox\" name=\"cookie\" value=\"yes\">ID、パスワードを保存する</td></TR>
<TR><td bgcolor=#cbba9e align=center colspan=2><input type="submit" id="input" value="ログイン"></td></tr></form>
<TR><td align="center" bgcolor=$TD_C2 colspan="2"><a href="./idpw.cgi">【ID、パスワードを忘れた方】</a></th></TR>
</table>




</TD><TD align=center width=$TOPLEFT>
<p><TABLE width=95% height=140 bgcolor=#6d614a>
<TR><TD align=center bgcolor=#cbba9e><h1><br><font color=#6d614a>$GAME_TITLE</font></h1><p><h2><font color=#6d614a>$KI</font></h2>

<br>$timemess<br>

<br><font size=2 color=#6d614a><B>[$new_date]</b><BR>次回の更新まで <B>$next_time</B> 分<BR></font>

<br>
<table><tbody>
<TR><TD><div class="midasi4"><b><font size="2">&nbsp;お知らせ</b></font></div></TD></TR>
<tr><td class="osirase2">
<div class="osirase">
$sirase
</div>
</td></tr></tbody></table>
<br>

</TD></TR></TABLE>

</TD></TR>
<TR><TD colspan="2" align=center valign="top" width=100%>

<br>
<TABLE width=100% BGCOLOR=$TD_C2 cellspacing=1 id="small"><TBODY>$mess</TBODY></TABLE>
<table width=90%><TR><TD>
<CENTER><HR size=0><p align=right>[<font color=8E6C68>TOTAL ACCESS<font color=red><B> $total_count </font></B>HIT</font>]</p>
</TD></TR>
<TR><TD colspan="2"><div class="midasi3"><b><font size="2">&nbsp;MAP LOG</b></font></div></TD></TR>
<TR><TD bgcolor=#cbba9c colspan="2" width=80% height=20 class="maru"><font color=#6d614a size=2>$S_MES</font></TD></TR>
<TR><TD colspan="2"><div class="midasi3"><b><font size="2">&nbsp;史記</font></div></b></TD></TR>
<TR><TD bgcolor=#cbba9c colspan="2" width=80% height=20 class="maru"><font color=#6d614a size=2>$D_MES</font></TD></TR>
$ACT_MES</table>
<br>
<br>
</TBODY></TABLE>
</TR></TD></TABLE>
</TR></TD></TABLE>

<form method=post action=./admin.cgi>
ID:<input type=text name=id size=7>
PASS:<input type=password name=pass size=7>
<input type=submit id=input value=管理者>
</form>

EOM

  &FOOTER;
  exit;

}
# _/_/_/_/_/_/_/_#
# 即席カウンター #
# _/_/_/_/_/_/_/_#
sub COUNTER {

  $file_read = "$LOG_DIR/counter.cgi";
  open(IN,"$file_read") or &ERR2('ファイルを開けませんでした。');
  @reading = <IN>;
  close(IN);

  ($total_count) = split(/<>/,$reading[0]);
  $total_count++;

  &SAVE_DATA("$file_read","$total_count");
}

