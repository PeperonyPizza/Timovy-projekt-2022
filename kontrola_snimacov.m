function [lidar_16] = kontrola_snimacov(pozicia,cesta,orientacia)

            
            %=============================================================>
            %                      KONTROLA SNIMACOV
            %=============================================================>
            
            lavy_snimac = pozicia - 1;  % lavy horny snimac
            pravy_snimac = pozicia + 1; % pravy dolny snimac
            
            velkost_mapy = size(cesta);
            
            max_hodnota = 15;
            
            % Osetrenie aby sa snimace nenastavili mimo mapy
            if min(lavy_snimac) >= 1 && max(pravy_snimac) <= 150

                % vytvorenie matice 5x5 do ktorej sa ukladaju hodnoty z
                % lidaru
                
                lidar_distance_16 = zeros(5,5);
                
                for j = 1:1:10
                    if pozicia(1,2)-1-j <= 0
                        lidar_distance_16(3,1) = 0;
                    elseif cesta(pozicia(1,1), pozicia(1,2)-1-j) == 1    %dopredu
                        if lidar_distance_16(3,1) == 0
                            lidar_distance_16(3,1) = j;
                        end
                    elseif j == 10 && lidar_distance_16(3,1) == 0
                            lidar_distance_16(3,1) = max_hodnota;
                    else
                        lidar_distance_16(3,1) = 0;
                    end
                    %%%%
                    if pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance_16(3,5) = 0;
                    elseif cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1   %dozadu
                        if lidar_distance_16(3,5) == 0
                            lidar_distance_16(3,5) = j;
                        end
                    elseif j == 10 && lidar_distance_16(3,5) == 0
                            lidar_distance_16(3,5) = max_hodnota;
                    else
                        lidar_distance_16(3,5) = 0;
                    end
                    %%%%
                    if pozicia(1,1)-1-j <= 0
                        lidar_distance_16(1,3) = 0;
                    elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1    %hore
                        if lidar_distance_16(1,3) == 0
                            lidar_distance_16(1,3) = j;
                        end
                    elseif j == 10 && lidar_distance_16(1,3) == 0
                            lidar_distance_16(1,3) = max_hodnota;
                    else
                        lidar_distance_16(1,3) = 0;
                    end
                    %%%%
                    if pozicia(1,1)+1+j >= velkost_mapy(1)
                        lidar_distance_16(5,3) = 0;
                    elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1    %dole
                        if lidar_distance_16(5,3) == 0
                            lidar_distance_16(5,3) = j;
                        end
                    elseif j == 10 && lidar_distance_16(5,3) == 0
                            lidar_distance_16(5,3) = max_hodnota;
                    else
                        lidar_distance_16(5,3) = 0;
                    end
                    %%%%
                    if pozicia(1,1)-1-j <= 0 || pozicia(1,2)-1-j <= 0
                         lidar_distance_16(1,1) = 0;
                    elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)-1-j) == 1    %lava-horna uhlopriecka
                        if lidar_distance_16(1,1) == 0
                            lidar_distance_16(1,1) = j;
                        end
                    elseif j == 10 && lidar_distance_16(1,1) == 0
                            lidar_distance_16(1,1) = max_hodnota;
                    else
                        lidar_distance_16(1,1) = 0;
                    end
                    %%%%
                    if pozicia(1,1)+1+j >= min(velkost_mapy) || pozicia(1,2)-1-j <= 0
                        lidar_distance_16(5,1) = 0;
                    elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)-1-j) == 1   %lava-dolna uhlopriecka
                        if lidar_distance_16(5,1) == 0
                            lidar_distance_16(5,1) = j;
                        end
                    elseif j == 10 && lidar_distance_16(5,1) == 0
                            lidar_distance_16(5,1) = max_hodnota;
                    else 
                        lidar_distance_16(5,1) = 0;
                    end
                    %%%%
                    if pozicia(1,1)-1-j <= 0 || pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance_16(1,5) = 0;
                    elseif cesta(pozicia(1,1)-1-j, pozicia(1,2)+1+j) == 1    %prava-horna uhlopriecka
                        if lidar_distance_16(1,5) == 0
                            lidar_distance_16(1,5) = j;
                        end
                    elseif j == 10 && lidar_distance_16(1,5) == 0
                            lidar_distance_16(1,5) = max_hodnota;
                    else
                        lidar_distance_16(1,5) = 0;
                    end
                    %%%%
                    if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)+1+j >= velkost_mapy(2)
                        lidar_distance_16(5,5) = 0;
                    elseif cesta(pozicia(1,1)+1+j, pozicia(1,2)+1+j) == 1    %prava-dolna uhlopriecka
                        if lidar_distance_16(5,5) == 0
                            lidar_distance_16(5,5) = j;
                        end
                    elseif j == 10 && lidar_distance_16(5,5) == 0
                            lidar_distance_16(5,5) = max_hodnota;
                    else
                        lidar_distance_16(5,5) = 0;
                    end  
                end
                
                %%Pridanie lucov
                subY21 = 0;
                addY41 = 0;
                subX12 = 0;
                addX14 = 0;
                subX52 = 0;
                addX54 = 0;
                subY25 = 0;
                addY45 = 0;
                
                for j = 1:1:10
                    if((mod(j,2)==0))
                        subY21 = subY21+1;
                        addY41 = addY41+1;
                        subX12 = subX12+1;
                        addX14 = addX14+1;
                        subX52 = subX52+1;
                        addX54 = addX54+1;
                        subY25 = subY25+1;
                        addY45 = addY45+1;
                    end
                    
                    if pozicia(1,2)-1-j <= 0 || (pozicia(1,1)-subY21 <= 0)
                        lidar_distance_16(2,1) = 0; %[y-riadky x-stlpce]
