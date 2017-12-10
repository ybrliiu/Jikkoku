#!/usr/bin/perl

#グラフ#

require './ini_file/index.ini';
require 'suport.pl';

&DECODE;
if($mode eq 'LIGHT') { &LIGHT; }
else{ &STATUS;} 
if($MENTE) { &ERR2("メンテナンス中です。しばらくお待ちください。"); }
if($ENV{'HTTP_REFERER'} !~ /i/ && $CHEACKER){ &ERR2("アドレスバーに値を入力しないでください。"); }

	&SERVER_STOP;



#軽量版（数値のみ）#

sub LIGHT {


	opendir(dirlist,"./charalog/main");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"./charalog/main/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);


	$goukei = 0;
	$inttype = 0;
	$strtype = 0;
	$leatype = 0;
	$chatype = 0;
	foreach(@CL_DATA){
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

	($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

	($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);

	($esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$ehiki,$eoujyou,$e_kei,$e_tan) = split(/,/,$esub3);

	($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL) = split(/,/,$esub4);


	$no[$econ]++;
	$sohei[$econ] += $esol;
	$tyohei[$econ] += $esol/$elea;
	if($esyuppei){
	$syutugeki[$econ] ++;
	}
	$money[$econ] += $egold;
	$rice[$econ] += $erice;
	$sent[$econ] += $ebouwin + $ekouwin + $ekoulos + $eboulos +$ehiki;
	$class[$econ] += $eclass;
	$str[$econ] += $estr;
	$int[$econ] += $eint;
	$lea[$econ] += $elea;
	$cha[$econ] += $echa;
	$kei[$econ] += $estr+$eint+$elea+$echa;
		if(($eint > $estr)&&($eint > $echa)&&($eint > $elea)){
		$inttype++;
		}elsif(($elea > $estr)&&($elea > $echa)&&($elea > $eint)){
		$leatype++;
		}elsif(($echa > $estr)&&($echa > $elea)&&($echa > $eint)){
		$chatype++;
		}else{
		$strtype++;
		}
	$goukei++;
}




	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	$country_no=0;$hit=0;
	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);

		$ninzugraph .= "$xname:$no[$xcid]人 ";
		$soheigraph .= "$xname:$sohei[$xcid]人 ";
#0除算の場合の特別処理
if($no[$xcid] == 0 || $no[$xcid] eq ""){
$no[$xcid]=1;
}
		$tyoheiritu[$xcid] = int(($tyohei[$xcid]/$no[$xcid])*100);
		$tyoheigraph .= "$xname:$tyoheiritu[$xcid]％ ";
		$syutugekiritu[$xcid] = int(($syutugeki[$xcid]/$no[$xcid])*100);
		$syutugraph .= "$xname:$syutugekiritu[$xcid]％ ";
		$moneyritu[$xcid] = int($money[$xcid]/$no[$xcid]);
		$moneygraph .= "$xname:$moneyritu[$xcid]G ";
		$riceritu[$xcid] = int($rice[$xcid]/$no[$xcid]);
		$ricegraph .= "$xname:$riceritu[$xcid]R ";
		$sentritu[$xcid] = int($sent[$xcid]/$no[$xcid]);
		$sentgraph .= "$xname:$sentritu[$xcid]回 ";
		$classritu[$xcid] = int($class[$xcid]/$no[$xcid]);
		$classgraph .= "$xname:$classritu[$xcid] ";
		$strritu[$xcid] = int($str[$xcid]/$no[$xcid]);
		$strgraph .= "$xname:$strritu[$xcid] ";
		$intritu[$xcid] = int($int[$xcid]/$no[$xcid]);
		$intgraph .= "$xname:$intritu[$xcid] ";
		$learitu[$xcid] = int($lea[$xcid]/$no[$xcid]);
		$leagraph .= "$xname:$learitu[$xcid] ";
		$charitu[$xcid] = int($cha[$xcid]/$no[$xcid]);
		$chagraph .= "$xname:$charitu[$xcid] ";
		$keiritu[$xcid] = int($kei[$xcid]/$no[$xcid]);
		$keigraph .= "$xname:$keiritu[$xcid] ";

		$country_no++;
	}




	&HEADER;

	print <<"EOM";
