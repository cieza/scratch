#!/usr/bin/perl

#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_1";
#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_1";
#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_1";
$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_1";

#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_2";
#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_2";
#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_2";
#$diretorio = "/home/azeic/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_2";


# $arquivo_final= "/home/azeic/arquivo-final.dat";



#########################
opendir(diretorio, $diretorio);
@lista = readdir(diretorio);
closedir(diretorio);


$sum_packets = 0;
$sum_packet_raw = 0;
$sum_out_packets = 0;
$sum_out_packet_raw = 0;
$count = 0;

foreach $dir_exp(@lista)
{

    if($dir_exp ne "." and $dir_exp ne "..")
    {
        $file_name = $diretorio."/".$dir_exp."/trace-rate.txt";
        $packets = 0;
        $packet_raw = 0;
        $out_packets = 0;
        $out_packet_raw = 0;
        open ARK, $file_name;
        foreach(<ARK>)
        {
            @linha = split(/\s+/);
            #verifica na coluna 4 (Type) do ARK se encontra alvo
            if($linha[4] eq "InSatisfiedInterests")
            {
                $packets = $packets + $linha[5];
                $packet_raw = $packet_raw + $linha[7];
            }
            if($linha[4] eq "OutInterests")
            {
                $out_packets = $out_packets + $linha[5];
                $out_packet_raw = $out_packet_raw + $linha[7];
            }

        }
        close ARK;
        $sum_packets = $sum_packets + $packets;
        $sum_packet_raw = $sum_packet_raw + $packet_raw;
        
        $sum_out_packets = $sum_out_packets + $out_packets;
        $sum_out_packet_raw = $sum_out_packet_raw + $out_packet_raw;
        
        $count = $count + 1;

        
    }
    
}

#medias
$x =  $sum_packets/$count;
$y = $sum_packet_raw/$count;
$a =  $sum_out_packets/$count;
$b = $sum_out_packet_raw/$count;

# razao entre interesses satisfeitos e interesses enviados
$valor_1 = $x/$a;
$valor_2 = $y/$a;
$valor_3 = $x/$b;
$valor_4 = $y/$b;

# Y/B: taxa de entrega calculada pela razão entre os interesses enviados e os interesses atendidos


print("X/A: $valor_1     Y/A: $valor_2      X/B: $valor_3      Y/B: $valor_4\n");


