<?php header("Content-Type:text/html;charset=SHIFT_JIS"); ?>
<?php
//==========================================================
//  �A�b�v���[�_�[ ver.0.5��
//  eWeb http://www.eweb-design.com/
//==========================================================

// �A�b�v���[�h����f�B���N�g��(���΃p�X)
$updir = "./image/";
$CHARA_IMAGE = 600;

//--------------------------------------------------------------------
// �ȏ�Ŋ�{�I�Ȑݒ�͏I���ł��B
// �ȉ��̕ύX�͎��ȐӔC�ł��肢���܂��B(�s���̓f�t�H���g��)
// ���M�m�F��ʂ�I����ʂ̃w�b�_�ƃt�b�^ �� 65�s�ڎ���
//--------------------------------------------------------------------

$dir = './image/';
$files = scandir($dir);
$no = count($files);
$no -= 22;

?>
<?php htmlHeader(); ?>
�A�b�v���[�h����<BR><BR>
<TABLE border="0" width="350" cellspacing="1" cellpadding="3" bgcolor="#884422">
<TR bgcolor="#C0C088">
<TD align="center"><FONT color="#ffffff">�t�@�C����<?php print($no); ?></FONT></TD>
<TD align="center"><FONT color="#ffffff">�T�C�Y</FONT></TD>
<TD align="center"><FONT color="#ffffff">�^�C�v</FONT></TD>
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
<TD align="center" colspan="2"><FONT color="#ff0000">�A�b�v���[�h���s</FONT></TD>
</TR>
<?php
  } elseif(strpos($_FILES['fl']['name'][$i], ".gif") == false) {
?>
<TR bgcolor="#F0F0F0">�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@
<TD><?php print($_FILES['fl']['name'][$i]); ?></TD>
<TD align="center" colspan="2"><FONT color="#ff0000">gif�t�@�C���ł͂���܂���B<?php print($sep[1]); ?></FONT></TD>
</TR>
<?php
   } elseif ($no > $CHARA_IMAGE) {
?>
<TR bgcolor="#F0F0F0">�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@
<TD><?php print($_FILES['fl']['name'][$i]); ?></TD>
<TD align="center" colspan="2"><FONT color="#ff0000">����ȏ�摜���A�b�v���[�h�ł��܂���B</FONT></TD>
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
<TD colspan="3">�A�C�R���摜�ɒǉ����܂����B</TD>
</TR>
<?php
$_FILES['fl']['name'][$i] = "$no.$sep[1]";
    move_uploaded_file($_FILES['fl']['tmp_name'][$i],$updir.mb_convert_encoding($_FILES['fl']['name'][$i],"SJIS","EUC-JP"));

  }
}
?>
</TABLE>
<BR>
<!-- ���쌠�\��                                                            -->
<!-- �����Ă��\���܂��񂪁A���̍ۂ�eWeb�Ƀ����N��\���Ă����Ɗ������ł��B-->
<FONT size="-1"><A href="http://www.eweb-design.com/">eWeb Uploader</A></FONT><BR>
<?php htmlFooter(); ?>

<?php function htmlHeader() { ?>


<!--- �w�b�_�[�̕ҏW --- �J�n ----------------------------->

<HTML>
<HEAD>
<link rel="shortcut icon" href="./favicon.ico" >
<STYLE type="text/css">
<!--
BODY,TR,TD,TH{
font-family : "�l�r �S�V�b�N";
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

<TITLE>�\���uNET</TITLE>
</HEAD>
<BODY BACKGROUND=./image/o.gif TEXT=444444>

<!--- �I�� --->


<?php } function htmlFooter() { ?>


<!--- �t�b�^�[�̕ҏW --- �J�n ----------------------------->

</BODY>
</HTML>

<!--- �I�� --->


<?php } ?>
