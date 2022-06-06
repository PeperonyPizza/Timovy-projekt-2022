function [pokuta,posledna_zmena] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena)
%=========================================================================>
%           KONTROLA ZMENY ORIENTACIE - Diskrétny pohyb
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
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          POHYBUJUCE_PREKAZKY, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


% Nastala zmena v smere
if predosla_orientacia ~= orientacia               
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
        if predosla_orientacia == 0 && orientacia == 3
            posledna_zmena = -1; % zmena smeru vlavo
        else
            posledna_zmena = 1; % zmena smeru vpravo        
        end
    end
    % Osetrenie aby sa robot neotocil do proti smeru
    if posledna_zmena == predosla_zmena
        pokuta = 1000;           
    else
        pokuta = 0;        
    end
% Nenastala zmena v smere   
else
    pokuta = 0;
    posledna_zmena = predosla_zmena;      
end
end