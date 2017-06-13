package Jikkoku::Service::Skill::Role::UsedInBattleMap::Disturb {

  use Mouse::Role;
  use Jikkoku;

  # エラー抑止のための先行宣言
  sub log_color;

  has 'log_color' => ( is => 'ro', isa => 'Str', default => 'yellowgreen' );

  with 'Jikkoku::Service::Skill::Role::UsedInBattleMap';

}

1;

__END__

妨害行動向けロール
ログの色を決める

