clear
reset
#unset key
fontsize = 12
set terminal png size 520,400 enhanced font "Helvetica,13"
set output "txentrega.png"

# Select histogram data
set style data histogram
set grid ytics
#set key left top reverse Left
set ylabel "Taxa de Entrega"
set yrange [0:1]
# Give the bars a plain fill pattern, and draw a solid line around them.
#set style fill solid border
set style fill pattern border
set style histogram errorbars gap 2 lw 1
#set datafile separator " "
set style histogram clustered
#plot for [COL=2:5] 'txentrega.tsv' using COL:xticlabels(1) title columnheader
plot 'txentrega' using 2:xtic(1) title "no-cache-no-mob" fill pattern 5, \
'' using 3 title "no-cache-no-mob-pollution" fill pattern 2, \
'' using 4 title "with-cache-no-mob" fill pattern 6, \
'' using 5 title "with-cache-no-mob-pollution" fill pattern 4