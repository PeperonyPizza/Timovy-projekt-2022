function [riadok_draha,stlpec_draha, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = pohyb(orientacia,pozicia, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45)
            %=============================================================>
            %                         POHYB ROBOTA
            %=============================================================>
            
%             % Pohyb robota smerom hore
%             if orientacia == 0
%                 
%                 riadok_draha = pozicia(1,1)-1;
%                 stlpec_draha = pozicia(1,2);
%             
%             % Pohyb robota smerom doprava
%             elseif orientacia == 1
%                 
%                 riadok_draha = pozicia(1,1);
%                 stlpec_draha = pozicia(1,2)+1;
% 
%             % Pohyb robota smerom dole
%             elseif orientacia == 2
%                 
%                 riadok_draha = pozicia(1,1)+1;
%                 stlpec_draha = pozicia(1,2);
% 
%             % Pohyb robota smerom dolava    
%             else
%                 
%                 riadok_draha = pozicia(1,1);
%                 stlpec_draha = pozicia(1,2)-1;
%                 
%             end

            % Pohyb robota smerom  (3,1)
            if orientacia == 0
                
                riadok_draha = pozicia(1,1);
                stlpec_draha = pozicia(1,2)-1;
            
            % Pohyb robota smerom (2,1)
            elseif orientacia == 1
%                 addY41 = 0;
%                 subX12 = 0;
%                 addX14 = 0;
%                 subX52 = 0;
%                 addX54 = 0;
%                 subY25 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)-subY21;
                stlpec_draha = pozicia(1,2)-1;

            % Pohyb robota smerom (1,1)
            elseif orientacia == 2
                
                riadok_draha = pozicia(1,1)-1;
                stlpec_draha = pozicia(1,2)-1;

            % Pohyb robota smerom (1,2)    
            elseif orientacia == 3
%                 subY21 = 0;
%                 addY41 = 0;
%                 addX14 = 0;
%                 subX52 = 0;
%                 addX54 = 0;
%                 subY25 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)-1;
                stlpec_draha = pozicia(1,2)-subX12;

            % Pohyb robota smerom (1,3)    
            elseif orientacia == 4
                
                riadok_draha = pozicia(1,1)-1;
                stlpec_draha = pozicia(1,2);

            % Pohyb robota smerom (1,4)    
            elseif orientacia == 5
%                 subY21 = 0;
%                 addY41 = 0;
%                 subX12 = 0;
%                 subX52 = 0;
%                 addX54 = 0;
%                 subY25 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)-1;
                stlpec_draha = pozicia(1,2)+addX14;
            % Pohyb robota smerom (1,5)    
            elseif orientacia == 6
                
                riadok_draha = pozicia(1,1)-1;
                stlpec_draha = pozicia(1,2)+1;
            % Pohyb robota smerom (2,5)    
            elseif orientacia == 7
%                 subY21 = 0;
%                 addY41 = 0;
%                 subX12 = 0;
%                 addX14 = 0;
%                 subX52 = 0;
%                 addX54 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)-subY25;
                stlpec_draha = pozicia(1,2)+1;
            % Pohyb robota smerom (3,5)    
            elseif orientacia == 8
                
                riadok_draha = pozicia(1,1);
                stlpec_draha = pozicia(1,2)+1;
            % Pohyb robota smerom (4,5)    
            elseif orientacia == 9
%                 subY21 = 0;
%                 addY41 = 0;
%                 subX12 = 0;
%                 addX14 = 0;
%                 subX52 = 0;
%                 addX54 = 0;
%                 subY25 = 0;
                riadok_draha = pozicia(1,1)+addY45;
                stlpec_draha = pozicia(1,2)+1;
            % Pohyb robota smerom (5,5)    
            elseif orientacia == 10
                
                riadok_draha = pozicia(1,1)+1;
                stlpec_draha = pozicia(1,2)+1;
            % Pohyb robota smerom (5,4)    
            elseif orientacia == 11
%                 subY21 = 0;
%                 addY41 = 0;
%                 subX12 = 0;
%                 addX14 = 0;
%                 subX52 = 0;
%                 subY25 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)+1;
                stlpec_draha = pozicia(1,2)+addX54;
            % Pohyb robota smerom (5,3)    
            elseif orientacia == 12
                
                riadok_draha = pozicia(1,1)+1;
                stlpec_draha = pozicia(1,2);
            % Pohyb robota smerom (5,2)    
            elseif orientacia == 13
%                 subY21 = 0;
%                 addY41 = 0;
%                 subX12 = 0;
%                 addX14 = 0;
%                 addX54 = 0;
%                 subY25 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)+1;
                stlpec_draha = pozicia(1,2)-subX52;
            % Pohyb robota smerom (5,1)    
            elseif orientacia == 14
                
                riadok_draha = pozicia(1,1)+1;
                stlpec_draha = pozicia(1,2)-1;
            % Pohyb robota smerom (4,1)    
            else%if orientacia == 15
