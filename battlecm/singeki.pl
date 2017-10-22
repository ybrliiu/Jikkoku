#_/_/_/_/_/_/_/_/_/_/#
#    進撃スキル      #
#_/_/_/_/_/_/_/_/_/_/#

sub SINGEKI {

	my $idate = time();

	($kstr_ex,$kint_ex,$klea_ex,$kcha_ex,$ksub1_ex,$ksub2_ex) = split(/,/,$ksub1);
	($ksien,$kskl1,$kskl2,$kskl3,$kskl4,$kskl5,$kskl6,$kskl7,$kskl8,$kskl9) = split(/,/,$kst);
	($ksingeki_time,$kanother) = split(/,/,$kskldata);

	if(!$ksyuppei){
		&ERR("出撃していません。");
	}elsif($idate < $ksingeki_time){
		my $nokori = $ksingeki_time-$idate;
		&ERR("あと $nokori秒 進撃スキルを使用できません。");
	}elsif($kskl7 !~ /2/){
		&ERR("進撃スキルを修得していません。");
	}elsif($kstr < 115){
		&ERR("武力が足りないので使用できません。");
  }else{

    $ksiki -= $MOR_SINGEKI;
    if($ksiki < 0){&ERR("士気が足りません。");}

#戦闘場所地名
    require './ini_file/bmmaplist.ini';
    my $battkemapname = "$TIKEI{$kiti}";

    &MAP_LOG("<font color=orange>【進撃】</font>$knameは進撃を行いました。($battkemapname\)");
    &K_LOG("<font color=orange>【進撃】</font>$knameは進撃を行いました。");
    &K_LOG2("<font color=orange>【進撃】</font>$knameは進撃を行いました。侵攻側の場合、410秒間攻撃力が25%上昇し、その後200秒間守備力が50%低下します。防衛側の場合、610秒間守備力が50%低下します。");
    $ksingeki_time = $idate+1200;
    $kskldata = "$ksingeki_time,$kanother,";
    &CHARA_MAIN_INPUT;
  }

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>進撃を実行しました	。</h2><p>
<form action="$BACK" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="OK">
</form>
</CENTER>
EOM
	&FOOTER;

	exit;

}
1;
