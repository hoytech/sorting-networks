use common::sense;

use Algorithm::Networksort qw(:all);
use Algorithm::Permute;
use File::Slurp;
use Data::Dumper;




my $good = [
         [0,2],
         [0,1],
         [1,2],
       ];

my $bad = [
         [0,1],
         [1,2],
         [0,1],
       ];



my $array_len = 3;


sub calc {
  my ($network) = @_;

  my $total_swaps;

  my $combinations = 2**$array_len;

  for (my $i=0; $i<$combinations; $i++) {
    my @array;
    @array[$_] = $i & (1 << $_) ? 1 : 0 for (0..($array_len-1));

    my @orig = @array;

    my ($output, $swaps) = nw_sort($network, \@array);

    print "<tr><td>$orig[2]$orig[1]$orig[0]</td><td>$swaps</tr>\n";

    $total_swaps += $swaps;
  }

  my $avg = sprintf("%.3g", $total_swaps / $combinations);
  print "<tr><th>Avg</th><td style='font-size:120%; font-weight:bold'>$avg</td></tr>\n";
}

calc($bad);
print "\n\n";
calc($good);






print "\n\n\n-------------------------\n\n\n";

foreach my $network ($bad, $good) {
  my $total_swaps = 0;
  my $combinations = 0;

  my @input = (0, 1, 2);

  Algorithm::Permute::permute {

    my @input_copy = @input;
    my @orig = @input;

    my ($output, $swaps) = nw_sort($network, \@input_copy);

    print "<tr><td>$orig[2]$orig[1]$orig[0]</td><td>$swaps</tr>\n";
    $total_swaps += $swaps;
    $combinations++;

  } @input;

  my $avg = sprintf("%.3g", $total_swaps / $combinations);
  print "<tr><th>Avg</th><td style='font-size:120%; font-weight:bold'>$avg</td></tr>\n\n";
}
