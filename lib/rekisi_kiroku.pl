#統一後　歴代統一国記録#

use v5.14;
use warnings;
use lib './lib';

use Jikkoku::Util qw/create_data/;
use Jikkoku::Model::Country;

sub create_html {
  my ($source, $term) = @_;
  my $archive = qx/perl $source.cgi/;
  $archive =~ s/Cache-Control: no-cache\nPragma: no-cache\nContent-type: text\/html\n\n//g;
  $archive =~ s/\.\//\.\.\//g;
  $archive =~ s/js\//\.\.\/js\//g;
  create_data "./REKISI/${source}_${term}.html", [$archive];
}

sub REKISI_KIROKU {
  my ($term, $unite_country_id) = @_;

  my $term_num = $term =~ s/第|期//gr;

  # 登録武将一覧記録
  create_html 'ranking', $term_num;

  # 名将記録
  create_html 'ranking2', $term_num;

  # 史記記録
  create_html 'map', $term_num;

  my $country_model = Jikkoku::Model::Country->new;
  my $unite_country = $country_model->get( $unite_country_id ); 

  open(my $fh, '<', './REKISI/index.html') or die "歴代統一国記録ファイルが開けませんでした";
  my $history_html = join '', <$fh>;
  $fh->close;

  my $new_line = qq{<tr><th>【$term】<\/th>}
    . qq{<td>統一国 : @{[ $unite_country->name ]}　君主 : @{[ $unite_country->king_name ]}}
    . qq{ 軍師 : @{[ $unite_country->strategist_name ]} 宰相 : @{[ $unite_country->premier_name ]}}
    . qq{ 大将軍 : @{[ $unite_country->great_general_name ]}<\/td>}
    . qq{<td>[<a href="ranking_$term_num.html">$termの武将一覧<\/a>]<\/td>}
    . qq{<td>[<a href="ranking2_$term_num.html">$termの名将<\/a>]<\/td>}
    . qq{<td>[<a href="map_$term_num.html">マップログ<\/a>]<\/td><\/tr>\n<\/TBODY>};
  $history_html =~ s/<\/TBODY>/$new_line/g;

  open(my $out, '>', './REKISI/index.html');
  $out->print( $history_html );
  $out->close;

}

1;
