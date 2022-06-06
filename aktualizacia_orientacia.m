function [orientacia_new] = aktualizacia_orientacia(natocenie,orientacia)
%=========================================================================>
%               AKTUALIZACIA ORIENTACIA - Diskrétna forma
%=========================================================================>
% Aktualizovanie orientacie - natočenia vozidla na základe výstupu z NS.
% Výstup funkcie určí smer pohybu v ďalšom kroku.
%
% Pre diskrétnu formu:
%   Vozidlo ma 4 možné smery orientácie.
%   ORIENTACIA_NEW môže nadobudnúť hodnoty 0-3 na základe natočenia.
% Pre analógovú formu:
%   Vozidlo ma 16 možných smerov orientácie.
%   ORIENTACIA_NEW môže nadobudnúť hodnoty 0-15 na základe natočenia.
%       
%
% AKTUALIZACIA_ORIENTACIA  Aktualizovanie orientacie - natočenia vozidla
%   ORIENTACIA_NEW = AKTUALIZACIA_ORIENTACIA(NATOCENIE, ORIENTACIA)
%      ORIENTACIA_NEW   rozsah možných hodnôt podľa formy pohybu
%      NATOCENIE        výstup z NS
%      ORIENTACIA       aktuálne natočenie vozidla
%                           
%
% See also POHYBUJUCE_PREKAZKY, KONTROLA_SNIMACOV, NEURONOVA_SIET, 
%          KONTROLA_ZMENY_ORIENTAACIE, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


    % Smer sa nemeni
    if natocenie >= -0.33 && natocenie <= 0.33
        orientacia_new = orientacia;    
    % Smer sa meni doprava       
    elseif natocenie < -0.33
        orientacia_new = orientacia+1;   
        % Osetrenie aby orientacia nebola > 3 (0,1,2,3)
        if orientacia_new > 3
            orientacia_new = 0;    
        end  
    % Smer sa meni dolava  
    else
        orientacia_new = orientacia-1;
        % Osetrenie aby orientacia nebola < 0 (0,1,2,3)
        if orientacia_new < 0
            orientacia_new = 3;   
        end
    end   
end