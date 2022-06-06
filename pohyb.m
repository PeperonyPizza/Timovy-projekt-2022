function [riadok_draha,stlpec_draha, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = pohyb(orientacia,pozicia, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45)
%=========================================================================>
%                         POHYB - Analógová forma
%=========================================================================>
% Pohyb vozidla v danom smere
%
% Pre diskrétnu formu:
%   Vozidlo ma 4 možné smery pohybu.
% Pre analógovú formu:
%   Vozidlo ma 16 možných smerov pohybu.
%
%
% POHYB  Pohyb vozidla.
%   RIADOK_DRAHA, STLPEC_DRAHA = POHYB(ORIENTACIA, POZICIA)
%      RIADOK_DRAHA nová pozícia - súradnica y
%      STLPEC_DRAHA nová pozícia - súradnica x
%      ORIENTACIA   želaný smer pohybu vozidla
%      POZICIA      aktuálna poloha vozidla
%
%   Premenne subY21,addY41,subX12,addX14,subX52,addX54,subY25,addY45:
%      Pomocne premenne pre odčítanie/pričítanie k súradnici x/y polohy robota,
%      pri pohybe v smere orientacii: 1, 3, 5, 7, 9, 11, 13, 15                           
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          POHYBUJUCE_PREKAZKY, KONTROLA_ZMENY_ORIENTAACIE, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


    % Pohyb robota smerom  (3,1)
    if orientacia == 0
        riadok_draha = pozicia(1,1);
        stlpec_draha = pozicia(1,2)-1;        
    % Pohyb robota smerom (2,1)    
    elseif orientacia == 1
        riadok_draha = pozicia(1,1)-subY21;
        stlpec_draha = pozicia(1,2)-1;
    % Pohyb robota smerom (1,1)
    elseif orientacia == 2
        riadok_draha = pozicia(1,1)-1;
        stlpec_draha = pozicia(1,2)-1;
    % Pohyb robota smerom (1,2)    
    elseif orientacia == 3
        riadok_draha = pozicia(1,1)-1;
        stlpec_draha = pozicia(1,2)-subX12;
    % Pohyb robota smerom (1,3)    
    elseif orientacia == 4
        riadok_draha = pozicia(1,1)-1;
        stlpec_draha = pozicia(1,2);
    % Pohyb robota smerom (1,4)    
    elseif orientacia == 5
        riadok_draha = pozicia(1,1)-1;
        stlpec_draha = pozicia(1,2)+addX14;
    % Pohyb robota smerom (1,5)    
    elseif orientacia == 6
        riadok_draha = pozicia(1,1)-1;
        stlpec_draha = pozicia(1,2)+1;
    % Pohyb robota smerom (2,5)    
    elseif orientacia == 7
        riadok_draha = pozicia(1,1)-subY25;
        stlpec_draha = pozicia(1,2)+1;
    % Pohyb robota smerom (3,5)    
    elseif orientacia == 8
        riadok_draha = pozicia(1,1);
        stlpec_draha = pozicia(1,2)+1;
    % Pohyb robota smerom (4,5)    
    elseif orientacia == 9
        riadok_draha = pozicia(1,1)+addY45;
        stlpec_draha = pozicia(1,2)+1;
    % Pohyb robota smerom (5,5)    
    elseif orientacia == 10        
        riadok_draha = pozicia(1,1)+1;
        stlpec_draha = pozicia(1,2)+1;
    % Pohyb robota smerom (5,4)    
    elseif orientacia == 11
        riadok_draha = pozicia(1,1)+1;
        stlpec_draha = pozicia(1,2)+addX54;
    % Pohyb robota smerom (5,3)     
    elseif orientacia == 12        
        riadok_draha = pozicia(1,1)+1;
        stlpec_draha = pozicia(1,2);
    % Pohyb robota smerom (5,2)          
    elseif orientacia == 13
        riadok_draha = pozicia(1,1)+1;
        stlpec_draha = pozicia(1,2)-subX52;
    % Pohyb robota smerom (5,1)    
    elseif orientacia == 14
        riadok_draha = pozicia(1,1)+1;
        stlpec_draha = pozicia(1,2)-1;
    % Pohyb robota smerom (4,1)    
    else
        riadok_draha = pozicia(1,1)+addY41;
        stlpec_draha = pozicia(1,2)-1;              
    end
    % Osetrenie aby sa robot nepohyboval mimo mapy
    if riadok_draha < 1 || stlpec_draha < 1 || riadok_draha > 150 || stlpec_draha > 150
        riadok_draha = pozicia(1,1);
        stlpec_draha = pozicia(1,2);
    end    
end