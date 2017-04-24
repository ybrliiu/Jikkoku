use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Chara::Protector';
use_ok $CLASS;

ok( my $model = $CLASS->new );
ok( $model->add('ybrliiu') );
ok $model->save;

subtest 'is_chara_protected' => sub {
  my $chara_id = 'ybrliiu';
  my $chara = Jikkoku::Model::Chara->get($chara_id);
  my $result;
  lives_ok { $result = $model->is_chara_protected($chara) };
  ok !defined $result;
  ok( my $id_list = $model->get_id_list_same_bm( $chara->soldier_battle_map('battle_map_id') ) );
  is $id_list->[0], $chara_id;
  ok $model->delete( $chara->id );
  dies_ok { $model->get( $chara->id ) };
  ok !$model->delete( $chara->id );
  $model->save;
};

done_testing;
