function [new_pohybujuce_prekazky] = pohybujuce_prekazky (cesta,old_pohybujuce_prekazky,pozicia)
%=========================================================================>
%               POHYBUJUCE PREKAZKY - Diskrétna forma
%=========================================================================>
% Táto funkcia je rovnaká pre diskrétnu aj analógovú formu pohybu robota.
%
% POHYBUJUCE_PREKAZKY  Vykonanie pohybu pre vsetky prekazky.
%   NEW_POHYBUJUCE_PREKAZKY = POHYBUJUCE_PREKAZKY(CESTA,OLD_POHYBUJUCE_PREKAZKY,POZICIA)
%      NEW_POHYBUJUCE_PREKAZKY  nove suradnice prekazok v tvare [x1 y1, x2 y2, ...]
%      CESTA                    mapa prostredia (zahrna aj informaciu o sucasnej polohe prekazok)
%      OLD_POHYBUJUCE_PREKAZKY  aktualne suradnice prekazok v tvare [x1 y1, x2 y2, ...]
%      POZICIA                  aktualna poloha robota v tvare [x y]
%                           
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          KONTROLA_ZMENY_ORIENTAACIE, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.

        new_pohybujuce_prekazky = old_pohybujuce_prekazky;
        for i = 1:2:length(old_pohybujuce_prekazky)
        pohyb_prekazky = randi(10); %smer
            switch pohyb_prekazky
                case 1 
                    new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)+1;%up
                case 2 
                    new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)-1;%down
                case 3 
                    new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)+1;%right
                case 4 
                    new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)-1;%left
                case {5,6,7,8,9,10}     
            end
            
            % aby prekazka nesla mimo cesty alebo narazila do auta
            while (cesta(new_pohybujuce_prekazky(i),new_pohybujuce_prekazky(i+1)) == 1) || (new_pohybujuce_prekazky(i)==pozicia(1) && new_pohybujuce_prekazky(i+1)==pozicia(2))
                pohyb_prekazky = randi(4);
                new_pohybujuce_prekazky = old_pohybujuce_prekazky;
                switch pohyb_prekazky
                    case 1 
                        new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)+1;
                    case 2 
                        new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)-1;
                    case 3 
                        new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)+1;
                    case 4 
                        new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)-1;
                end
            end 
        end
end


% function [new_pohybujuce_prekazky] = pohybujuce_prekazky (cesta,old_pohybujuce_prekazky,pozicia)
% 
%         new_pohybujuce_prekazky = old_pohybujuce_prekazky;
%         for i = 1:2:length(old_pohybujuce_prekazky)
%         pohyb_prekazky = randi(10); %smer
%             switch pohyb_prekazky
%                 case 1 
%                     new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)+1;%up
%                 case 2 
%                     new_pohybujuce_prekazky(i) = new_pohybujuce_prekazky(i)-1;%down
%                 case 3 
%                     new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)+1;%right
%                 case 4 
%                     new_pohybujuce_prekazky(i+1) = new_pohybujuce_prekazky(i+1)-1;%left
%                 case {5,6,7,8,9,10}
%                     
%             end
% 
%             if((cesta(new_pohybujuce_prekazky(i),new_pohybujuce_prekazky(i+1)) == 1) || (new_pohybujuce_prekazky(i)==pozicia(1) && new_pohybujuce_prekazky(i+1)==pozicia(2)))
%                 new_pohybujuce_prekazky = old_pohybujuce_prekazky;
%             end
% 
%         end
% end