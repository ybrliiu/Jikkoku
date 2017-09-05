use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Model::Chara::CommandRecord';

ok my $command_record = Jikkoku::Model::Chara::CommandRecord->new('ybrliiu');
is @{ $command_record->get_all }, $command_record->MAX;
ok $command_record->input(
  $command_record->INFLATE_TO->new({
    id => 10,
    description => '農業開発',
  }),
  [10 .. 20],
);
my $command_list = $command_record->get_all;
is $command_list->[$_]->description, '農業開発' for 10 .. 20;

done_testing;

