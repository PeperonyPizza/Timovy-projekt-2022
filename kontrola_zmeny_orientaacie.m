function [pokuta,posledna_zmena, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena,kroky, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45)
             %=============================================================>
            %                  KONTROLA ZMENY ORIENTACIE
            %=============================================================>
            
            % Nastala zmena v smere
            if predosla_orientacia ~= orientacia
                subY21 = 0;
                addY41 = 0;
                subX12 = 0;
                addX14 = 0;
                subX52 = 0;
                addX54 = 0;
                subY25 = 0;
                addY45 = 0;
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
                    
                    if predosla_orientacia == 0 && orientacia == 15
                        
                        posledna_zmena = -1; % zmena smeru vlavo
                        
                    else
                        
                        posledna_zmena = 1; % zmena smeru vpravo
                        
                    end
                end

                % Osetrenie aby sa robot neotocil do proti smeru
                if posledna_zmena == predosla_zmena
                    
                    pokuta = 1000000000;
                    
                else
                    
                    pokuta = -1000;
                    
                end
            
            % Nenastala zmena v smere   
            else
                if((mod(kroky,2)==0))
                        subY21 = subY21+1;
                        addY41 = addY41+1;
                        subX12 = subX12+1;
                        addX14 = addX14+1;
                        subX52 = subX52+1;
                        addX54 = addX54+1;
                        subY25 = subY25+1;
                        addY45 = addY45+1;
                end
                pokuta = 0;
                posledna_zmena = predosla_zmena;
                
            end
            
          
end

