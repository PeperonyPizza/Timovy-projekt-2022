function [riadok_draha,stlpec_draha] = pohyb(orientacia,pozicia)
            %=============================================================>
            %                         POHYB ROBOTA
            %=============================================================>
            
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

