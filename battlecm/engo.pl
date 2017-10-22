#_/_/_/_/_/_/_/_/_/_/#
#      掩護スキル      #
#_/_/_/_/_/_/_/_/_/_/#

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Service::Skill::Protect::Protect;

sub ENGO {

  my $idate = time;
  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get($kid));

  my $protect = Jikkoku::Service::Skill::Protect::Protect->new({ chara => $chara });
  eval {
    $protect->exec();
  };

  if (my $e = $@) {
    if ( Jikkoku::Class::Role::BattleActionException->caught($e) ) {
      ERR $e->message;
    } else {
      ERR $e;
    }
  }

  render($chara);
}

sub render {
  my ($chara) = @_;

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>掩護を行いました。</h2><p>
<form action="$BACK" method="post">
<input type=hidden name=id value="@{[ $chara->id ]}">
<input type=hidden name=pass value="@{[ $chara->pass ]}">
<input type=hidden name=mode value=STATUS>
<input type=submit value="OK">
</form>
</CENTER>
EOM
	&FOOTER;

}

1;
