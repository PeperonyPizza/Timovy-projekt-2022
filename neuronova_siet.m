function [output] = neuronova_siet(W1,W2,W3,snimace)
            %=============================================================>
            %                     VYPOCET VYSTUPU UNS
            %=============================================================>
            
            A1 = W1*double(snimace);
            O1 = tanh(A1);
            A2 = W2*O1;
            O2 = tanh(A2);
            %TODO: pridat rozsah -pi pi
            output = W3*O2;%-1,1 1:0.33 0.33:-0.33 -0.33:-1
end

