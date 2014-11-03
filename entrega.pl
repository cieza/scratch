#!/usr/bin/perl

$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_3";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_1";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_1";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_1";

#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_2";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_2";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_2";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_2";


# $arquivo_final= "/home/elise/ndnSIM/ns-3/resultados/arquivo-final-entrega";



#########################
opendir(diretorio, $diretorio);
@lista = readdir(diretorio);
closedir(diretorio);


#$sum_packets = 0;
$sum_packet_raw = 0;
#$sum_out_packets = 0;
$sum_satisfied_packet_raw = 0;
$count = 0;

foreach $dir_exp(@lista)
{

    if($dir_exp ne "." and $dir_exp ne "..")
    {
        $file_name = $diretorio."/".$dir_exp."/trace-rate.txt";
        #$packets = 0;
        $ininterest_packet_raw = 0;
        #$out_packets = 0;
        $insatisfiedinterest_packet_raw = 0;
        open ARK, $file_name;
        foreach(<ARK>)
        {
            @linha = split(/\s+/);
            #print("linha: $linha[4] \n");
            
            
            if($linha[3] eq "dev=local(1)")
            {
                #verifica na coluna 4 (Type) do ARK se encontra alvo
                if($linha[4] eq "InInterests")
                {
                    #print("Entrou\n");
                    #$packets = $packets + $linha[5];
                    $ininterest_packet_raw = $ininterest_packet_raw + $linha[7];
                }
                if($linha[4] eq "InSatisfiedInterests")
                {
                    #print("Entrou\n");
                    #$out_packets = $out_packets + $linha[5];
                    $insatisfiedinterest_packet_raw = $insatisfiedinterest_packet_raw + $linha[7];
                }
            }

        }
        close ARK;
        #$sum_packets = $sum_packets + $packets;
        $sum_packet_raw = $sum_packet_raw + $ininterest_packet_raw;
        
        #$sum_out_packets = $sum_out_packets + $out_packets;
        $sum_satisfied_packet_raw = $sum_satisfied_packet_raw + $insatisfiedinterest_packet_raw;
        
        $count = $count + 1;

        
    }
    
}

#medias
#$x =  $sum_packets/$count;
$media_enviados = $sum_packet_raw/$count;
#$a =  $sum_out_packets/$count;
$media_satisfeitos = $sum_satisfied_packet_raw/$count;

# razao entre interesses satisfeitos e interesses enviados
$taxa_entrega = $media_satisfeitos/$media_enviados;

# taxa_entrega: taxa de entrega calculada pela razão entre os interesses enviados e os interesses atendidos


print("Media_satisfeitos: $media_satisfeitos         Media_enviados: $media_enviados         Taxa_de_entrega: $taxa_entrega\n");


