use v5.24;
use warnings;
use Data::Dumper;

open my $fh, '<', './log_file/jinkei.cgi';
my @formations = <$fh>;
$fh->close;

my $output = "[\n";
my $count = 0;
for my $str (@formations) {
  my (
    $name,
    $increase_attack_power_ratio, $increase_defence_power_ratio,
    $increase_attack_power_ratio_when_advantageous, $increase_defence_power_ratio_when_advantageous,
    $increase_attack_power_num, $increase_defence_power_num,
    $advantageous_formations_name, $reforming_time, $class,
    $description, 
  )
    = map { $_ eq '' ? 0 : $_ } split /<>/, $str;

  my @advantageous_formations_name = map { qq{'$_'} } split /,/, $advantageous_formations_name;

  $output .= <<"EOS";
  {
    id                                             => $count,
    name                                           => '$name',
    increase_attack_power_ratio                    => $increase_attack_power_ratio,
    increase_defence_power_ratio                   => $increase_defence_power_ratio,
    increase_attack_power_ratio_when_advantageous  => $increase_attack_power_ratio_when_advantageous,
    increase_defence_power_ratio_when_advantageous => $increase_defence_power_ratio_when_advantageous,
    increase_attack_power_num                      => $increase_attack_power_num,
    increase_defence_power_num                     => $increase_defence_power_num,
    reforming_time                                 => $reforming_time,
    class                                          => $class,
    advantageous_formations_id                     => [@{[ join ', ', @advantageous_formations_name ]}],
    skills                                         => [],
    description                                    => '',
    acquire_condition                              => sub { 1 },
  },
EOS
  
  $count++;
}
$output .= "]\n";

my $formations_data = eval "$output";
my $formations_hash = +{ map { $_->{name} => $_ } @$formations_data };
for my $formation (values %$formations_hash) {
  $formation->{advantageous_formations_id} = [
    map {
      my $advantageous_formation_name = $_;
      $formations_hash->{$advantageous_formation_name}->{id};
    } @{ $formation->{advantageous_formations_id} }
  ];
}

my $output_2 = "[\n";
for my $formation (@$formations_data) {
  my $increase_attack_power_ratio_when_advantageous
    = $formation->{increase_attack_power_ratio_when_advantageous} != 0 
      ? $formation->{increase_attack_power_ratio_when_advantageous} - $formation->{increase_attack_power_ratio}
      : 0;
  my $increase_defence_power_ratio_when_advantageous
    = $formation->{increase_defence_power_ratio_when_advantageous} != 0
      ? $formation->{increase_defence_power_ratio_when_advantageous} - $formation->{increase_defence_power_ratio}
      : 0;
  $output_2 .= <<"EOS";
  {
    id                                             => $formation->{id},
    name                                           => '$formation->{name}',
    increase_attack_power_ratio                    => $formation->{increase_attack_power_ratio},
    increase_defence_power_ratio                   => $formation->{increase_defence_power_ratio},
    increase_attack_power_ratio_when_advantageous  => $increase_attack_power_ratio_when_advantageous,
    increase_defence_power_ratio_when_advantageous => $increase_defence_power_ratio_when_advantageous,
    increase_attack_power_num                      => $formation->{increase_attack_power_num},
    increase_defence_power_num                     => $formation->{increase_defence_power_num},
    reforming_time                                 => $formation->{reforming_time},
    class                                          => $formation->{class},
    advantageous_formations_id                     => [@{[ join ', ', @{ $formation->{advantageous_formations_id} } ]}],
    skills                                         => [],
    description                                    => '',
    acquire_condition                              => sub { 1 },
  },
EOS
}
$output_2 .= "]\n";
say $output_2;

{
  open my $fh, '>', 'formation.conf';
  $fh->print($output_2);
  $fh->close;
}

