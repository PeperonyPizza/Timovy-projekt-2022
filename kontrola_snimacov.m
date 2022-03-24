function [snimace, lidar] = kontrola_snimacov(pozicia,cesta,orientacia)

            
            %=============================================================>
            %                      KONTROLA SNIMACOV
            %=============================================================>
            
            lavy_snimac = pozicia - 1;  % lavy horny snimac
            pravy_snimac = pozicia + 1; % pravy dolny snimac
            
            velkost_mapy = size(cesta);
            
            max_hodnota = 11;
            
            % Osetrenie aby sa snimace nenastavili mimo mapy
            if min(lavy_snimac) >= 1 && max(pravy_snimac) <= 150
                
                % vytvorenie matice 3x3
                matica = cesta(lavy_snimac(1,1):pravy_snimac(1,1),lavy_snimac(1,2):pravy_snimac(1,2));

                % vytvorenie matice 3x3 do ktorej sa ukladaju hodnoty z
                % lidaru
                lidar_distance = zeros(3,3);
                
                for j = 1:1:10
                    if pozicia(1,2)-1-j <= 0
                        lidar_distance(2,1) = 0;
                    elseif cesta(pozicia(1,1), pozicia(1,2)-1-j) == 1    %dopredu
                        if lidar_distance(2,1) == 0
                            lidar_distance(2,1) = j;
                        end
                    elseif j == 10 && lidar_distance(2,1) == 0
                            lidar_distance(2,1) = max_hodnota;
                    else
                        lidar_distance(2,1) = 0;
                    end
                    %%%%
                    if pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance(2,3) = 0;
                    elseif cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1   %dozadu
                        if lidar_distance(2,3) == 0
                            lidar_distance(2,3) = j;
                        end
                    elseif j == 10 && lidar_distance(2,3) == 0
                            lidar_distance(2,3) = max_hodnota;
                    else
                        lidar_distance(2,3) = 0;
                    end
                    %%%%
                    if pozicia(1,1)-1-j <= 0
                        lidar_distance(1,2) = 0;
                    elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1    %hore
                        if lidar_distance(1,2) == 0
                            lidar_distance(1,2) = j;
                        end
                    elseif j == 10 && lidar_distance(1,2) == 0
                            lidar_distance(1,2) = max_hodnota;
                    else
                        lidar_distance(1,2) = 0;
                    end
                    %%%%
                    if pozicia(1,1)+1+j >= velkost_mapy(1)
                        lidar_distance(3,2) = 0;
                    elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1    %dole
                        if lidar_distance(3,2) == 0
                            lidar_distance(3,2) = j;
                        end
                    elseif j == 10 && lidar_distance(3,2) == 0
                            lidar_distance(3,2) = max_hodnota;
                    else
                        lidar_distance(3,2) = 0;
                    end
                    %%%%
                    if pozicia(1,1)-1-j <= 0 || pozicia(1,2)-1-j <= 0
                         lidar_distance(1,1) = 0;
                    elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)-1-j) == 1    %lava-horna uhlopriecka
                        if lidar_distance(1,1) == 0
                            lidar_distance(1,1) = j;
                        end
                    elseif j == 10 && lidar_distance(1,1) == 0
                            lidar_distance(1,1) = max_hodnota;
                    else
                        lidar_distance(1,1) = 0;
                    end
                    %%%%
                    if pozicia(1,1)+1+j >= min(velkost_mapy) || pozicia(1,2)-1-j <= 0
                        lidar_distance(3,1) = 0;
                    elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)-1-j) == 1   %lava-dolna uhlopriecka
                        if lidar_distance(3,1) == 0
                            lidar_distance(3,1) = j;
                        end
                    elseif j == 10 && lidar_distance(3,1) == 0
                            lidar_distance(3,1) = max_hodnota;
                    else 
                        lidar_distance(3,1) = 0;
                    end
                    %%%%
                    if pozicia(1,1)-1-j <= 0 || pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance(1,3) = 0;
                    elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)+1+j) == 1    %prava-horna uhlopriecka
                        if lidar_distance(1,3) == 0
                            lidar_distance(1,3) = j;
                        end
                    elseif j == 10 && lidar_distance(1,3) == 0
                            lidar_distance(1,3) = max_hodnota;
                    else
                        lidar_distance(1,3) = 0;
                    end
                    %%%%
                    if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance(3,3) = 0;
                    elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)+1+j) == 1    %prava-dolna uhlopriecka
                        if lidar_distance(3,3) == 0
                            lidar_distance(3,3) = j;
                        end
                    elseif j == 10 && lidar_distance(3,3) == 0
                            lidar_distance(3,3) = max_hodnota;
                    else
                        lidar_distance(3,3) = 0;
                    end  
                end

                % Urcenie smeru doprava
                if orientacia == 1
                    
                    matica = rot90(matica);
                    lidar_distance = rot90(lidar_distance);
                
                % Urcenie smeru dole
                elseif orientacia == 2
                    
                    matica = rot90(rot90(matica));
                    lidar_distance = rot90(rot90(lidar_distance));
                
                % Urcenie smeru dolava
                elseif orientacia == 3
                    
                    matica = rot90(rot90(rot90(matica)));
                    lidar_distance = rot90(rot90(rot90(lidar_distance)));
                    
                end
                
            % Snimace sa nastavili mimo mapy    
            else
                
                matica = ones(3,3);
                lidar_distance = ones(3,3);
                
            end
            
            snimace = matica(:);
            snimace(5) = [];
            
            
            lidar = lidar_distance(:);
            lidar(5) = [0];
end

