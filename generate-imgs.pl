use common::sense;

use Algorithm::Networksort qw(:all);
use File::Slurp;
use Data::Dumper;



mkdir('img/');


my @options = ( graph => 'svg', vt_margin => 5, );




my $net;


$net = [
         [0,1],
         [0,2],
         [1,2],
       ];

write_file('img/notation.svg', nw_graph($net, 3, @options, ));




$net = [
         [0,1],
       ];
 
write_file('img/basecase.svg', nw_graph($net, 2, @options,
  inputline_color_override => { 0 => { inputend => 'green;fill:green', }, 1 => { inputend => 'green;fill:green', }, }
));




$net = [
         [0,1],
         [1,2],
       ];
 
write_file('img/construction-step1.svg', nw_graph($net, 3, @options,
  inputline_color_override => { 2 => { inputend => 'green;fill:green', }, }
));




$net = [
         [0,1],
         [1,2],
         [0,1],
       ];
 
write_file('img/construction-step2.svg', nw_graph($net, 3, @options,
  inputline_color_override => { 0 => { inputend => 'green;fill:green', }, 1 => { inputend => 'green;fill:green', }, 2 => { inputend => 'green;fill:green', }, }
));




$net = [
         [0,2],
         [0,1],
         [1,2],
       ];
 
write_file('img/good-size3.svg', nw_graph($net, 3, @options));



$net = [
         [0,1],
         [1,2],
         [0,1],
       ];

write_file('img/bad-size3.svg', nw_graph($net, 3, @options));




##my @net = nw_comparators(5, algorithm => 'bubble');
my @net = (
         [0,1],
         [1,2],
         [2,3],
         [3,4],

         [0,1],
         [1,2],
         [2,3],

         [0,1],
         [1,2],

         [0,1],
       );

my @z = @net[0..3];
write_file('img/bubble-sort.svg', nw_graph(\@z, 5, @options,
  inputline_color_override => { 4 => { inputend => 'green;fill:green', }, }
));

@z = @net[0..6];
write_file('img/bubble-sort2.svg', nw_graph(\@z, 5, @options,
  inputline_color_override => { 4 => { inputend => 'green;fill:green', }, 3 => { inputend => 'green;fill:green', }, }
));

@z = @net[0..8];
write_file('img/bubble-sort3.svg', nw_graph(\@z, 5, @options,
  inputline_color_override => { 4 => { inputend => 'green;fill:green', }, 3 => { inputend => 'green;fill:green', }, 2 => { inputend => 'green;fill:green', }, }
));

@z = @net[0..9];
write_file('img/bubble-sort4.svg', nw_graph(\@z, 5, @options,
  inputline_color_override => { 4 => { inputend => 'green;fill:green', }, 3 => { inputend => 'green;fill:green', }, 2 => { inputend => 'green;fill:green', }, 1 => { inputend => 'green;fill:green', }, 0 => { inputend => 'green;fill:green', }, }
));





##my @net = nw_comparators(4, algorithm => 'bubble');
my @net = (
         [0,1],
         [1,2],
         [2,3],

         [0,1],
         [1,2],

         [0,1],
       );

my @z = @net[0..0];
write_file('img/stable1.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 0 => { inputbegin => 'green;fill:green', },
                                1 => { inputbegin => 'blue;fill:blue', }, }
));

my @z = @net[0..1];
write_file('img/stable2.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 0 => { inputbegin => 'green;fill:green', },
                                2 => { inputbegin => 'blue;fill:blue', }, }
));

my @z = @net[0..2];
write_file('img/stable3.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 0 => { inputbegin => 'green;fill:green', },
                                3 => { inputend => 'blue;fill:blue', }, }
));

my @z = @net[0..3];
write_file('img/stable4.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 1 => { inputbegin => 'green;fill:green', },
                                3 => { inputend => 'blue;fill:blue', }, }
));

my @z = @net[0..4];
write_file('img/stable5.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 2 => { inputend => 'green;fill:green', },
                                3 => { inputend => 'blue;fill:blue', }, }
));

write_file('img/stable6.svg', nw_graph(\@net, 4, @options,
  inputline_color_override => { 2 => { inputend => 'green;fill:green', },
                                3 => { inputend => 'blue;fill:blue', }, }
));




my @net = nw_comparators(4, algorithm => 'batcher');

my @z = @net[0..0];
write_file('img/unstable1.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 1 => { inputbegin => 'green;fill:green', },
                                2 => { inputbegin => 'blue;fill:blue', }, }
));

my @z = @net[0..1];
write_file('img/unstable2.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 3 => { inputend => 'green;fill:green', },
                                2 => { inputbegin => 'blue;fill:blue', }, }
));

my @z = @net[0..4];
write_file('img/unstable3.svg', nw_graph(\@z, 4, @options,
  inputline_color_override => { 3 => { inputend => 'green;fill:green', },
                                2 => { inputend => 'blue;fill:blue', }, }
));







### Requires my patches

my @network1 = nw_comparators(8, algorithm => 'bitonic');
my $net = make_network_unidirectional([ @network1 ]);
write_file('img/bitonic-size8.svg', nw_graph($net, 8, @options,));

my @network1 = nw_comparators(8, algorithm => 'bubble');
write_file('img/bubble-size8.svg', nw_graph(\@network1, 8, @options,));


my @network1 = nw_comparators(4, algorithm => 'bitonic');
write_file('img/bitonic-bi-size4.svg', nw_graph(\@network1, 4, @options,));

my @network1 = nw_comparators(4, algorithm => 'bitonic');
my $net = make_network_unidirectional([ @network1 ]);
write_file('img/bitonic-uni-size4.svg', nw_graph($net, 4, @options,));




my @network1 = nw_comparators(8, algorithm => 'batcher');
write_file('img/batcher-size8.svg', nw_graph(\@network1, 8, @options,));


my @network1 = nw_comparators(10, algorithm => 'batcher');
write_file('img/batcher-size10.svg', nw_graph(\@network1, 10, @options,));



my @network1 = nw_comparators(8, algorithm => 'bosenelson');
write_file('img/bosenelson-size8.svg', nw_graph(\@network1, 8, @options,));

my @network1 = nw_comparators(10, algorithm => 'bosenelson');
write_file('img/bosenelson-size10.svg', nw_graph(\@network1, 10, @options,));






my $paeth_median_9 = [[0,3],[1,4],[2,5],[0,1],[0,2],[4,5],[3,5],[1,2],[3,4],[1,3],[1,6],[4,6],[2,6],[2,3],[4,7],[2,4],[3,7],[4,8],[3,8],[3,4]];
write_file('img/paeth-median9.svg', nw_graph($paeth_median_9, 9, @options,
  inputline_color_override => { 4 => { inputend => 'green;fill:green', }, }
));









my @net = nw_comparators(4, algorithm => 'batcher');

my @z = @net[0..0];
write_file('img/hasse2.svg', nw_graph(\@z, 4, @options, ));

my @z = @net[0..1];
write_file('img/hasse3.svg', nw_graph(\@z, 4, @options, ));

my @z = @net[0..2];
write_file('img/hasse4.svg', nw_graph(\@z, 4, @options, ));

my @z = @net[0..3];
write_file('img/hasse5.svg', nw_graph(\@z, 4, @options, ));

my @z = @net[0..4];
write_file('img/hasse6.svg', nw_graph(\@z, 4, @options, ));