%                     elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)-1-j) == 1) 
                    elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)-1) == 1) 
                        if lidar_distance_16(2,1) == 0
                            lidar_distance_16(2,1) = j;
                        end
                    elseif (j ~= 1) && cesta(pozicia(1,1)-subY21, pozicia(1,2)-j-1) == 1    %2;1
                        if lidar_distance_16(2,1) == 0
                            lidar_distance_16(2,1) = j;
                        end
                    elseif j == 10 && lidar_distance_16(2,1) == 0
                            lidar_distance_16(2,1) = max_hodnota;
                    else
                        lidar_distance_16(2,1) = 0;
                    end
                    
                    if pozicia(1,2)-1-j <= 0 || pozicia(1,1)+addY41 >= velkost_mapy(2)
                        lidar_distance_16(4,1) = 0; %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)-1-j) == 1) 
                        if lidar_distance_16(4,1) == 0
                            lidar_distance_16(4,1) = j;
                        end
                    elseif (j ~= 1) && cesta(pozicia(1,1)+addY41, pozicia(1,2)-1-j) == 1    %4;1
                        if lidar_distance_16(4,1) == 0
                            lidar_distance_16(4,1) = j;
                        end
                    elseif j == 10 && lidar_distance_16(4,1) == 0
                            lidar_distance_16(4,1) = max_hodnota;
                    else
                        lidar_distance_16(4,1) = 0;
                    end
                    
                    if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)-subX52 <= 0
                        lidar_distance_16(5,2) = 0;        %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1) 
                        if lidar_distance_16(5,2) == 0
                            lidar_distance_16(5,2) = j;
                        end
                    elseif (j ~= 1) && cesta(pozicia(1,1)+1+j, pozicia(1,2)-subX52) == 1    %5;2
                        if lidar_distance_16(5,2) == 0
                            lidar_distance_16(5,2) = j;
                        end
                    elseif j == 10 && lidar_distance_16(5,2) == 0
                            lidar_distance_16(5,2) = max_hodnota;
                    else
                        lidar_distance_16(5,2) = 0;
                    end
                    
                    if pozicia(1,1)+1+j >= velkost_mapy(1) || pozicia(1,2)+addX54 >= velkost_mapy(2)
                        lidar_distance_16(5,4) = 0;        %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1)+1+j, pozicia(1,2)) == 1) 
                        if lidar_distance_16(5,4) == 0
                            lidar_distance_16(5,4) = j;
                        end
                    elseif (j ~= 1) && cesta(pozicia(1,1)+1+j, pozicia(1,2)+addX54) == 1    %5;4
                        if lidar_distance_16(5,4) == 0
                            lidar_distance_16(5,4) = j;
                        end
                    elseif j == 10 && lidar_distance_16(5,4) == 0
                            lidar_distance_16(5,4) = max_hodnota;
                    else
                        lidar_distance_16(5,4) = 0;
                    end
                    
                    if pozicia(1,2)+1+j >= velkost_mapy(2) || pozicia(1,1)+addY45 >= velkost_mapy(1)
                        lidar_distance_16(4,5) = 0;        %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1) 
                        if lidar_distance_16(4,5) == 0
                            lidar_distance_16(4,5) = j;
                        end    
                    elseif (j ~= 1) && cesta(pozicia(1,1)+addY45, pozicia(1,2)+1+j) == 1   %4;5
                        if lidar_distance_16(4,5) == 0
                            lidar_distance_16(4,5) = j;
                        end
                    elseif j == 10 && lidar_distance_16(4,5) == 0
                            lidar_distance_16(4,5) = max_hodnota;
                    else
                        lidar_distance_16(4,5) = 0;
                    end
                    
                    if pozicia(1,2)+1+j >= velkost_mapy(2) || pozicia(1,1)-subY25 <= 0
                        lidar_distance_16(2,5) = 0;        %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1), pozicia(1,2)+1+j) == 1) 
                        if lidar_distance_16(2,5) == 0
                            lidar_distance_16(2,5) = j;
                        end    
                    elseif j == 10 && lidar_distance_16(2,5) == 0
                            lidar_distance_16(2,5) = max_hodnota;
                    elseif (j ~= 1) && cesta(pozicia(1,1)-subY25, pozicia(1,2)+1+j) == 1   %2;5
                        if lidar_distance_16(2,5) == 0
                            lidar_distance_16(2,5) = j;
                        end        
                    else
                        lidar_distance_16(2,5) = 0;
                    end
                    
                    if pozicia(1,1)-1-j <= 0 || pozicia(1,2)+addX14 >= velkost_mapy(1)
                        lidar_distance_16(1,4) = 0;    %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1) 
                        if lidar_distance_16(1,4) == 0
                            lidar_distance_16(1,4) = j;
                        end 
                    elseif (j ~= 1) && cesta(pozicia(1,1)-1-j, pozicia(1,2)+addX14) == 1    %1;4
                        if lidar_distance_16(1,4) == 0
                            lidar_distance_16(1,4) = j;
                        end
                    elseif j == 10 && lidar_distance_16(1,4) == 0
                            lidar_distance_16(1,4) = max_hodnota;
                    else
                        lidar_distance_16(1,4) = 0;
                    end
                    
                    if pozicia(1,1)-1-j <= 0 || pozicia(1,2)-subX12 <= 0
                        lidar_distance_16(1,2) = 0;    %[y-riadky x-stlpce]
                    elseif (j == 1) && (cesta(pozicia(1,1)-1-j, pozicia(1,2)) == 1) 
                        if lidar_distance_16(1,2) == 0
                            lidar_distance_16(1,2) = j;
                        end 
                    elseif (j ~= 1) && cesta(pozicia(1,1)-1-j, pozicia(1,2)-subX12) == 1    %1;2
                        if lidar_distance_16(1,2) == 0
                            lidar_distance_16(1,2) = j;
                        end
                    elseif j == 10 && lidar_distance_16(1,2) == 0
                            lidar_distance_16(1,2) = max_hodnota;
                    else
                        lidar_distance_16(1,2) = 0;
                    end
                end
                    %%%%
                %             uhlopriecky
