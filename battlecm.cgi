#!/usr/bin/perl

#################################################################
#   【バトルマップコマンド処理】                                  #
#################################################################

use lib './lib', './extlib';
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;   

require './lib/skl_lib.pl';
require './ini_file/index.ini';
require 'suport.pl';

	if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
	if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
	&DECODE;

	#時間制限 19-25時
	&TIME_RIMIT;

#i-newbmの時
if($in{'mobile'} eq "yes"){
	require 'i-suport.pl';
}

	&CHARA_MAIN_OPEN;
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);
	if($ksol <= 0){
	$ksol = 0;
	&TETTAI();	#>lib/skl_lib.pl
	&CHARA_MAIN_INPUT;
	&ERR("兵士0人では戦闘できません。");
	}

#newbm.cgi,i-newbm.cgiで戻るボタン押したときの処理#
	if($in{'inline'} eq "1"){
	$BACK = "./newbm.cgi\" method=\"post\">\n<input type=hidden name=inline value=1><br dummy=\"";
	}elsif("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/newbm.cgi"){
	$BACK = "./newbm.cgi";
	}elsif($in{'mobile'} eq "yes"){
	$BACK = "./i-newbm.cgi";
	}else{
	$BACK = "./status.cgi";
	}

#戦闘モード追加時#
	if($mode =~ /BATTLE/ && $mode =~ /,/){
	($mode,$mode2) = split(/,/,$mode);
	}

if($mode eq 'IDOU') { require './battlecm/idou.pl';&IDOU(0); }
elsif($mode eq 'IDOUP') { require './battlecm/idoup.pl';&IDOUP; }
elsif($mode eq 'SEKISYO') { require './battlecm/sekisyo.pl';&SEKISYO; }
elsif($mode eq 'TAIKYAKU') { require './battlecm/taikyaku.pl';&TAIKYAKU; }
elsif($mode eq 'HOKYU') { require './battlecm/hokyu.pl';&HOKYU; }
elsif($mode eq 'KAGO') { require './battlecm/kago.pl';&KAGO; }
elsif($mode eq 'KAGOL') { require './battlecm/kagoL.pl';&KAGOL; }
elsif($mode eq 'YOUDOU') { require './battlecm/youdou.pl';&YOUDOU; }
elsif($mode eq 'YOUDOUL') { require './battlecm/youdouL.pl';&YOUDOUL; }
elsif($mode eq 'KONRAN') { require './battlecm/konran.pl';&KONRAN; }
elsif($mode eq 'ASIDOME') { require './battlecm/asidome.pl';&ASIDOME; }
elsif($mode eq 'KAHEI') { require './battlecm/kahei.pl';&KAHEI; }
elsif($mode eq 'KOBU') { require './battlecm/kobu.pl';&KOBU; }
elsif($mode eq 'KOBUL') { require './battlecm/kobuL.pl';&KOBUL; }
elsif($mode eq 'SENDOU') { require './battlecm/sendou.pl';&SENDOU; }
elsif($mode eq 'SENDOUL') { require './battlecm/sendouL.pl';&SENDOUL; }
elsif($mode eq 'SAIHEN') { require './battlecm/saihen.pl';&SAIHEN; }
elsif($mode eq 'BATTLE') {
	$idate = time();
	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);
	($krenpei,$khitokiri,$kstk,$kgsk,$koujyou2,$kago,$kagoL,$kyoudou,$kyoudouL,$kobu,$kobuL,$ksendou,$ksendouL,$knaiskl,$kkeiskl,$ktanskl,$kkinto,$k_jsub1,$k_jsub2) = split(/,/,$ksub4);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	&TOWN_DATA_OPEN("$kiti");
					
	if($ksol <= 0){
	&ERR("兵士0人では戦闘できません。");
	}elsif(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $kkoutime){
		$nokori = $kkoutime-$idate;
		&ERR("あと $nokori秒 行動できません。");
	}else{

		#掩護処理 ./lib/skl_lib.pl
    NEW_ENGO_SYORI($kid, $in{eid});

		require './battlecm/battle.pl';
		&BATTLE;
	}
}elsif($mode eq 'BUKIYA') { require './battlecm/bukiya.pl';&BUKIYA; }
elsif($mode eq 'ENGO') { require './battlecm/engo.pl';&ENGO; }
elsif($mode eq 'SYUKUTI') { require './battlecm/syukuti.pl';&SYUKUTI; }
elsif($mode eq 'KASOKU') { require './battlecm/kasoku.pl';&KASOKU; }
elsif($mode eq 'KINTO') { require './battlecm/kinto.pl';&KINTO; }
elsif($mode eq 'SINGEKI') { require './battlecm/singeki.pl';&SINGEKI; }

else{&ERR('正しく選択されていません。');}
