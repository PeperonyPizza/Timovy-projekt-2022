function [output] = neuronova_siet(W1,W2,W3,snimace)
%=========================================================================>
%                   NEURONOVA SIET - Analógový pohyb
%=========================================================================>
% Výstup pre diskrétnu formu:
%   Hodnota v intervale <-1; 1>
%
% Výstup pre analógovú formu:
%   Hodnota v intervale <-pi; pi>
%
% NEURONOVA_SIET  Vypocet vystupu UNS - predstavuje zmenu natocenia vozidla.
%   OTPUT = NEURONOVA_SIET(W1, W2, W3, snimace)
%      OUTPUT       hodnota z intervalu <-pi;pi>, želaná zmena natocenia vozidla
%      W1, W2, W3   jednotlivé váhy NS. Obsahujú dáta - gény daného jedinca.
%                   rozdelenie génov pre obidve formy pohybu:
%                       W1 - 90, W2 - 100, W3 - 10
%      SNIMACE      stĺpcový vektor s 10 riadkami
%                   prvých 9 hodnôt predstavujú dáta z lidaru (predná časť vozidla)
%                   posledná hodnota predstavuje informáciu o predošlej zmene
%                           
%
% See also KONTROLA_SNIMACOV, POHYBUJUCE_PREKAZKY, AKTUALIZACIA_ORIENTACIA, 
%          KONTROLA_ZMENY_ORIENTAACIE, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.

            
            A1 = [W11*double(snimace/16)+ W12*neuro_image_vector/255];
            O1 = tanh(A1);
            A2 = W2*O1;
            O2 = tanh(A2);
            
    output = W3*O2*pi; % <-pi;pi>
end