<table bgcolor="#6d614a" cellspacing="3">
<tr><td align="center" bgcolor="#FFFFFF" colspan="3" valign="middle"><b><font size="3">- 国力比較（数値のみ） -</font></b>[<a href="./graph.cgi">グラフあり</a>]</td></tr>
<tr><td>


<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>武将数</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		$ninzugraph
</td></tr>
</table>

</td></tr><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>総兵力</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$soheigraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均徴兵率</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$tyoheigraph
</td></tr>
</table>

</td></tr><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>出撃率</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$syutugraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均所持金</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$moneygraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均所持米</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$ricegraph
</td></tr>
</table>

</td></tr><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均戦闘回数</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$sentgraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均階級値</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$classgraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>武力平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$strgraph
</td></tr>
</table>

</td></tr><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>知力平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$intgraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>統率力平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$leagraph
</td></tr>
</table>

</td><td><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>人望平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$chagraph
</td></tr>
</table>

</td></tr><tr><td>

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>能力値の合計の平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
$keigraph
</td></tr>
</table>

</td></tr><tr><td colspan="3">

<table width="100%" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>武将タイプの割合(合計:$goukei人)</b></td></tr>
<tr><td align="center" bgcolor="#FFFFFF">武官:$strtype人 文官:$inttype人 統率官:$leatype人 仁官:$inttype人</td></tr>
</table>


</td></tr></table>


EOM


	&FOOTER;

exit;

}









#通常版（グラフあり）#

sub STATUS{


	opendir(dirlist,"./charalog/main");
	while($file = readdir(dirlist)){
		if($file =~ /\.cgi/i){
			if(!open(page,"./charalog/main/$file")){
				&ERR2("ファイルオープンエラー！");
			}
			@page = <page>;
			close(page);
			push(@CL_DATA,"@page<br>");
		}
	}
	closedir(dirlist);


	$goukei = 0;
	$inttype = 0;
	$strtype = 0;
	$leatype = 0;
	$chatype = 0;
	foreach(@CL_DATA){
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email,$eos,$ecm,$est,$esz,$esg,$eyumi,$eiba,$ehohei,$esenj,$esm,$ebname,$eaname,$esname,$eazoku,$eaai,$esub3,$esub4,$esub5) = split(/<>/);

	($estr_ex,$eint_ex,$elea_ex,$echa_ex,$esub1_ex,$esub2_ex) = split(/,/,$esub1);

	($ejinkei,$esyuppei,$eiti,$ex,$ey,$ebattletime,$ekoutime,$eidoup,$ekicn,$eksup,$emsup,$esakup,$eonmip) = split(/,/,$esenj);

	($esitahei,$esarehei,$ebouwin,$ekouwin,$ekoulos,$eboulos,$ekun,$enai,$emei,$ehiki,$eoujyou,$e_kei,$e_tan) = split(/,/,$esub3);

	($erenpei,$ehitokiri,$estk,$egsk,$eoujyou2,$eago,$eagoL,$eyoudou,$eyoudouL,$eobu,$eobuL,$esendou,$esendouL) = split(/,/,$esub4);


	$no[$econ]++;
	$sohei[$econ] += $esol;
	$tyohei[$econ] += $esol/$elea;
	if($esyuppei){
	$syutugeki[$econ] ++;
	}
	$money[$econ] += $egold;
	$rice[$econ] += $erice;
	$sent[$econ] += $ebouwin + $ekouwin + $ekoulos + $eboulos +$ehiki;
	$class[$econ] += $eclass;
	$str[$econ] += $estr;
	$int[$econ] += $eint;
	$lea[$econ] += $elea;
	$cha[$econ] += $echa;
	$kei[$econ] += $estr+$eint+$elea+$echa;
		if(($eint > $estr)&&($eint > $echa)&&($eint > $elea)){
		$inttype++;
		}elsif(($elea > $estr)&&($elea > $echa)&&($elea > $eint)){
		$leatype++;
		}elsif(($echa > $estr)&&($echa > $elea)&&($echa > $eint)){
		$chatype++;
		}else{
		$strtype++;
		}
	$goukei++;
}




	open(IN,"$COUNTRY_LIST") or &ERR2('ファイルを開けませんでした。err no :country');
	@COU_DATA = <IN>;
	close(IN);
	$country_no=0;$hit=0;
	foreach(@COU_DATA){
		($xcid,$xname,$xele,$xmark,$xking,$xmes,$xsub,$xpri)=split(/<>/);

		if($no[$xcid] > $no_max){
		$no_max = $no[$xcid];
		}
		$ninzugraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$no[$xcid]]
        },";
		if($sohei[$xcid] > $sohei_max){
		$sohei_max = $sohei[$xcid];
		}
		$soheigraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$sohei[$xcid]]
        },";

