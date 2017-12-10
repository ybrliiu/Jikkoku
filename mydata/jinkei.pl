#_/_/_/_/_/_/_/_/_/#
#  　陣形変更    #
#_/_/_/_/_/_/_/_/_/#

sub JINKEI {

	&CHARA_MAIN_OPEN;
	($kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip) = split(/,/,$ksenj);

	if($in{'jinkei' eq ""}){ &ERR("選択されていません。"); }
	elsif($in{'jinkei'} =~ m/[^0-9]/){ &ERR("数字以外のデータが含まれています。"); }
	$idate = time();
	if($idate < $ksakup){
	$nokori = $ksakup-$idate;
	 &ERR("あと $nokori秒 陣形変更できません。"); 
	}

	open(IN,"./log_file/jinkei.cgi") or &ERR2("陣形データ読み込み失敗");
	@JINKEI = <IN>;
	close(IN);
	$hit = 0;
	$i = 0;
	if($kjinkei eq ""){$kjinkei=0;}
	foreach(@JINKEI){
	($jinname,$jinaup,$jindup,$jinaup2,$jindup2,$jinaup3,$jindup3,$jin_tokui,$jinchange,$jinclas,$jinsetumei,$jinsub,$jinsub2)=split(/<>/);
	if($in{'jinkei'} eq $i){
		if($jinclas > $kclass || $jinsub2 ne ""){
			}else{
			$hen = $jinname;
			$hit = 1;
				if($ksyuppei){
				$ksakup = $idate+$jinchange;
				}
			last;
			}
		}
	$i++;
	}
	if(!$hit){ &ERR("不正な操作です。"); }

	$kjinkei = $in{'jinkei'};
	$res_mes = "陣形を$henに変更しました。";

	$ksenj = "$kjinkei,$ksyuppei,$kiti,$kx,$ky,$kbattletime,$kkoutime,$kidoup,$kkicn,$kksup,$kmsup,$ksakup,$konmip,";
	&CHARA_MAIN_INPUT;

	if("$ENV{'HTTP_REFERER'}" eq "$KEITAI_SURL"){
	$url = "./i-status.cgi";
	$mmode = "MENT";
	}elsif("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/status.cgi"){
	$url = "./status.cgi";
	$mmode = "STATUS";
	}elsif($in{'inline'} eq "1"){	#BMインラインフレーム
	$url = "./newbm.cgi";
	$mmode = "STATUS";
	$inline = "<input type=hidden name=inline value=1>";
	}elsif("$ENV{'HTTP_REFERER'}" eq "$SANGOKU_URL/newbm.cgi"){
	$url = "./newbm.cgi";
	$mmode = "STATUS";
	}elsif($in{'mobile'} eq "yes"){
	$url = "./i-newbm.cgi";
	$mmode = "STATUS";
	}else{
	$url = "./mydata.cgi";
	$mmode = "MYDATA";
	}

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>$res_mes</h2><p>
<form action="$url" method="post">
$inline
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=$mmode>
<input type=submit id=input value="ＯＫ"></form></CENTER>
EOM
	&FOOTER;

	exit;

}
1;
