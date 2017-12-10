# 仕官コマンド

use lib './lib', './extlib';
use Jikkoku::Model::Unite;

sub SHIKAN {

	$ksub2=0;
	&COUNTRY_DATA_OPEN($kcon);
	if($xcid eq 0){
		if($cou_name[$zcon] eq ""){
			&K_LOG("$mmonth月:その国へは仕官できません。");
		}else{

      {
        our ($zcon, $mmonth);
        use strict;
        use warnings;
        use Jikkoku::Model::Chara;
        use Jikkoku::Model::Country;
        my $chara_model = Jikkoku::Model::Chara->new;
        my $country_model = Jikkoku::Model::Country->new;
        my $can_participate = $country_model->get_with_option($zcon)->match(
          Some => sub {
            my $country = shift;
            if ( $country->can_participate($chara_model, $country_model) ) {
              1;
            } else {
              K_LOG(qq{$mmonth月 : 仕官制限によりその国には仕官できません。}
              . qq{<a href="manual.html#participation_restriction" target="_blank">【仕官制限について】</a>});
              0;
            }
          },
          None => sub {
            K_LOG(qq{$mmonth月 : その国は存在しません。});
            0;
          },
        );
        return unless $can_participate;
      }

			if(@B_LIST eq "0"){
				open(IN,"$LOG_DIR/black_list.cgi");
				@B_LIST = <IN>;
				close(IN);
			}
			my $black_list_hit=0;
			foreach (@B_LIST) {
				my ($bid, $bcon, $bname, $bsub) = split /<>/;
				if ($bid eq $kid && $bcon eq $kcon) {
					$black_list_hit = 1;
				}
			}
      my $is_unite = Jikkoku::Model::Unite->is_unite;
			if ($black_list_hit && !$is_unite) {
				&K_LOG("$mmonth月:$cou_name[$zcon]へ仕官は拒否されました。");
			} else {
				$kcon = $zcon;
				&K_LOG("$mmonth月:$cou_name[$zcon]へ仕官しました。");
				&MAP_LOG("$mmonth月:$knameは$cou_name[$zcon]へ仕官しました。");
			}
		}
	}else{
		&K_LOG("$mmonth月:無所属でなければ仕官できません。");
	}

}
1;
