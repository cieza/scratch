#!/usr/bin/perl

#$diretorio = "/Users/Elise/Desktop/resultados75/ndn-no-cache-no-mob/experimento_1";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_1";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_1";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_1";

#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_2";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_2";
$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_2";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_2";


# $arquivo_final= "/Users/Elise/Desktop/arquivo-final.dat";



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
            #print("linha: $linha[4] \n");
            #verifica na coluna 4 (Type) do ARK se encontra alvo
            if($linha[4] eq "InSatisfiedInterests")
            {
                #print("Entrou\n");
                $packets = $packets + $linha[5];
                $packet_raw = $packet_raw + $linha[7];
            }
            if($linha[4] eq "OutInterests")
            {
                #print("Entrou\n");
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

$valor_teste = $y/9000;


# Y/B: 


print("X/A: $valor_1     Y/A: $valor_2      X/B: $valor_3      Y/B: $valor_4      TESTE: $valor_teste     atendidos: $sum_packet_raw     media: $y\n");


