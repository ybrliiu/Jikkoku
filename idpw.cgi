#!/usr/bin/perl

#ID、PW忘れたとき用#

require './ini_file/index.ini';
require 'suport.pl';

&DECODE;

if($in{'mode'} eq "SOUSIN"){&sousin;}
else{&main;}

sub main{

	&HEADER;

print <<"EOM";

●ID,パスワードを忘れた方<br>
<br>
キャラを登録したIPアドレスを使って、下の入力欄に登録名とメールアドレスを入力して送信してください。<br>
送信されたメールアドレス宛にIDとパスワードを書いたメールを送ります。<br>
※メールアドレスを登録時入力していた方は、登録時と同じアドレスを入力すれば登録時のIPアドレスを使用する必要はありません。<br>
<br>
<form action="./idpw.cgi" method="POST">
登録名：<input type="text" size="10" name="name">
メールアドレス：<input type="text" size="10" name="mail">
<input type="hidden" name="mode" value="SOUSIN">
<input type="submit" value="送信">
</form>
<br>
<br>
<form action="./index.cgi" method="POST">
<input type="submit" value="戻る">
</form>

EOM

	&FOOTER;

exit;

}

sub sousin{

	if($in{'name'} eq "" || $in{'mail'} eq ""){&ERR2("登録名かメールアドレスが入力されていません");}
	if(length($in{'name'}) > 45 || length($in{'name'}) > 45){&ERR2("文字数多すぎるみたいです");}
	if ($in{'mail'} !~ /(.*)\@(.*)\.(.*)/){ &ERR2("メールの入力が不正です。");}

	&TIME_DATA;


#要請記録
	open(IN, "./log_file/idpw.cgi");
	@stopcount = <IN>;
	close(IN);

	push(@stopcount,"「名前：$in{'name'}、メール：$in{'mail'}、$ENV{'REMOTE_HOST'}、$daytime」<br>\n");

	open(OUT, "> ./log_file/idpw.cgi");
	print OUT "@stopcount";
	close(OUT);



#武将データ検索
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

	$mailflag = 0;
	foreach(@CL_DATA){
	($eid,$epass,$ename,$echara,$estr,$eint,$elea,$echa,$esol,$egat,$econ,$egold,$erice,$ecex,$eclass,$earm,$ebook,$ebank,$esub1,$esub2,$epos,$emes,$ehost,$edate,$email) = split(/<>/);

		if($in{'name'} eq "$ename"){
			if($ENV{'REMOTE_HOST'} eq "$ehost" || $in{'mail'} eq "$email"){
			$mailflag = 1;
			}
		last;
		}
	}

	if(!$mailflag){&ERR2("登録名が違うか、IPアドレスもしくはメールアドレスが違います。<br><br>※なんらかの理由で登録時と同じIP、登録時のメールアドレスを使用できない場合は<a href=\"./bbs.cgi\">専用BBS</a>に書き込んでください。");}
		


#メール送信部
	$sendmail = '/usr/sbin/sendmail'; # sendmailコマンドパス
	$from = 'mp0liiu@lunadraco.sakura.ne.jp'; # 送信元メールアドレス
	$to = "$in{'mail'}"; # あて先メールアドレス
	$cc = ''; # Ccのあて先メールアドレス
	$subject = '【十国志NET】ID、PWの確認'; # メールの件名
	$msg = <<"_TEXT_"; # メールの本文(ヒアドキュメントで変数に代入)
【十国志NET】ID、PWの確認

$in{'name'}さんのID:$eid
$in{'name'}さんのパスワード:$epass

です。

$ENV{'REMOTE_HOST'}
$daytime

_TEXT_

	# 変換は Encode.pm
	use Encode; 
	$msg = decode('utf-8', $msg);
	$subject = decode('utf-8', $subject);
	$msg = encode('jis',$msg);
	$subject = encode('MIME-Header-ISO_2022_JP', $subject);

	# sendmail コマンド起動
	open(SDML,"| $sendmail -t -i") || die 'sendmail error';
	# メールヘッダ出力
	print SDML "From: $from\n";
	print SDML "To: $to\n";
	print SDML "Cc: $cc\n";
	print SDML "Subject: $subject\n";
	print SDML "Content-Transfer-Encoding: 7bit\n";
	print SDML "Content-Type: text/plain;\n\n";
	# メール本文出力
	print SDML "$msg";
	# sendmail コマンド閉じる
	close(SDML); 




	&HEADER;

print <<"EOM";

送信しました。メールが届くまでお待ち下さい。<br>
もし届かない場合は専用BBSに書き込んでください。<br>
<br>
<form action="./index.cgi" method="POST">
<input type="submit" value="戻る">
</form>

EOM

	&FOOTER;


exit;
}