#0除算の場合の特別処理
if($no[$xcid] == 0 || $no[$xcid] eq ""){
$no[$xcid]=1;
}
		$tyoheiritu[$xcid] = int(($tyohei[$xcid]/$no[$xcid])*100);

		$tyoheigraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$tyoheiritu[$xcid]]
        },";
		$syutugekiritu[$xcid] = int(($syutugeki[$xcid]/$no[$xcid])*100);
		$syutugraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$syutugekiritu[$xcid]]
        },";
		$moneyritu[$xcid] = int($money[$xcid]/$no[$xcid]);
		if($moneyritu[$xcid] > $money_max){
		$money_max = $moneyritu[$xcid];
		}
		$moneygraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$moneyritu[$xcid]]
        },";
		$riceritu[$xcid] = int($rice[$xcid]/$no[$xcid]);
		if($riceritu[$xcid] > $rice_max){
		$rice_max = $riceritu[$xcid];
		}
		$ricegraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$riceritu[$xcid]]
        },";
		$sentritu[$xcid] = int($sent[$xcid]/$no[$xcid]);
		if($sentritu[$xcid] > $sent_max){
		$sent_max = $sentritu[$xcid];
		}
		$sentgraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$sentritu[$xcid]]
        },";
		$classritu[$xcid] = int($class[$xcid]/$no[$xcid]);
		if($classritu[$xcid] > $class_max){
		$class_max = $classritu[$xcid];
		}
		$classgraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$classritu[$xcid]]
        },";
		$strritu[$xcid] = int($str[$xcid]/$no[$xcid]);
		if($strritu[$xcid] > $str_max){
		$str_max = $strritu[$xcid];
		}
		$strgraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$strritu[$xcid]]
        },";
		$intritu[$xcid] = int($int[$xcid]/$no[$xcid]);
		if($intritu[$xcid] > $int_max){
		$int_max = $intritu[$xcid];
		}
		$intgraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$intritu[$xcid]]
        },";
		$learitu[$xcid] = int($lea[$xcid]/$no[$xcid]);
		if($learitu[$xcid] > $lea_max){
		$lea_max = $learitu[$xcid];
		}
		$leagraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$learitu[$xcid]]
        },";
		$charitu[$xcid] = int($cha[$xcid]/$no[$xcid]);
		if($charitu[$xcid] > $cha_max){
		$cha_max = $charitu[$xcid];
		}
		$chagraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$charitu[$xcid]]
        },";
		$keiritu[$xcid] = int($kei[$xcid]/$no[$xcid]);
		if($keiritu[$xcid] > $kei_max){
		$kei_max = $keiritu[$xcid];
		}
		$keigraph .= "        {
            fillColor : \"$ELE_BG[$xele]\",
            strokeColor : \"rgba(220, 220, 220, 1)\",
            data : [$keiritu[$xcid]]
        },";
		$tyoheititle .= "$xname:<font color=$ELE_BG[$xele]>■</font> ";

		$country_no++;
	}



