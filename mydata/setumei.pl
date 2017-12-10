#_/_/_/_/_/_/_/_/#
#      すきる      #
#_/_/_/_/_/_/_/_/#

sub SETUMEI {

	&CHARA_MAIN_OPEN;
	&COUNTRY_DATA_OPEN("$kcon");
	&TIME_DATA;
	&HEADER;

	print <<"EOM";

<frameset cols="100,*">
  <TD><TR><TABLE>
<form action="$FILE_STATUS" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit id=input value="戻る"></form></CENTER>
</TD></TR></TABLE>
 <frame src="../manual.html"
    name="contents">
</frameset>


EOM

	&FOOTER;

	exit;

}
1;