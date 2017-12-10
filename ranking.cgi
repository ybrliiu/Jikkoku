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

use CGI::Carp qw/fatalsToBrowser/;
use lib './lib', './extlib';
use Jikkoku::Model::Diplomacy;
my $diplomacy_model = Jikkoku::Model::Diplomacy->new;
use Jikkoku::Model::Country;
my $country_model = Jikkoku::Model::Country->new;

if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
&DECODE;
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }
if($mode eq 'C_RAN') { &C_RAN; }
else{&RANKING;}


#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#      参加者リストＯＰＥＮ      #
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

sub RANKING {

	&SERVER_STOP;

	open(IN,"$CHARA_DATA");
	@DL_DATA = <IN>;
	close(IN);

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。');
	@COU_DATA = <IN>;
	close(IN);
	$country_no=0;

	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
		$cou_name[$country_no]="$xname";
		$cou_name2[$xcid]="$xname";
		$c[$country_no]=0;
		$c_no[$country_no]=$xcid;
		$c_color[$xcid]=$xele;
		$c_king[$country_no]=$xking;
		($xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1)= split(/,/,$xsub);
		$c_gun[$country_no]=$xgunshi;
		$c_dai[$country_no]=$xdai;
		$c_sai[$country_no]=$xxsub1;
		$country_no++;
	}

	open(IN,"$TOWN_LIST");
	@T_LIST = <IN>;
	close(IN);
	$town_c0=0;$town_c1=0;$town_c2=0;$town_c3=0;
	$l=0;
	foreach(@T_LIST){
		($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$z[0],$z[1],$z[2],$z[3])=split(/<>/);
		$TOWN_NAME[$l]="$zname";
		for($p=0;$p<$country_no;$p++){
			if($zcon eq "$c_no[$p]"){$town_c[$p]++;$mes[$p].="$zname ";}
		}
		$l++;
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
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);

	@tmp = map {(split /<>/)[14]} @CL_DATA;
	@CL_DATA = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];
	$num = @CL_DATA;
	$i=0;
	$date = time;

	foreach(@CL_DATA) {
	($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);
		$s_num = int($kclass / $LANK);
		if($s_num > 100){$s_num = 100;}

		$chit=0;
		for($j=0;$j<$country_no;$j++){
			if($kcon eq "$c_no[$j]"){
				$chit=1;
				if($kid eq "$c_king[$j]"){
					$c_k_name[$j] = $kname;
				}
				if($kid eq "$c_gun[$j]"){
					$c_g_name[$j] = $kname;
				}
				if($kid eq "$c_dai[$j]"){
					$c_d_name[$j] = $kname;
				}
				if($kid eq "$c_sai[$j]"){
					$c_s_name[$j] = $kname;
				}
				if($c[$j] <= 10 && $kcon ne 0){
				$ldate = $DEL_TURN - $ksub2;
				if($ldate <= 0){
					$rm = "<font color=red>削除対象</font>";
				}else{
					$rm = "<font color=blue>$ldate</font>";
				}
				$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id='ballon' style='background-color:rgba($ELE_RGBA[$c_color[$kcon]]0.7)';><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$kid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";
				$list[$j] .= "<TR><TD><img src=$IMG/$kchara.gif width=64 height=64></TD><TD><span class=$kid>$kname</span></TD><TD>$kstr</TD><TD>$kint</TD><TD>$klea</TD><TD>$kcha</TD><TD>Lv.$s_num $LANK[$s_num]</TD><TD>武器：$kaname：威力：$karm<BR>書物：$ksname：威力：$kbook<BR>防具：$kbname：威力：$kmes</TD><TD>$rmターン</TD></TR>";
				}else{
				$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id='ballon' style='background-color:rgba($ELE_RGBA[$c_color[$kcon]]0.7)';><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$kid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";
					$lista[$j] .= "<span class=$kid>$kname</span>(Lv.$s_num $LANK[$s_num]) ";
				}
				$c[$j]++;
			}
		}

		if(!$chit){
				$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id='ballon' style='background-color:rgba($ELE_RGBA[$c_color[$kcon]]0.7)';><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$kid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";

				$list_etc .= "<span class=$kid>$kname</span> ";
		}
	}

	$b_js = 1;
	&HEADER;

	$l_rank = "<TR><TD></TD><TH>名前</TH><TH>武力</TH><TH>知力</TH><TH>統率力</TH><TH>人望</TH><TH>階級</TH><TH>装備品</TH><TH>削除まで</TH></TR>";

	print <<"EOM";

<script type="text/javascript"><!--
var num = 0;

\$(document).ready(function(){

$balllist

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

});
--></script>

