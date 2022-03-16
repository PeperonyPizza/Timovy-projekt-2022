function [pp2] = aktualizacia_orientacia(natocenie,orientacia)
            %=============================================================>
            %                   AKTUALIZACIA ORIENTACIE
            %=============================================================>
            
            % Smer sa nemeni
            if natocenie >= -0.33 && natocenie <= 0.33
                
                pp2 = orientacia; 
              
            % Smer sa meni doprava   
            elseif natocenie < -0.33
                
                pp2 = orientacia+1;
                
                % Osetrenie aby orientacia nebola >= 3 (0,1,2,3)
                if pp2 > 3
                    
                    pp2 = 0;
                    
                end
                
            % Smer sa meni dolava
            else
                
                pp2 = orientacia-1;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 < 0
                    
                    pp2 = 3;
                    
                end

            end
            
           
end

