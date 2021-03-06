function [pokuta,posledna_zmena] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena)
             %=============================================================>
            %                  KONTROLA ZMENY ORIENTACIE
            %=============================================================>
            
            % Nastala zmena v smere
            if predosla_orientacia ~= orientacia
                
                % 3 2 || 2 3 || 2 1 || 1 2
                if abs(predosla_orientacia - orientacia) == 1
                    
                    % 3 2 || 2 1
                    if (predosla_orientacia - orientacia) > 0
                        
                        posledna_zmena = -1;  % zmena smeru vlavo
                        
                    else
                        
                        posledna_zmena = 1; % zmena smeru vpravo
                        
                    end
                
                % Ak neplatia vyssie uvedene kombinacie
                else
                    
                    if predosla_orientacia == 0 && orientacia == 3
                        
                        posledna_zmena = -1; % zmena smeru vlavo
                        
                    else
                        
                        posledna_zmena = 1; % zmena smeru vpravo
                        
                    end
                end

                % Osetrenie aby sa robot neotocil do proti smeru
                if posledna_zmena == predosla_zmena
                    
                    pokuta = 1000;
                    
                else
                    
                    pokuta = 0;
                    
                end
            
            % Nenastala zmena v smere   
            else
                
                pokuta = 0;
                posledna_zmena = predosla_zmena;
                
            end
            
          
end

