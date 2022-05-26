function [pp2] = aktualizacia_orientacia(natocenie,orientacia)
            %=============================================================>
            %                   AKTUALIZACIA ORIENTACIE
            %=============================================================>
            
%             % Smer sa nemeni
%             if natocenie >= -0.33 && natocenie <= 0.33
%                 
%                 pp2 = orientacia; 
%               
%             % Smer sa meni doprava   
%             elseif natocenie < -0.33
%                 
%                 pp2 = orientacia+1;
%                 
%                 % Osetrenie aby orientacia nebola >= 3 (0,1,2,3)
%                 if pp2 > 3
%                     
%                     pp2 = 0;
%                     
%                 end
%                 
%             % Smer sa meni dolava
%             else
%                 
%                 pp2 = orientacia-1;
%                 
%                 % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
%                 if pp2 < 0
%                     
%                     pp2 = 3;
%                     
%                 end
% 
%             end
% Smer sa nemeni - (3,5)
            if natocenie >= -pi/16 && natocenie <= pi/16 %d
                
                pp2 = orientacia; 
              
            % Smer sa meni doprava   
            elseif natocenie <= -pi+pi/16 %
                
                pp2 = orientacia+4;
                
                % Osetrenie aby orientacia nebola >= 3 (0,1,2,3)
                if pp2 > 15
                    
                    pp2 = 0;
                    
                end
                
            % Smer sa meni dolava
            elseif natocenie >= pi-pi/16 %
                
                pp2 = orientacia-4;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 < 0
                    
                    pp2 = 16+orientacia;
                    
                end
            % Smer sa meni dolava - (1,4)
            elseif natocenie < pi-pi/8+pi/16 && natocenie >= pi-pi/8-pi/16  %
                
                pp2 = orientacia-3;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 < 0
                    
                    pp2 = 16+orientacia;
                    
                end
            % Smer sa meni dolava - (1,5)
            elseif natocenie < pi-2*pi/8+pi/16 && natocenie >= pi-2*pi/8-pi/16  %
                
                pp2 = orientacia-2;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 < 0
                    
                    pp2 = 16+orientacia;
                    
                end
            % Smer sa meni dolava - (2,5)
            elseif natocenie < pi-3*pi/8+pi/16 && natocenie >= pi-3*pi/8-pi/16  %
                
                pp2 = orientacia-1;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 < 0
                    
                    pp2 = 16+orientacia;
                    
                end

            % Smer sa meni doprava - (5,4)
            elseif natocenie > -pi+pi/8-pi/16 && natocenie <= -pi+pi/8+pi/16  %
                
                pp2 = orientacia+3;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 > 15
                    
                    pp2 = 0;
                    
                end
            % Smer sa meni dolava - (5,5)
            elseif natocenie > -pi+2*pi/8-pi/16 && natocenie <= -pi+2*pi/8+pi/16  %
                
                pp2 = orientacia+2;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 > 15
                    
                    pp2 = 0;
                    
                end
            % Smer sa meni dolava - (4,5)
            else %natocenie > -pi+3*pi/8-pi/16 && natocenie <= -pi+3*pi/8+pi/16  %
                
                pp2 = orientacia+1;
                
                % Osetrenie aby orientacia nebola <= 0 (0,1,2,3)
                if pp2 > 15
                    
                    pp2 = 0;
                    
                end

            end
end

