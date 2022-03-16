function [start,cesta] = vyber_trasy(trasa_num)
% Nacitanie a uprava trasy
% 

switch trasa_num
    case 1
        start = [39 74];
        cesta = imread('trasa_stvorec.bmp');
    case 2
        start = [39 74];
        cesta = imread('race_track.bmp');
    case 3
        start = [32 74];
        cesta = imread('trasa_kruh.bmp');
    case 4
        start = [55 74];
        cesta = imread('trasa_osmicka.bmp');
    case 5    
        start = [28 74];
        cesta = imread('trasa_sestuholnik.bmp');
end

cesta = (cesta(:,:,1) + cesta(:,:,2) + cesta(:,:,3)) ./ (255);
end