#グラフy軸の上昇値?#
	if($no_max <= 10){
	$no_gmax = 1;
	}elsif($no_max < 100){
	$no_gmax = int($no_max/10)+1;
	}else{
	$no_gmax = (int($no_max/100)+1)*10;
	}

	if($sohei_max <= 100){
	$sohei_gmax = 10;
	}elsif($sohei_max < 1000){
	$sohei_gmax = (int($sohei_max/100)+1)*10;
	}elsif($sohei_max < 10000){
	$sohei_gmax = (int($sohei_max/1000)+1)*100;
	}elsif($sohei_max < 100000){
	$sohei_gmax = (int($sohei_max/10000)+1)*1000;
	}else{
	$sohei_gmax = (int($sohei_max/100000)+1)*10000;
	}

	if($money_max <= 10000){
	$money_gmax = 1000;
	}elsif($money_max < 100000){
	$money_gmax = (int($money_max/10000)+1)*1000;
	}elsif($money_max < 1000000){
	$money_gmax = (int($money_max/100000)+1)*10000;
	}elsif($money_max < 10000000){
	$money_gmax = (int($money_max/1000000)+1)*100000;
	}else{
	$money_gmax = (int($money_max/10000000)+1)*1000000;
	}

	if($rice_max <= 10000){
	$rice_gmax = 1000;
	}elsif($rice_max < 100000){
	$rice_gmax = (int($rice_max/10000)+1)*1000;
	}elsif($rice_max < 1000000){
	$rice_gmax = (int($rice_max/100000)+1)*10000;
	}elsif($rice_max < 10000000){
	$rice_gmax = (int($rice_max/1000000)+1)*100000;
	}else{
	$rice_gmax = (int($rice_max/10000000)+1)*1000000;
	}

	if($sent_max <= 10){
	$sent_gmax = 1;
	}elsif($sent_max < 100){
	$sent_gmax = int($sent_max/10)+1;
	}elsif($sent_max < 1000){
	$sent_gmax = (int($sent_max/100)+1)*10;
	}elsif($sent_max < 10000){
	$sent_gmax = (int($sent_max/1000)+1)*100;
	}else{
	$sent_gmax = (int($sent_max/10000)+1)*1000;
	}

	if($class_max <= 1000){
	$class_gmax = 100;
	}elsif($class_max < 10000){
	$class_gmax = (int($class_max/1000)+1)*100;
	}elsif($class_max < 100000){
	$class_gmax = (int($class_max/10000)+1)*1000;
	}elsif($class_max < 1000000){
	$class_gmax = (int($class_max/100000)+1)*10000;
	}else{
	$class_gmax = (int($class_max/1000000)+1)*100000;
	}

	if($str_max < 100){
	$str_gmax = int($str_max/10)+1;
	}elsif($str_max < 1000){
	$str_gmax = (int($str_max/100)+1)*10;
	}else{
	$str_gmax = (int($str_max/1000)+1)*100;
	}

	if($int_max < 100){
	$int_gmax = int($int_max/10)+1;
	}elsif($int_max < 1000){
	$int_gmax = (int($int_max/100)+1)*10;
	}else{
	$int_gmax = (int($int_max/1000)+1)*100;
	}

	if($lea_max < 100){
	$lea_gmax = int($lea_max/10)+1;
	}elsif($lea_max < 1000){
	$lea_gmax = (int($lea_max/100)+1)*10;
	}else{
	$lea_gmax = (int($lea_max/1000)+1)*100;
	}

	if($cha_max < 100){
	$cha_gmax = int($cha_max/10)+1;
	}elsif($cha_max < 1000){
	$cha_gmax = (int($cha_max/100)+1)*10;
	}else{
	$cha_gmax = (int($cha_max/1000)+1)*100;
	}

	if($kei_max < 1000){
	$kei_gmax = (int($kei_max/100)+1)*10;
	}elsif($kei_max < 10000){
	$kei_gmax = (int($kei_max/1000)+1)*100;
	}else{
	$kei_gmax = (int($kei_max/10000)+1)*1000;
	}




$graph = "1";
	&HEADER;

	print <<"EOM";
<table bgcolor="#6d614a" cellspacing="3">
<tr><td align="center" bgcolor="#FFFFFF" colspan="3" valign="middle"><b><font size="3">- 国力比較 -</font></b>[<a href="./graph.cgi?mode=LIGHT">数値のみ</a>]</td></tr>
<tr><td>


<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>武将数</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="ninzu" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>総兵力</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="sohei" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均徴兵率</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="canvas" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td></tr><tr><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>出撃率</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="syutugeki" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均所持金</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="money" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均所持米</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="rice" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td></tr><tr><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均戦闘回数</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="sent" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>平均階級値</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="class" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>武力平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="str" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td></tr><tr><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>知力平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="int" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>統率力平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="lea" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>人望平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="cha" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td></tr><tr><td>

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>能力値の合計の平均</b></td></tr>
<tr><td bgcolor="#FFFFFF"><br>
		<canvas id="kei" height="250" width="400"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">$tyoheititle</td></tr>
</table>

</td></tr><tr><td colspan="3">

