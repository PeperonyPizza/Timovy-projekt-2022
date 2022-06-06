function [lidar_16] = kontrola_snimacov(pozicia,cesta,orientacia)
%=========================================================================>
%                KONTROLA SNIMACOV - Analógový pohyb
%=========================================================================>
% Lidar je realizovaný 16 lúčmi, rovnomerne pokrývajúcimi okolie robota (uhol lúča je 22.5 [°])
%
% Rozdiel medzi diskretnou a analógovou formou je ORIENTACIA (viď nižšie)
%
% KONTROLA_SNIMACOV  Aktualizovanie dat z lidaru.
%   LIDAR_16 = POHYBUJUCE_PREKAZKY(CESTA,OLD_POHYBUJUCE_PREKAZKY,POZICIA)
%      LIDAR_16                 aktualizovanie dat z lidaru
%      POZICIA                  aktualna poloha robota v tvare [x y]
%      ORIENTACIA               informácia o aktuálnom natočení vozidla
%                               diskrétna forma - robot sa natáča o 90.0 [°]
%                               analogova forma - robot sa natáča o 22.5 [°]
%      
% ORIENTACIA
%   Pre diskrétnu formu:
%       Hodnoty 0 až 3:
%           0   natočenie vozidla nahor
%           1   natočenie vozidla doprava
%           2   natočenie vozidla dole
%           3   natočenie vozidla doľava
%   Pre analógovú formu:
%       Hodnoty 0 až 15:
%           Pohyb po osi x/y:
%           0   natočenie vozidla doľava
%           4   natočenie vozidla nahor
%           8   natočenie vozidla doprava
%           12  natočenie vozidla dole
%
%           Pohyb po uhlopriečkach:
%           2   natočenie vozidla doľava-nahor
%           6   natočenie vozidla doprava-nahor
%           10  natočenie vozidla doprava-dole
%           14  natočenie vozidla doľava-dole
%
%           Zvyšné pohyby - medzi osou a uhlopriečkou:
%           1   os: doľava, uhlopriečka: doľava-nahor
%           3   os: nahor,  uhlopriečka: doľava-nahor
%           5   os: nahor,  uhlopriečka: doprava-nahor
%           7   os: doprava,uhlopriečka: doprava-nahor
%           9   os: doprava,uhlopriečka: doprava-dole
%           11  os: dole,   uhlopriečka: doprava-dole
%           13  os: dole,   uhlopriečka: doľava-dole
%           15  os: doľava, uhlopriečka: doľava-dole
%
% See also POHYBUJUCE_PREKAZKY, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          KONTROLA_ZMENY_ORIENTAACIE, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


    lavy_snimac = pozicia - 1;  % lavy horny snimac
    pravy_snimac = pozicia + 1; % pravy dolny snimac
            
    velkost_mapy = size(cesta);
            
    max_hodnota = 15;
            
    % Osetrenie aby sa snimace nenastavili mimo mapy
    if min(lavy_snimac) >= 1 && max(pravy_snimac) <= 150

    % vytvorenie matice 5x5 do ktorej sa ukladaju hodnoty z lidaru
    lidar_distance_16 = zeros(5,5);
                
    for j = 1:1:10
        if pozicia(1,2)-1-j <= 0
            lidar_distance_16(3,1) = 0;       
        elseif cesta(pozicia(1,1), pozicia(1,2)-1-j) == 1    %dopredu
            if lidar_distance_16(3,1) == 0
                lidar_distance_16(3,1) = j;
            end
        elseif j == 10 && lidar_distance_16(3,1) == 0
            lidar_distance_16(3,1) = max_hodnota;
        end
        %%%%

        if pozicia(1,2)+1+j >= velkost_mapy(2)
            lidar_distance_16(3,5) = 0;
        elseif cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1   %dozadu
            if lidar_distance_16(3,5) == 0
                lidar_distance_16(3,5) = j;    
            end
        elseif j == 10 && lidar_distance_16(3,5) == 0
            lidar_distance_16(3,5) = max_hodnota;    
        end

        %%%%
        if pozicia(1,1)-1-j <= 0
            lidar_distance_16(1,3) = 0;
        elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1    %hore
            if lidar_distance_16(1,3) == 0
                lidar_distance_16(1,3) = j;
            end
        elseif j == 10 && lidar_distance_16(1,3) == 0
            lidar_distance_16(1,3) = max_hodnota;
                   
        end
        %%%%

        if pozicia(1,1)+1+j >= velkost_mapy(1)
            lidar_distance_16(5,3) = 0;
        elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1    %dole
            if lidar_distance_16(5,3) == 0
                lidar_distance_16(5,3) = j;
            end
        elseif j == 10 && lidar_distance_16(5,3) == 0
            lidar_distance_16(5,3) = max_hodnota;
        end

        %%%%
        if pozicia(1,1)-1-j <= 0 || pozicia(1,2)-1-j <= 0
            lidar_distance_16(1,1) = 0;
        elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)-1-j) == 1    %lava-horna uhlopriecka
            if lidar_distance_16(1,1) == 0
                lidar_distance_16(1,1) = j;  
            end
        elseif j == 10 && lidar_distance_16(1,1) == 0
            lidar_distance_16(1,1) = max_hodnota;
        end

        %%%%
        if pozicia(1,1)+1+j >= min(velkost_mapy) || pozicia(1,2)-1-j <= 0
            lidar_distance_16(5,1) = 0;
        elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)-1-j) == 1   %lava-dolna uhlopriecka
            if lidar_distance_16(5,1) == 0
                lidar_distance_16(5,1) = j;
            end
        elseif j == 10 && lidar_distance_16(5,1) == 0
            lidar_distance_16(5,1) = max_hodnota;
        end

        %%%%
        if pozicia(1,1)-1-j <= 0 || pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance_16(1,5) = 0;
        elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)+1+j) == 1    %prava-horna uhlopriecka
            if lidar_distance_16(1,5) == 0
                lidar_distance_16(1,5) = j;  
            end
        elseif j == 10 && lidar_distance_16(1,5) == 0
            lidar_distance_16(1,5) = max_hodnota;
        end
        %%%%

        if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)+1+j >= velkost_mapy(2)
            lidar_distance_16(5,5) = 0;
        elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)+1+j) == 1    %prava-dolna uhlopriecka
            if lidar_distance_16(5,5) == 0
                lidar_distance_16(5,5) = j;     
            end
        elseif j == 10 && lidar_distance_16(5,5) == 0
            lidar_distance_16(5,5) = max_hodnota;       
        end  
    end

    %%Pridanie lucov
    subY21 = 0;
    addY41 = 0;
    subX12 = 0;
    addX14 = 0;
    subX52 = 0;
    addX54 = 0;
    subY25 = 0;
    addY45 = 0;

    for j = 1:1:10
        if((mod(j,2)==0))
            subY21 = subY21+1;
            addY41 = addY41+1;
            subX12 = subX12+1;
            addX14 = addX14+1;
            subX52 = subX52+1;
            addX54 = addX54+1;
            subY25 = subY25+1;
            addY45 = addY45+1;
        end

        if pozicia(1,2)-1-j <= 0 || (pozicia(1,1)-subY21 <= 0)
            lidar_distance_16(2,1) = 0; %[y-riadky x-stlpce]   
        elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)-1) == 1) 
            if lidar_distance_16(2,1) == 0
                lidar_distance_16(2,1) = j;
            end    
        elseif (j ~= 1) && cesta(pozicia(1,1)-subY21, pozicia(1,2)-j-1) == 1    %2;1
            if lidar_distance_16(2,1) == 0
                lidar_distance_16(2,1) = j;
            end  
        elseif j == 10 && lidar_distance_16(2,1) == 0
            lidar_distance_16(2,1) = max_hodnota;        
        end
                    
        if pozicia(1,2)-1-j <= 0 || pozicia(1,1)+addY41 >= velkost_mapy(2)
            lidar_distance_16(4,1) = 0; %[y-riadky x-stlpce]
        elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)-1-j) == 1) 
            if lidar_distance_16(4,1) == 0
                lidar_distance_16(4,1) = j;
            end
        elseif (j ~= 1) && cesta(pozicia(1,1)+addY41, pozicia(1,2)-1-j) == 1    %4;1
            if lidar_distance_16(4,1) == 0
                lidar_distance_16(4,1) = j;        
            end
        elseif j == 10 && lidar_distance_16(4,1) == 0
            lidar_distance_16(4,1) = max_hodnota;
        end

        if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)-subX52 <= 0
            lidar_distance_16(5,2) = 0;        %[y-riadky x-stlpce]
        elseif (j == 1) && (cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1) 
            if lidar_distance_16(5,2) == 0
                lidar_distance_16(5,2) = j;
            end
        elseif (j ~= 1) && cesta(pozicia(1,1)+1+j, pozicia(1,2)-subX52) == 1    %5;2
            if lidar_distance_16(5,2) == 0
                lidar_distance_16(5,2) = j;
            end
        elseif j == 10 && lidar_distance_16(5,2) == 0
            lidar_distance_16(5,2) = max_hodnota;      
        end

        if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)+addX54 >= velkost_mapy(2)
            lidar_distance_16(5,4) = 0;        %[y-riadky x-stlpce]       
        elseif (j == 1) && (cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1) 
            if lidar_distance_16(5,4) == 0
                lidar_distance_16(5,4) = j;    
            end
        elseif (j ~= 1) && cesta(pozicia(1,1)+1+j, pozicia(1,2)+addX54) == 1    %5;4
            if lidar_distance_16(5,4) == 0
                lidar_distance_16(5,4) = j;  
            end
        elseif j == 10 && lidar_distance_16(5,4) == 0
            lidar_distance_16(5,4) = max_hodnota;      
        end
                    
        if pozicia(1,2)+1+j >= velkost_mapy(2) || pozicia(1,1)+addY45 >= velkost_mapy(1)
            lidar_distance_16(4,5) = 0;        %[y-riadky x-stlpce]  
        elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1) 
            if lidar_distance_16(4,5) == 0
                lidar_distance_16(4,5) = j;
            end    
        elseif (j ~= 1) && cesta(pozicia(1,1)+addY45, pozicia(1,2)+1+j) == 1   %4;5
            if lidar_distance_16(4,5) == 0
                lidar_distance_16(4,5) = j;
            end
        elseif j == 10 && lidar_distance_16(4,5) == 0
            lidar_distance_16(4,5) = max_hodnota;
        end
                    
        if pozicia(1,2)+1+j >= velkost_mapy(2) || pozicia(1,1)-subY25 <= 0
            lidar_distance_16(2,5) = 0;        %[y-riadky x-stlpce]
        elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1) 
            if lidar_distance_16(2,5) == 0
                lidar_distance_16(2,5) = j;
            end    
        elseif j == 10 && lidar_distance_16(2,5) == 0
            lidar_distance_16(2,5) = max_hodnota;
        elseif (j ~= 1) && cesta(pozicia(1,1)-subY25, pozicia(1,2)+1+j) == 1   %2;5
            if lidar_distance_16(2,5) == 0
                lidar_distance_16(2,5) = j;  
            end        
        end
                    
        if pozicia(1,1)-1-j <= 0 || pozicia(1,2)+addX14 >= velkost_mapy(1)
            lidar_distance_16(1,4) = 0;    %[y-riadky x-stlpce]
        elseif (j == 1) && (cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1) 
        if lidar_distance_16(1,4) == 0
            lidar_distance_16(1,4) = j;
        end 
        elseif (j ~= 1) && cesta(pozicia(1,1)-1-j, pozicia(1,2)+addX14) == 1    %1;4
            if lidar_distance_16(1,4) == 0
                lidar_distance_16(1,4) = j;   
            end
        elseif j == 10 && lidar_distance_16(1,4) == 0
            lidar_distance_16(1,4) = max_hodnota;
        end
                    
        if pozicia(1,1)-1-j <= 0 || pozicia(1,2)-subX12 <= 0
            lidar_distance_16(1,2) = 0;    %[y-riadky x-stlpce]   
        elseif (j == 1) && (cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1) 
            if lidar_distance_16(1,2) == 0
                lidar_distance_16(1,2) = j;
            end    
        elseif (j ~= 1) && cesta(pozicia(1,1)-1-j, pozicia(1,2)-subX12) == 1    %1;2
            if lidar_distance_16(1,2) == 0
                lidar_distance_16(1,2) = j;
            end
        elseif j == 10 && lidar_distance_16(1,2) == 0
            lidar_distance_16(1,2) = max_hodnota;
        end
    end
    %%%%

    size_array = size(lidar_distance_16);
    array = lidar_distance_16;
    lidar_16 = [rot90(array(:,1)) array(size_array(1),2:end) rot90(rot90(array(1:end-1,size_array(1))')) rot90(rot90(array(1,2:end-1)))];
                
    lidar_16 = lidar_16';

    % Urcenie smeru dolava
    if orientacia == 0
        lidar_16 = circshift(lidar_16,-14);       
    elseif orientacia == 1
        lidar_16 = circshift(lidar_16,-13);      
    elseif orientacia == 2
        lidar_16 = circshift(lidar_16,-12);         
    elseif orientacia == 3
        lidar_16 = circshift(lidar_16,-11); 
                    
    % Urcenie smeru nahor   
    elseif orientacia == 4
        lidar_16 = circshift(lidar_16,-10);   
    elseif orientacia == 5
        lidar_16 = circshift(lidar_16,-9);   
    elseif orientacia == 6
        lidar_16 = circshift(lidar_16,-8);    
    elseif orientacia == 7
        lidar_16 = circshift(lidar_16,-7);
                    
    % Urcenie smeru doprava   
    elseif orientacia == 8
        lidar_16 = circshift(lidar_16,-6);  
    elseif orientacia == 9
        lidar_16 = circshift(lidar_16,-5);   
    elseif orientacia == 10
        lidar_16 = circshift(lidar_16,-4);
    elseif orientacia == 11
        lidar_16 = circshift(lidar_16,-3); 
                    
    % Urcenie smeru vzad
    elseif orientacia == 12
        lidar_16 = circshift(lidar_16,-2);
    elseif orientacia == 13
        lidar_16 = circshift(lidar_16,-1);
    elseif orientacia == 14
        lidar_16 = circshift(lidar_16,0);
    elseif orientacia == 15
        lidar_16 = circshift(lidar_16,1); 
    end
                
    % Snimace sa nastavili mimo mapy    
    else
        lidar_16 = ones(16,1);
    end  
end
