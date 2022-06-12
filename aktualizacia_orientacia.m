function [pp2] = aktualizacia_orientacia(natocenie,orientacia)
%=========================================================================>
%               AKTUALIZACIA ORIENTACIA - Analógová forma
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


    % Smer sa nemeni - (3,5)
    if natocenie >= -pi/16 && natocenie <= pi/16 %d
        pp2 = orientacia;  
        % Smer sa meni doprava
    elseif natocenie <= -pi+pi/16 %
        pp2 = orientacia+4;
        % Osetrenie aby orientacia nebola > 15 (0-15)
        if pp2 > 15
            pp2 = 0;
        end
    % Smer sa meni dolava
    elseif natocenie >= pi-pi/16 %
        pp2 = orientacia-4;
        % Osetrenie aby orientacia nebola < 0 (0-15)
        if pp2 < 0
            pp2 = 16+orientacia; 
        end
    % Smer sa meni - (1,4)
    elseif natocenie < pi-pi/8+pi/16 && natocenie >= pi-pi/8-pi/16  %
        pp2 = orientacia-3;
        % Osetrenie aby orientacia nebola < 0 (0-15)
        if pp2 < 0
            pp2 = 16+orientacia;
        end
    % Smer sa meni - (1,5)
    elseif natocenie < pi-2*pi/8+pi/16 && natocenie >= pi-2*pi/8-pi/16  %
        pp2 = orientacia-2;
        % Osetrenie aby orientacia nebola < 0 (0-15)
        if pp2 < 0
            pp2 = 16+orientacia;
        end
    % Smer sa meni - (2,5)
    elseif natocenie < pi-3*pi/8+pi/16 && natocenie >= pi-3*pi/8-pi/16  %
        pp2 = orientacia-1;
        % Osetrenie aby orientacia nebola < 0 (0-15)
        if pp2 < 0
            pp2 = 16+orientacia;
        end
    % Smer sa meni - (5,4)
    elseif natocenie > -pi+pi/8-pi/16 && natocenie <= -pi+pi/8+pi/16  %
        pp2 = orientacia+3;
        % Osetrenie aby orientacia nebola > 15 (0-15)
        if pp2 > 15
            pp2 = 0;    
        end
    % Smer sa meni - (5,5)
    elseif natocenie > -pi+2*pi/8-pi/16 && natocenie <= -pi+2*pi/8+pi/16  %
        pp2 = orientacia+2;
        % Osetrenie aby orientacia nebola > 15 (0-15)
        if pp2 > 15
            pp2 = 0;
        end
    % Smer sa meni - (4,5)
    else %natocenie > -pi+3*pi/8-pi/16 && natocenie <= -pi+3*pi/8+pi/16  %
        pp2 = orientacia+1;
        % Osetrenie aby orientacia nebola > 15 (0-15)
        if pp2 > 15
            pp2 = 0;
        end
    end
end