function [start,cesta,checkpoints,prekazky] = vyber_trasy(trasa_num)
%=========================================================================>
%                   VYBER TRASY - Diskrétna forma
%=========================================================================>
% Táto funkcia je rovnaká pre diskrétnu aj analógovú formu pohybu robota.
%
% 
% VYBER_TRASY  Nacitanie a uprava trasy
%   START,CESTA,CHECKPOINTS,PREKAZKY = VYBER_TRASY(TRASA_NUM)
%      START        startovacia poloha v tvare [x, y]
%      CESTA        mapa prostredia
%      CHECKPOINTS  poloha checkpointov
%      PREKAZKY     aktualne suradnice prekazok v tvare [x1 y1, x2 y2, ...]
%      TRASA_NUM    ziadane prostredie:
%                                       1 = stvorec
%                                       2 = race track
%                                       3 = kruh
%                                       4 = osmicka
%                                       5 = sestuholnik
%                                       6 = race track_2
%                           
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          KONTROLA_ZMENY_ORIENTAACIE, POHYB, GENETICKY_ALGORITMUS,
%          POHYBUJUCE_PREKAZKY, VYKRESLOVANIE, VYKRESLOVANIE_SIMULACIA.


collum = [75 75 75 75 75 75 75 75];
one = ones(1,8);

if(trasa_num == 1)  %stvorec
    checkpoints = cat(2,[collum; 29:36],[108:115; collum],[collum; 114:121],[35:42;collum]);
%     prekazky = [80 32 112 75 75 118 39 80];
    prekazky = [41 118, 42 108, 38 98, 41 88, 40 78, 42 68, 40 58, 39 48, 42 36, 52 33, 62 34, 72 35, 82 33, 92 31, 102 35, 112 36, 110 46, 109 56,  108 66, 110 76, 112 86, 109 96, 112 106, 109 115, 99 116, 89 114, 79 117, 69 115, 59 114, 49 116, 42 114];
elseif(trasa_num == 2)  %race track
    checkpoints = cat(2,[one*25;46:53],[8:15;one*33],[one*37;14:21],[one*87;29:36],[one*117;2:9], ...
                        [133:140;one*41],[108:115;one*65],[108:115;one*120],[one*77;113:120], ...
                        [one*50;126:133],[21:28;one*110],[35:42;collum]);
    prekazky = [25 48 37 18 117 6 111 65 77 115 25 110];
elseif(trasa_num == 3) %kruh
    checkpoints = cat(2,[collum; 21:28],[119:126; collum],[collum; 124:131], [25:32;collum]);  
    prekazky = [75 26 122 75 75 126 24 75];
elseif(trasa_num == 4)  %osmicka
    checkpoints = cat(2,[39:46;one*45],[collum; 9:16],[93:100; one*37],[85:92; one*64],[102:109; one*88],[collum; 131:138],[43:50;one*113], [51:58;one*87]); 
    prekazky = [41 45 94 37 104 88 45 113];
elseif(trasa_num == 5)  %sestuholnik
    checkpoints = cat(2,[collum; 25:32],[120:127; collum],[collum; 117:124],[22:29;collum]);
    prekazky = [75 26 122 75 75 119 24 75];
elseif(trasa_num == 6)  %race track_2
    collum4 = [39 39 39 39 39 39 39 39]; collum12 = [137 136 135 134 133 132 131 131]; collum13 = [63 63 63 63 63 63 63 63];
    collum3 = [52 51 50 49 48 47 46 46]; collum11 = [13 13 13 13 13 13 13 13]; collum14 = [87 87 87 87 87 87 87 87];
    collum1 = [63 62 61 60 59 58 57 57]; collum10 = [119 119 119 119 119 119 119 119]; collum15 = [100 100 100 100 100 100 100 100];
    collum2 = [56 56 55 54 53 52 51 51]; collum9 = [95 95 95 95 95 95 95 95]; collum16 = [114 114 114 114 114 114 114 114];
    collum5 = [25 25 25 25 25 25 25 25]; collum8 = [75 75 75 75 75 75 75 75]; collum17 = [126 126 126 126 126 126 126 126];
    collum6 = [47 47 46 45 44 43 42 42]; collum7 = [60 60 60 60 60 60 60 60]; collum18 = [105 105 105 105 105 105 105 105];
    collum19 = [94 94 93 92 91 90 89 89]; collum21 = [49 49 49 49 49 49 49 49]; collum23 = [135 135 135 135 135 135 135 135];
    collum20 = [77 77 77 77 77 77 77 77]; collum22 = [37 37 37 37 37 37 37 37]; collum24 = [120 120 120 120 120 120 120 120];
    collum25 = [108 108 108 108 108 108 108 108];
    collum26 = [102 102 101 100 99 98 97 96]; collum27 = [39 39 38 37 36 35 34 33];

    checkpoints = cat(2, [34:40,40; collum1], [17:23,23; collum3], [13,13:18,18; 16,16:21,21], [collum6;19,19:24,24] ...
        , [collum8; 29:36], [collum10; 2:9], ...
        [collum12; 29:35,35], [108:115; collum13], [108:115; collum14], ...
        [108:115; collum16],[collum18;136:143], [collum20;126:133], ...
        [collum22; 139:146],[21:28; collum24]);
    prekazky = [36 60 14 17 119 4 110 63 105 138 23 120];

end


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
    case 6
        start = [39 74];
        cesta = imread('race_track_2.bmp');
end

cesta = (cesta(:,:,1) + cesta(:,:,2) + cesta(:,:,3)) ./ (255);
end