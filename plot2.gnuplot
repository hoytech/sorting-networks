set title "Comparisons required with various sorting network algorithms"
set ylabel "Comparisons required"
set xlabel "Input size"

set pointsize 2

set key left top
plot [2:9] 'output/bubble.dat' with points title 'Bubble', \
           'output/bosenelson.dat' with lines title 'Bose-Nelson', \
           'output/bitonic.dat' with lines title 'Bitonic', \
           'output/batcher.dat' with points title 'Merge-Exchange'

set term png
set output "img/algo-comparison2.png"
replot
