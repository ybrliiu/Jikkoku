package Jikkoku::Class::Base::TextData {

  use Jikkoku;
  use Carp;
  use Jikkoku::Util qw/validate_values/;

  sub COLUMNS() { die " 定数 COLUMNS を指定してください " }

  sub PRIMARY_KEY() { die " 定数 PRIMARY_KEY を指定してください " }

  # if you need to use subdata, override this constant value.
  sub SUBDATA_COLUMNS() { {} }

  sub after {
    my ($class, $method_name, $code) = @_;
    my $origin = $class->can($method_name) // croak " $method_name メソッドが存在しません ";
    no strict 'refs';
    no warnings 'redefine';
    *{$method_name} = sub {
      use strict 'refs';
      use warnings 'redefine';
      my $self = shift;
      my $return = $self->$origin(@_);
      $self->$code(@_);
      $return;
    };
  }

  sub around {
    my ($class, $method_name, $code) = @_;
    my $origin = $class->can($method_name) // croak " $method_name メソッドが存在しません ";
    no strict 'refs';
    no warnings 'redefine';
    *{$method_name} = sub {
      use strict 'refs';
      use warnings 'redefine';
      $code->($origin, @_);
    };
  }

  sub before {
    my ($class, $method_name, $code) = @_;
    my $origin = $class->can($method_name) // croak " $method_name メソッドが存在しません ";
    no strict 'refs';
    no warnings 'redefine';
    *{$method_name} = sub {
      use strict 'refs';
      use warnings 'redefine';
      my $self = shift;
      $self->$code(@_);
      $self->$origin(@_);
    };
  }

  sub make_accessors {
    my ($class, $list) = @_;
    for my $name (@$list) {
      unless ( $class->can($name) ) {
        no strict 'refs';
        *{$name} = sub {
          use strict 'refs';
          my ($self, $value) = @_;
          return $self->{$name} if @_ == 1;
          $self->{$name} = $value;
        };
      }
    }
  }

  sub make_hash_accessors {
    my ($class, $list) = @_;

    my $subdata_columns = $class->SUBDATA_COLUMNS;
    my $subdata_hash = +{ map {
      $_ => +{  map { $_ => 1 } @{ $class->SUBDATA_COLUMNS->{$_} } };
    } keys %{ $class->SUBDATA_COLUMNS } };

    for my $name (@$list) {
      unless ( $class->can($name) ) {
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

  }

  sub new {
    my ($class, $args) = @_;
    if (ref $args eq 'HASH') {
      $class->_new_by_args( $args );
    } else {
      $class->_new_by_textdata( $args );
    }
  }

  sub _new_by_args {
    my ($class, $args) = @_;
    validate_values $args => $class->COLUMNS;
    for (keys %{ $class->SUBDATA_COLUMNS }) {
      validate_values $_ => $args->{$_};
    }
    bless $args, $class;
  }

  sub _new_by_textdata {
    my ($class, $textdata) = @_;
    my $self = bless {}, $class;
    $self->{_textdata} = \$textdata;
    $self->set_data;
    $self;
  }

  sub abort {
    my ($self) = @_;
    $self->set_data;
  }

  sub commit {
    my ($self) = @_;
    $self->{_textdata} = $self->output;
  }

  sub set_data {
    my ($self) = @_;
    my @data_array = split /<>/, ${ $self->{_textdata} };
    no warnings 'uninitialized';
    $self->{ $self->COLUMNS->[$_] } = $data_array[$_] for 0 .. $#data_array;
    $self->set_subdata($_) for keys %{ $self->SUBDATA_COLUMNS };
  }

  sub set_subdata {
    my ($self, $subdata_type) = @_;
    my @subdata;
    {
      # データがない領域を split すると鬱陶しいので、本来推奨されないがここだけ
      no warnings 'uninitialized';
      @subdata = split /,/, $self->{$subdata_type};
    }
    $self->{$subdata_type} = +{
      map {
        $self->SUBDATA_COLUMNS->{$subdata_type}[$_] => $subdata[$_]
      } 0 .. $#subdata
    };
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
