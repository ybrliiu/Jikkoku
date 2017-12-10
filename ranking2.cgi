#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#    また設置に関する質問はサポート掲示板にお願いいたします。   #
#    直接メールによる質問は一切お受けいたしておりません。       #
#################################################################


require './ini_file/index.ini';
require 'suport.pl';

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
#if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
&RANKING;


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      参加者リストＯＰＥＮ      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub RANKING {

	&SERVER_STOP;
	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。');
	@COU_DATA = <IN>;
	close(IN);

	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
		$cou_name[$xcid]="$xname";
		$cou_color[$xcid] = $xele;
	}

	$dir="./charalog/main";
	opendir(dirlist,"$dir");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"$dir/$file")){
				&ERR("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/,$page[0]);

			if($kname =~ "【NPC】"){next;}

			($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex,$ktec1,$ktec2,$ktec3,$kvsub1,$kvsub2,) = split(/,/,$ksub1);

	($ksitahei,$ksarehei,$kbouwin,$kkouwin,$kkoulos,$kboulos,$kkun,$knai,$kmei,$khiki,$koujyou,$k_kei,$k_tan,$ksihai,$kkezuri,$ksihaicn,$kkezuricn) = split(/,/,$ksub3);

			$kskais = $kbouwin+$kkouwin+$kkoulos+$kboulos+$khiki+$ksihai;
			$ksyouri = $kbouwin+$kkouwin;
			$lpoint = $kstr+$kint+$klea+$kcha;
			push(@CL_DATA,"$kid<>$kpass<>$kname<>$kchara<>$kstr<>$kint<>$klea<>$kcha<>$ksol<>$kgat<>$kcon<>$kgold<>$krice<>$kcex<>$kclass<>$karm<>$kbook<>$kbank<>$ksub1<>$ksub2<>$kpos<>$kmes<>$khost<>$kdate<>$kmail<>$kos<>$kcm<>$kst<>$ksz<>$ksg<>$kyumi<>$kiba<>$khohei<>$ksenj<>$ksm<>$kbname<>$kaname<>$ksname<>$kazoku<>$kaai<>$ksub3<>$ksub4<>$ksub5<>$lpoint<>$ksitahei<>$ksarehei<>$kbouwin<>$kkouwin<>$kskais<>$ksyouri<>$ksihai<>$kkezuri<>\n");
		}
	}
	closedir(dirlist);



	@tmp = map {(split /<>/)[43]} @CL_DATA;
	@POINT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;

	$best_list = "<TR><TD align=center>タイトル</TD><TD align=center>数値</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";

	$point_list = "<TR><TD align=center>順位</TD><TD align=center>総合</TD><TD align=center>武力</TD><TD align=center>知力</TD><TD align=center>統率力</TD><TD align=center>人望</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@POINT){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#sum style=\"color:FFFFFF\">総合\能\力No.1</a></TH><TH>$klpoint</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
			$point_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$klpoint</TH><TD>$kstr</TD><TD>$kint</TD><TD>$klea</TD><TD>$kcha</TD><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$point_list .= "<TR><TD align=center>$i</TD><TH>$klpoint</TH><TD>$kstr</TD><TD>$kint</TD><TD>$klea</TD><TD>$kcha</TD><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[4]} @CL_DATA;
	@STR = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$str_list = "<TR><TD align=center>順位</TD><TD align=center>武力</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@STR){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#str style=\"color:FFFFFF\">武力No.1</a></TH><TH>$kstr</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$str_list .= "<TR><TH><font color=blue>【$i】</font></TD><TH>$kstr</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$str_list .= "<TR><TD align=center>$i</TD><TH>$kstr</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[5]} @CL_DATA;
	@INT = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$int_list = "<TR><TD align=center>順位</TD><TD align=center>知力</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@INT){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#int style=\"color:FFFFFF\">知力No.1</a></TH><TH>$kint</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
			$int_list .= "<TR><TH><font color=blue>【$i】</TH><TH>$kint</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$int_list .= "<TR><TD align=center>$i</TD><TH>$kint</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[6]} @CL_DATA;
	@LER = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$lea_list = "<TR><TD align=center>順位</TD><TD align=center>統率力</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@LER){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
		$lea_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$klea</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#lea style=\"color:FFFFFF\">統率力No.1</a></TH><TH>$klea</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$lea_list .= "<TR><TD align=center>$i</TD><TH>$klea</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[7]} @CL_DATA;
	@CHA = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$cha_list = "<TR><TD align=center>順位</TD><TD align=center>人望</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@CHA){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#cha style=\"color:FFFFFF\">人望No.1</a></TH><TH>$kcha</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$cha_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kcha</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$cha_list .= "<TR><TD align=center>$i</TD><TH>$kcha</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[11]} @CL_DATA;
	@GOLD = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$gold_list = "<TR><TD align=center>順位</TD><TD align=center>金</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@GOLD){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#gold style=\"color:FFFFFF\">所持金No.1</a></TH><TH>金:$kgold</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$gold_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>金:$kgold</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$gold_list .= "<TR><TD align=center>$i</TD><TH>金:$kgold</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[12]} @CL_DATA;
	@RICE = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$rice_list = "<TR><TD align=center>順位</TD><TD align=center>米</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@RICE){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#rice style=\"color:FFFFFF\">穀物No.1</a></TH><TH>米:$krice</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$rice_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>米:$krice</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$rice_list .= "<TR><TD align=center>$i</TD><TH>米:$krice</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[14]} @CL_DATA;
	@CLASS = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$class_list = "<TR><TD align=center>順位</TD><TD align=center>階級値</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@CLASS){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#class style=\"color:FFFFFF\">階級値No.1</a></TH><TH>$kclass</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$class_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kclass</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$class_list .= "<TR><TD align=center>$i</TD><TH>$kclass</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[21]} @CL_DATA;
	@BOU = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$bou_list = "<TR><TD align=center>順位</TD><TD align=center>威力</TD><TD align=center>防具名称</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@BOU){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#bou style=\"color:FFFFFF\">防具威力No.1</a></TH><TH>$kmes</FONT></TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$bou_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kmes</FONT></TH><TH>$kbname</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$bou_list .= "<TR><TD align=center>$i</TD><TH>$kmes</FONT></TH><TH>$kbname</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[15]} @CL_DATA;
	@ARM = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$arm_list = "<TR><TD align=center>順位</TD><TD align=center>威力</TD><TD align=center>武器名称</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@ARM){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#arm style=\"color:FFFFFF\">武器威力No.1</a></TH><TH>$karm</FONT></TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$arm_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$karm</FONT></TH><TH>$kaname</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$arm_list .= "<TR><TD align=center>$i</TD><TH>$karm</FONT></TH><TH>$kaname</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[16]} @CL_DATA;
	@BOOK = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$book_list = "<TR><TD align=center>順位</TD><TD align=center>威力</TD><TD align=center>書物名称</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@BOOK){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#book style=\"color:FFFFFF\">書物威力No.1</a></TH><TH>$kbook</FONT></TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$book_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kbook</FONT></TH><TH>$ksname</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$book_list .= "<TR><TD align=center>$i</TD><TH>$kbook</FONT></TH><TH>$ksname</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[44]} @CL_DATA;
	@DEAD = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$dead_list = "<TR><TD align=center>順位</TD><TD align=center>倒した兵数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@DEAD){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($knum eq ""){
			$knum=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#sitahei style=\"color:FFFFFF\">倒した兵数No.1</s></TH><TH>$knum人</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$dead_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$knum人</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$dead_list .= "<TR><TD align=center>$i</TD><TH>$knum人</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[45]} @CL_DATA;
	@SARETA = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$sareta_list = "<TR><TD align=center>順位</TD><TD align=center>倒された兵数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@SARETA){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($ksarehei eq ""){
			$ksarehei=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#sarehei style=\"color:FFFFFF\">倒された兵数No.1</a></TH><TH>$ksarehei人</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$sareta_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$ksarehei人</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$sareta_list .= "<TR><TD align=center>$i</TD><TH>$ksarehei人</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[46]} @CL_DATA;
	@BOUWIN = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$bouwin_list = "<TR><TD align=center>順位</TD><TD align=center>防衛側勝利回数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@BOUWIN){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei,$kbouwin) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($kbouwin eq ""){
			$kbouwin=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#bou_win style=\"color:FFFFFF\">防衛側勝利回数No.1</a></TH><TH>$kbouwin回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$bouwin_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kbouwin回</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$bouwin_list .= "<TR><TD align=center>$i</TD><TH>$kbouwin回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[47]} @CL_DATA;
	@KOUWIN = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$kouwin_list = "<TR><TD align=center>順位</TD><TD align=center>侵攻側勝利回数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@KOUWIN){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei,$kbouwin,$kkouwin) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($kkouwin eq ""){
			$kkouwin=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#kou_win style=\"color:FFFFFF\">侵攻側勝利回数No.1</a></TH><TH>$kkouwin回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$kouwin_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kkouwin回</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$kouwin_list .= "<TR><TD align=center>$i</TD><TH>$kkouwin回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[48]} @CL_DATA;
	@KOULOS = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$koulos_list = "<TR><TD align=center>順位</TD><TD align=center>戦闘回数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@KOULOS){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei,$kbouwin,$kkouwin,$kskais) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($kkoulos eq ""){
			$kkoulos=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#battle style=\"color:FFFFFF\">戦闘回数No.1</a></TH><TH>$kskais回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$koulos_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kskais回</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$koulos_list .= "<TR><TD align=center>$i</TD><TH>$kskais回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[49]} @CL_DATA;
	@BOULOS = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$boulos_list = "<TR><TD align=center>順位</TD><TD align=center>戦闘勝利回数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@BOULOS){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei,$kbouwin,$kkouwin,$kskais,$ksyouri) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($ksyori eq ""){
			$ksyori=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#win style=\"color:FFFFFF\">戦闘勝利回数No.1</a></TH><TH>$ksyouri回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$boulos_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$ksyouri回</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$boulos_list .= "<TR><TD align=center>$i</TD><TH>$ksyouri回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	@tmp = map {(split /<>/)[50]} @CL_DATA;
	@BOULOS = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$sihai_list = "<TR><TD align=center>順位</TD><TD align=center>都市支配回数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@BOULOS){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei,$kbouwin,$kkouwin,$kskais,$ksyouri,$ksihai) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($ksihai eq ""){
			$ksihai=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#sihai style=\"color:FFFFFF\">支配回数No.1</a></TH><TH>$ksihai回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$sihai_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$ksihai回</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$sihai_list .= "<TR><TD align=center>$i</TD><TH>$ksihai回</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}


	@tmp = map {(split /<>/)[51]} @CL_DATA;
	@BOULOS = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];

	$i=1;
	$kezuri_list = "<TR><TD align=center>順位</TD><TD align=center>城壁削り数</TD><TD align=center colspan=2>名前</TD><TD align=center>所属国</TD></TR>";
	foreach(@BOULOS){
		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$klpoint,$knum,$ksarehei,$kbouwin,$kkouwin,$kskais,$ksyouri,$ksihai,$kkezuri) = split(/<>/);

