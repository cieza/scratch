reset
fontsize = 12
set terminal png size 520,400 enhanced font "Helvetica,13"
set output "realistic_conteudos.png"
set style fill pattern border
set style histogram errorbars gap 2 lw 1
set style data histogram
set grid ytics
set key left top reverse Left
#set xlabel "Qtde. de Consumidores"
set xlabel "Consumer nodes"
#set ylabel "Qtde. Retransmissões de Conteúdos"
set ylabel "Content packets"
set yrange [0:1600]
set datafile separator " "
plot 'new_data_conteudos' using 11:12:13:xtic(1) ti "CCN-wireless" fill pattern 6, \
'' using 5:6:7 ti "Wang et al. [21]" fill pattern 5, \
'' using 8:9:10 ti "Non-proactive GeoZone" fill pattern 2, \
'' using 2:3:4 ti "Proactive GeoZone" fill pattern 4
