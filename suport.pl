#_/_/_/_/_/_/_/_/_/_/_/_/#
#   CHARA MAIN OPEN      #
#_/_/_/_/_/_/_/_/_/_/_/_/#

use Carp qw/longmess/;
use lib './lib', './extlib';
use Jikkoku::Util qw/open_data save_data/;

sub CHARA_MAIN_OPEN {

	open(IN,"$CHARA_DATA/$in{'id'}.cgi") or &ERR2('IDとパスが正しくありません！');
	@CN_DATA = <IN>;
	close(IN);

  suport_expand_my_chara_to_global_variables($CN_DATA[0]);

	$menuneed = 1;
	if ($in{'id'} ne "$kid" or $in{'pass'} ne "$kpass") {
    $menuneed = 0;
    &ERR2("IDとパスが正しくありません！");
  }
	# インラインフレーム(バトルマップの時)
	if($in{'inline'} eq "1"){
    $menuneed = 0;
  }

}

sub suport_expand_my_chara_to_global_variables {
  my $str = shift;

  (
    $kid,    $kpass,  $kname,    $kchara,    $kstr,   $kint,  $klea,
    $kcha,   $ksol,   $kgat,     $kcon,      $kgold,  $krice, $kcex,
    $kclass, $karm,   $kbook,    $kbank,     $ksub1,  $ksub2, $kpos,
    $kmes,   $khost,  $kdate,    $kmail,     $kos,    $kcm,   $kst,
    $ksz,    $ksg,    $kyumi,    $kiba,      $khohei, $ksenj, $ksm,
    $kbname, $kaname, $ksname,   $kazoku,    $kaai,   $ksub3, $ksub4,
    $ksub5,  $kspbuy, $kskldata, $kskldata2, $ksub6,  $ksub7, $ksub8,
    $k_code,
  ) = split /<>/, $str;

  (
    $kjinkei, $ksyuppei, $kiti,  $kx,    $ky,     $kbattletime, $kkoutime,
    $kidoup,  $kkicn,    $kksup, $kmsup, $ksakup, $konmip
  ) = split /,/, $ksenj;

  (
    $ksitahei, $ksarehei, $kbouwin, $kkouwin,  $kkoulos, $kboulos,
    $kkun,     $knai,     $kmei,    $khiki,    $koujyou, $k_kei,
    $k_tan,    $ksihai,   $kkezuri, $ksihaicn, $kkezuricn
  ) = split /,/, $ksub3;

  (
    $krenpei, $khitokiri, $kstk,   $kgsk,    $koujyou2, $kago,     $kagoL,
    $kyoudou, $kyoudouL,  $kobu,   $kobuL,   $ksendou,  $ksendouL, $knaiskl,
    $kkeiskl, $ktanskl,   $kkinto, $k_jsub1, $k_jsub2
  ) = split /,/, $ksub4;

  ($ksien,    $kskl1,   $kskl2,    $kskl3,    $kskl4,    $kskl5, $kskl6, $kskl7, $kskl8, $kskl9) = split /,/, $kst;
  ($kstr_ex,  $kint_ex, $klea_ex,  $kcha_ex,  $ksub1_ex, $ksub2_ex) = split /,/, $ksub1;
  ($kindbmm,  $ksettei, $ksettei2, $ksettei3, $ksettei4, $ksettei5) = split /,/, $ksz;
  ($karm2,    $kaname2, $kazoku2,  $kaai2) = split /,/, $ksub5;
  ($kbookskl, $kbouskl)   = split /,/, $kyumi;
  ($ksiki,    $ksiki_max) = split /,/, $ksub6;
  ($ksingeki_time, $kanother) = split /,/, $kskldata;

}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#   CHARA MAIN INPUT     #
#_/_/_/_/_/_/_/_/_/_/_/_/#
sub CHARA_MAIN_INPUT {

  $ksub1 = "$kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,";
  $ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
  $ksub3 = "$ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn,";
	$kyumi = "$kbookskl,$kbouskl,";
	$ksub6 = "$ksiki,$ksiki_max,";

	@NEW_DATA=();
	unshift(@NEW_DATA,"$kid<>$kpass<>$kname<>$kchara<>$kstr<>$kint<>$klea<>$kcha<>$ksol<>$kgat<>$kcon<>$kgold<>$krice<>$kcex<>$kclass<>$karm<>$kbook<>$kbank<>$ksub1<>$ksub2<>$kpos<>$kmes<>$khost<>$kdate<>$kmail<>$kos<>$kcm<>$kst<>$ksz<>$ksg<>$kyumi<>$kiba<>$khohei<>$ksenj<>$ksm<>$kbname<>$kaname<>$ksname<>$kazoku<>$kaai<>$ksub3<>$ksub4<>$ksub5<>$kspbuy<>$kskldata<>$kskldata2<>$ksub6<>$ksub7<>$ksub8<>$k_code<>\n");

  if ($ksyuppei && $kiti eq '') {
    my $data = open_data('log_file/system_log.cgi');
    (my $stack_trace = longmess) =~ s/\n/<br>/g;
    unshift @$data, " [bm_id error] $kname の bm_id がおかしいです。<br>$stack_trace";
    save_data('log_file/system_log.cgi', $data);
  }

	&SAVE_DATA("$CHARA_DATA/$kid\.cgi",@NEW_DATA,1);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#     ENEMY DATA ALL OPEN      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub ENEMY_OPEN {

	open(IN,"$CHARA_DATA/$in{'eid'}.cgi") or next;
	@E_DATA = <IN>;
	close(IN);

  suport_expand_enemy_chara_to_global_variables($E_DATA[0]);

	if($in{'eid'} ne "$eid" ){&ERR2("IDとPASSが正しくありません！");}

}

