<?php header("Content-Type:text/html;charset=SHIFT_JIS"); ?>
<?php
//==========================================================
//  アップローダー ver.0.5β
//  eWeb http://www.eweb-design.com/
//==========================================================

// アップロードするディレクトリ(相対パス)
$updir = "./image/";
$CHARA_IMAGE = 600;

//--------------------------------------------------------------------
// 以上で基本的な設定は終了です。
// 以下の変更は自己責任でお願いします。(行数はデフォルト時)
// 送信確認画面や終了画面のヘッダとフッタ → 65行目周辺
//--------------------------------------------------------------------

$dir = './image/';
$files = scandir($dir);
$no = count($files);
$no -= 22;

?>
<?php htmlHeader(); ?>
アップロード結果<BR><BR>
<TABLE border="0" width="350" cellspacing="1" cellpadding="3" bgcolor="#884422">
<TR bgcolor="#C0C088">
<TD align="center"><FONT color="#ffffff">ファイル名<?php print($no); ?></FONT></TD>
<TD align="center"><FONT color="#ffffff">サイズ</FONT></TD>
<TD align="center"><FONT color="#ffffff">タイプ</FONT></TD>
</TR>
<?php
for($i=0;$i<sizeof($_FILES['fl']['name']);$i++) {
  if($_FILES['fl']['name'][$i]=="") continue;
  $_POST['frb']="true";
  $name = str_replace('.gif', '', $_FILES['fl']['name'][$i]);
  $num = $name+0;

$sep = explode(".",$_FILES['fl']['name'][$i]);

if(!is_uploaded_file($_FILES['fl']['tmp_name'][$i])) {
?>
<TR bgcolor="#F0F0F0">
<TD><?php print($_FILES['fl']['name'][$i]); ?></TD>
<TD align="center" colspan="2"><FONT color="#ff0000">アップロード失敗</FONT></TD>
</TR>
<?php
  } elseif(strpos($_FILES['fl']['name'][$i], ".gif") == false) {
?>
<TR bgcolor="#F0F0F0">　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
<TD><?php print($_FILES['fl']['name'][$i]); ?></TD>
<TD align="center" colspan="2"><FONT color="#ff0000">gifファイルではありません。<?php print($sep[1]); ?></FONT></TD>
</TR>
<?php
   } elseif ($no > $CHARA_IMAGE) {
?>
<TR bgcolor="#F0F0F0">　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
<TD><?php print($_FILES['fl']['name'][$i]); ?></TD>
<TD align="center" colspan="2"><FONT color="#ff0000">これ以上画像をアップロードできません。</FONT></TD>
</TR>
<?php
  } else {
?>
<TR bgcolor="#F0F0F0">
<TD><?php print($_FILES['fl']['name'][$i]); ?></TD>
<TD align="right"><?php print($_FILES['fl']['size'][$i]); ?>Byte</TD>
<TD align="right"><?php print($_FILES['fl']['type'][$i]); ?></TD>
</TR>
<TR bgcolor="#F0F0F0">
<TD colspan="3">アイコン画像に追加しました。</TD>
</TR>
<?php
$_FILES['fl']['name'][$i] = "$no.$sep[1]";
    move_uploaded_file($_FILES['fl']['tmp_name'][$i],$updir.mb_convert_encoding($_FILES['fl']['name'][$i],"SJIS","EUC-JP"));

  }
}
?>
</TABLE>
<BR>
<!-- 著作権表示                                                            -->
<!-- 消しても構いませんが、その際はeWebにリンクを貼ってくれると嬉しいです。-->
<FONT size="-1"><A href="http://www.eweb-design.com/">eWeb Uploader</A></FONT><BR>
<?php htmlFooter(); ?>

<?php function htmlHeader() { ?>


<!--- ヘッダーの編集 --- 開始 ----------------------------->

<HTML>
<HEAD>
<link rel="shortcut icon" href="./favicon.ico" >
<STYLE type="text/css">
<!--
BODY,TR,TD,TH{
font-family : "ＭＳ ゴシック";
font-size: 11pt
}
A:HOVER{
 color: #AA8855
}
.S1 {color:#fff; border-style: double; border-width: 3px;BACKGROUND: #633;}
.dmg { color: #FF0000; font-size: 18pt }
.clit { color: #0000FF; font-size: 18pt }
.r { color: #FF4444; font-size: 10pt }
.b { color: #4444DD; font-size: 10pt }
.s { color: #44AAEE; font-size: 10pt }
.g { color: #44DD44; font-size: 10pt }
.o { color: #EEAA44; font-size: 10pt }
-->
</STYLE>

<TITLE>十国志NET</TITLE>
</HEAD>
<BODY BACKGROUND=./image/o.gif TEXT=444444>

<!--- 終了 --->


<?php } function htmlFooter() { ?>


<!--- フッターの編集 --- 開始 ----------------------------->

</BODY>
</HTML>

<!--- 終了 --->


<?php } ?>