if($balllist !~ /(\".$kid\")/){
	$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id=ballon style=background-color:rgba($ELE_RGBA[$cou_color[$kcon]]0.7);><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src=./menu.cgi?id=$kid&send=1></iframe></td></tr></table></div>\"));}num++;});
";
	}
	$butaibasyo = "<span class=$kid>$kname</span>";

		if($cou_name[$kcon] eq ""){
			$kcon_name= "無所属";
		}else{
			$kcon_name= "$cou_name[$kcon]";
		}
		if($kkezuri eq ""){
			$kkezuri=0;
		}
		if($i eq 1){
			$best_list .= "<TR><TH bgcolor=$TD_C7><a href=#kezuri style=\"color:FFFFFF\">城壁削りNo.1</a></TH><TH>$kkezuri</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		$kezuri_list .= "<TR><TH><font color=blue>【$i】</font></TH><TH>$kkezuri</TH><TH><font color=AA0000>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}else{
		$kezuri_list .= "<TR><TD align=center>$i</TD><TH>$kkezuri</TH><TH><font color=$TD_C7>$butaibasyo</TH><TD width=5><img src=$IMG/$kchara.gif width=64 height=64></TD><TD align=center>$kcon_name</TD></TR>";
		}
		$i++;
		if($i>10){last;}
	}

	$b_js = 1;
	&HEADER;

	print <<"EOM";

