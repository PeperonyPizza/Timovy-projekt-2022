function [output] = neuronova_siet(W11,W12,W2,W3,snimace,neuro_image_vector)
            %=============================================================>
            %                     VYPOCET VYSTUPU UNS
            %=============================================================>
            
            A1 = [W11*double(snimace/16)+ W12*neuro_image_vector/255];
            O1 = tanh(A1);
            A2 = W2*O1;
            O2 = tanh(A2);
            
            output = W3*O2*pi;%-1,1 1:0.33 0.33:-0.33 -0.33:-1


end