<table height="250" width="400" cellspacing="3" bgcolor="#6d614a">
<tr><td align="center" bgcolor="#FFFFFF"><b>武将タイプの割合(合計:$goukei人)</b></td></tr>
<tr><td bgcolor="#FFFFFF">
<canvas id="en" height="450" width="600"></canvas>
</td></tr>
<tr><td align="center" bgcolor="#FFFFFF">武官:<font color="#F7464A">■</font> 文官:<font color="#3CB371">■</font> 統率官:<font color="#FF7F50">■</font> 仁官:<font color="#6A5ACD">■</font></td></tr>
</table>


</td></tr></table>



<script>

var barChartData = {
    labels : [''],
    datasets : [
$ninzugraph
    ]
}
// オプション
var options = {
    // X, Y 軸ラインが棒グラフの値の上にかぶさるようにするか    
    scaleOverlay : true,
    // 値の開始値などを自分で設定するか
    scaleOverride : true,
    
    // 以下の 3 オプションは scaleOverride: true の時に使用
    // Y 軸の値のステップ数
    // e.g. 10 なら Y 軸の値は 10 個表示される
    scaleSteps : 10,
    // Y 軸の値のステップする大きさ
    // e.g. 10 なら 0, 10, 20, 30 のように増えていく
    scaleStepWidth : $no_gmax,
    // Y 軸の値の始まりの値
    scaleStartValue : 0,
    // X, Y 軸ラインの色
    scaleLineColor : "rgba(0, 0, 0, .1)",
    // X, Y 軸ラインの幅
    scaleLineWidth : 1,
    // ラベルの表示 ( Y 軸の値 )
    scaleShowLabels : true,
    // ラベルの表示フォーマット ( Y 軸の値 )
    scaleLabel : "<%=value%>(人)",
    // X, Y 軸値のフォント
    scaleFontFamily : "'Arial'",
    // X, Y 軸値のフォントサイズ
    scaleFontSize : 12,
    // X, Y 軸値のフォントスタイル, normal, italic など
    scaleFontStyle : "normal",
    // X, Y 軸値の文字色
    scaleFontColor : "#666",    
    // グリッドライン ( Y 軸の横ライン ) の表示 
    scaleShowGridLines : true,
    // グリッドラインの色
    scaleGridLineColor : "rgba(0, 0, 0, .05)",
    // グリッドラインの幅
    scaleGridLineWidth : 1,
    // 棒グラフの値部分の枠線の表示
    barShowStroke : true,
    // 棒グラフの値部分の枠線の幅    
    barStrokeWidth : 1,
    // 棒グラフの値と値のスペース ( 違う X 値のものと )
    barValueSpacing : 5,
    // 棒グラフの値と値のスペース ( 同じ X 値のものと )
    barDatasetSpacing : 1,
    // 表示の時のアニメーション
    animation : true,
    // アニメーションの速度 ( ステップ数 )
    animationSteps : 50,
    // アニメーションの種類, 以下が用意されている
    // linear, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic,
    // easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint,
    // easeOutQuint, easeInOutQuint, easeInSine, easeOutSine, easeInOutSine,
    // easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc,
    // easeInElastic, easeOutElastic, easeInOutElastic, easeInBack, easeOutBack,
    // easeInOutBack, easeInBounce, easeOutBounce, easeInOutBounce
    animationEasing : "easeOutQuad",
    // アニメーション終了後に実行する処理
    // animation: false の時にも実行されるようです
    // e.g. onAnimationComplete : function() {alert('complete');}
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("ninzu").getContext("2d")).Bar(barChartData, options);




var barChartData = {
    labels : [''],
    datasets : [
$soheigraph
    ]
}

var options = {
     scaleOverlay : true,
    scaleOverride : true,
    
     scaleSteps : 10,
     scaleStepWidth : $sohei_gmax,
     scaleStartValue : 0,
     scaleLineColor : "rgba(0, 0, 0, .1)",
     scaleLineWidth : 1,
      scaleShowLabels : true,
     scaleLabel : "<%=value%>(人)",
     scaleFontFamily : "'Arial'",
    scaleFontSize : 12,
    scaleFontStyle : "normal",
     scaleFontColor : "#666",    
     scaleShowGridLines : true,
     scaleGridLineColor : "rgba(0, 0, 0, .05)",
     scaleGridLineWidth : 1,
    barShowStroke : true,
     barStrokeWidth : 1,
    barValueSpacing : 5,
     barDatasetSpacing : 1,
    animation : true,
    animationSteps : 50,
     animationEasing : "easeOutQuad",
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("sohei").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$tyoheigraph
    ]
}