%                 if(lidar_distance_16(1,1) ~= 15)
%                     lidar_distance_16(1,1) = lidar_distance_16(1,1)*1.4142;
%                 end
%                 if(lidar_distance_16(1,5) ~= 15)
%                     lidar_distance_16(1,5) = lidar_distance_16(1,5)*1.4142;
%                 end
%                 if(lidar_distance_16(5,1) ~= 15)
%                     lidar_distance_16(5,1) = lidar_distance_16(5,1)*1.4142;
%                 end
%                 if(lidar_distance_16(5,5) ~= 15)
%                     lidar_distance_16(5,5) = lidar_distance_16(5,5)*1.4142;
%                 end
%                 %
%                 if(lidar_distance_16(1,2) ~= 15)
%                     lidar_distance_16(1,2) = lidar_distance_16(1,2)*1.118034;
%                 end
%                 if(lidar_distance_16(1,4) ~= 15)
%                     lidar_distance_16(1,4) = lidar_distance_16(1,4)*1.118034;
%                 end
%                 if(lidar_distance_16(2,1) ~= 15)
%                     lidar_distance_16(2,1) = lidar_distance_16(2,1)*1.118034;
%                 end
%                 if(lidar_distance_16(4,1) ~= 15)
%                     lidar_distance_16(4,1) = lidar_distance_16(4,1)*1.118034;
%                 end
% 
%                 if(lidar_distance_16(2,5) ~= 15)
%                     lidar_distance_16(2,5) = lidar_distance_16(2,5)*1.118034;
%                 end
%                 if(lidar_distance_16(4,5) ~= 15)
%                     lidar_distance_16(4,5) = lidar_distance_16(4,5)*1.118034;
%                 end
% 
%                 if(lidar_distance_16(5,2) ~= 15)
%                     lidar_distance_16(5,2) = lidar_distance_16(5,2)*1.118034;
%                 end
%                 if(lidar_distance_16(5,4) ~= 15)
%                     lidar_distance_16(5,4) = lidar_distance_16(5,4)*1.118034;
%                 end    

                size_array = size(lidar_distance_16);
                array = lidar_distance_16;
                lidar_16 = [rot90(array(:,1)) array(size_array(1),2:end) rot90(rot90(array(1:end-1,size_array(1))')) rot90(rot90(array(1,2:end-1)))];
                
                lidar_16 = lidar_16';

                lidar_16 = circshift(lidar_16,orientacia);
                
%                 % Urcenie smeru doprava
%                 if orientacia == 1
%                     lidar_16 = circshift(lidar_16,4);
%                 
%                 % Urcenie smeru vzad
%                 elseif orientacia == 2
%                     lidar_16 = circshift(lidar_16,8);
% %                 
%                 % Urcenie smeru dolava
%                 elseif orientacia == 3
%                     lidar_16 = circshift(lidar_16,-4);
%                     
%                 end
                
            % Snimace sa nastavili mimo mapy    
            else
                
                lidar_16 = ones(16,1);

            end
            
%             snimace = matica(:);
%             snimace(5) = [];
%             
%             lidar = lidar_distance(:);
%             lidar(5) = [];
            
            
            
%             lidar_16 = lidar_distance_16(:);
            

            
%             lidar_16 = lidar_distance_16(:);
%             lidar_16(7) = [];
%             lidar_16(7) = [];
%             lidar_16(7) = [];
%             lidar_16(9) = [];
%             lidar_16(9) = [];
%             lidar_16(9) = [];
%             lidar_16(11) = [];
%             lidar_16(11) = [];
%             lidar_16(11) = [];
% vekt = [rot90(array(:,1)) array(size_array(1),2:end) rot90(rot90(array(1:end-1,size_array(1))')) rot90(rot90(array(1,2:end-1)))];
        
%         size_array = size(lidar_distance_16);
%         array = lidar_distance_16;
%         lidar_16 = [rot90(array(:,1)) array(size_array(1),2:end) rot90(rot90(array(1:end-1,size_array(1))')) rot90(rot90(array(1,2:end-1)))];

        
            
end
