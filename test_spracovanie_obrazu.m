clc
clear
addpath("genetic")

collum = [75 75 75 75 75 75 75 75];
start_line = [36:43; collum];

% start = [39 74];
checkpoints = cat(2,[collum; 29:36],[108:115; collum],[collum; 114:121]);
%x y, 36-43	75, 75	29-36, 109-116	75, 75	114-121

trasa_num = 1;

[start,cesta] = vyber_trasy(trasa_num);

[riadok_cesta,stlpec_cesta] = size(cesta);

% Main cyklus

for i=0:4:360
     rotacia_obrazu_v2_RGB(start,cesta,checkpoints, [74 39], i , 4);
%     rotacia_obrazu_v1_BW(cesta,[74 39], i , 5,1);
end