sub suport_expand_enemy_chara_to_global_variables {
  my $str = shift;

  (
    $eid,    $epass,  $ename,    $echara,    $estr,   $eint,  $elea,
    $echa,   $esol,   $egat,     $econ,      $egold,  $erice, $ecex,
    $eclass, $earm,   $ebook,    $ebank,     $esub1,  $esub2, $epos,
    $emes,   $ehost,  $edate,    $email,     $eos,    $ecm,   $est,
    $esz,    $esg,    $eyumi,    $eiba,      $ehohei, $esenj, $esm,
    $ebname, $eaname, $esname,   $eazoku,    $eaai,   $esub3, $esub4,
    $esub5,  $espbuy, $eskldata, $eskldata2, $esub6,  $esub7, $esub8,
    $e_code,
  ) = split /<>/, $str;

  (
    $esitahei, $esarehei, $ebouwin, $ekouwin,  $ekoulos, $eboulos,
    $ekun,     $enai,     $emei,    $ehiki,    $eoujyou, $e_kei,
    $e_tan,    $esihai,   $ekezuri, $esihaicn, $ekezuricn
  ) = split /,/, $esub3;

  (
    $ejinkei, $esyuppei, $eiti,  $ex,    $ey,     $ebattletime, $ekoutime,
    $eidoup,  $ekicn,    $eksup, $emsup, $esakup, $eonmip
  ) = split /,/, $esenj;


  (
    $erenpei, $ehitokiri, $estk,   $egsk,    $eoujyou2, $eago,     $eagoL,
    $eyoudou, $eyoudouL,  $eobu,   $eobuL,   $esendou,  $esendouL, $enaiskl,
    $ekeiskl, $etanskl,   $ekinto, $e_jsub1, $e_jsub2
  ) = split /,/, $esub4;

  ($esien,    $eskl1,   $eskl2,   $eskl3,   $eskl4,    $eskl5, $eskl6, $eskl7, $eskl8, $eskl9) = split /,/, $est;
  ($estr_ex,  $eint_ex, $elea_ex, $echa_ex, $esub1_ex, $esub2_ex) = split /,/, $esub1;
  ($ebookskl, $ebouskl)   = split /,/, $eyumi;
  ($esiki,    $esiki_max) = split /,/, $esub6;
  ($esingeki_time, $eanother) = split /,/, $eskldata;

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#    ENEMY DATA ALL INPUT      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
sub ENEMY_INPUT {

  $esub1 = "$estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex,";
  $esub3 = "$esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$ehiki,$eoujyou,$e_kei,$e_tan,$esihai,$ekezuri,$esihaicn,$ekezuricn,";
  $esenj = "$ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip,";
	$eyumi = "$ebookskl,$ebouskl,";
	$esub6 = "$esiki,$esiki_max,";

	@NEW_DATA=();
	unshift(@NEW_DATA,"$eid<>$epass<>$ename<>$echara<>$estr<>$eint<>$elea<>$echa<>$esol<>$egat<>$econ<>$egold<>$erice<>$ecex<>$eclass<>$earm<>$ebook<>$ebank<>$esub1<>$esub2<>$epos<>$emes<>$ehost<>$edate<>$email<>$eos<>$ecm<>$est<>$esz<>$esg<>$eyumi<>$eiba<>$ehohei<>$esenj<>$esm<>$ebname<>$eaname<>$esname<>$eazoku<>$eaai<>$esub3<>$esub4<>$esub5<>$espbuy<>$eskldata<>$eskldata2<>$esub6<>$esub7<>$esub8<>$e_code<>\n");

  if ($espbuy eq '' || !defined $espbuy) {
    my $data = open_data('log_file/system_log.cgi');
    (my $stack_trace = longmess) =~ s/\n/<br>/g;
    unshift @$data, " [SP購入数エラー] $ename のSP購入数がおかしいです。<br>$stack_trace";
    save_data('log_file/system_log.cgi', $data);
  }

	&SAVE_DATA("$CHARA_DATA/$eid\.cgi",@NEW_DATA,1);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub MAP_LOG {

	open(IN,"+< $MAP_LOG_LIST");
	flock(IN, 2);
	@S_MOVE = <IN>;

	&TIME_DATA;

	unshift(@S_MOVE,"$_[0]($mday日$hour時$min分$sec秒)\n");

	splice(@S_MOVE,200);

	seek(IN, 0, 0);
	print IN @S_MOVE;
	close(IN);

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub MAP_LOG2 {

	open(IN,"+< $MAP_LOG_LIST2");
	flock(IN, 2);
	@S_MOVE = <IN>;

	&TIME_DATA;

	unshift(@S_MOVE,"<b>$_[0]</b>($mday日$hour時$min分$sec秒)\n");

	splice(@S_MOVE,100);

	seek(IN, 0, 0);
	print IN @S_MOVE;
	close(IN);

}
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/    システムログの書き込み _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub SYSTEM_LOG {

	open(IN,"+< $SYSTEM_LOG");
	flock(IN, 2);
	@S_MOVE = <IN>;

	&TIME_DATA;

	unshift(@S_MOVE,"<b>$_[0]</b>($mday日$hour時$min分$sec秒)\n");

	splice(@S_MOVE,100);

	seek(IN, 0, 0);
	print IN @S_MOVE;
	close(IN);

}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/       LOGの書き込み      _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub K_LOG {

	open(IN,"./charalog/log/$kid.cgi");
	@K_LOG = <IN>;
	close(IN);

	unshift(@K_LOG,"$_[0]($mday日$hour時$min分$sec秒)\n");

	splice(@K_LOG,600);

	&SAVE_DATA("./charalog/log/$kid.cgi",@K_LOG);

}

sub E_LOG {

	if($eid ne "" && !$last_battle){
		open(IN,"./charalog/log/$eid\.cgi") or print "相手武将ログファイルが開けません。";
		@E_LOG = <IN>;
		close(IN);
		unshift(@E_LOG,"$_[0]($mday日$hour時$min分$sec秒)\n");
		splice(@E_LOG,600);

		&SAVE_DATA("./charalog/log/$eid.cgi",@E_LOG);
	}
}

sub E_LOG2 {

	if($eid ne "" && !$last_battle){
		open(IN,"./charalog/blog/$eid\.cgi") or print "相手武将ログファイルが開けません。";
		@E_LOG2 = <IN>;
		close(IN);
		unshift(@E_LOG2,"$_[0]($mday日$hour時$min分$sec秒)\n");
		splice(@E_LOG2,600);

		&SAVE_DATA("./charalog/blog/$eid.cgi",@E_LOG2);
	}
}

sub K_LOG2 {

	open(IN,"./charalog/blog/$kid\.cgi");
	@K_LOG2 = <IN>;
	close(IN);
	unshift(@K_LOG2,"$_[0]($mday日$hour時$min分$sec秒)\n");
	splice(@K_LOG2,600);
	&SAVE_DATA("./charalog/blog/$kid.cgi",@K_LOG2);
}


# 時間制限 #

sub TIME_RIMIT {

	&TIME_DATA;

	if($CONFIG_TIMERIMIT){ #時間制限つける
		if($hour < 11 && $hour >= 1){
		&ERR("BM上で行動可能な時間帯でありません！");
		}
	}
}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#    BATTLE ITEM ALL OPEN      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub CHARA_ITEM_OPEN {

	open(IN,"$ARM_LIST") or &ERR('ファイルを開けませんでした。');
	@ARM_DATA = <IN>;
	close(IN);
	open(IN,"$PRO_LIST") or &ERR('ファイルを開けませんでした。');
	@PRO_DATA = <IN>;
	close(IN);

	($karmname,$karmval,$karmdmg,$karmwei,$karmele,$karmsta,$karmclass,$karmtownid) = split(/<>/,$ARM_DATA[$karm]);
	($kproname,$kproval,$kprodmg,$kprowei,$kproele,$kprosta,$kproclass,$kprotownid) = split(/<>/,$PRO_DATA[$kbook]);

	if($eid){
		($earmname,$earmval,$earmdmg,$earmwei,$earmele,$earmsta,$earmclass,$earmtownid) = split(/<>/,$ARM_DATA[$earm]);
		($eproname,$eproval,$eprodmg,$eprowei,$eproele,$eprosta,$eproclass,$eprotownid) = split(/<>/,$PRO_DATA[$ebook]);
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       時間 取得        #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub TIME_DATA {
	$tt = time ;
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime(time);
	$mon++;
	$ww = (Sun,Mon,Tue,Wed,Thu,Fri,Sat)[$wday];
	$year += 1900;
	$daytime = sprintf("%02d\/%02d\/%02d\/(%s) %02d:%02d:%02d", $year,$mon,$mday,$ww,$hour,$min,$sec);
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#        COUNTRY DATA OPEN       #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub COUNTRY_DATA_OPEN {

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	$country_no=0;$hit=0;
	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
		if("$_[0]" eq "$xcid"){$hit=1;last;}
		$country_no++;
	}

	if(!$hit){
		$xcid=0;
		$xname="無所属";
		$xele=0;
		$xmark=48;
		$xking="";
		$xmes=0;
		$xsub=0;
		$xpri=0;
	}
	($xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1,$xxsub2)= split(/,/,$xsub);

	foreach(@COU_DATA){
		($x2cid,$x2name,$x2ele,$x2mark)=split(/<>/);
		$cou_name[$x2cid] = "$x2name";
		$cou_ele[$x2cid] = "$x2ele";
		$cou_mark[$x2cid] = "$x2mark";
	}
}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      COUNTRY DATA INPUT      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
sub COUNTRY_DATA_INPUT {

	splice(@COU_DATA,$country_no,1,"$xcid<>$xname<>$xele<>$xmark<>$xking<>$xmes<>$xsub<>$xpri<>\n");
	&SAVE_DATA($COUNTRY_LIST,@COU_DATA);

	$s_i = int(rand(5));
	if($s_i eq 0 && $xcid ne ""){
		&SAVE_DATA($COUNTRY_LIST2,@COU_DATA);
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#        TOWN DATA OPEN          #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub TOWN_DATA_OPEN {

	open(IN,"$TOWN_LIST") or &ERR("指定されたファイルが開けません。");
	@TOWN_DATA = <IN>;
	close(IN);
	$zid = $_[0];
	($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$zdef_att,$zsub1,$zsub2,$z[0],$z[1],$z[2],$z[3],$z[4],$z[5],$z[6],$z[7])=split(/<>/,$TOWN_DATA[$_[0]]);

	if($zname eq ""){&ERR("その街は存在しません。");}

	$zc=0;
	foreach(@TOWN_DATA){
		($z2name,$z2con,$z2num,$z2nou,$z2syo,$z2shiro)=split(/<>/);
		$town_name[$zc] = "$z2name";
		$town_cou[$zc] = "$z2con";
		$town_shiro[$zc] = "$z2shiro";
		$town_get[$z2con] += 1;
		$town_num[$z2con] += $z2num;
		$town_nou[$z2con] += $z2nou;
		$town_syo[$z2con] += $z2syo;
		$zc++;
	}

}

#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#       TOWN DATA INPUT        #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
sub TOWN_DATA_INPUT {

	if("$zname" ne ""){
		splice(@TOWN_DATA,$zid,1,"$zname<>$zcon<>$znum<>$znou<>$zsyo<>$zshiro<>$znou_max<>$zsyo_max<>$zshiro_max<>$zpri<>$zx<>$zy<>$zsouba<>$zdef_att<>$zsub1<>$zsub2<>$z[0]<>$z[1]<>$z[2]<>$z[3]<>$z[4]<>$z[5]<>$z[6]<>$z[7]<>\n");
		&SAVE_DATA($TOWN_LIST,@TOWN_DATA);
	}

	$s_it = int(rand(5));
	if($s_it == 0 && $zname ne ""){
		&SAVE_DATA($TOWN_LIST2,@TOWN_DATA);
	}
}

#_/_/_/_/_/_/_/_/#
#     DECODE     #
#_/_/_/_/_/_/_/_/#

sub DECODE {

	if ($ENV{'REQUEST_METHOD'} eq "POST") {
		if ($ENV{'CONTENT_LENGTH'} > 51200) { &ERR("投稿量が大きすぎます"); }
		read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	} else { $buffer = $ENV{'QUERY_STRING'}; }
	@pairs = split(/&/, $buffer);

	$v=0;
	foreach (@pairs) {
		($name,$value) = split(/=/, $_);
		$value =~ tr/+/ /;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

		# タグ処理
		$value =~ s/</&lt;/g;
		$value =~ s/>/&gt;/g;
		$value =~ s/\"/&quot;/g;
    if($name eq "armname"){
      $value =~ s/\,/，/g;
    }
    if($value =~ /\&lt;a\&gt;/ && $value =~ /\&lt;aa\&gt;/ && $value =~ /\&lt;\/a\&gt;/){
      $value =~ s/\&lt;a\&gt;/<a href\=\"/g;
      $value =~ s/\&lt;aa\&gt;/\" target=\"_blank\">/g;
      $value =~ s/\&lt;\/a\&gt;/<\/a\>/g;
    }if($value =~ /\&lt;b\&gt;/ && $value =~ /\&lt;\/b\&gt;/){
      $value =~ s/\&lt;b\&gt;/\<b\>/g;
      $value =~ s/\&lt;\/b\&gt;/\<\/b\>/g;
    }if($value =~ /\&lt;s\&gt;/ && $value =~ /\&lt;\/s\&gt;/){
      $value =~ s/\&lt;s\&gt;/\<s\>/g;
      $value =~ s/\&lt;\/s\&gt;/\<\/s\>/g;
    }if($value =~ /\&lt;u\&gt;/ && $value =~ /\&lt;\/u\&gt;/){
      $value =~ s/\&lt;u\&gt;/\<u\>/g;
      $value =~ s/\&lt;\/u\&gt;/\<\/u\>/g;
    }if($value =~ /\&lt;i\&gt;/ && $value =~ /\&lt;\/i\&gt;/){
      $value =~ s/\&lt;i\&gt;/\<i\>/g;
      $value =~ s/\&lt;\/i\&gt;/\<\/i\>/g;
    }if($value =~ /\&lt;sub\&gt;/ && $value =~ /\&lt;\/sub\&gt;/){
      $value =~ s/\&lt;sub\&gt;/\<sub\>/g;
      $value =~ s/\&lt;\/sub\&gt;/\<\/sub\>/g;
    }if($value =~ /\&lt;red\&gt;/ && $value =~ /\&lt;\/red\&gt;/){
      $value =~ s/\&lt;red\&gt;/\<font color=\"red\"\>/g;
      $value =~ s/\&lt;\/red\&gt;/\<\/font\>/g;
    }if($value =~ /\&lt;blue\&gt;/ && $value =~ /\&lt;\/blue\&gt;/){
      $value =~ s/\&lt;blue\&gt;/\<font color=\"blue\"\>/g;
      $value =~ s/\&lt;\/blue\&gt;/\<\/font\>/g;
    }if($value =~ /\&lt;green\&gt;/ && $value =~ /\&lt;\/green\&gt;/){
      $value =~ s/\&lt;green\&gt;/\<font color=\"#00FF00\"\>/g;
      $value =~ s/\&lt;\/green\&gt;/\<\/font\>/g;
    }if($value =~ /\&lt;black\&gt;/ && $value =~ /\&lt;\/black\&gt;/){
      $value =~ s/\&lt;black\&gt;/\<font color=\"#000000\"\>/g;
      $value =~ s/\&lt;\/black\&gt;/\<\/font\>/g;
    }

		# 改行等処理
		if (($name eq "ins")||($name eq "message")||($name eq "mes")) {
			$value =~ s/\r\n/<br>/g;
			$value =~ s/\r/<br>/g;
			$value =~ s/\n/<br>/g;
		} else {
			$value =~ s/\r//g;
			$value =~ s/\n//g;
		}

		if($name eq 'no'){
			$no[$v] = $value;
			$v++;
			$in{$name} = $value;
		}else{
			$in{$name} = $value;
		}
	}
	$mode = $in{'mode'};
	$in{'url'} =~ s/^http\:\/\///;
	$cookie_pass = $in{'pass'};
	$cookie_id = $in{'id'};
}


#_/_/_/_/_/_/_/_/#
#   HOST NAME    #
#_/_/_/_/_/_/_/_/#

sub HOST_NAME {
	$host = $ENV{'REMOTE_HOST'};
	$addr = $ENV{'REMOTE_ADDR'};

	if ($get_remotehost) {
		if ($host eq "" || $host eq "$addr") {
			$host = gethostbyaddr(pack("C4", split(/\./, $addr)), 2);
		}
	}
	if ($host eq "") { $host = $addr; }

}

# アクセス元調査

sub suport_referer_file {
  my $http_referer = $ENV{'HTTP_REFERER'};
  my ($file_name) = ($http_referer =~ m!([^/]+$)!);
  $file_name;
}

#_/_/_/_/_/_/_/_/#
#  ERROR PRINT   #
#_/_/_/_/_/_/_/_/#

sub ERR {
  my $mes = shift;

	&CHARA_MAIN_OPEN;
	&HEADER;
	&DECODE;
	if($in{'inline'} eq "1"){	#BMインラインフレーム時
	$BACK = "./newbm.cgi";
	$inline = "<input type=hidden name=inline value=1>";
	}elsif("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/newbm.cgi"){
	$BACK = "./newbm.cgi";
	}elsif("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/auto_in.cgi"){
	$BACK = "./auto_in.cgi";
	}else{
	$BACK = "./status.cgi";
	}

	print "<center><hr size=0><h3>ERROR !</h3>\n";
	print "<P><font color=red><B>$mes</B></font>\n";
	print "<form action=\"$BACK\" method=\"post\">$inline<input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"街へ戻る\"></form>";
	print "<P><hr size=0></center>\n</body></html>\n";
	exit;
}

#_/_/_/_/_/_/_/_/_/#
#   ERROR PRINT2   #
#_/_/_/_/_/_/_/_/_/#

sub ERR2 {

	&HEADER;
	if("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/bbs.cgi"){
	$BACK = "./bbs.cgi";
	}else{
	$BACK = "./index.cgi";
	}
	print "<center><hr size=0><h3>ERROR ! </h3>\n";
	print "<P><font color=red><B>$_[0]</B></font>\n";
	print "<form action=\"$BACK\" method=\"post\"><input type=submit id=input value=\"戻る\"></form>";
	print "<P><hr size=0></center>\n</body></html>\n";
	exit;
}



#_/_/_/_/_/_/_/_/#
#  お知らせ   #
#_/_/_/_/_/_/_/_/#

sub OSRS {

	&CHARA_MAIN_OPEN;
	&HEADER;
	print "<center><hr size=0><h3>お知らせ</h3>\n";
	print "<P><font color=red><B>$_[0]</B></font>\n";
	print "<form action=\"$FILE_STATUS\" method=\"post\"><input type=hidden name=id value=$kid><input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS><input type=submit id=input value=\"街へ戻る\"></form>";
	print "<P><hr size=0></center>\n</body></html>\n";
	exit;
}


#_/_/_/_/_/_/_/_/_/_/_/_/#
#     SAVE_DATA          #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub SAVE_DATA (\$\@){

	local($datafile, @data) = @_;
	if($LOCK){
		if($_[2]){
			local($datadir) = $CHARA_DATA;
		}else{
			local($datadir) = $LOG_DIR;
		}
		local($tmpfile) = $datafile . '.tmp';
		local($tmp_dummy) = $datafile . '.dmy.tmp';
		local($file) = substr($datafile,length($datadir) + 1);
		opendir(DIR, $datadir) ;
		@list = readdir(DIR) ;
		closedir(DIR) ;
		foreach (@list) {
			if ($_ =~ /($file).*\.tmp$/) {
				local($mtime) = (stat($tmpfile))[9];
				my $at_last = time - 60 - $mtime;
				if ($mtime && 0 < $at_last) {
					&UNLOCK;
				}
				&ERR2("テンポラリファイルが存在します。<br>LOCK解除まで $at_last 秒");
			}
		}
		if(!open(TMP,'>', $tmpfile)){
      my $e = $!;
			&UNLOCK;
			&ERR2("テンポラリファイルが作成出来ません。(reason : $e, file : $tmpfile)<br>");
		}elsif(!close(TMP)){
			&UNLOCK;
			&ERR2("テンポラリファイルがクローズ出来ません。<br>");
		}elsif(!open(DMY, '>', $tmp_dummy)){
			&UNLOCK;
			&ERR2("格納用一時ファイルが作成出来ません。<br>");
		}elsif(!close(DMY)){
			&UNLOCK;
			&ERR2("格納用一時ファイルがクローズ出来ません。<br>");
		}elsif(!chmod (0666, $tmp_dummy)){
			&UNLOCK;
			&ERR2("格納用一時ファイルの属性が変更出来ません。<br>");
		}elsif(!open(DMY, '>', $tmp_dummy)){
			&UNLOCK;
			&ERR2("格納用一時ファイルがオープン出来ません。<br>");
		}
		print DMY @data;
		if (!close(DMY)){
			&UNLOCK;
			&ERR2("格納用一時ファイルが保存出来ません。<br>");
		}elsif(!rename("$tmp_dummy" , "$datafile")){
			&UNLOCK;
			&ERR2("格納用一時ファイルをデータファイルにリネーム出来ません。<br>");
		}elsif(!unlink ("$tmpfile")){
			&UNLOCK;
			&ERR2("テンポラリファイルが削除出来ません。<br>");
		}
	}else{
		open(OUT,">$datafile");
		print OUT @data;
		close(OUT);
	}
}
##########
# UNLOCK #
##########
sub UNLOCK{
	unlink ("$tmpfile");
	unlink ("$tmp_dummy");
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       HTML HEADER      #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub HEADER {

	if($ksettei eq ""){
	$ksettei = "$FONT_SIZE";
	}


	#index.cgiでmetaデータ追加#
	if($meta){
	$meta = "<meta name=\"description\" content=\"戦略シミュレーションゲーム、十国志NETです。三国志NETの大幅改造版です。国を作り仲間と協力して大陸の統一を目指します。\" />
<meta name=\"keywords\" content=\"十国志NET,十国志,三国志NET,ブラウザゲーム,オンラインゲーム,CGIゲーム,無料,戦略シミュレーションゲーム\" />\n";
	}

	print "Cache-Control: no-cache\n";
	print "Pragma: no-cache\n";
	print "Content-type: text/html\n\n";
	print <<"EOM";
<!DOCTYPE html>
<html>
<head>
$meta
<link rel="shortcut icon" href="./favicon.ico" >
<META HTTP-EQUIV="Content-type" CONTENT="text/html; charset=UTF-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
EOM

	#量が多いページ(log,newbm,status,blog,mylog2.cgi)#
	if($zukei){
	$css3 .= "\n<link rel=\"stylesheet\" href=\"js/zukei.css\">";
	}

	#status.cgi専用css#
	if($status_css){
	$css3 .= "\n<link rel=\"stylesheet\" href=\"js/status.css\">";
	}

	#mydata/myskl2.plで専用css追加#
	if($sklcss){
	$css3 = "<link rel=\"stylesheet\" type=\"text/css\" href=\"js/skl.css\">";
	}

	#graph.cgiでグラフ描画用js追加#
	if($graph){
	$css3 = "<script src=\"js/Chart.js\"></script>";
	}

	#status.cgi,newbm.cgi,log.cgi,mylog.chi,mycou2.cgi,ranking.cgi,rankng2.cgi ballon用js,css
	if($b_js){
	$ballonjs = "<link rel=\"stylesheet\" href=\"js/jqballon.css\">";
	}

	#その他機種別追加js,css
	$agent = $ENV{'HTTP_USER_AGENT'};
	if($agent =~ /Android/){
	$usejs = "";
	$css = "<link rel=\"stylesheet\" href=\"js/base.css\">";
	}elsif($agent =~ /iPhone/ || $agent =~ /iPod/){
	$usejs = "";
	$css = "<link rel=\"stylesheet\" href=\"js/base.css\">";
	$css2 = "body {-webkit-text-size-adjust: 100%;}";
	}else{
	$usejs = "";
	$css = "<link rel=\"stylesheet\" href=\"js/base.css\">";
	}

	print <<"EOM";
<title>$GAME_TITLE</title>
<script src="public/js/jquery-3.1.0.min.js"></script>
$css
$ballonjs
$css3
<STYLE type="text/css">
<!--
$css2
body,tr,td,th,form { font-family : "メイリオ","Yu Gothic","VL Gothic","Ubuntu","monospace"; font-size: $ksettei; }
a{ text-decoration:none;}
a:link.mikata { color: #2222FF; font-size: $ksettei }
a:link.enemy { color: red; font-size: $ksettei }
a:link#mikata { color: #2222FF; font-size: $ksettei }
a:link#enemy { color: red; font-size: $ksettei }
a:link    { color: #4682B4 }
a:visited { color: #4682B4 }
a:hover   { color: #FFFF00 }
a:active  { color: #00FF00 }
.S1 {color:#fff; border-style: double; border-width: 3px;BACKGROUND: #633;}
.dmg { color: #FF0000; font-size: 18pt }
.clit { color: #0000FF; font-size: 18pt }
#small { font-size: xx-small; }
.bmj { color: #000000; font-size: 5pt }
.r { color: #FF4444; font-size: 10pt }
.b { color: #4444DD; font-size: 10pt }
.s { color: #44AAEE; font-size: 10pt }
.g { color: #44DD44; font-size: 10pt }
.o { color: #EEAA44; font-size: 10pt }
-->
</STYLE>
$usejs
EOM


if($menuneed){

print <<'EOM';
<script type="text/javascript"><!--
  $(document).ready(function(){

$("#menu li").hover(
	function () {
		this.style.backgroundColor = "#333333";
		this.style.color = "#EEEEEE";
		$(this).children('ul').animate({height: "show", opacity: "show"},{duration: "fast", easing: "swing"});
	},function () {
		this.style.backgroundColor = "#EEEEEE";
		this.style.color = "#000000";
		$(this).children('ul').animate({height: "toggle", opacity: "toggle"},{duration: "fast", easing: "linear"});
	}
);

});
--></script>
EOM

}


print <<"EOM";
</head>
<body background="$BACKGROUND" bgcolor="$BGCOLOR" text="$TEXT" link="$LINK" vlink="$VLINK" alink="$ALINK" leftmargin="0" marginwidth="0" marginheight="0">

<a name="top"></a>
EOM


if ($menuneed) {

print<<"EOM";
<div id="menu">
<div style="width:30px;height:30px;float:left;">
</div>
<li>▼ゲーム関連
	<ul>
	<li><a href="./index.cgi" target="_blank">・ゲームトップ</a></li>
	<li><a href="$BBS1_URL?name=$kname&icon=$kchara" target="_blank">・専用BBS</a></li>
	<li><a href="$SANGOKU_URL/manual.html" target="_blank">・説明書</a></li>
	<li><a href="./mydata.cgi?id=$kid&pass=$kpass&mode=ZATU_BBS" target="_blank">・雑談BBS</a></li>
	<li><a href="./entry.cgi?mode=RESISDENTS&id=$kid&pass=$kpass" target="_blank">・初心者向け説明</a></li>
	<li><a href="http://www9.atwiki.jp/jikkokusinet/pages/1.html" target="_blank">・十国志NETwiki</a></li>
	<li><a href="REKISI/index.html" target="_blank">・歴代統一国</a></li>
	<li><a href="$AICON_URL" target="_blank">・アイコン一覧</a></li>
	<li><a href="$SANGOKU_URL/rireki.html" target="_blank">・改造履歴</a></li>
	<li><a href="$SANGOKU_URL/manual.html#hatena" target="_blank">・困った時は</a></li>
	</ul>
</li>
<li><form action="./status.cgi" method="post"><input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=STATUS>
<input type=submit value="マイページ"></form></li>
<li>▼武将情報
	<ul>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=MYDATA>
	<input type=submit value="・設定&戦績"></form></li>
	<li><form action="./auto_in.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass>
	<input type=submit value="・BM行動予約"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=MYSKL>
	<input type=submit value="・スキル確認"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=SKL_BUY>
	<input type=submit value="・スキル修得"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=UNIT_SELECT>
	<input type=submit value="・部隊編成"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=BLOG>
	<input type=submit value="・戦闘ログ"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=MYLOG>
	<input type=submit value="・行動ログ"></form></li>
	</ul>
</li>
<li>▼手紙
	<ul>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=LETTER>
	<input type=submit value="・個人宛手紙"></form></li>
	<li><form action="./log.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=submit value="・手紙ログ"></form></li>
	</ul>
</li>
<li>▼国家情報
	<ul>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=COUNTRY_TALK>
	<input type=submit value="・会議室"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=LOCAL_RULE>
	<input type=submit value="・国法"></form></li>
	<li><form action="./mycou.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=submit value="・国データ"></form></li>
	<li><form action="./mycou2.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=submit value="・国の武将データ"></form></li>
	<li><form action="./mydata.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=hidden name=mode value=KING_COM>
	<input type=submit value="・司令部"></form></li>
	</ul>
</li>
<li>▼都市情報
	<ul>
	<li><form action="./mylog.cgi" method="post"><input type=hidden name=id value=$kid>
	<input type=hidden name=pass value=$kpass><input type=submit value="・滞在武将一覧"></form></li>
	</ul>
</li>
<li>▼ゲーム情報
	<ul>
	<li><a href="./map.cgi" target="_blank">・勢力図</a></li>
	<li><a href="$FILE_RANK" target="_blank">・登録武将一覧</a></li>
	<li><a href="$LINK2_URL" target="_blank">・$LINK2</a></li>
	<li><a href="./graph.cgi" target="_blank">・国力比較</a></li>
	</ul>
</li>
</div>
EOM
}


}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#       HTML FOOTER      #
#_/_/_/_/_/_/_/_/_/_/_/_/#

sub FOOTER {
	# 可変、削除禁止
	print "<CENTER><a name=\"sita\"></a><HR SIZE=0>\n";
	print "<font color=998877>十国志NET </font><font size=1 color=998877>$KI</font> <font color=998877>$VERSNT</font><br>\n";
	print "<font color=998877>ADMINISTARTOR liiu </font><a href=\"$SANGOKU_URL/index.cgi\">GAME TOP</a><br>\n";
	print "<font color=998877>三国志NET $VER </font><a href=\"http://www3.to/maccyu2/\" target=\"_top\">maccyu</a><br>\n";
	print "<a href=\"http://ayfreenet.web.infoseek.co.jp/\" target=\"_blank\">HOMEPAGE GARO</a>\n";
    print "</body></html>\n";
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#    COOKIE 情報取得     #
#_/_/_/_/_/_/_/_/_/_/_/_/#
sub GET_COOKIE {
	@pairs = split(/;/, $ENV{'HTTP_COOKIE'});
	foreach (@pairs) {
		local($key,$val) = split(/=/);
		$key =~ s/\s//g;
		$GET{$key} = $val;
	}
	@pairs = split(/,/, $GET{'WOR'});
	foreach (@pairs) {
		local($key,$val) = split(/<>/);
		$COOK{$key} = $val;
	}
	$_id  = $COOK{'id'};
	$_pass = $COOK{'pass'};
}

#_/_/_/_/_/_/_/_/_/_/_/_/#
#        SET COOKIE      #
#_/_/_/_/_/_/_/_/_/_/_/_/#
sub SET_COOKIE {

	local($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime(time+60*24*60*60);
	@month=('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
	$gmt = sprintf("%s, %02d-%s-%04d %02d:%02d:%02d GMT",
			$week[$wday],$mday,$month[$mon],$year+1900,$hour,$min,$sec);
	$cook="id<>$kid\,pass<>$kpass";
	print "Set-Cookie: WOR=$cook; expires=$gmt\n";
}

#_/_/_/_/_/_/_/_/_/_/#
#   GUEST情報収集    #
#_/_/_/_/_/_/_/_/_/_/#

sub MAKE_GUEST_LIST {

	open(GUEST,"$GUEST_LIST") or &ERR2('ファイルを開けませんでした。');
	@GUEST=<GUEST>;close(GUEST);

	$times = time();@m_list = ();$hit=0;@New_guest_list=();

	foreach (@GUEST){($timer,$name,$con,$opos) = split(/<>/);
		if( $times - 180 > $timer){
			next;
		}elsif($kname eq $name){
			if( $times - 5 <= $timer && $SERVER_REDUCTION){
				&ERR("前回更新してから５秒以上経過していません。<BR>間隔をあけて実行してください。");
			}
			push (@New_guest_list,"$times<>$kname<>$kcon<>$kpos<>\n");
			$m_list .= "$kname\[$town_name[$kpos]\] ";
			$hit = 1;
		}else{
			push (@New_guest_list,"$timer<>$name<>$con<>$opos<>\n");
			if($kcon eq $con){
				$m_list .= "$name\[$town_name[$opos]\] ";
			}
		}
	}

	if(!$hit){
		push(@New_guest_list,"$times<>$kname<>$kcon<>$kpos<>\n");
		$m_list .= "$kname\[$town_name[$kpos]\] ";
	}

	open(GUEST,">$GUEST_LIST") or &ERR('ファイルを開けませんでした。');
	print GUEST @New_guest_list;close(GUEST);
}

#_/_/_/_/_/_/_/_/_/_/#
#   負荷防止機能     #
#_/_/_/_/_/_/_/_/_/_/#

sub SERVER_STOP {

	&HOST_NAME;
	open(GUEST,"$LOG_DIR/stop.cgi") or &ERR2('ファイルを開けませんでした。');
	@STOP=<GUEST>;close(GUEST);
if($host eq ""){&ERR("ホスト名を有効にしてください。");}
	$times = time();@m_list = ();$hit=0;@New_stop=();
	$phit=0;
	foreach (@STOP){
		($stimer,$shost) = split(/<>/);
		if( $times - 180 > $stimer){
			next;
		}elsif($shost eq $host){
			if( $times-5 <= $stimer){
				$phit = 1;
			}
			push (@New_stop,"$times<>$host<>\n");
			$hit = 1;
		}else{
			push (@New_stop,"$stimer<>$shost<>\n");
		}
	}


	if(!$hit){
		push(@New_stop,"$times<>$host<>\n");
	}

	open(GUEST,">$LOG_DIR/stop.cgi") or &ERR2('ファイルを開けませんでした。');
	print GUEST @New_stop;close(GUEST);

	if($phit && $SERVER_REDUCTION){
		if($in{'id'} eq ""){
			&ERR2("サーバへの不可防止の為、更新してから<BR>5秒以上間隔をあけて実行してください。<BR>Your host name : $host");
		}else{
			&ERR("サーバへの不可防止の為、更新してから<BR>5秒以上間隔をあけて実行してください。<BR>Your host name : $host");
		}
	}

}


1;
