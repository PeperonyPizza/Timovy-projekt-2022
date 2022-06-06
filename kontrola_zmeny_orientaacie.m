function [pokuta,posledna_zmena, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena,kroky, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45)
%=========================================================================>
%           KONTROLA ZMENY ORIENTACIE - Analógový pohyb
%=========================================================================>
% Hlavnou úlohou funkcie je kontrola aby vozidlo išlo v požadovanom smere.
% Ak vozidlo zmeni smer na nežiadúci tak nastane pokutovanie.
%
% KONTROLA_ZMENY_ORIENTAACIE  Kontrola aby vozidlo išlo v požadovanom smere
%   POKUTA, POSLEDNA_ZMENA = KONTROLA_ZMENY_ORIENTAACIE(PREDOSLA_ORIENTACIA, ORIENTACIA, PREDOSLA_ZMENA)
%      POKUTA               V prípade nežiadúceho otočenia nastane pokutovanie, inak 0
%      POSLEDNA_ZMENA       Hodnota závislá od zmeny natočenia
%      PREDOSLA_ORIENTACIA  aktuálne natočenie robota
%      ORIENTACIA           želané natočenie robota - výstup z funkcie AKTUALIZACIA_ORIENTACIA                       
%      PREDOSLA_ZMENA       informacia o zmene natočenia v predchádzajúcom kroku
%
%   Premenne subY21,addY41,subX12,addX14,subX52,addX54,subY25,addY45:
%      Pomocne premenne pre odčítanie/pričítanie k súradnici x/y polohy robota,
%      pri pohybe v smere orientacii: 1, 3, 5, 7, 9, 11, 13, 15
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          POHYBUJUCE_PREKAZKY, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


% Nastala zmena v smere - vynulovanie hodnôt
if predosla_orientacia ~= orientacia
    subY21 = 0;
    addY41 = 0;
    subX12 = 0;
    addX14 = 0;
    subX52 = 0;
    addX54 = 0;
    subY25 = 0;
    addY45 = 0;
    % 3 2 || 2 3 || 2 1 || 1 2
    if abs(predosla_orientacia - orientacia) == 1
        % 3 2 || 2 1
        if (predosla_orientacia - orientacia) > 0     
            posledna_zmena = -1;  % zmena smeru vlavo         
        else
            posledna_zmena = 1; % zmena smeru vpravo                        
        end   
    % Ak neplatia vyssie uvedene kombinacie
    else
        if predosla_orientacia == 0 && orientacia == 15
            posledna_zmena = -1; % zmena smeru vlavo                
        else
            posledna_zmena = 1; % zmena smeru vpravo
        end
    end
    % Osetrenie aby sa robot neotocil do proti smeru
    if posledna_zmena == predosla_zmena           
        pokuta = 1000000000;        
    else         
        pokuta = -1000;   
    end  
% Nenastala zmena v smere   
else
    if((mod(kroky,2)==0)) %každý druhý krok sa vykoná pohyb
        subY21 = subY21+1;
        addY41 = addY41+1;
        subX12 = subX12+1;
        addX14 = addX14+1;
        subX52 = subX52+1;
        addX54 = addX54+1;
        subY25 = subY25+1;
        addY45 = addY45+1;
    end
    pokuta = 0;
    posledna_zmena = predosla_zmena;            
end    
end