<TABLE WIDTH="100%" height=100% bgcolor=$TABLE_C>
  <TBODY>
    <TR>
      <TD BGCOLOR=$TD_C1 WIDTH=100% height=5>　<font size=4>　　　＜＜<B> 　 - RANKING - 　 </B>＞＞</font></TD>
    </TR>
    <TR>
      <TD bgcolor=$TD_C4><CENTER>
<BR>
EOM

	$c_c=0;
	$c_i=0;
	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
		if($xking ne "" && $c_k_name[$c_c] eq ""){
			open(IN,"./charalog/main/$xking.cgi");
			@CN_DATA = <IN>;
			close(IN);
			($lid,$lpass,$lname) = split(/<>/,$CN_DATA[0]);
			$c_k_name[$c_c] = "$lname";
    }

    my $diplomacy_list = $diplomacy_model->get_by_country_id( $xcid );

print<<"EOM";
<TABLE bgcolor=$ELE_BG[$xele] width=60%><TBODY><TR><TD colspan=6 bgcolor=$ELE_BG[$xele] align=center><font color=$ELE_C[$xele] size=4><B>$xname</font></TD></TR><TR><TH bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>君主</TH><TH bgcolor=FFFFFF colspan=2><font size=3 color=$ELE_BG[$xele]>$c_k_name[$c_c]</TH><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>武将数</TD><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]> $c[$c_c] 名</TD><TD bgcolor=$ELE_C[$xele]><a href=./$FILE_RANK?mode=C_RAN&con_no=$xcid>武将一覧</a></TD></TR>
<TR><TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>軍師</TH>
<TH bgcolor=$ELE_C[$xele]><font size=2 color=$ELE_BG[$xele]>$c_g_name[$c_c]</TH>
<TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>宰相</TH>
<TH bgcolor=$ELE_C[$xele]><font size=2 color=$ELE_BG[$xele]>$c_s_name[$c_c]</TH>
<TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>大将軍</TH>
<TH bgcolor=$ELE_C[$xele]><font size=2 color=$ELE_BG[$xele]>$c_d_name[$c_c]</TH></TR>
<TR><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>支配都市数</TD><TD colspan=5 bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>$town_c[$c_c]都市($mes[$c_c])</TD></TR>
<TR><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>外交状況</font></TD><TD colspan=5 bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>@{[ map { $_->show_status( $xcid, $country_model ) . '<br>' } @$diplomacy_list ]}</font></TD></TR>
</TBODY></TABLE><BR>
      <TABLE bgcolor=$ELE_BG[$xele] border="0">
        <TBODY bgcolor=$ELE_C[$xele]>
$l_rank $list[$c_i] 
         </TR>
		<TR><TD bgcolor=$ELE_C[$xele] align=center colspan=20><font color=$ELE_BG[$xele]>$lista[$c_i]
		</TD></TR>
        </TBODY>
      </TABLE><br><br><br><br><br>
EOM
		$c_c++;
		$c_i++;
	}

print <<"EOM";
<TABLE bgcolor=$ELE_BG[0] width=60%><TBODY><TR><TD colspan=5 bgcolor=$ELE_BG[0] align=center><font color=$ELE_C[0] size=4><B>無所属国</font></TD></TR><TR><TD align=center bgcolor=$ELE_C[0]><a href=./$FILE_RANK?mode=C_RAN&con_no=0>放浪者一覧</a></TD></TR></TBODY></TABLE><BR>
      <TABLE width=100% bgcolor=$ELE_BG[0] border="0">
        <TBODY bgcolor=$ELE_C[0]>
		<TR><TD bgcolor=$ELE_C[0] align=center><font color=$ELE_BG[0]>$list_etc
		</TD></TR>
        </TBODY>
      </TABLE><br><br><br><br><br>
<p>現在総人口 $num 名
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


