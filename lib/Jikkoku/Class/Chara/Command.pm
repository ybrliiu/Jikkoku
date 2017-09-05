package Jikkoku::Class::Chara::Command {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Class::Role::TextData';

  has 'id'          => ( metaclass => 'Column', is => 'ro', isa => 'Int', default  => 0 );
  has 'not_used'    => ( metaclass => 'Column', is => 'ro', isa => 'Str', default  => '' );
  has 'description' => ( metaclass => 'Column', is => 'ro', isa => 'Str', default  => '何もしない' );
  has 'not_used2'   => ( metaclass => 'Column', is => 'ro', isa => 'Str', default  => '' );
  has 'options'     => ( metaclass => 'Column', is => 'ro', isa => 'Str', default  => '' );
  has 'num'         => ( metaclass => 'Column', is => 'ro', isa => 'Str', default  => '' );

  __PACKAGE__->meta->make_immutable;

}

1;

