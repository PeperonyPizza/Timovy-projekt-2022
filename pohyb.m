function [riadok_draha,stlpec_draha] = pohyb(orientacia,pozicia)
%=========================================================================>
%                         POHYB - Diskrétna forma
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
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          POHYBUJUCE_PREKAZKY, KONTROLA_ZMENY_ORIENTAACIE, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


    % Pohyb robota smerom hore
    if orientacia == 0 
        riadok_draha = pozicia(1,1)-1;
        stlpec_draha = pozicia(1,2);
            
    % Pohyb robota smerom doprava
    elseif orientacia == 1
        riadok_draha = pozicia(1,1);
        stlpec_draha = pozicia(1,2)+1;

    % Pohyb robota smerom dole
    elseif orientacia == 2
        riadok_draha = pozicia(1,1)+1;
        stlpec_draha = pozicia(1,2);

    % Pohyb robota smerom dolava    
    else
        riadok_draha = pozicia(1,1);
        stlpec_draha = pozicia(1,2)-1;    
    end
            
    % Osetrenie aby sa robot nepohyboval mimo mapy
    if riadok_draha < 1 || stlpec_draha < 1 || riadok_draha > 150 || stlpec_draha > 150
        riadok_draha = pozicia(1,1);
        stlpec_draha = pozicia(1,2);
    end                
end