var options = {
      scaleOverlay : true,
      scaleOverride : true,
    
     scaleSteps : 10,
      scaleStepWidth : 10,
      scaleStartValue : 0,
      scaleLineColor : "rgba(0, 0, 0, .1)",
      scaleLineWidth : 1,
      scaleShowLabels : true,
     scaleLabel : "<%=value%>%",
      scaleFontFamily : "'Arial'",
     scaleFontSize : 12,
     scaleFontStyle : "normal",
    scaleFontColor : "#666",    
     scaleShowGridLines : true,
    scaleGridLineColor : "rgba(0, 0, 0, .05)",
     scaleGridLineWidth : 1,
    barShowStroke : true,
     barStrokeWidth : 1,
      barValueSpacing : 5,
      barDatasetSpacing : 1,
     animation : true,
     animationSteps : 50,
     animationEasing : "easeOutQuad",
     onAnimationComplete : null
}
var chart = new Chart(document.getElementById("canvas").getContext("2d")).Bar(barChartData, options);




var barChartData = {
    labels : [''],
    datasets : [
$syutugraph
    ]
}

var options = {
      scaleOverlay : true,
       scaleOverride : true,
    
       scaleSteps : 10,
      scaleStepWidth : 10,
      scaleStartValue : 0,
     scaleLineColor : "rgba(0, 0, 0, .1)",
     scaleLineWidth : 1,
      scaleShowLabels : true,
      scaleLabel : "<%=value%>%",
       scaleFontFamily : "'Arial'",
     scaleFontSize : 12,
     scaleFontStyle : "normal",
     scaleFontColor : "#666",    
     scaleShowGridLines : true,
     scaleGridLineColor : "rgba(0, 0, 0, .05)",
     scaleGridLineWidth : 1,
      barShowStroke : true,
     barStrokeWidth : 1,
      barValueSpacing : 5,
      barDatasetSpacing : 1,
     animation : true,
     animationSteps : 50,
    animationEasing : "easeOutQuad",
     onAnimationComplete : null
}
var chart = new Chart(document.getElementById("syutugeki").getContext("2d")).Bar(barChartData, options);
	



var barChartData = {
    labels : [''],
    datasets : [
$moneygraph
    ]
}

var options = {
     scaleOverlay : true,
      scaleOverride : true,
    
    scaleSteps : 10,
      scaleStepWidth : $money_gmax,
      scaleStartValue : 0,
      scaleLineColor : "rgba(0, 0, 0, .1)",
      scaleLineWidth : 1,
      scaleShowLabels : true,
     scaleLabel : "<%=value%>(G)",
     scaleFontFamily : "'Arial'",
     scaleFontSize : 12,
     scaleFontStyle : "normal",
     scaleFontColor : "#666",    
      scaleShowGridLines : true,
     scaleGridLineColor : "rgba(0, 0, 0, .05)",
     scaleGridLineWidth : 1,
     barShowStroke : true,
    barStrokeWidth : 1,
    barValueSpacing : 5,
    barDatasetSpacing : 1,
     animation : true,
    animationSteps : 50,
    animationEasing : "easeOutQuad",
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("money").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$ricegraph
    ]
}

var options = {
    scaleOverlay : true,
    scaleOverride : true,
    
     scaleSteps : 10,
     scaleStepWidth : $rice_gmax,
    scaleStartValue : 0,
     scaleLineColor : "rgba(0, 0, 0, .1)",
    scaleLineWidth : 1,
     scaleShowLabels : true,
     scaleLabel : "<%=value%>(R)",
     scaleFontFamily : "'Arial'",
    scaleFontSize : 12,
     scaleFontStyle : "normal",
     scaleFontColor : "#666",    
     scaleShowGridLines : true,
    scaleGridLineColor : "rgba(0, 0, 0, .05)",
    scaleGridLineWidth : 1,
     barShowStroke : true,
    barStrokeWidth : 1,
      barValueSpacing : 5,
     barDatasetSpacing : 1,
     animation : true,
    animationSteps : 50,
    animationEasing : "easeOutQuad",
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("rice").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$sentgraph
    ]
}

