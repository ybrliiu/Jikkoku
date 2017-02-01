package Jikkoku::Class::Role::TextData {

  use Mouse::Role;
  use Carp;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  has 'textdata' => ( is => 'rw', isa => 'ScalarRef' );

  requires qw( PRIMARY_KEY );

  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    if ($_[0] eq 'HASH') {
      my $args = shift;
      $class->_buildargs_hash($args);
      $class->$orig($args);
    }
    else {
      my $textdata = shift;
      my $hash = $class->_buildargs_textdata($textdata);
      $class->$orig($hash);
    }
  };

  sub _buildargs_hash {
    my ($class, $args) = @_;
    my @hash_fields = grep { $_->can('keys') } $class->get_column_attributes;
    for my $attr (@hash_fields) {
      $args->{$attr->name} = Jikkoku::Class::Role::TextData::HashField->new({
        keys      => $attr->keys,
        data      => $args->{$attr->name},
        validator => $attr->validator,
      });
    }
  }

  sub _buildargs_textdata {
    my ($class, $textdata) = @_;
    my $hash = $class->textdata_to_hash($textdata);
    $hash->{textdata} = \$textdata;
    $hash;
  }

  # キャッシュを行っているので動的に attribute の追加を行う際は注意
  # (そんなケースは考えにくいが...)
  sub get_column_attributes {
    my $class = ref $_[0] || $_[0];
    state $cache = {};
    return @{ $cache->{$class} } if exists $cache->{$class};
    my @attributes = grep {
      $_->isa('Jikkoku::Class::Role::TextData::Attribute::Column')
    } $class->meta->get_all_attributes;
    $cache->{$class} = \@attributes;
    @attributes;
  }

  sub textdata_to_hash {
    my ($class, $textdata) = @_;
    # NOTE : <><> -> split -> 空文字列
    my @data_array = split /<>/, $textdata;
    my @columns    = map { $_->name } $class->get_column_attributes;
    # 空文字列は未定義データとして、あとで default の値を入れてもらう
    my $hash       = +{ map {
     ( !defined $data_array[$_] || $data_array[$_] eq '' ) ? () : ( $columns[$_] => $data_array[$_] )
    } 0 .. $#columns };

    my @hash_fields = grep { $_->can('keys') } $class->get_column_attributes;
    $class->sub_textdata_to_hash_field($hash, $_) for @hash_fields;
    $hash;
  }

  sub sub_textdata_to_hash_field {
    my ($class, $hash, $meta_attr) = @_;
    # 未定義データが多いと警告が出まくるので
    no warnings 'uninitialized';
    my @subdata = split /,/, $hash->{$meta_attr->name};
    my $data = +{ map { $meta_attr->keys->[$_] => $subdata[$_] } 0 .. @{ $meta_attr->keys } };
    use warnings 'uninitialized';
    $hash->{$meta_attr->name} = Jikkoku::Class::Role::TextData::HashField->new({
      keys      => $meta_attr->keys,
      data      => $data,
      validator => $meta_attr->validator,
    });
  }

  sub output {
    my $self = shift;
    my @columns = map { $_->name } $self->get_column_attributes;
    # オブジェクトデータをそのままテキストデータに変換して出力するが、
    # 元テキストデータに未定義値があった場合、オブジェクトのデフォルト値が代わりに出力される
    my $textdata = join( '<>', map {
      my $attr = $self->$_;
      # 空文字列からは can が呼び出せないので...
      if ($attr ne '') {
        $attr->can('output') ? $attr->output : $attr
      } else {
        '';
      }
    } @columns ) . '<>';
    \$textdata;
  }

  sub update_textdata {
    my $self = shift;
    $self->textdata( $self->output );
  }

  sub set_hash_value {
    my ($self, $hash) = @_;
    my @rw_attributes = grep { $_->is eq 'rw' } $self->get_column_attributes;
    for my $attribute (@rw_attributes) {
      my $attr_name = $attribute->name;
      if ( exists $hash->{$attr_name} ) {
        $self->$attr_name( $hash->{$attr_name} );
      }
    }
    return 1;
  }

  sub abort {
    my $self = shift;
    my $hash = $self->textdata_to_hash( ${ $self->textdata } );
    $self->set_hash_value($hash);
  }

  sub make_hash_fields {
    my $class = shift;
    my @hash_fields = grep { $_->can('keys') } $class->get_column_attributes;
    for my $attr (@hash_fields) {
      my $attr_name = $attr->name;
      $class->meta->add_method("field_${attr_name}" => sub {
        my ($self, $key, $value) = @_;
        return $self->$attr_name->get($key) if @_ == 2;
        $self->$attr_name->set($key => $value);
      });
    }
  }

}

