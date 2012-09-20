set title "Comparisons required with various sorting network algorithms"
set ylabel "Comparisons required"
set xlabel "Input size"

set key left top
set yrange [1:10000]
plot [2:256] 'output/bubble.dat' with lines title 'Bubble', \
             'output/bosenelson.dat' with lines title 'Bose-Nelson', \
             'output/bitonic.dat' with lines title 'Bitonic', \
             'output/batcher.dat' with lines title 'Merge-Exchange'

set term png
set output "img/algo-comparison.png"
replot
