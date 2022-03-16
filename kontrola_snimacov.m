function [snimace] = kontrola_snimacov(pozicia,cesta,orientacia)

            
            %=============================================================>
            %                      KONTROLA SNIMACOV
            %=============================================================>
            
            lavy_snimac = pozicia - 1;  % lavy horny snimac
            pravy_snimac = pozicia + 1; % pravy dolny snimac

            % Osetrenie aby sa snimace nenastavili mimo mapy
            if min(lavy_snimac) >= 1 && max(pravy_snimac) <= 150
                
                % vytvorenie matice 3x3
                matica = cesta(lavy_snimac(1,1):pravy_snimac(1,1),lavy_snimac(1,2):pravy_snimac(1,2));
                
                % Urcenie smeru doprava
                if orientacia == 1
                    
                    matica = rot90(matica);
                
                % Urcenie smeru dole
                elseif orientacia == 2
                    
                    matica = rot90(rot90(matica));
                
                % Urcenie smeru dolava
                elseif orientacia == 3
                    
                    matica = rot90(rot90(rot90(matica)));
                    
                end
                
            % Snimace sa nastavili mimo mapy    
            else
                
                matica = ones(3,3);
                
            end
            
            snimace = matica(:);
            snimace(5) = [];
end