package Jikkoku::Class::Role::TextData::HashField {

  use Mouse;
  use Jikkoku;
  use Carp;

  has 'keys'      => ( is => 'ro', isa => 'ArrayRef', required => 1 );
  has 'data'      => ( is => 'rw', isa => 'HashRef', required => 1 );
  has 'validator' => ( is => 'ro', isa => 'CodeRef', required => 1 );

  sub get {
    my ($self, $key) = @_;
    my $data = $self->data;
    Carp::croak("$key というフィールドは存在しません。") unless exists $data->{$key};
    $data->{$key};
  }

  sub set {
    my ($self, $key, $value) = @_;
    $self->validator->(@_);
    my $data = $self->data;
    Carp::croak("$key というフィールドは存在しません。") unless exists $data->{$key};
    $data->{$key} = $value;
  }

  sub output {
    my $self = shift;
    no warnings 'uninitialized';
    join( ',', map { $self->data->{$_} } @{ $self->keys } ) . ',';
  }

  __PACKAGE__->meta->make_immutable;

}

# NOTE : Meta Attribute にすることによるアクセッサ速度低下は特にない。
# Benchmark: running metaclass_attribute, nomal_mouse_attribute for at least 3 CPU seconds...
# metaclass_attribute:  4 wallclock secs ( 3.15 usr +  0.00 sys =  3.15 CPU) @ 10954469.21/s (n=34506578)
# nomal_mouse_attribute:  4 wallclock secs ( 3.12 usr +  0.00 sys =  3.12 CPU) @ 12655688.14/s (n=39485747)
#                             Rate   metaclass_attribute nomal_mouse_attribute
# metaclass_attribute   10954469/s                    --                  -13%
# nomal_mouse_attribute 12655688/s                   16%                    --

package Mouse::Meta::Attribute::Custom::Column {
  sub register_implementation() { 'Jikkoku::Class::Role::TextData::Attribute::Column' }
}

package Jikkoku::Class::Role::TextData::Attribute::Column {

  use Mouse;
  use Jikkoku;
  extends 'Mouse::Meta::Attribute';

  sub is { shift->{is} }

}

package Mouse::Meta::Attribute::Custom::HashField {
  sub register_implementation() { 'Jikkoku::Class::Role::TextData::Attribute::HashField' }
}

package Jikkoku::Class::Role::TextData::Attribute::HashField {

  use Mouse;
  use Jikkoku;
  extends 'Jikkoku::Class::Role::TextData::Attribute::Column';

  has 'keys'      => ( is => 'ro', isa => 'ArrayRef', required => 1 );
  has 'validator' => ( is => 'ro', isa => 'CodeRef', required => 1 );

}

1;

=encoding utf8

=head1 NAME
  Jikkoku::Class::Role::TextData

=head1 SYNOPSYS

=head1 NOTE

HashFieldは全て書き換え
(戦略
  TextData でHashFieldを使用しているクラスを特定
    HashFieldのメソッド名で全ファイル検索かける
    書き換え
    commit -> update_textdata に変更、注意
    Class::Division はそのまま (commit -> commit)
    Model にも commit を
)

=cut
