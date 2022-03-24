function [output] = neuronova_siet(W1,W2,W3,lidar,snimace)
            %=============================================================>
            %                     VYPOCET VYSTUPU UNS
            %=============================================================>
            
            A1 = W1*double([snimace;lidar./0.25]);
            O1 = tanh(A1);
            A2 = W2*O1;
            O2 = tanh(A2);
            
            output = W3*O2;%-1,1 1:0.33 0.33:-0.33 -0.33:-1
end