<script type="text/javascript"><!--
var num = 0;

\$(document).ready(function(){

$balllist

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

});
--></script>

<CENTER><TABLE WIDTH="80%" height=100% bgcolor=$TD_C7>
<TBODY><TR><TD BGCOLOR=$TD_C8 WIDTH=100% height=100% align=center>
<BR>
<TABLE border=1 width=90% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH bgcolor=$TD_C13><font size=5 color=CCDDCC>- 名 将 一 覧 -</font></TH></TR>
</TBODY></TABLE>

<BR><p>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>大陸の英雄</font></TH></TR>
$best_list
</TBODY></TABLE>

<BR><p><a name="str"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>豪傑　１０選</font></TH></TR>
$str_list
</TBODY></TABLE>

<BR><p><a name="int"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>秀才　１０選</font></TH></TR>
$int_list
</TBODY></TABLE>

<BR><p><a name="lea"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>指揮　１０選</font></TH></TR>
$lea_list
</TBODY></TABLE>

<BR><p><a name="cha"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>魅力　１０選</font></TH></TR>
$cha_list
</TBODY></TABLE>

<BR><p><a name="sum"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=9 bgcolor=$TD_C13><font size=4 color=CCDDCC>名将　１０選</font></TH></TR>
$point_list
</TBODY></TABLE>

