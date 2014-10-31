#!/usr/bin/perl

#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_3";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_3";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_3";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_3";

$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob/experimento_4";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-no-cache-no-mob-pollution/experimento_4";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob/experimento_4";
#$diretorio = "/home/elise/ndnSIM/ns-3/resultados/ndn-with-cache-no-mob-pollution/experimento_4";

#########################
opendir(diretorio, $diretorio);
@lista = readdir(diretorio);
closedir(diretorio);


$sum_out_packets = 0;
$sum_receive_data = 0;
$count = 0;


foreach $dir_exp(@lista)
{
    if($dir_exp ne "." and $dir_exp ne "..")
    {
        $file_name = $diretorio."/".$dir_exp."/saida.txt";
        $packets = 0;
        $packet_raw = 0;
        $out_packets = 0;
        $out_packet_raw = 0;
        open ARK, $file_name;
        %out_packets = ();
        %receive_data = ();
        foreach(<ARK>)
        {
            @linha = split(/\s+/);
            if($linha[1] == 2 || $linha[1] == 3 || $linha[1] == 6 || $linha[1] == 9 || $linha[1] == 12)
            {
                $id = $linha[1];
                if($linha[3] eq "Interest:")
                {
                    @expr = split("/", $linha[4]);
                    if($expr[2] == $id )
                    {
                        $out_packets{$linha[4]} = 1;
                    }
                }
                else
                {
                    @expr = split("/", $linha[4]);
                    if($expr[2] == $id )
                    {
                        $receive_data{$linha[4]} = 1;
                    }
                }
            }
            
        }
        close ARK;
        $sum_out_packets = $sum_out_packets + keys %out_packets;
        $sum_receive_data = $sum_receive_data + keys %receive_data;
        $count = $count + 1;
        
    }

}

$y = $sum_receive_data/$count;
$b = $sum_out_packets/$count;
$valor_1 = $y/$b;
print("Y/B: $valor_1 \n");

print("\ncount: $count\n");
print("Número de out: ".( $sum_out_packets)." \n");
print("Número de receive: ". ($sum_receive_data)." \n");