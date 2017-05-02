#スキル設定ファイル#

use lib './lib', './extlib';

#スキルの消費士気設定
$MOR_ENGO = 10;
$MOR_KYOSYU = 20;
$MOR_SINGEKI = 40;
$MOR_HAJYO = 7;
$MOR_HOUI = 20;
$MOR_SAIHEN = 25;
$MOR_KONRAN = 20;
$MOR_ASIDOME = 12;
$MOR_HOKYU = 5;
$MOR_TYOUBO = 7;
$MOR_S = 5;
$MOR_L = 7;
$MOR_SYUKUTI = 7;
$MOR_KASOKU = 7;
$MOR_KINTOUN = 15;


#撤退時の動作
sub TETTAI {

  $ksyuppei = 0;
  $kiti = "";
  $kx = "";
  $ky = "";
  RESET_STATE();
  if($_[0] eq ""){
  &K_LOG("【撤退】部隊が全滅しているので撤退しました。");
  &K_LOG2("【撤退】部隊が全滅しているので撤退しました。");
  }else{
  &K_LOG("【撤退】$_[0]");
  &K_LOG2("【撤退】$_[0]");
  }
  $ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";

  open(IN,"./log_file/engolist.cgi") or &ERR("指定されたファイルが開けません。");
  @ENGO_DATA = <IN>;
  close(IN);
  @NEWENGO = ();
  foreach(@ENGO_DATA){($enid,$entime,$eniti,$enx,$eny,$enname,$encon,$ensub3,$ensub4)=split(/<>/);
    if($kid eq $enid){
    }else{
    push(@NEWENGO,"$_");
    }
  }
  &SAVE_DATA("./log_file/engolist.cgi",@NEWENGO);

}

# 状態のリセット
sub RESET_STATE {
  $kkicn = 0;
  $kksup = 0;
  $kmsup = 0;
  $ksakup = 0;
  $konmip = 0;
}

#相手撤退時の動作
sub E_TETTAI {

  $esyuppei = 0;
  $eiti = "";
  $ex = "";
  $ey = "";
  $ekicn = 0;
  $eksup = 0;
  $emsup = 0;
  $esakup = 0;
  $eonmip = 0;
  if($_[0] eq ""){
  &E_LOG("【撤退】部隊が全滅しているので撤退しました。");
  &E_LOG2("【撤退】部隊が全滅しているので撤退しました。");
  }else{
  &E_LOG("【撤退】$_[0]");
  &E_LOG2("【撤退】$_[0]");
  }
  $esenj = "$ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip,";

  open(IN,"./log_file/engolist.cgi") or &ERR("指定されたファイルが開けません。");
  @ENGO_DATA = <IN>;
  close(IN);
  @NEWENGO = ();
  foreach(@ENGO_DATA){($enid,$entime,$eniti,$enx,$eny,$enname,$encon,$ensub3,$ensub4)=split(/<>/);
    if($eid eq $enid){
    }else{
    push(@NEWENGO,"$_");
    }
  }
  &SAVE_DATA("./log_file/engolist.cgi",@NEWENGO);

}


#掩護部隊の処理
sub ENGO_SYORI {

  if($in{'eid'} ne "jyouhekisyugohei" && $in{'eid'} ne ""){
  open(IN,"./log_file/engolist.cgi") or &ERR("指定されたファイルが開けません。");
  @ENGO_DATA = <IN>;
  close(IN);
  $engohit=0;

    foreach(@ENGO_DATA){
    ($enid,$entime,$eniti,$enx,$eny,$enname,$encon,$ensub3,$ensub4) = split(/<>/);
      if($entime >= $idate){
        if($eniti eq $kiti && $in{'eid'} ne $enid){
        &ENEMY_OPEN;
        ($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);
        $zsa = abs($ex-$enx);$zsa2 = abs($ey-$eny);$zsa3 = $zsa+$zsa2;
          if($encon eq $econ && $eniti eq $eiti && $zsa3 <= 3){
          # battle.pl で使用
          $engohit=1;  
          $in{'eid'} = $enid;
          $zsa = abs($kx-$ex);$zsa2 = abs($ky-$ey);$engosa = $zsa+$zsa2;
          # battle.plで使用
          $mae_name = $ename;
          &K_LOG("<font color=blue>【掩護】</font>$enameは$ennameの掩護部隊に守られています！");
          &K_LOG2("<b><font color=blue>【掩護】</font>$enameは$ennameの掩護部隊に守られています！</b>");
          &E_LOG("<font color=red>【掩護】</font>$knameの攻撃を受けましたが$ennameが掩護しました！");
          &E_LOG2("<b><font color=red>【掩護】</font>$knameの攻撃を受けましたが$ennameが掩護しました！</b>");
          &MAP_LOG("$knameは$enameを攻撃しましたが$ennameが掩護に入りました！");
          last;
          }
        }
      }
    $i++;
    }

  }
}

