#!/usr/bin/perl

#$diretorio = "/Users/Elise/Desktop/graficos/resultados";

$diretorio = "/home/elise/ndnSIM/ns-3/resultados";


$n = $ARGV[0];

#########################
opendir(diretorio, $diretorio);
@lista = readdir(diretorio);
closedir(diretorio);


#$sum_packets = 0;
$sum_packet_raw = 0;
#$sum_out_packets = 0;
$sum_satisfied_packet_raw = 0;
$count = 0;
@scenarios = ();
$scenarios[0] = ["Politica","NaoProativo","ProAtivo"];
$k = 1;

foreach $dir_scenario(@lista)
{
    
    print("Pasta: $dir_scenario\n");

    if($dir_scenario ne "." and $dir_scenario ne ".." and $dir_scenario ne ".git")
    {
        @experimentos_dirs = ();
        $dir_exp_n = $diretorio."/".$dir_scenario."/experimento_".$n;
        $dir_exp_n_1 = $diretorio."/".$dir_scenario."/experimento_".($n+1);
        $experimentos_dirs[0] = $dir_exp_n;
        $experimentos_dirs[1] = $dir_exp_n_1;
        
        
        
        $i = 1;
        @experimentos = ();
        foreach $experimento_dir(@experimentos_dirs)
        {
            
            opendir(diretorio_experimento, $experimento_dir);
            @lista_experimento = readdir(diretorio_experimento);
            closedir(diretorio_experimento);
        
            $sum_packet_raw = 0;
            $sum_satisfied_packet_raw = 0;
            $count = 0;
            foreach $dir_exp(@lista_experimento)
            {
        
                if($dir_exp ne "." and $dir_exp ne "..")
                {
        
                    
                    $file_name = $experimento_dir."/".$dir_exp."/trace-rate.txt";
                    print("Arquivo: $file_name \n");
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
            $media_enviados = $sum_packet_raw/$count;
            $media_satisfeitos = $sum_satisfied_packet_raw/$count;
            $taxa_entrega = $media_satisfeitos/$media_enviados;
            $experimentos[$i] = $taxa_entrega;
            $i = $i + 1;
        
        }
        
        $experimentos[0] = $dir_scenario;
        $scenarios[$k] = [@experimentos];
        $k = $k + 1;
    }
    
    
}

$file_name = "/home/elise/ndnSIM/ns-3/txentrega.txt";
#$file_name = "/Users/Elise/Desktop/graficos/txentrega.txt";
open ARK, ">".$file_name;
select ARK;
$i = 0;
while($i < 3)
{
    $j = 0;
    while($j < $k)
    {
        @experimentos = @scenarios[$i];
        print("$scenarios[$j][$i]      ");
        $j = $j + 1;
    }
    print("\n");
    $i = $i + 1;
}

close ARK;
#medias
#$x =  $sum_packets/$count;

