use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Class::Role::TextData';

package Jikkoku::Player {

  use Mouse;
  use Jikkoku;

  use constant PRIMARY_KEY => 'name';

  # metaclass => 'column' の attribute は, テキストデータの要素として順番に定義される.
  # 宣言の順番を変更するとデータ構造が崩れるのでしないこと
  has 'name' => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'buff' => (
    metaclass     => 'HashField',
    is            => 'rw',
    isa           => 'Jikkoku::Class::Role::TextData::HashField',
    keys          => [qw( stuck kintoun attack_up )],
    validators    => +{
      kintoun => sub {
        my ($value) = @_;
        die "kintounが0以下になります" if $value < 0;
      },
    },
  );
  has 'debuff' => (
    metaclass     => 'Jikkoku::Class::Role::TextData::Attribute::HashField',
    is            => 'rw',
    isa           => 'Jikkoku::Class::Role::TextData::HashField',
    keys          => [qw( stuck kintoun attack_up )],
  );
  has 'power' => ( metaclass => 'Column', is => 'rw', isa => 'Int', default => 1 );
  has 'pass'  => ( metaclass => 'Column', is => 'rw', isa => 'Str', default => 'password' );

  with 'Jikkoku::Class::Role::TextData';

  __PACKAGE__->make_hash_fields;
  __PACKAGE__->meta->make_immutable;

}

ok my $player = Jikkoku::Player->new('ybrliiu<>100,200<><><>password_string<>');
is $player->buff->get('stuck'), 100;
is $player->field_buff('stuck'), 100;
dies_ok { $player->buff->set(kintoun => -100) };
ok $player->debuff->set(attack_up => 'トラウマ');
is ${ $player->output }, "ybrliiu<>100,200,,<>,,トラウマ,<>1<>password_string<>\n";
ok $player->abort;
is ${ $player->output }, "ybrliiu<>100,200,,<>,,,<>1<>password_string<>\n";

done_testing;
