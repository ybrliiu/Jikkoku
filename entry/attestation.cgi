sub ATTESTATION {

	&HEADER;
print <<NEW;
�� ���[���ɓY�t���ꂽ�F�؃L�[�Ƃh�c�ƃp�X����͂��Ă��������B<BR>
�� �F�؃L�[���o�^����܂��ƃQ�[�����J�n���邱�Ƃ��ł��܂��B<p>

<center><form method=$method action=$FILE_ENTRY>
<table bgcolor=$TABLE_C><tbody bgcolor=$TD_C3>
<TR><TH bgcolor=$TD_C2 colspan=2>�F ��</TH></TR>
<TR><TH>ID</TH><TD>
<input type=text name=id class=text size=10></TD></TR>
<TR><TH>�p�X���[�h</TH><TD>
<input type=password name=pass class=text size=10></TD></TR>
<TR><TH>�F�؃L�[</TH><TD>
<input type=password name=key class=text size=10></TD></TR>
</TD></TR>
<input type=hidden name=mode value="SET_ENTRY">
<TR><TD bgcolor=$TD_C4 colspan=2 align=center><input type=submit value="�F��"></TD></TR>
</TBODY></TABLE>
</form>

NEW
	&FOOTER;
	exit;
}

# Sub Set Regist #
sub SET_ENTRY {

	&HOST_NAME;
	&CHARA_MAIN_OPEN;
	$akey = crypt("$kpass",$ATTESTATION_ID);

	if($akey ne $in{'key'}){&ERR2("�Ï؃L�[���Ⴂ�܂��I\n");}
	if(($kos & 1) eq 1){&ERR2("���ɔF�؍ς݂ł��B");}

	&MAP_LOG("<font color=blue><B>[�F��]</B></font>$kname���V���ɓo�^����܂����I");
	$kos|=1;

	&CHARA_MAIN_INPUT;
	&HEADER;

	print qq|�F�؂��������܂���<br>\n|;
	print qq|ID��$kid�ł��B<br>\n|;
	print qq|�p�X���[�h��$kpass�ł��B<br><br>\n|;

	print qq|�o�^�葱���͂���Ŋ����ł��B<br>\n|;
	print qq|�s�n�o�y�[�W���烍�O�C���ł��܂��B<br>\n|;

	print qq|<a href="$FILE_TOP">\[�߂�\]</a>\n|;
	&FOOTER;
	exit;
}

1;