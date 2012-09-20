use common::sense;

use Template;
use Data::Dumper;
use Time::HiRes;
use Statistics::Descriptive;

my $iters = 100000;
my $rounds = 5;

my $half_iters = int($iters/2);

my $output = {};

my @algos = qw/ -q -l -c -k /;
#my @algos = qw/ -l /;

my $alg2name = {
  '-q' => 'qsort(3)',
  '-l' => 'Leaky',
  '-c' => 'Const-simple',
  '-k' => 'Const-best',
};

my $alg2const = {
  '-q' => 0,
  '-l' => 0,
  '-c' => 1,
  '-k' => 1,
};

foreach my $algo (@algos) {

  foreach my $direction (qw / -d -a /) {
    my $stat = Statistics::Descriptive::Full->new();

    open(my $fh, '>', "output/data$algo$direction") || die "$!";

    for (1..$rounds) {

      my $duration = `./output/a.out -i $iters $algo $direction |sort -n|tail -n $half_iters|head -n 1`;
      chomp $duration;

      print $fh "$duration\n";

      $stat->add_data($duration);

      print "$algo $direction $duration\n";
    }

    my $mean = $stat->mean();
    my $median = $stat->median();
    my $stddev = $stat->standard_deviation();

    $output->{$algo}->{$direction}->{mean} = $mean;
    $output->{$algo}->{$direction}->{median} = $median;
    $output->{$algo}->{$direction}->{stddev} = $stddev;

    print "$algo $direction $median ($mean $stddev)\n";
  }

}



print Dumper($output);


my $tmpl = <<'END';

  <table border=1 cellspacing=0 cellpadding=5>
    <tr>
      <th>Algo</th>
      <th>Asc</th>
      <th>Desc</th>
      <th>Const</th>
    </tr>
[%- FOREACH algo IN algos -%]
    <tr>
      <th>[% alg2name.$algo %]</th>
      <td>[% fmt(data.$algo.$asc.median) %] &mu;s</td>
      <td>[% fmt(data.$algo.$desc.median) %] &mu;s</td>
      [%- IF alg2const.$algo %]
        <td align=center style="color:green">&#x2713;</td>
      [%- ELSE %]
        <td align=center style="color:red">&#x2717;</td>
      [%- END -%]
    </tr>
[%- END -%]
  </table>

END


my $template = Template->new();
my $html;

$template->process(\$tmpl, {
   algos => \@algos,
   data => $output,
   alg2name => $alg2name, 
   alg2const => $alg2const, 
   asc => '-a',
   desc => '-d',
   fmt => sub {
     my $us = shift;
     return sprintf("%.3f", $us/1000.0);
   }
 }, \$html) || die $template->error();

print "$html\n";