use Jikkoku::Model::Chara;
use Jikkoku::Model::MapLog;

sub NEW_ENGO_SYORI {
  my ($my_id, $enemy_id) = @_;

  return undef if $enemy_id eq "jyouhekisyugohei" || $enemy_id eq ""; 

  my $chara_model = Jikkoku::Model::Chara->new;
  my $my_self = $chara_model->get($my_id);
  my $enemy   = $chara_model->get($enemy_id);

  my $protector = Jikkoku::Model::Chara::Protector->new->is_chara_protected($enemy);
  return unless defined $protector;

  ###### GLOBAL VALUES used by battle.pl ########
  # target chara id protector
  $in{eid} = $protector->id;
  # original target chara is enemy
  $mae_name = $enemy->name;
  # battle.pl 互換性
  $engohit = 1;

  $my_self->save_command_log("<font color=blue>【掩護】</font>@{[ $enemy->name ]}は@{[ $protector->name ]}の掩護部隊に守られています！");
  $my_self->save_battle_log("<b><font color=blue>【掩護】</font>@{[ $enemy->name ]}は@{[ $protector->name ]}の掩護部隊に守られています！</b>");
  $enemy->save_command_log("<font color=red>【掩護】</font>@{[ $my_self->name ]}の攻撃を受けましたが@{[ $protector->name ]}が掩護しました！");
  $enemy->save_battle_log("<b><font color=red>【掩護】</font>@{[ $my_self->name ]}の攻撃を受けましたが@{[ $protector->name ]}が掩護しました！</b>");

  Jikkoku::Model::MapLog->new->add("@{[ $my_self->name ]}は@{[ $enemy->name ]}を攻撃しましたが@{[ $protector->name ]}が掩護に入りました！")->save;
}

#移動スキル処理
sub IDOUSKL{

  if($kskl3 > 2){
  $kidoup = $SOL_MOVE[$ksub1_ex]+4;#移動スキル3#
  }elsif($kskl3 > 0){
  $kidoup = $SOL_MOVE[$ksub1_ex]+1;#移動スキル1#
  }else{
  $kidoup = $SOL_MOVE[$ksub1_ex];
  }

}

sub IDOUSKL2{

  if($kskl3 > 1){
  $kbattletime = $idate+$BMT_REMAKE-20;#移動スキル2#
  }else{
  $kbattletime = $idate+$BMT_REMAKE;
  }

}

sub IDOUSKL2_2{

  #移動スキル2#
  if($kskl3 > 1){$kbattletime -= 20;}

}

sub IDOUSKL_HYOJI{

  if($kskl3 > 2){
  $SOL_MOVE[$ksub1_ex] += 4;
  }elsif($kskl3 > 0){
  $SOL_MOVE[$ksub1_ex] += 1;
  }

}


#移動補助スキル 筋斗雲
sub KINTOUN {
  my ($x, $y) = @_;

  if($kkinto > $idate){
    if($CAN_MOVE[$BM_TIKEI[$y][$x]] > 3){
      $moto_movepoint = $CAN_MOVE[$BM_TIKEI[$y][$x]];
      $CAN_MOVE[$BM_TIKEI[$y][$x]] = 3;
    }
  }
}

# 状態による消費移動ポイントの調整
our @skl_lib_move_cost_adjusted_by_states;
sub skl_lib_adjust_state_move_cost {
  my ($x, $y, $chara, $time) = @_;
  my $terrain = $BM_TIKEI[$y][$x];
  if ( !$skl_lib_move_cost_adjusted_by_states[$terrain] ) {
    $CAN_MOVE[$terrain] += $chara->states->adjust_move_cost( $CAN_MOVE[$terrain] );
    $skl_lib_move_cost_adjusted_by_states[$terrain] = 1;
  }
}

#筋斗雲でおかしくなった地形の移Pを戻す
sub KINTOUN_RETURN {
  my ($x,$y) = @_;

  if($moto_movepoint ne ""){
    $CAN_MOVE[$BM_TIKEI[$y][$x]] = $moto_movepoint;
  }
  $moto_movepoint = "";
}

1;
