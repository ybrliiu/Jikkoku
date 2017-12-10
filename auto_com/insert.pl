
our (%in, @no);
use lib './lib', './extlib';
use Jikkoku;
use Jikkoku::Model::Chara;
use Jikkoku::Model::Chara::BattleActionReservation;

sub auto_com_insert {
  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = $chara_model->get_with_option($in{id})->match(
    Some => sub { $_ },
    None => sub { ERR("IDが間違っています") },
  );
  ERR("パスワードが間違っています") unless $chara->check_pass($in{pass});
  my $reservation = Jikkoku::Model::Chara::BattleActionReservation->new->get($chara->id);
  $reservation->insert([$no[0]], scalar @no);
  $reservation->save;

	HEADER();

	print <<"EOM";
<CENTER><hr size=0><h2>NO:@{[ $no[0] + 1 ]}に@{[ scalar @no ]}個空白を注入しました。</h2><p>
<form action="./auto_in.cgi" method="post">
<input type=hidden name=id value=$in{id}>
<input type=hidden name=pass value=$in{pass}>
<input type=submit value="ＯＫ"></form></CENTER>
EOM

	FOOTER();
}

1;
