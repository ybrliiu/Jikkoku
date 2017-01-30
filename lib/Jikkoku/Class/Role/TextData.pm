package Jikkoku::Class::Role::TextData {

  use Moo::Role;
  use Carp;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  has 'fh'        => ( is => 'rw' );
  has '_textdata' => ( is => 'rw', init_arg => undef );

  requires qw(
    COLUMNS
    PRIMARY_KEY
  );

  sub SUBDATA_COLUMNS() { +{} }

  sub columns_without_subdata {
    my @subdata_columns = keys SUBDATA_COLUMNS();
    [
      grep {
        my $column = $_;
        not grep { $column eq $_ } @subdata_columns;
      } @{ COLUMNS() }
    ];
  }

  sub has_hash {
    my ($list) = @_;

    my $subdata_hash = +{ map {
      $_ => +{  map { $_ => 1 } @{ SUBDATA_COLUMNS()->{$_} } };
    } keys %{ SUBDATA_COLUMNS() } };

    for my $name (@$list) {
      my $field = $subdata_hash->{$name};
      no strict 'refs';
      *{$name} = sub {
        use strict 'refs';
        my ($self, $key, $value) = @_;
        Carp::croak("$key というフィールドは $name subdata に存在しません。") unless exists $field->{$key};
        return $self->{$name}{$key} if @_ == 2;
        $self->{$name}{$key} = $value;
      };
    }

  }

  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    if (ref $args eq 'HASH') {
      my $args = shift;
      $class->$orig($args);
    } else {
      my $textdata = shift;
      my $hash = $class->textdata_to_hash;
      my $self = $class->$orig($hash);
      $self->_textdata( $textdata );
      $self;
    }
  };

  sub textdata_to_hash {
    my ($class, $textdata) = @_;
    my @data_array = split /<>/, $textdata;
    my $hash = {};
    no warnings 'uninitialized';
    $hash->{ $class->COLUMNS->[$_] } = $data_array[$_] for 0 .. $#data_array;
    $class->sub_textdata_to_hash($hash, $_) for keys %{ $class->SUBDATA_COLUMNS };
    $hash;
  }

  sub sub_textdata_to_hash {
    my ($class, $hash, $subdata_type) = @_;
    my @subdata;
    {
      # データがない領域を split すると鬱陶しいので、本来推奨されないがここだけ
      no warnings 'uninitialized';
      @subdata = split /,/, $hash->{$subdata_type};
    }
    $hash->{$subdata_type} = +{
      map {
        $class->SUBDATA_COLUMNS->{$subdata_type}[$_] => $subdata[$_]
      } 0 .. $#subdata
    };
  }

  sub abort {
    my ($self) = @_;
    $self->set_data;
  }

  sub commit {
    my ($self) = @_;
    $self->{_textdata} = $self->output;
  }

  sub output {
    my ($self) = @_;
    my $temp;
    for (keys %{ $self->SUBDATA_COLUMNS }) {
      ( $temp->{$_}, $self->{$_} ) = ( $self->{$_}, ${ $self->output_subdata($_)} );
    }
    # データがない領域を join すると鬱陶しいので、本来推奨されないがここだけ
    no warnings 'uninitialized';
    my $textdata = join('<>', map { $self->{$_} } @{ $self->COLUMNS }) . '<>';
    $self->{$_} = $temp->{$_} for keys %{ $self->SUBDATA_COLUMNS };
    \$textdata;
  }

  sub output_subdata {
    my ($self, $subdata_type) = @_;
    # データがない領域を join すると鬱陶しいので、本来推奨されないがここだけ
    no warnings 'uninitialized';
    # 最後に separator をつけないと、後で set_subdata でsplit する時にバグる
    my $textdata = join(',', map { $self->{$subdata_type}{$_} } @{ $self->SUBDATA_COLUMNS->{$subdata_type} }) . ',';
    \$textdata;
  }

}

1;