<BR><p><a name="gold"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>富豪　１０選</font></TH></TR>
$gold_list
</TBODY></TABLE>

<BR><p><a name="rice"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>穀物　１０選</font></TH></TR>
$rice_list
</TBODY></TABLE>

<BR><p><a name="class"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>功労者　１０選</font></TH></TR>
$class_list
</TBODY></TABLE>

<BR><p><a name="arm"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=6 bgcolor=$TD_C13><font size=4 color=CCDDCC>武器　１０選</font></TH></TR>
$arm_list
</TBODY></TABLE>

<BR><p><a name="bou"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=6 bgcolor=$TD_C13><font size=4 color=CCDDCC>防具　１０選</font></TH></TR>
$bou_list
</TBODY></TABLE>

<BR><p><a name="book"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=6 bgcolor=$TD_C13><font size=4 color=CCDDCC>書物　１０選</font></TH></TR>
$book_list
</TBODY></TABLE>

<BR><p><a name="sitahei"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>倒した兵数　１０選</font></TH></TR>
$dead_list
</TBODY></TABLE>

<BR><p><a name="sarehei"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>倒された兵数　１０選</font></TH></TR>
$sareta_list
</TBODY></TABLE>

<BR><p><a name="kou_win"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>闘神　１０選</font></TH></TR>
$kouwin_list
</TBODY></TABLE>

<BR><p><a name="bou_win"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>守護神　１０選</font></TH></TR>
$bouwin_list
</TBODY></TABLE>

<BR><p><a name="battle"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>戦神　１０選</font></TH></TR>
$koulos_list
</TBODY></TABLE>

<BR><p><a name="win"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>勝神　１０選</font></TH></TR>
$boulos_list
</TBODY></TABLE>

<BR><p><a name="sihai"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>支配回数　１０選</font></TH></TR>
$sihai_list
</TBODY></TABLE>

<BR><p><a name="kezuri"></a>
<TABLE border=1 width=80% class=S3 cellspacing=0 CELLPADDING=0><TBODY>
<TR><TH colspan=5 bgcolor=$TD_C13><font size=4 color=CCDDCC>城壁破壊　１０選</font></TH></TR>
$kezuri_list
</TBODY></TABLE>


<form action="$FILE_TOP" method="post">
<input type=submit id=input value="メニューに戻る"></form>

      </TD>
    </TR>
  </TBODY>
</TABLE>
EOM

	&FOOTER;

	exit;
}

