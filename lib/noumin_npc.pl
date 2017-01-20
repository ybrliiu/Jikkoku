#農民NPC作成

sub NOUMIN_NPC{

	open(IN, "./log_file/npc_con.cgi");
	my $nid = <IN>;
	close(IN);
	$nid+=0;

	#バトルマップ読み込み
	require "./log_file/map_hash/$zi.pl";

	#農民NPCデータ生成
	my $proba=int(rand(5))+1;
	my $i=0;
	for($i=0;$i<$proba;$i++){

		#ランダムに部隊を配置
		my $randy = int(rand($BM_Y));
		my $randx = int(rand($BM_X));
		my $count,$i,$j,$nx,$ny = 0;
		for($n=$randy;$n<$BM_Y;$n++){
			for($j=$randx;$j<$BM_X;$j++){
				if($BM_TIKEI[$n][$j] ne "" && ($BM_TIKEI[$n][$j] != 18 && $BM_TIKEI[$n][$j] != 22) ){
				$nx = $j;
				$ny = $n;
				$count = 2;
				}
				if($n == $BM_Y-1 && $j == $BM_X-1){
				$count++;
				$n = 0;
				$j = 0;
				}
				if($count > 1){
				last;
				}
			}
			if($count > 1){
			last;
			}
		}
		if($nx eq "" || $ny eq ""){&MAP_LOG("$mmonth月:異常なバトルマップデータです。管理者に報告してください。");}
		my $proba2=int(rand(12));

		my $nname,$nstr,$nint,$nlea,$ncha,$nsol,$ngat,$nclass,$narm,$nbook,$nmes,$naname,$nbname,$nsname,$nhohei,$nprof,$nkome,$nhohei="";
		my $nsenj=",,,,,,,,,,,,,";
		my $nsub1=",,,,,,";
		my $nst=",,,,,,,,,,";
		if($proba2==0){
		$nname="農民反乱軍";$nstr="105";$nint="1";$nlea="60";$ncha="1";$nsol="60";$ngat="100";$nclass="2000";
		$narm="5";$nbook="0";$nmes="5";$naname="米俵";$nbname="藁束";$nsname="農民の生き様";
		$nprof="俺達に勝てるのか？";
		$nkome="正規軍の癖に弱いな！";
		$nsenj="0,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,0,0,";$nst=",,,,0,,,,,,";$nhohei="1";
		}elsif($proba2==1){
		$nname="農民反乱軍";$nstr="130";$nint="1";$nlea="65";$ncha="1";$nsol="65";$ngat="200";$nclass="10000";
		$narm="20";$nbook="0";$nmes="20";$naname="輝く米俵";$nbname="強い藁束";$nsname="米俵の美しさ";
		$nprof="見よ！！この美しい米俵を！！";
		$nkome="必殺！米俵アタック！！";
		$nsenj="4,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,8,0,";$nst=",,,,0:2,,,,,,";$nhohei="1";
		}elsif($proba2==2){
		$nname="農民反乱軍の指導者";$nstr="200";$nint="1";$nlea="75";$ncha="1";$nsol="75";$ngat="500";$nclass="30000";
		$narm="120";$nbook="0";$nmes="120";$naname="聖鍬エクワカリバー";$nbname="頑丈な米俵";$nsname="農民の楽園";
		$nprof="俺達は農民の楽園を築くのだ。";
		$nkome="行くぞ農民共！政府軍は皆殺しだあ！！";
		$nsenj="6,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,22,0,";$nst=",,,,0:1:2:3,0:1:2,,,,,";$nhohei="1";
		}elsif($proba2==3){
		$nname="黄巣軍の残党";$nstr="55";$nint="1";$nlea="100";$ncha="1";$nsol="100";$ngat="50";$nclass="1000";
		$narm="0";$nbook="0";$nmes="5";$naname="鋤";$nbname="木の板";$nsname="農民の不満";
		$nprof="俺の畑はいなごのせいで全滅だ...。";
		$nkome="お米食わせろ！";
		$nsenj="0,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,15,0,";$nst=",,,,,0,,,,,";$nhohei="";
		}elsif($proba2==4){
		$nname="黄巣軍の残党";$nstr="55";$nint="1";$nlea="130";$ncha="1";$nsol="130";$ngat="50";$nclass="10000";
		$narm="0";$nbook="0";$nmes="5";$naname="丈夫な鋤";$nbname="岩塩";$nsname="塩について";
		$nprof="政府の塩は高すぎるんだよ。";
		$nkome="塩はいらないか？";
		$nsenj="8,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,19,0,";$nst=",,,,,0:1,,,,,";$nhohei="";
		}elsif($proba2==5){
		$nname="黄巣軍の残党";$nstr="1";$nint="1";$nlea="80";$ncha="100";$nsol="80";$ngat="50";$nclass="1000";
		$narm="0";$nbook="0";$nmes="5";$naname="鎌";$nbname="竹束";$nsname="反乱軍の意地";
		$nprof="...。";
		$nkome="...。";
		$nsenj="0,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,40,0,";$nst=",,,,,0,,,,,";$nhohei="";
		}elsif($proba2==6){
		$nname="農民反乱軍";$nstr="1";$nint="100";$nlea="60";$ncha="1";$nsol="60";$ngat="100";$nclass="2000";
		$narm="0";$nbook="10";$nmes="0";$naname="鍬";$nbname="鍋";$nsname="農業書";
		$nprof="支配者の統治が悪いから反乱が起きるのだ。";
		$nkome="お前達に、俺達の苦しみがわかるはずがない。";
		$nsenj="0,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,5,0,";$nst=",,,,,,,,,,";$nhohei="";
		}elsif($proba2==7){
		$nname="方臘軍";$nstr="55";$nint="1";$nlea="120";$ncha="1";$nsol="120";$ngat="200";$nclass="6000";
		$narm="10";$nbook="0";$nmes="10";$naname="鉈";$nbname="藁束";$nsname="明教の書";
		$nprof="こんな重税には耐えられねえ！";
		$nkome="花石綱をやめろ！！";
		$nsenj="1,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,16,0,";$nst=",,,,,0:1:2,,,,,";$nhohei="";
		}elsif($proba2==8){
		$nname="方臘軍";$nstr="120";$nint="1";$nlea="60";$ncha="1";$nsol="60";$ngat="200";$nclass="6000";
		$narm="20";$nbook="0";$nmes="0";$naname="鍬";$nbname="木の板";$nsname="喫菜事魔";
		$nprof="清浄光明　大力智慧　無上至真　摩尼光仏...";
		$nkome="清浄光明　大力智慧　無上至真　摩尼光仏...";
		$nsenj="2,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,31,0,";$nst=",,,,0:1,,,,,,";$nhohei="";
		}elsif($proba2==9){
		$nname="方臘";$nstr="70";$nint="200";$nlea="200";$ncha="1";$nsol="200";$ngat="500";$nclass="30000";
		$narm="120";$nbook="130";$nmes="120";$naname="法器";$nbname="喫菜事魔";$nsname="摩尼教下部賛";
		$nprof="宋代末に起こった方臘の乱の首謀者。マニ教徒と言われている。";
		$nkome="...光の開放を";
		$nsenj="11,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,10,0,";$nst=",3,,,,0:1:2,,,,,";$nhohei="";
		}elsif($proba2==10){
		$nname="方臘軍";$nstr="55";$nint="1";$nlea="120";$ncha="1";$nsol="120";$ngat="200";$nclass="6000";
		$narm="10";$nbook="0";$nmes="10";$naname="連弩";$nbname="藁束";$nsname="明教の書";
		$nprof="こんな重税には耐えられねえ！";
		$nkome="花石綱をやめろ！！";
		$nsenj="1,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,20,0,";$nst=",,,,,0:1:2,,,,,";$nhohei="";
		}elsif($proba2==11){
		$nname="農民反乱軍";$nstr="65";$nint="1";$nlea="130";$ncha="1";$nsol="65";$ngat="200";$nclass="10000";
		$narm="20";$nbook="0";$nmes="20";$naname="輝く米俵";$nbname="強い藁束";$nsname="米俵の美しさ";
		$nprof="見よ！！この美しい米俵を！！";
		$nkome="必殺！米俵アタック！！";
		$nsenj="4,1,$zi,$nx,$ny,0,0,0,0,0,0,0,0,";
		$nsub1="0,0,0,0,20,0,";$nst=",,,,0:2,,,,,,";$nhohei="1";
		}

	my @new_chara=();
	unshift(@new_chara,"nouminn_$nid<>農民NPC_qS+3DfV_$nid<>$nname【NPC】<>0<>$nstr<>$nint<>$nlea<>$ncha<>$nsol<>$ngat<>0<>$proba<>10000<>0<>$nclass<>$narm<>$nbook<>100<>$nsub1<>0<>$zi<>$nmes<><>$date<>mail@.mail.jp<>1<>$nkome<>$nst<><><>$nprof<><>$nhohei<>$nsenj<>0<>$nbname<>$naname<>$nsname<>無<>0<>0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,<><>,,,,<>\n");
	open(OUT,">./charalog/main/nouminn_$nid.cgi");
	print OUT @new_chara;
	close(OUT);

	my @new_com=();
	for($n=0;$n<$BMMAX_COM;$n++){
		push(@new_com,"10<><>PC攻撃<><><>1<><>\n");
	}
	open(OUT,">./charalog/auto_com/nouminn_$nid.cgi");
	print OUT @new_com;
	close(OUT);

	# autocomリストに登録
	open(IN,"./log_file/auto_list.cgi");
	my @auto_list = <IN>;
	close(IN);
	push (@auto_list, "nouminn_$nid.cgi\n");
	open(OUT,">\./log_file/auto_list.cgi");
	print OUT @auto_list;
	close(OUT);
	$n=0;
	
	
	$nid++;
	}

open(OUT, "> ./log_file/npc_con.cgi");
print OUT "$nid";
close(OUT);

}
1;
