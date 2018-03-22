use Test::Jikkoku;

use_ok 'Jikkoku::Role::Logger';

package Jikkoku::Model::Log {

  use Mouse;
  use Jikkoku;

  use constant {
    file_path => 'role_test.log',
    MAX       => 10,
  };

  with 'Jikkoku::Role::Logger';

  __PACKAGE__->meta->make_immutable;

}

# 国民のコマンド一覧の表示方法はどうなる？
ok my $logger = Jikkoku::Model::Log->new;

subtest add => sub {
  my $before_num = @{ $logger->get_all };
  ok $logger->add('テストログ');
  is @{ $logger->get_all }, $before_num + 1;
  like $logger->get_all->[0], qr/テストログ \((.*)日(.*)時(.*)分(.*)秒\)/;
};

subtest save => sub {
  $logger->add('テストログ(save)') for 0 .. 10;
  ok $logger->save;
  is @{ $logger->get_all }, $logger->MAX;
};

subtest abort => sub {
  $logger->lock;
  $logger->add('テストログ(abort)');
  ok $logger->abort;
  unlike $logger->get_all->[0], qr/テストログ\(abort\)/;
};

subtest commit => sub {
  $logger->lock;
  $logger->add('テストログ(commit)');
  ok $logger->commit;
  like $logger->get_all->[0], qr/テストログ\(commit\)/;
};

done_testing;

