#_/_/_/_/_/_/_/_/_/_/#
#      足止めスキル      #
#_/_/_/_/_/_/_/_/_/_/#

use Jikkoku::Model::Chara;
use Jikkoku::Model::BattleMap;
use Jikkoku::Model::MapLog;
use Jikkoku::Class::Skill::Disturb::Stuck;

sub ASIDOME {

  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara       = $chara_model->get($kid);

  my $stuck = Jikkoku::Class::Skill::Disturb::Stuck->new({ chara => $chara });

  eval {
    $stuck->exec({
      target_id        => $in{eid} || undef,
      chara_model      => $chara_model,
      map_log_model    => Jikkoku::Model::MapLog->new,
      battle_map_model => Jikkoku::Model::BattleMap->new,
    });
  };

  if (my $e = $@) {
    if ( Jikkoku::Class::Role::BattleActionException->caught($e) ) {
      ERR $e->message;
    } else {
      ERR $e;
    }
  }

	&HEADER;

	print <<"EOM";
<CENTER><hr size=0><h2>足止めを行いました。</h2><p>
<form action="$BACK" method="post">
<input type=hidden name=id value=$kid>
<input type=hidden name=pass value=$kpass>
<input type=hidden name=mode value=STATUS>
<input type=submit value="OK">
</form>
</CENTER>
EOM
	&FOOTER;

	exit;
}

1;
