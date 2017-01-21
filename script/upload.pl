# 未完成

use v5.24;
use warnings;
use utf8;
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

use Net::FTP;
use Path::Tiny;

print "please input upload dir : ";
chomp(my $dir = <>);
my $ftp = Net::FTP->new('lunadraco.sakura.ne.jp');
$ftp->login(lunadraco => 'yakg927ntf@') or die 'auth failed';
$ftp->cwd("www/$dir") or die "cwd failed (goto $dir)";
upload($ftp);
$ftp->quit;

sub upload {
  my ($ftp) = @_;
  my $cd = path('./');
  my $itr = $cd->iterator({recurse => 1});
  my @IGNORE_FILES = qw/.git log_file charalog image sound REKISI backup etc/;
  while ( my $path = $itr->() ) {
    unless ( grep { $path =~ $_ } @IGNORE_FILES && $path->is_file ) {
      warn "upload $path ...";
      # $ftp->put("$path") or die "put $path failed.";
    }
  }
}
