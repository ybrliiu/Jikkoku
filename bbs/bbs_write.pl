#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#
#_/    専用BBS書き込み     _/#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/#

# 受け付けない単語 (spam排除目的)
my @rejection_words = qw(
  pharmshop-online\.com 
  viagra levitra cialis sex supplement
  casino
  url= href=
  http://
  \.azca\.ru \.bsno\.ru
  comment
);
my $rejection_words_regexp = join '|', @rejection_words;

sub BBS_WRITE{

	&TIME_DATA;
	&HOST_NAME;

	if(length($in{'title'}) > 40 || length($in{'ins'}) > 6000) { &ERR2("もっと手短に伝言を伝えてください"); }
	if(($in{'itstealth'} eq "" || $in{'itstealth'} ne "$bbskanri") && $in{'name'} eq "管理人"){ &ERR2("その名前は使用できません。"); }
	if(length($in{'name'}) > 48){&ERR2("名前は全角16文字以下で入力して下さい。"); }
	if(($in{'title'} eq "" && $in{'b_no'} eq "")|| $in{'ins'} eq "") { &ERR2("メッセージかタイトルが記入されていません。"); }

  # $& = パターンマッチにマッチした文字列
  if ($in{ins} =~ /($rejection_words_regexp)/) {
    SYSTEM_LOG("[spam検知] match: $& ");
    ERR2("[spam検知]<br>本文の中に使用できない単語が含まれています。($&) <br>申し訳ないですが、他の文字に置き換えるなどしてください。");
  }

	open(IN,"./bbs/senb.cgi") or &ERR2('ファイルを開けませんでした。err no :country');
	@BBS_DATA = <IN>;
	close(IN);

	$bbs_num = @BBS_DATA;
	if($bbs_num > $MES_MAX) { pop(@BBS_DATA); }

	if($in{"type"} eq "all"){$bbtype = 1;$back = "COUNTRY_ALL_TALK"}else{$bbtype = 0;$back = "COUNTRY_TALK"}

	($lbbid,$lbbtitle,$lbbmes,$lbbcharaimg,$lbbname,$lbbhost,$lbbtime,$lbbele,$lbbcon,$lbbtype,$lbbno,$lbbheap)=split(/<>/,$BBS_DATA[0]);

	if($in{'name'} eq ""){$in{'name'} = "名無し";}
	if($in{'icon'} eq ""){$in{'icon'} = 0;}
	$bno = $lbbno + 1;
	$bbname = "NO:$bno <B>$in{'name'}より</B>";

	if($in{'b_no'} ne ""){
		$b_heap = $in{'b_no'};

		#age
		$i=0;
		foreach(@BBS_DATA){
		($bid2,$btitle2,$bmes2,$bcharaimg2,$bname2,$bhost2,$btime2,$bele2,$bcon2,$btype2,$bno2,$bheap2)=split(/<>/);
			if(!$bheap2 && $bno2 eq $b_heap){
			$skno = $i;
			splice(@BBS_DATA,$skno,1,"$bid2<>$btitle2<>$bmes2<>$bcharaimg2<>$bname2<>$bhost2<>$btime2<>$bele2<>$tt<>$btype2<>$bno2<>$bheap2<>\n") or &ERR2('error:age');
			last;
			}
		$i++;
		}

	}else{
		$b_heap = 0;
	}
	unshift(@BBS_DATA,"$kid<>$in{'title'}<>$in{'ins'}<>$in{'icon'}<>$bbname<>$host<>$daytime<>$xele<>$tt<>$bbtype<>$bno<>$b_heap<>\n");

	open(OUT,">./bbs/senb.cgi") or &ERR2('ファイルを開けませんでした。');
	print OUT @BBS_DATA;
	close(OUT);

	if($in{'itstealth'} eq "$bbskanri"){
	$formp ="<input type=hidden name=itstealth value=$bbskanri>";
	}




#管理人にメール送信部
	$sendmail = '/usr/sbin/sendmail'; # sendmailコマンドパス
	$from = 'mp0liiu@lunadraco.sakura.ne.jp'; # 送信元メールアドレス
	$to = 'raian@reeshome.org'; # あて先メールアドレス
	$cc = ''; # Ccのあて先メールアドレス
	$subject = '【十国志NET】専用BBSで書き込みがありました'; # メールの件名
	$in{'ins'} =~ s/<br>/\n/g; #改行
	$msg = <<"_TEXT_"; # メールの本文(ヒアドキュメントで変数に代入)
【十国志NET】専用BBSで書き込みがありました

題名：$in{'title'}
名前：$in{'name'}
本文:$in{'ins'}

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
<CENTER><hr size=0><h2>専用BBSに書き込みをしました。</h2><p>

<form action="./bbs.cgi" method="post">
<input type=hidden name=name value=$in{'name'}>
<input type=hidden name=icon value=$in{'icon'}>
$formp
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;
	exit;
	
}
1;
