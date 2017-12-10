#_/_/_/_/_/_/_/_/_/_/#
#       下  野       #
#_/_/_/_/_/_/_/_/_/_/#

use Jikkoku::Model::Country;

sub GEYA {

	$ksub2 = 0;

  my $country_model = Jikkoku::Model::Country->new;
  my $is_error      = 0;
  my $country       = $country_model->get_with_option($kcon)->foreach(sub {
    my $country = shift;
    if ($country->king_id eq $kid) {
      K_LOG("$mmonth月:君主は下野できません");
      $is_error = 1;
    }
  });
  return if $is_error;

	if ($kcon eq "0") {
		K_LOG("$mmonth月:すでに無所属です。");
	} else {
		$kcon = 0;
		$kclass -= 500;
    $kclass = 0 if $kclass < 0;
		$ksol = 0;
		$ksyuppei = 0;
		$kiti = "";
		$kx = "";
		$ky = "";
		$kkicn = 0;
		$kksup = 0;
		$kmsup = 0;
		$ksakup = 0;
		$konmip = 0;
		K_LOG("$mmonth月:下野して無所属になりました。");
		K_LOG("【撤退】下野と同時に撤退しました。");
		K_LOG2("【撤退】下野と同時に撤退しました。");
		MAP_LOG("$mmonth月:$knameは下野しました。");
	}

}
1;