%                 subY21 = 0;
%                 subX12 = 0;
%                 addX14 = 0;
%                 subX52 = 0;
%                 addX54 = 0;
%                 subY25 = 0;
%                 addY45 = 0;
                riadok_draha = pozicia(1,1)+addY41;
                stlpec_draha = pozicia(1,2)-1;
                  
            end
            
            % Osetrenie aby sa robot nepohyboval mimo mapy
            if riadok_draha < 1 || stlpec_draha < 1 || riadok_draha > 150 || stlpec_draha > 150
                
                riadok_draha = pozicia(1,1);
                stlpec_draha = pozicia(1,2);
                
            end
            
              
end































%  % Pohyb robota smerom  (3,1)
%             if orientacia == 0
%                 
%                 riadok_draha = pozicia(1,1);
%                 stlpec_draha = pozicia(1,2)-1;
%             
%             % Pohyb robota smerom (2,1)
% %             elseif orientacia == 1
% %                 addY41 = 0;
% %                 subX12 = 0;
% %                 addX14 = 0;
% %                 subX52 = 0;
% %                 addX54 = 0;
% %                 subY25 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)-subY21;
% %                 stlpec_draha = pozicia(1,2)-1;
% 
%             % Pohyb robota smerom (1,1)
% %             elseif orientacia == 2
% %                 
% %                 riadok_draha = pozicia(1,1)-1;
% %                 stlpec_draha = pozicia(1,2)-1;
% 
%             % Pohyb robota smerom (1,2)    
% %             elseif orientacia == 3
% %                 subY21 = 0;
% %                 addY41 = 0;
% %                 addX14 = 0;
% %                 subX52 = 0;
% %                 addX54 = 0;
% %                 subY25 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)-1;
% %                 stlpec_draha = pozicia(1,2)-subX12;
% 
%             % Pohyb robota smerom (1,3)    
%             elseif orientacia == 4
%                 
%                 riadok_draha = pozicia(1,1)-1;
%                 stlpec_draha = pozicia(1,2);
% 
%             % Pohyb robota smerom (1,4)    
% %             elseif orientacia == 5
% %                 subY21 = 0;
% %                 addY41 = 0;
% %                 subX12 = 0;
% %                 subX52 = 0;
% %                 addX54 = 0;
% %                 subY25 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)-1;
% %                 stlpec_draha = pozicia(1,2)+addX14;
%             % Pohyb robota smerom (1,5)    
% %             elseif orientacia == 6
% %                 
% %                 riadok_draha = pozicia(1,1)-1;
% %                 stlpec_draha = pozicia(1,2)+1;
%             % Pohyb robota smerom (2,5)    
% %             elseif orientacia == 7
% %                 subY21 = 0;
% %                 addY41 = 0;
% %                 subX12 = 0;
% %                 addX14 = 0;
% %                 subX52 = 0;
% %                 addX54 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)-subY25;
% %                 stlpec_draha = pozicia(1,2)+1;
%             % Pohyb robota smerom (3,5)    
%             elseif orientacia == 8
%                 
%                 riadok_draha = pozicia(1,1);
%                 stlpec_draha = pozicia(1,2)+1;
%             % Pohyb robota smerom (4,5)    
% %             elseif orientacia == 9
% %                 subY21 = 0;
% %                 addY41 = 0;
% %                 subX12 = 0;
% %                 addX14 = 0;
% %                 subX52 = 0;
% %                 addX54 = 0;
% %                 subY25 = 0;
% %                 riadok_draha = pozicia(1,1)+addY45;
% %                 stlpec_draha = pozicia(1,2)+1;
%             % Pohyb robota smerom (5,5)    
% %             elseif orientacia == 10
% %                 
% %                 riadok_draha = pozicia(1,1)+1;
% %                 stlpec_draha = pozicia(1,2)+1;
%             % Pohyb robota smerom (5,4)    
% %             elseif orientacia == 11
% %                 subY21 = 0;
% %                 addY41 = 0;
% %                 subX12 = 0;
% %                 addX14 = 0;
% %                 subX52 = 0;
% %                 subY25 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)+1;
% %                 stlpec_draha = pozicia(1,2)+addX54;
%             % Pohyb robota smerom (5,3)    
%             else%if orientacia == 12
%                 
%                 riadok_draha = pozicia(1,1)+1;
%                 stlpec_draha = pozicia(1,2);
%             % Pohyb robota smerom (5,2)    
% %             elseif orientacia == 13
% %                 subY21 = 0;
% %                 addY41 = 0;
% %                 subX12 = 0;
% %                 addX14 = 0;
% %                 addX54 = 0;
% %                 subY25 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)+1;
% %                 stlpec_draha = pozicia(1,2)-subX52;
%             % Pohyb robota smerom (5,1)    
% %             elseif orientacia == 14
% %                 
% %                 riadok_draha = pozicia(1,1)+1;
% %                 stlpec_draha = pozicia(1,2)-1;
%             % Pohyb robota smerom (4,1)    
% %             elseif orientacia == 15
% %                 subY21 = 0;
% %                 subX12 = 0;
% %                 addX14 = 0;
% %                 subX52 = 0;
% %                 addX54 = 0;
% %                 subY25 = 0;
% %                 addY45 = 0;
% %                 riadok_draha = pozicia(1,1)+addY41;
% %                 stlpec_draha = pozicia(1,2)-1;
%                   
%             end
            