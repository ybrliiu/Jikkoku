use Test::Jikkoku;
use Jikkoku::Class::Chara;

my @charactors = (
  {
    id => 'haruka',
    name => '高山春香',
  },
  {
    id => 'yuuu',
    name => '園田優',
  },
  {
    id => 'kotone',
    name => '野田コトネ',
  },
  {
    id => 'sizuku',
    name => '南しずく',
  },
  {
    id => 'kaede',
    name => '池野楓',
  },
  {
    id => 'yuzu',
    name => '飯塚ゆず',
  },
  {
    id => 'mituki',
    name => '園田美月',
  },
  {
    id => 'rina',
    name => '坂井理奈',
  },
  {
    id => 'sumisumi',
    name => '乙川澄',
  },
);

for my $chara_data (@charactors) {
  my $chara = Jikkoku::Class::Chara->new({
    id         => $chara_data->{id},
    pass       => 'qwerty',
    name       => $chara_data->{name},
    icon       => 0,
    force      => 1,
    intellect  => 100,
    leadership => 53,
    popular    => 1,
    soldier_num => 53,
    soldier_training => 100,
    country_id => 1,
    money      => 50000,
    rice       => 40000,
    contribute => 100,
    class       => 10000,
    weapon_power => 13,
    book_power   => 56,
    loyalty      => 65,
    delete_turn => 0,
    town_id     => 3,
    guard_power => 12,
    host => '----',
    update_time => time,
    mail => '@',
    is_authed => 1,
    win_message => '優ちゃーん！',
    skill_point => 8,
    last_login_host => '',
    weapon_skill_id => '',
  });
  ok $chara->save;
}

done_testing;
