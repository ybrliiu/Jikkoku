#_/_/_/_/_/_/_/_/#
#     布告処理    #
#_/_/_/_/_/_/_/_/#

use lib './lib', './extlib';
use Jikkoku::Model::Chara;
use Jikkoku::Model::GameDate;

sub SENSEN {

  &CHARA_MAIN_OPEN;
  &COUNTRY_DATA_OPEN($kcon);
  &TIME_DATA;
  $jyoho="$in{'sel'}";
  $econ="$in{'cou'}";
  ($jyear,$jmonth) = split(/,/,$jyoho);


  if($kcon eq $econ){&ERR("自国です。");}
  if($cou_name[$in{'cou'}] eq ""){&ERR("その国は存在しません。");}
  if($xking ne $kid && $xgunshi ne $kid && $xxsub1 ne $kid){&ERR("王か軍師か宰相でなければ実行できません。");}
  if(length($in{'sei'}) > 240) { &ERR("声明文は80文字以内にして下さい"); }


  if($in{'to'} eq "0"){&NOMAL;}
  elsif($in{'to'} eq "1"){&TANSYUKU;}
  elsif($in{'to'} eq "2"){&TEISEN;}
  elsif($in{'to'} eq "3"){&RYODO;}
  elsif($in{'to'} eq "4"){&TUKO;}
  elsif($in{'to'} eq "5"){&TANSYUKU_KYOKA;}
  elsif($in{'to'} eq "6"){&TEISEN_KYOKA;}
  elsif($in{'to'} eq "7"){&RYODO_KYOKA;}
  elsif($in{'to'} eq "8"){&TUKO_KYOKA;}
  else{&ERR('異常な値です。');}


  #宣戦布告
  sub NOMAL {

    #年月表示
    open(IN,"$LOG_DIR/date_count.cgi") or &ERR('ファイルを開けませんでした。');
    @MONTH_DATA = <IN>;
    close(IN);
    ($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
    $new_date = sprintf("%02d\年%02d\月", $F_YEAR+$myear, $mmonth);
    $wyear=$F_YEAR+$myear;
    $wmonth=$mmonth+37;
    while($wmonth>12){
    $wyear++;
    $wmonth-=12;
    }
    if(($wyear>$jyear)||($wyear==$jyear && $wmonth>$jmonth)){&ERR('開戦時間が異常です。');}


    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($skcon eq $kcon && $secon eq $econ && $stype eq "0" && !$son){
      &ERR('既に宣戦布告しています。');
      }
    }


    unshift(@KOUSEN,"0<>0<>$kcon<>$econ<>$jyear<>$jmonth<>$sub1<>$sub2<>$sub3<>\n");
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);


    if($xking eq "$kid"){
      $rank_mes = "君主";
    }elsif($xgunshi eq "$kid"){
      $rank_mes = "軍師";
    }elsif($xxsub1 eq "$kid"){
      $rank_mes = "宰相";
    }
    &MAP_LOG("<font color=\"#ff6600\"><b>【宣戦布告】</b></font>$cou_name[$kcon]は$cou_name[$econ]へ宣戦布告を行いました！　「$in{'sei'}」　開戦時間:$jyear年$jmonth月（$cou_name[$kcon]$rank_mes：$knameより）");
    &MAP_LOG2("<font color=\"#ff6600\"><b>【宣戦布告】</b></font>$cou_name[$kcon]は$cou_name[$econ]へ宣戦布告を行いました！　「$in{'sei'}」　開戦時間:$jyear年$jmonth月（$cou_name[$kcon]$rank_mes：$knameより））");


    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[宣戦布告]</font>$cou_name[$kcon]は$cou_name[$econ]へ宣戦布告を行いました！　「$in{'sei'}」　開戦時間:$jyear年$jmonth月（$cou_name[$kcon]$rank_mes：$knameより）<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);


    $res_mes = "宣戦布告を出しました。";
  }


  #短縮布告
  sub TANSYUKU{


    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    $si=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($skcon eq $kcon && $secon eq $econ && $stype eq 0 && !$son){
      &ERR('既に宣戦布告しています。');
      }elsif($skcon eq $kcon && $secon eq $econ && $stype eq 0 && $son){
      $s_hit=1;
      $si=$i;
      }
    $i++;
    }


    if($s_hit){
    splice(@KOUSEN,$si,1);
    $res_mes = "短縮布告要請を取り消しました。";
    $t_mes="の短縮布告要請を取り消しました。";
    }else{
    unshift(@KOUSEN,"0<>1<>$kcon<>$econ<>$jyear<>$jmonth<>$in{'sei'}<>$kid<>$kname<>\n");
    $res_mes = "短縮布告要請を出しました。";
    $t_mes="短縮布告要請を行いました。<br>司令部の外交関連操作にてご確認ください。";
    }
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);


    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[短縮布告要請]</font>$cou_name[$kcon]は$cou_name[$econ]へ$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);

  }


  #停戦
  sub TEISEN {

    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    $t_hit=0;
    $si=0;
    foreach (@KOUSEN) {
      ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if ($skcon eq $kcon && $secon eq $econ && $stype eq 1 && $son) {
        $s_hit=1;
        $si=$i;
      } elsif ($skcon eq $kcon && $secon eq $econ && $stype eq 1 && !$son) {
        &ERR('停戦済み。');
      } elsif($secon eq $kcon && $skcon eq $econ && $stype eq 1) {
        &ERR('既に相手国から停戦要請が来ています。');
      } elsif($skcon eq $kcon && $secon eq $econ && $stype eq 0) {
        $t_hit=1;
      } elsif($secon eq $kcon && $skcon eq $econ && $stype eq 0) {
        $t_hit=1;
      }
      $i++;
    }

    if(!$t_hit){&ERR('交戦状態でないか、宣戦布告をしていないので実行できません。');}

    if($s_hit){
      splice(@KOUSEN,$si,1);
      $res_mes = "停戦要請を取り消しました。";
      $t_mes="の停戦要請を取り消しました。";
    }else{
      unshift(@KOUSEN,"1<>1<>$kcon<>$econ<>$jyear<>$jmonth<>$in{'sei'}<>$kid<>$kname<>\n");
      $res_mes = "停戦要請を出しました。";
      $t_mes="停戦要請を行いました。<br>司令部の外交関連操作にてご確認ください。";
    }
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);

    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[停戦要請]</font>$cou_name[$kcon]は$cou_name[$econ]へ$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);

  }


  #領土割譲、譲受
  sub RYODO{


    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    $si=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($skcon eq $kcon && $secon eq $econ && $stype eq 2 && $son){
      $s_hit=1;
      $si=$i;
      }elsif($skcon eq $kcon && $secon eq $econ && $stype eq 2 && !$son){
      &ERR('既に領土割譲、譲受中です。');
      }elsif($secon eq $kcon && $skcon eq $econ && $stype eq 2){
      &ERR('既に相手が領土割譲、譲受要請を出しているか、領土割譲、譲受中です。');
      }
    $i++;
    }


    if($s_hit){
    splice(@KOUSEN,$si,1);
    $res_mes = "領土割譲・譲受要請を取り消しました。";
    $t_mes="の領土割譲・譲受要請を取り消しました。";
    }else{
    unshift(@KOUSEN,"2<>1<>$kcon<>$econ<>$jyear<>$jmonth<>$in{'sei'}<>$kid<>$kname<>\n");
    $res_mes = "領土割譲・譲受要請を出しました。";
    $t_mes="領土割譲・譲受要請を行いました。<br>司令部の外交関連操作にてご確認ください。";
    }
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);


    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[領土割譲・譲受要請]</font>$cou_name[$kcon]は$cou_name[$econ]へ$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);

  }


  #通行許可
  sub TUKO{


    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    $si=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($skcon eq $kcon && $secon eq $econ && $stype eq 3 && $son){
      $s_hit=1;
      $si=$i;
      }elsif($skcon eq $kcon && $secon eq $econ && $stype eq 3 && !$son){
      &ERR('既に通行許可を出しています。');
      }elsif($secon eq $kcon && $skcon eq $econ && $stype eq 3){
      &ERR('既に通行許可を出しているか、相手国から通行許可要請が来ています。');
      }
    $i++;
    }


    if($s_hit){
    splice(@KOUSEN,$si,1);
    $res_mes = "通行許可要請を取り消しました。";
    $t_mes="の通行許可要請を取り消しました。";
    }else{
    unshift(@KOUSEN,"3<>1<>$kcon<>$econ<>$jyear<>$jmonth<>$in{'sei'}<>$kid<>$kname<>\n");
    $res_mes = "通行許可要請を出しました。";
    $t_mes="通行許可要請を行いました。<br>司令部の外交関連操作にてご確認ください。";
    }
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);



    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[通行許可要請]</font>$cou_name[$kcon]は$cou_name[$econ]へ$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);

  }


  #短縮布告許可
  sub TANSYUKU_KYOKA{

    if($in{'sen'} eq ""){&ERR('選択されていません！！');}

    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($secon eq $kcon && $skcon eq $econ && $stype eq 0 && $son){
        if($in{'sen'} eq "1"){
        splice(@KOUSEN, $i, 1, "$stype<>0<>$skcon<>$secon<>$syear<>$smonth<>$ssub1<>$ssub2<>$ssub3<>\n");
        $res_mes = "短縮布告要請を承諾しました。";
        $t_mes="短縮布告要請を承諾しました。";
        #年月表示
        open(IN,"$LOG_DIR/date_count.cgi") or &ERR('ファイルを開けませんでした。');
        @MONTH_DATA = <IN>;
        close(IN);
        ($myear,$mmonth,$mtime) = split(/<>/,$MONTH_DATA[0]);
        $wyear = $syear;
        &COUNTRY_DATA_OPEN($econ);
        #職
        if($xking eq "$ssub2"){
          $rank_mes = "君主";
        }elsif($xgunshi eq "$ssub2"){
          $rank_mes = "軍師";
        }elsif($xxsub1 eq "$ssub2"){
          $rank_mes = "宰相";
        }
        &MAP_LOG("<font color=\"#ff6600\"><b>【短縮布告】</b></font>$cou_name[$econ]は$cou_name[$kcon]へ宣戦布告を行いました！「$ssub1」開戦時間:$wyear年$smonth月（$cou_name[$econ]$rank_mes：$ssub3より）");
        &MAP_LOG2("<font color=\"#ff6600\"><b>【短縮布告】</b></font>$cou_name[$econ]は$cou_name[$kcon]へ宣戦布告を行いました！「$ssub1」開戦時間:$wyear年$smonth月（$cou_name[$econ]$rank_mes：$ssub3より））");
        #手紙
        $in{'eid'} = $ssub2;
        &ENEMY_OPEN;      
        open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
        @MES_REG = <IN>;
        close(IN);
        $mes_num = @MES_REG;
        if($mes_num > $MES_MAX) { pop(@MES_REG); }
        unshift(@MES_REG,"$kcon<>$ssub2<>$epos<>$ssub3<><font color=\"#ff6600\">[宣戦布告]</font>$cou_name[$econ]は$cou_name[$kcon]へ宣戦布告を行いました！「$ssub1」開戦時間:$wyear年$smonth月（$cou_name[$econ]$rank_mes：$ssub3より）<>$cou_name[$kcon]<>$daytime<>$echara<>$econ<><>\n");
        &SAVE_DATA($MESSAGE_LIST,@MES_REG);

        }else{
        splice(@KOUSEN,$i,1);
        $res_mes = "短縮布告要請を拒否しました。";
        $t_mes="短縮布告要請を拒否しました。";
        }
      &SAVE_DATA($KOUSEN_DATA,@KOUSEN);
      last;
      }
    $i++;
    }

    if($res_mes eq ""){&ERR('該当情報がありません。');}

    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[短縮布告要請]</font>$cou_name[$kcon]は$cou_name[$econ]の$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);


  }


  #停戦許可
  sub TEISEN_KYOKA{

    if($in{'sen'} eq ""){&ERR('選択されていません！！');}

    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    $t_hit=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($secon eq $kcon && $skcon eq $econ && $stype eq 1 && $son){
        if($in{'sen'} eq "1"){
        $s_hit=1;
        $t_hit=1;
        splice(@KOUSEN,$i,1);
        $res_mes = "停戦要請に承諾しました。";
        $t_mes="停戦要請に承諾しました。";
        &COUNTRY_DATA_OPEN($econ);
        #職
        if($xking eq "$ssub2"){
          $rank_mes = "君主";
        }elsif($xgunshi eq "$ssub2"){
          $rank_mes = "軍師";
        }elsif($xxsub1 eq "$ssub2"){
          $rank_mes = "宰相";
        }
        &MAP_LOG("<font color=\"#ff6600\"><b>【停戦】</b></font>$cou_name[$econ]は$cou_name[$kcon]と停戦しました。「$ssub1」（$cou_name[$econ]$rank_mes：$ssub3より）");
        &MAP_LOG2("<font color=\"#ff6600\"><b>【停戦】</b></font>$cou_name[$econ]は$cou_name[$kcon]と停戦しました。「$ssub1」（$cou_name[$econ]$rank_mes：$ssub3より））");
        #手紙
        $in{'eid'} = $ssub2;
        &ENEMY_OPEN;    
        open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
        @MES_REG = <IN>;
        close(IN);
        $mes_num = @MES_REG;
        if($mes_num > $MES_MAX) { pop(@MES_REG); }
        unshift(@MES_REG,"$kcon<>$ssub2<>$epos<>$ssub3<><font color=\"#ff6600\">[停戦]</font>$cou_name[$econ]は$cou_name[$kcon]と停戦しました。「$ssub1」（$cou_name[$econ]$rank_mes：$ssub3より）<>$cou_name[$kcon]<>$daytime<>$echara<>$econ<><>\n");
        &SAVE_DATA($MESSAGE_LIST,@MES_REG);
        }else{
        $s_hit=1;
        splice(@KOUSEN,$i,1);
        $res_mes = "停戦要請を拒否しました。";
        $t_mes="停戦要請を拒否しました。";
        &SAVE_DATA($KOUSEN_DATA,@KOUSEN);
        }
      last;
      }
    $i++;
    }
    if(!$s_hit){&ERR('停戦要請がきていないようです');}

    if($t_hit){
      @NEW_KOUSEN=();
      foreach(@KOUSEN){
      ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
        if($secon eq $kcon && $skcon eq $econ && $stype eq 0){
        }elsif($skcon eq $kcon && $secon eq $econ && $stype eq 0){
        }else{
        push(@NEW_KOUSEN,"$_");
        }
      }
      &SAVE_DATA($KOUSEN_DATA,@NEW_KOUSEN);
    }


    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[停戦要請]</font>$cou_name[$kcon]は$cou_name[$econ]の$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);

  }


  #領土割譲・譲受
  sub RYODO_KYOKA{

    if($in{'sen'} eq ""){&ERR('選択されていません！！');}

    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($secon eq $kcon && $skcon eq $econ && $stype eq 2 && $son){
        if($in{'sen'} eq "1"){
        splice(@KOUSEN,$i,1,"$stype<>0<>$skcon<>$secon<>$syear<>$smonth<>$ssub1<>$ssub2<>$ssub3<>\n");
        $res_mes = "領土割譲・譲受要請を許可しました。";
        $t_mes="領土割譲・譲受要請を許可しました。";
        $yousei="要請";
        &COUNTRY_DATA_OPEN($econ);
        #職
        if($xking eq "$ssub2"){
          $rank_mes = "君主";
        }elsif($xgunshi eq "$ssub2"){
          $rank_mes = "軍師";
        }elsif($xxsub1 eq "$ssub2"){
          $rank_mes = "宰相";
        }
        &MAP_LOG("<font color=\"#ff6600\"><b>【領土割譲・譲受】</b></font>$cou_name[$econ]は$cou_name[$kcon]と領土割譲・譲受を行います。「$ssub1」（$cou_name[$econ]$rank_mes：$ssub3より）");
        &MAP_LOG2("<font color=\"#ff6600\"><b>【領土割譲・譲受】</b></font>$cou_name[$econ]は$cou_name[$kcon]と領土割譲・譲受を行います。「$ssub1」（$cou_name[$econ]$rank_mes：$ssub3より））");
        #手紙
        $in{'eid'} = $ssub2;
        &ENEMY_OPEN;      
        open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
        @MES_REG = <IN>;
        close(IN);
        $mes_num = @MES_REG;
        if($mes_num > $MES_MAX) { pop(@MES_REG); }
        unshift(@MES_REG,"$kcon<>$ssub2<>$epos<>$ssub3<><font color=\"#ff6600\">[領土割譲・譲受]</font>$cou_name[$econ]は$cou_name[$kcon]と領土割譲・譲受を行います。「$ssub1」（$cou_name[$econ]$rank_mes：$ssub3より）<>$cou_name[$kcon]<>$daytime<>$echara<>$econ<><>\n");
        &SAVE_DATA($MESSAGE_LIST,@MES_REG);
        }else{
        splice(@KOUSEN,$i,1);
        $res_mes = "領土割譲・譲受要請を拒否しました。";
        $t_mes="領土割譲・譲受要請を拒否しました。";
        $yousei="要請";
        }
      $s_hit=1;
      last;
      }elsif($secon eq $kcon && $skcon eq $econ && $stype eq 2 && !$son){
        if($in{'sen'} eq "2"){
        splice(@KOUSEN,$i,1);
        $res_mes = "領土割譲・譲受可能状態を解除しました。";
        $t_mes="領土割譲・譲受可能状態を解除しました。";
        $s_hit=1;
        last;
        }
      }elsif($skcon eq $kcon && $secon eq $econ && $stype eq 2 && !$son){
        if($in{'sen'} eq "2"){
        splice(@KOUSEN,$i,1);
        $res_mes = "領土割譲・譲受可能状態を解除しました。";
        $t_mes="領土割譲・譲受可能状態を解除しました。";
        $s_hit=1;
        last;
        }
      }
    $i++;
    }
    if(!$s_hit){&ERR('領土割譲・譲受要請が来ていないようです。');}
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);


    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[領土割譲・譲受$yousei]</font>$cou_name[$kcon]は$cou_name[$econ]との$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);

  }


  #通行許可
  sub TUKO_KYOKA{

    if($in{'sen'} eq ""){&ERR('選択されていません！！');}

    open(IN,"$KOUSEN_DATA") or &ERR('ファイルを開けませんでした。');
    @KOUSEN = <IN>;
    close(IN);
    $i=0;
    $s_hit=0;
    foreach(@KOUSEN){
    ($stype,$son,$skcon,$secon,$syear,$smonth,$ssub1,$ssub2,$ssub3)=split(/<>/);
      if($secon eq $kcon && $skcon eq $econ && $stype eq 3 && $son){
        if($in{'sen'} eq "1"){
        splice(@KOUSEN,$i,1,"$stype<>0<>$skcon<>$secon<>$syear<>$smonth<>$ssub1<>$ssub2<>$ssub3<>\n");
        $res_mes = "通行許可要請を許可しました。";
        $t_mes="通行許可要請を許可しました。";
        $yousei="要請";
        #職
        if($xking eq "$kid"){
          $rank_mes = "君主";
        }elsif($xgunshi eq "$kid"){
          $rank_mes = "軍師";
        }elsif($xxsub1 eq "$kid"){
          $rank_mes = "宰相";
        }
        &MAP_LOG("<font color=\"#ff6600\"><b>【通行許可】</b></font>$cou_name[$kcon]は$cou_name[$econ]に自国領の通行を許可しました。「$ssub1」（$cou_name[$kcon]$rank_mes：$knameより）");
        &MAP_LOG2("<font color=\"#ff6600\"><b>【通行許可】</b></font>$cou_name[$kcon]は$cou_name[$econ]に自国領の通行を許可しました。「$ssub1」（$cou_name[$kcon]$rank_mes：$knameより");
        #手紙    
        open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
        @MES_REG = <IN>;
        close(IN);
        $mes_num = @MES_REG;
        if($mes_num > $MES_MAX) { pop(@MES_REG); }
        unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[通行許可]</font>$cou_name[$kcon]は$cou_name[$econ]に自国領の通行を許可しました。「$ssub1」（$cou_name[$kcon]$rank_mes：$knameより）<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
        &SAVE_DATA($MESSAGE_LIST,@MES_REG);
        }else{
        splice(@KOUSEN,$i,1);
        $res_mes = "通行許可要請を拒否しました。";
        $t_mes="通行許可要請を拒否しました。";
        $yousei="要請";
        }
      $s_hit=1;
      last;
      }elsif($secon eq $kcon && $skcon eq $econ && $stype eq 3 && !$son){
        if($in{'sen'} eq "2"){
        splice(@KOUSEN,$i,1);
        $res_mes = "通行許可を取り消ししました。";
        $t_mes="通行許可を取り消ししました。";
        $s_hit=1;
        last;
        }
      }elsif($skcon eq $kcon && $secon eq $econ && $stype eq 3 && !$son){
        if($in{'sen'} eq "2"){
        splice(@KOUSEN,$i,1);
        $res_mes = "通行許可を取り消ししました。";
        $t_mes="通行許可を取り消ししました。";
        $s_hit=1;
        last;
        }
      }
    $i++;
    }
    if(!$s_hit){&ERR('通行許可要請が来ていないようです。');}
    &SAVE_DATA($KOUSEN_DATA,@KOUSEN);


    open(IN,"$MESSAGE_LIST") or &ERR('ファイルを開けませんでした。');
    @MES_REG = <IN>;
    close(IN);
    $mes_num = @MES_REG;
    if($mes_num > $MES_MAX) { pop(@MES_REG); }
    unshift(@MES_REG,"$econ<>$kid<>$kpos<>$kname<><font color=\"#ff6600\">[通行許可$yousei]</font>$cou_name[$kcon]は$cou_name[$econ]との$t_mes<>$cou_name[$econ]<>$daytime<>$kchara<>$kcon<><>\n");
    &SAVE_DATA($MESSAGE_LIST,@MES_REG);


  }


  &HEADER;

  print <<"EOM";
<CENTER><hr size=0><h2>$res_mes</h2><p>
<form action=\"./mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=HUKOKU>
<input type=submit id=input value=\"外交関連操作に戻る\"></form>
<form action=\"./mydata.cgi\" method=\"post\">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=KING_COM>
<input type=submit id=input value=\"指令部に戻る\"></form>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="街に戻る"></form>
</CENTER>
EOM
  &FOOTER;

  exit;
}
1;