var options = {
     scaleOverlay : true,
    scaleOverride : true,
    
     scaleSteps : 10,
      scaleStepWidth : $sent_gmax,
    scaleStartValue : 0,
     scaleLineColor : "rgba(0, 0, 0, .1)",
    scaleLineWidth : 1,
   scaleShowLabels : true,
    scaleLabel : "<%=value%>(回)",
    scaleFontFamily : "'Arial'",
    scaleFontSize : 12,
     scaleFontStyle : "normal",
     scaleFontColor : "#666",    
    scaleShowGridLines : true,
     scaleGridLineColor : "rgba(0, 0, 0, .05)",
    scaleGridLineWidth : 1,
    barShowStroke : true,
    barStrokeWidth : 1,
     barValueSpacing : 5,
     barDatasetSpacing : 1,
    animation : true,
     animationSteps : 50,
    animationEasing : "easeOutQuad",
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("sent").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$classgraph
    ]
}

var options = {
 
    scaleOverlay : true,

    scaleOverride : true,
    

    scaleSteps : 10,

    scaleStepWidth : $class_gmax,

    scaleStartValue : 0,

    scaleLineColor : "rgba(0, 0, 0, .1)",

    scaleLineWidth : 1,

    scaleShowLabels : true,

    scaleLabel : "<%=value%>",

    scaleFontFamily : "'Arial'",

    scaleFontSize : 12,

    scaleFontStyle : "normal",

    scaleFontColor : "#666",    

    scaleShowGridLines : true,

    scaleGridLineColor : "rgba(0, 0, 0, .05)",

    scaleGridLineWidth : 1,

    barShowStroke : true,
  
    barStrokeWidth : 1,

    barValueSpacing : 5,

    barDatasetSpacing : 1,

    animation : true,

    animationSteps : 50,

    animationEasing : "easeOutQuad",

    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("class").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$strgraph
    ]
}

var options = {
  
    scaleOverlay : true,

    scaleOverride : true,
    

    scaleSteps : 10,

    scaleStepWidth : $str_gmax,

    scaleStartValue : 0,

    scaleLineColor : "rgba(0, 0, 0, .1)",

    scaleLineWidth : 1,

    scaleShowLabels : true,

    scaleLabel : "<%=value%>",

    scaleFontFamily : "'Arial'",

    scaleFontSize : 12,

    scaleFontStyle : "normal",

    scaleFontColor : "#666",    

    scaleShowGridLines : true,

    scaleGridLineColor : "rgba(0, 0, 0, .05)",

    scaleGridLineWidth : 1,

    barShowStroke : true,
  
    barStrokeWidth : 1,

    barValueSpacing : 5,

    barDatasetSpacing : 1,

    animation : true,

    animationSteps : 50,

    animationEasing : "easeOutQuad",

    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("str").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$intgraph
    ]
}

var options = {

    scaleOverlay : true,

    scaleOverride : true,
    

    scaleSteps : 10,

    scaleStepWidth : $int_gmax,

    scaleStartValue : 0,

    scaleLineColor : "rgba(0, 0, 0, .1)",

    scaleLineWidth : 1,

    scaleShowLabels : true,
  
    scaleLabel : "<%=value%>",
  
    scaleFontFamily : "'Arial'",
  
    scaleFontSize : 12,
  
    scaleFontStyle : "normal",
  
    scaleFontColor : "#666",    
 
    scaleShowGridLines : true,
 
    scaleGridLineColor : "rgba(0, 0, 0, .05)",
 
    scaleGridLineWidth : 1,

    barShowStroke : true,

    barStrokeWidth : 1,

    barValueSpacing : 5,

    barDatasetSpacing : 1,

    animation : true,

    animationSteps : 50,

    animationEasing : "easeOutQuad",

    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("int").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$leagraph
    ]
}

