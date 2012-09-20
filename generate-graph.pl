use common::sense;

use Algorithm::Networksort qw(:all);
use File::Slurp;
use Data::Dumper;

my $height = 256;


mkdir('output');


foreach my $algo (qw/batcher bosenelson bitonic/) {
  open(my $fh, '>', "output/$algo.dat");

  for my $i (2..$height) {
    print "$algo $i\n";
    my @network1 = nw_comparators($i, algorithm => $algo);

    print $fh "" . (scalar @network1) . "\n";
  }
}


{
  open(my $fh, '>', "output/bubble.dat");

  for my $i (2..$height) {
    print $fh "" . ($i * ($i-1) / 2) . "\n";
  }
}