sub C_RAN{

	&SERVER_STOP;

	$C_NEXT_NUM = 100;

	open(IN,"$CHARA_DATA");
	@DL_DATA = <IN>;
	close(IN);
	$date = time;

	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。');
	@COU_DATA = <IN>;
	close(IN);
	$country_no=0;

	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
		$cou_name[$country_no]="$xname";
		$cou_name2[$xcid]="$xname";
		$c[$country_no]=0;
		$c_color[$xcid]=$xele;
		$c_no[$country_no]=$xcid;
		$c_king[$country_no]=$xking;
		($xgunshi,$xdai,$xuma,$xgoei,$xyumi,$xhei,$xxsub1)= split(/,/,$xsub);
		$c_gun[$country_no]=$xgunshi;
		$c_dai[$country_no]=$xdai;
		$c_sai[$country_no]=$xxsub1;
		$country_no++;
	}

	open(IN,"$TOWN_LIST");
	@T_LIST = <IN>;
	close(IN);
	$town_c0=0;$town_c1=0;$town_c2=0;$town_c3=0;
	$l=0;
	$papa = "$in{'con_no'}";
	foreach(@T_LIST){
		($zname,$zcon,$znum,$znou,$zsyo,$zshiro,$znou_max,$zsyo_max,$zshiro_max,$zpri,$zx,$zy,$zsouba,$z[0],$z[1],$z[2],$z[3])=split(/<>/);
		$TOWN_NAME[$l]="$zname";
			if($zcon eq "$papa"){$town_c[$papa]++;$mes[$papa].="$zname ";}
		$l++;
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
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);

	@tmp = map {(split /<>/)[14]} @CL_DATA;
	@CL_DATA = @CL_DATA[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp];
	$num = @CL_DATA;
	$i=0;

	if($in{'c_num'} eq ""){
		$c_num = 0;
	}else{
		$c_num = $in{'c_num'};
	}

		$j=0;
	if($in{'con_no'} ne "0"){
		foreach(@CL_DATA) {
	($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);
		$s_num = int($kclass / $LANK);
		if($s_num > 100){$s_num = 100;}

		$chit=0;
		for($j=0;$j<$country_no;$j++){

			if($kcon eq "$in{'con_no'}"){
			$chit=1;
			if($kid eq "$c_king[$j]"){
				$c_k_name[$in{'con_no'}] = "$kname";
			}
			if($kid eq "$c_gun[$j]"){
				$c_g_name[$in{'con_no'}] = "$kname";
			}
			if($kid eq "$c_dai[$j]"){
				$c_d_name[$in{'con_no'}] = "$kname";
			}
			if($kid eq "$c_sai[$j]"){
				$c_s_name[$in{'con_no'}] = "$kname";
			}

			if($c[$j] <= 10 && $kcon ne 0){
			$ldate = $DEL_TURN - $ksub2;
			if($ldate <= 0){
				$rm = "<font color=red>削除対象</font>";
			}else{
				$rm = "<font color=blue>$ldate</font>";
			}
			}
			$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id='ballon' style='background-color:rgba($ELE_RGBA[$c_color[$kcon]]0.7)';><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$kid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";
			$list[$j] .= "<TR><TD><img src=$IMG/$kchara.gif width=64 height=64></TD><TD><span class=$kid>$kname</span></TD><TD>$kstr</TD><TD>$kint</TD><TD>$klea</TD><TD>$kcha</TD><TD>Lv.$s_num $LANK[$s_num]</TD><TD>武器：$kaname：威力：$karm<BR>書物：$ksname：威力：$kbook<BR>防具：$kbname：威力：$kmes</TD><TD>$rmターン</TD></TR>";
			$c[$j]++;
			}
			}
		}
	}else{
		foreach(@CL_DATA) {
	($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5) = split(/<>/);
			$s_num = int($kclass / $LANK);
			if($s_num > 60){$s_num =60;}

			$chit=0;
			for($j=0;$j<$country_no;$j++){
				if($kcon eq "$c_no[$j]"){
				$chit=1;
				last;
				}
			}
			$ldate = $DEL_TURN - $ksub2;
			if($ldate <= 0){
				$rm = "<font color=red>削除対象</font>";
			}else{
				$rm = "<font color=blue>$ldate</font>";
			}

			if(!$chit){
			if($c[0] >= $c_num && $c[0] < $c_num + $C_NEXT_NUM){
			$balllist .= "\$(\".$kid\").click(function () {if(num<1){\$(this).append(\$(\"<div id='ballon' style='background-color:rgba($ELE_RGBA[$c_color[$kcon]]0.7)';><table><tr><td style='text-align:right;height:5px;'><span id=clo><b>×閉じる</b></span></td><tr><td style='width:100\%;height:100\%;'><iframe src='./menu.cgi?id=$kid&send=1'></iframe></td></tr></table></div>\"));}num++;});\n";
			$list[0] .= "<TR><TD><img src=$IMG/$kchara.gif width=64 height=64></TD><TD><span class=$kid>$kname</span></TD><TD>$kstr</TD><TD>$kint</TD><TD>$klea</TD><TD>$kcha</TD><TD>Lv.$s_num $LANK[$s_num]</TD><TD>武器：$kaname：威力：$karm<BR>書物：$ksname：威力：$kbook<BR>防具：$kbname：威力：$kmes</TD><TD>$rmターン</TD></TR>";
			$c[$j]++;
			}
				$c[0]++;
			}
		}
	}

	$b_js = 1;
	&HEADER;

	$l_rank = "<TR><TD></TD><TH>名前</TH><TH>武力</TH><TH>知力</TH><TH>統率力</TH><TH>人望</TH><TH>階級</TH><TH>装備品</TH><TH>削除まで</TH></TR>";

	print <<"EOM";

