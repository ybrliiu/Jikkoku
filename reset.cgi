##############
# Reset Mode #
##############

use lib './lib', './extlib';
use CGI::Carp qw/fatalsToBrowser/;

use File::Path;
use Jikkoku::Model::GameDate;
use Jikkoku::Model::Chara::AutoModeList;

sub RESET_MODE {
  my ($start_time) = @_;

  my $game_date_model = Jikkoku::Model::GameDate->new;
  $game_date_model->init( $start_time );
  $game_date_model->save;

  # MAIN DATA
  $dir="./charalog/main";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # COMMAND DATA
  $dir="./charalog/command";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # LOG DATA
  $dir="./charalog/log";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # BATTLE LOG DATA
  $dir="./charalog/blog";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # AUTO_COM DATA
  $dir="./charalog/auto_com";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # PROF DATA
  $dir="./charalog/prof";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # BM自動モード保存コマンドリスト削除
  $dir="./charalog/auto_com_save";
  rmtree($dir,{keep_root=>\$dir});

  # 保存コマンドリスト削除
  $dir="./charalog/com_save";
  rmtree($dir,{keep_root=>\$dir});

  # 個人バックアップデータ
  $dir="./backup-main";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # バックアップデータ
  $dir="./backup";
  opendir(dirlist,"$dir");
  while($file = readdir(dirlist)){
    if($file =~ /\.cgi/i){
      unlink("$dir/$file");
    }
  }
  closedir(dirlist);

  # NEW DATA
  @NEW_DATA = ();

  # ACT LOG
  $actfile = "$LOG_DIR/act_log.cgi";
  open(OUT,">$actfile");
  print OUT @NEW_DATA;
  close(OUT);

  # BBS LIST
  open(OUT,">$BBS_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # COUNTRY LIST
  open(OUT,">$COUNTRY_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # COUNTRY_LIST2 LIST
  open(OUT,">$COUNTRY_LIST2");
  print OUT @NEW_DATA;
  close(OUT);

  # DEF LIST
  open(OUT,">$DEF_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # MAP LOG LIST
  open(OUT,">$MAP_LOG_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # MAP LOG LIST2
  open(OUT,">$MAP_LOG_LIST2");
  print OUT @NEW_DATA;
  close(OUT);

  # MESSAGE LIST
  open(OUT,">$MESSAGE_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # MESSAGE2 LIST
  open(OUT,">$MESSAGE_LIST2");
  print OUT @NEW_DATA;
  close(OUT);

  # COUNTRY NO
  open(OUT,">$COUNTRY_NO_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # COUNTRY MES
  open(OUT,">$COUNTRY_MES");
  print OUT @NEW_DATA;
  close(OUT);

  # LOCAL_LIST
  open(OUT,">$LOCAL_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  # UNIT_LIST
  open(OUT,">$UNIT_LIST");
  print OUT @NEW_DATA;
  close(OUT);

  open(IN,"$F_TOWN_LIST");
  @F_T_DATA = <IN>;
  close(IN);

  # TOWN LIST
  open(OUT,">$TOWN_LIST");
  print OUT @F_T_DATA;
  close(OUT);

  # TOWN2 LIST
  open(OUT,">$TOWN_LIST2");
  print OUT @F_T_DATA;
  close(OUT);

  # STOP_COUNT(コマンド更新時間を制限するファイル)
  $stopcount = 0;
  open(OUT, "> ./log_file/stop_con.cgi");
  print OUT "$stopcount";
  close(OUT);

  # BLACKLIST_RESET
  open(OUT,"> ./log_file/black_list.cgi");
  print OUT @NEW_DATA;
  close(OUT);

  # 布告リスと
  open(OUT,">$KOUSEN_DATA");
  print OUT @NEW_DATA;
  close(OUT);

  # 掩護リスと
  open(OUT,"> ./log_file/engolist.cgi");
  print OUT @NEW_DATA;
  close(OUT);

  # 統一したかどうか記録(1:統一状態、0:統一してない状態)
  $touitu = 0;
  open(OUT,"> ./log_file/touitu_flag.cgi");
  print OUT $touitu;
  close(OUT);

  # 建国リストリセット
  open(OUT,"> ./log_file/kenkoku_list.cgi");
  print OUT @NEW_DATA;
  close(OUT);

  # BM自動モードのリスト削除
  my $auto_list_model = Jikkoku::Model::Chara::AutoModeList->new;
  $auto_list_model->init;

  &SYSTEM_LOG("全データを初期化しました。");
  &MAP_LOG("全データを初期化しました。");
}
1;