var options = {

    scaleOverlay : true,

    scaleOverride : true,
    

    scaleSteps : 10,

    scaleStepWidth : $lea_gmax,
 
    scaleStartValue : 0,
 
    scaleLineColor : "rgba(0, 0, 0, .1)",
 
    scaleLineWidth : 1,
 
    scaleShowLabels : true,
 
    scaleLabel : "<%=value%>",
 
    scaleFontFamily : "'Arial'",

    scaleFontSize : 12,

    scaleFontStyle : "normal",

    scaleFontColor : "#666",    

    scaleShowGridLines : true,

    scaleGridLineColor : "rgba(0, 0, 0, .05)",

    scaleGridLineWidth : 1,

    barShowStroke : true,

    barStrokeWidth : 1,

    barValueSpacing : 5,

    barDatasetSpacing : 1,

    animation : true,

    animationSteps : 50,

    animationEasing : "easeOutQuad",

    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("lea").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$chagraph
    ]
}

var options = {

    scaleOverlay : true,
    scaleOverride : true,
    

    scaleSteps : 10,
    scaleStepWidth : $cha_gmax,
    scaleStartValue : 0,
    scaleLineColor : "rgba(0, 0, 0, .1)",
    scaleLineWidth : 1,
    scaleShowLabels : true,
    scaleLabel : "<%=value%>",
    scaleFontFamily : "'Arial'",
    scaleFontSize : 12,
    scaleFontStyle : "normal",
    scaleFontColor : "#666",    
    scaleShowGridLines : true,
    scaleGridLineColor : "rgba(0, 0, 0, .05)",
    scaleGridLineWidth : 1,
    barShowStroke : true,
    barStrokeWidth : 1,
    barValueSpacing : 5,
    barDatasetSpacing : 1,
    animation : true,
    animationSteps : 50,
    animationEasing : "easeOutQuad",
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("cha").getContext("2d")).Bar(barChartData, options);



var barChartData = {
    labels : [''],
    datasets : [
$keigraph
    ]
}

var options = {

    scaleOverlay : true,
    scaleOverride : true,
    
    scaleSteps : 10,
    scaleStepWidth : $kei_gmax,
    scaleStartValue : 0,
    scaleLineColor : "rgba(0, 0, 0, .1)",
    scaleLineWidth : 1,
    scaleShowLabels : true,
    scaleLabel : "<%=value%>",
    scaleFontFamily : "'Arial'",
    scaleFontSize : 12,
    scaleFontStyle : "normal",
   scaleFontColor : "#666",    
    scaleShowGridLines : true,
     scaleGridLineColor : "rgba(0, 0, 0, .05)",
    scaleGridLineWidth : 1,
    barShowStroke : true,
     barStrokeWidth : 1,
     barValueSpacing : 5,
    barDatasetSpacing : 1,
     animation : true,
    animationSteps : 50,
    animationEasing : "easeOutQuad",
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("kei").getContext("2d")).Bar(barChartData, options);



var doughnutData = [
    {
        value: $strtype,
        color:"#F7464A"
    },
    {
        value : $inttype,
        color : "#3CB371"
    },
    {
        value : $leatype,
        color : "#FF7F50"
    },
    {
        value : $chatype,
        color : "#6A5ACD"
    }
];
// オプション
var options = {
    // セグメントの枠線の表示
    segmentShowStroke : true,
    // セグメントの枠線の色
    segmentStrokeColor : "#fff",
    // セグメントの枠線の太さ
    segmentStrokeWidth : 2,
    // 中央の円のカットの大きさ ( パーセント )
    percentageInnerCutout : 60,
    // 表示の時のアニメーション
    animation : true,
    // アニメーションの速度 ( ステップ数 )
    animationSteps : 60,
    // アニメーションの種類, 以下が用意されている
    // linear, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic,
    // easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint,
    // easeOutQuint, easeInOutQuint, easeInSine, easeOutSine, easeInOutSine,
    // easeInExpo, easeOutExpo, easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc,
    // easeInElastic, easeOutElastic, easeInOutElastic, easeInBack, easeOutBack,
    // easeInOutBack, easeInBounce, easeOutBounce, easeInOutBounce
    animationEasing : "easeOutQuad",
    // 回転で表示するアニメーションの有無
    animateRotate : true,
    // 中央から拡大しながら表示するアニメーションの有無
    animateScale : true,
    // アニメーション終了後に実行する処理
    // animation: false の時にも実行されるようです
    // e.g. onAnimationComplete : function() {alert('complete');}
    onAnimationComplete : null
}
var chart = new Chart(document.getElementById("en").getContext("2d")).Doughnut(doughnutData, options);

</script>

EOM


	&FOOTER;

exit;

}