<script type="text/javascript"><!--
var num = 0;

\$(document).ready(function(){

$balllist

\$(document).on('click','#clo', function(){\$("div:last").remove();num = 0;});

});
--></script>

<TABLE WIDTH="100%" height=100% bgcolor=$TABLE_C>
  <TBODY>
    <TR>
      <TD BGCOLOR=$TD_C1 WIDTH=100% height=5>　<font size=4>　　　＜＜<B> 　 - RANKING - 　 </B>＞＞</font></TD>
    </TR>
    <TR>
      <TD bgcolor=$TD_C4><CENTER>
<BR>
EOM

	$c_c=0;
	if($in{'con_no'} ne "0"){

		foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);
			if($xcid eq $in{'con_no'}){
			if($xking ne "" && $c_k_name[$c_c] eq ""){
				open(IN,"./charalog/main/$xking.cgi");
				@CN_DATA = <IN>;
				close(IN);
				($lid,$lpass,$lname) = split(/<>/,$CN_DATA[0]);
				$c_k_name[$c_c] = "$lname";
			}

      my $diplomacy_list = $diplomacy_model->get_by_country_id( $xcid );

	print<<"EOM";
<TABLE bgcolor=$ELE_BG[$xele] width=60%><TBODY><TR><TD colspan=6 bgcolor=$ELE_BG[$xele] align=center><font color=$ELE_C[$xele] size=4><B>$xname</font></TD></TR><TR><TH bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>君主</TH><TH bgcolor=FFFFFF colspan=2><font size=3 color=$ELE_BG[$xele]>$c_k_name[$c_c]</TH><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>武将数</TD><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]> $c[$c_c] 名</TD><TD bgcolor=$ELE_C[$xele]><a href=./$FILE_RANK?mode=C_RAN&con_no=$xcid>武将一覧</a></TD></TR>
<TR><TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>軍師</TH>
<TH bgcolor=$ELE_C[$xele]><font size=2 color=$ELE_BG[$xele]>$c_g_name[$in{'con_no'}]</TH>
<TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>宰相</TH>
<TH bgcolor=$ELE_C[$xele]><font size=2 color=$ELE_BG[$xele]>$c_s_name[$in{'con_no'}]</TH>
<TH bgcolor=$ELE_BG[$xele]><font color=$ELE_C[$xele]>大将軍</TH>
<TH bgcolor=$ELE_C[$xele]><font size=2 color=$ELE_BG[$xele]>$c_d_name[$in{'con_no'}]</TH></TR>
<TR><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>支配都市数</TD><TD colspan=5 bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>$town_c[$in{'con_no'}]都市($mes[$in{'con_no'}])</TD></TR>
<TR><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>外交状況</font></TD><TD colspan=5 bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>@{[ map { $_->show_status( $xcid, $country_model ) . '<br>' } @$diplomacy_list ]}</font></TD></TR>
</TBODY></TABLE><BR>
	      <TABLE bgcolor=$ELE_BG[$xele] border="0">
	        <TBODY bgcolor=$ELE_C[$xele]>
	$l_rank $list[$c_c] 
	         </TR>
			<TR><TD bgcolor=$ELE_C[$xxele] align=center colspan=20><font color=$ELE_BG[$xxele]>$lista[0]
			</TD></TR>
	        </TBODY>
	      </TABLE><br><br><br><br><br>
EOM
			$c_c++;
			}
		}

	}else{

	$xele=0;

	print<<"EOM";
	<TABLE bgcolor=$ELE_BG[$xxele] width=60%><TBODY><TR><TD colspan=2 bgcolor=$ELE_BG[$xele] align=center><font color=$ELE_C[$xele] size=4><B>無所属</font></TD></TR><TR><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]>武将数</TD><TD bgcolor=$ELE_C[$xele]><font color=$ELE_BG[$xele]> $c[$c_c] 名</TD></TR></TBODY></TABLE><BR>
	      <TABLE bgcolor=$ELE_BG[$xele] border="0">
	        <TBODY bgcolor=$ELE_C[$xele]>
	$l_rank $list[$c_c] 
	         </TR>
	        </TBODY>
	      </TABLE><br><br><br><br><br>
EOM
	}

	$q=0;
	for($p=0;$p<$c[0];$p+=$C_NEXT_NUM){
		$next_mes .= "\[<a href=./$FILE_RANK?mode=C_RAN&con_no=$in{'con_no'}&c_num=$p>$q</a>\] ";
		$q++;
	}
	
print <<"EOM";
$next_mes
<form action="$FILE_RANK" method="post">
<input type=submit id=input value="RANKING TOP"></form>

      </TD>
    </TR>
  </TBODY>
</TABLE>
EOM

	&FOOTER;

	exit;

}
