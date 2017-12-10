#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#################################################################


require './ini_file/index.ini';
require 'suport.pl';

	$in{'num'}=1;

	&DECODE;

	if($in{'id'} ne ""){
	$modoru = "<form action=\"$FILE_STATUS\" method=\"post\">
<input type=hidden name=id value=$in{'id'}>
<input type=hidden name=pass value=$in{'pass'}>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value=\"戻る\"></form>";
	}

	if($in{'num'} < 1 || $in{'num'} > $CHARA_IMAGE/50 || $in{'num'} =~ m/[^0-9]/){
	&ERR2("フォームの値が不正です。");
	}

	$image=$in{'num'}*50;
	$start=$image-50;

for($p=$CHARA_IMAGE;$p>0;$p-=50){
	$e=$p/50;
	if($in{'num'} == $e){
	$sirusi = "<b>";
	$sirusi2 = "</b>";
	}else{
	$sirusi = "";
	$sirusi2 = "";
	}
	$page[$e] = "$sirusi<a href=\"./aicon.cgi?num=$e\">$e</a>$sirusi2 ";
}

	&HEADER;

	print <<"EOM";

<center>
<h2>アイコン一覧</h1>
@page
<br>
<br>
<table bgcolor=666666 border="1">
<tr>

EOM

for($i=$start;$i<$image;$i++){
	if($i%10==0){
	print "</tr><tr>";
	}
print "<TD  align=center><img src=\"image/$i.gif\" width=\"64\" height=\"64\"><br>$i</TD>";
	if($i==$image-1){
	print "</table>";
	}
}

	print <<"EOM";
<br>
<form action="./upload.cgi" method="post"  target="_blank">
<input type=submit id=input value="画像をアップロードする">
</form>
<br>
$modoru
</center>

EOM

	&FOOTER;
	exit;
