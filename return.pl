#キャラデータが壊れていたときバックアップから自動復旧#

sub RETURN {

if($hour > 21 || $hour == 1){
$bkfile = "./backup-main";
}else{
$bkfile = "./backup-main2";
}
	open(page,"$bkfile/$file");
	@page = <page>;
	close(page);

	($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$kspbuy,$kskldata,$kskldata2,$ksub6,$ksub7,$ksub8) = split(/<>/,$page[0]);


#バックアップの作成時間取得#
$kousinbi = "$bkfile/$file";
$modtime = (stat($kousinbi))[9];
($bsec, $bmin, $bhour, $bmday, $bmon, $byear) = localtime($modtime);
$sakuseibi = "（作成時間：$bmday日$bhour時$bmin分$bsec秒）";


	&K_LOG("<font color=blue>\[個人データ復旧\]</font> $knameの武将データが破損していたためバックアップファイルから復旧しました。。$sakuseibi");
	&SYSTEM_LOG("<font color=blue>\[個人データ復旧\]</font> $knameの武将データが破損していたためバックアップファイルから復旧しました。。$sakuseibi");

	if($kid eq ""){

	if($hour > 21 || $hour == 1){
	$bkfile = "./backup-main2";
	}else{
	$bkfile = "./backup-main";
	}
		open(page,"$bkfile/$file");
		@page = <page>;
		close(page);

		($kid,$kpass,$kname,$kchara,$kstr,$kint,$klea,$kcha,$ksol,$kgat,$kcon,$kgold,$krice,$kcex,$kclass,$karm,$kbook,$kbank,$ksub1,$ksub2,$kpos,$kmes,$khost,$kdate,$kmail,$kos,$kcm,$kst,$ksz,$ksg,$kyumi,$kiba,$khohei,$ksenj,$ksm,$kbname,$kaname,$ksname,$kazoku,$kaai,$ksub3,$ksub4,$ksub5,$kspbuy,$kskldata,$kskldata2,$ksub6,$ksub7,$ksub8) = split(/<>/,$page[0]);



	#バックアップの作成時間取得#
	$kousinbi = "$bkfile/$file";
	$modtime = (stat($kousinbi))[9];
	($bsec, $bmin, $bhour, $bmday, $bmon, $byear) = localtime($modtime);
	$sakuseibi = "（作成時間：$bmday日$bhour時$bmin分$bsec秒）";


	&K_LOG("<font color=#000000>\[個人データ復旧２\]</font> $knameの武将データが破損していたためバックアップファイルから復旧しました。。$sakuseibi");
	&SYSTEM_LOG("<font color=#000000>\[個人データ復旧２\]</font> $knameの武将データのバックアップファイルも破損していたためバックアップファイル２から復旧しました。。$sakuseibi");

	}

}

1;
