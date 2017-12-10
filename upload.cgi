#!/usr/bin/perl

#################################################################
#   【免責事項】                                                #
#    このスクリプトはフリーソフトです。このスクリプトを使用した #
#    いかなる損害に対して作者は一切の責任を負いません。         #
#################################################################


require './ini_file/index.ini';
require 'suport.pl';

	&HEADER;

	print <<"EOM";

<TABLE border=0 width=100% height=100%><TR><TD align=center>
<TABLE border=0 width=100%>
<TR><TH bgcolor=414141>
<font color=ffffff> - 画像のアップロード - </font>
</TH></TR>

<TR><TD>
<TABEL bgcolor=#AA0000><TR><TD bgcolor=#000000>
___<font color=white>●ゲームで使いたいアイコン画像をアップロードすることができます。<br>
<br>
[アップロードの仕方]<br>
・アップロードできるのはgif形式の画像だけです。オススメ画像形式変換サイト→<a href="http://www.bannerkoubou.com/photoeditor/conversion" target="_blank">こちら</a><br>
・gifアニメもOKです。ただし容量は1MBまでにして下さい。<br>
・画像のサイズはできるだけ64px×64pxにして下さい。それ以外のサイズの画像を使用した場合、レイアウトが崩れたりする場所がでてくるかもしれません。<br>
・もし画像をアップロードする場所がなくなってしまったら、専用BBSで報告して下さい。アップロードする場所を新たに作ります。<br>
<br>
[注意事項]<br>
・アップロードした画像は誰でも使用・閲覧できます。<br>
・法律に違反する画像のアップロードは禁止です。<br>
・他人を不快にさせるような画像のアップロードは禁止です。<br>
・上記のような画像があった場合、専用BBSで報告して下さい。削除します。
</font>
</TD></TR></TABLE>
</TD></TR>
<hr>
<TR><TD>
<TABLE><TR><TD>
<FORM method="POST" action="upload.php" enctype="multipart/form-data">
<INPUT type="hidden" name="max_file_size" value="1000000">
アップロードするファイルを選択してください。<BR>
<BR>
<INPUT name="fl[]" type="file" size="50"><BR>
<INPUT type="submit" value="アップロード">
</FORM>
</TD></TR></TABLE>

</TR></TD>
</TABLE>
</TABLE>

EOM

	&FOOTER;
	exit;
