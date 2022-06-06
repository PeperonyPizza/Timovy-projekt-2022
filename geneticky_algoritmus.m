function [Pop] = geneticky_algoritmus(Pop,Fit,Space,Delta)
%=========================================================================>
%               GENETICKY ALGORITMUS - Analógový pohyb
%=========================================================================>
% Genetický algoritmus - korekcia výstupov a dosiahnutie optimalneho
%                        správania
%
% Táto funkcia je rovnaká pre diskrétnu aj analógovú formu pohybu robota.
%
%
% GENETICKY_ALGORITMUS optimalizácia výsledkov
%   POP_NEW = GENETICKY_ALGORITMUS(POP, FIT, SPACE, DELTA)
%      POP_NEW  nová populácia - 1. jedinec je najlepšie dosiahnuté
%                                riešenie v generácii
%      POP      aktuálna populácia (aktuálne riešenia úlohy)
%      SPACE    prehladávací priestor
%      DELTA    krok aditívnej mutácie
%                           
%
%   See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, POHYBUJUCE_PREKAZKY,
%            KONTROLA_ZMENY_ORIENTAACIE, POHYB,
%            VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


    Best = selbest(Pop,Fit,1);
    Old = selrand(Pop,Fit,6);
    Work1 = selsus(Pop,Fit,7);
    Work2 = seltourn(Pop,Fit,8);
    Work1 = crossov(Work1,1,0);
    Work2 = mutx(Work2,0.12,Space);
    Work1 = muta(Work1,0.15,Delta,Space);
    Work3 = genrpop(3,Space);

    Pop = [Best;Old;Work1;Work2;Work3];
    
end

