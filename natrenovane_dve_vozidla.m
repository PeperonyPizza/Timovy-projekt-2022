clc
clear
addpath("genetic")
numgen = 3500; % pocet generacii
lpop = 25;	   % pocet chromozonov v populacii
lstring = 210; % pocet genov v chromozone (90+100+10)200
M = 1;         % maximalny prehladavaci priestor


collum = [75 75 75 75 75 75 75 75];
one = ones(1,8);
start_line = [36:43; collum];
% start = [39 74];

%x y, 36-43	75, 75	29-36, 109-116	75, 75	114-121
min_pp=inf;
kroky = 1150;

%%%%%% NASTAVENIE MAPY %%%%%%
trasa_num = 2;      %vyber mapy: 1 = stvorec
                    %            2 = race track
                    %            3 = kruh
                    %            4 = osmicka
                    %            5 = sestuholnik
                    %            6 = race track_2
%%%%%% NASTAVENIE POČTU AUTÍČOK %%%%%%  (1 alebo 2)
auticko = 1;

pocetSpusteni = 1;

if(trasa_num == 1)  %stvorec
    kroky = 750;
    checkpoints = cat(2,[collum; 29:36],[108:115; collum],[collum; 114:121],[35:42;collum]);
elseif(trasa_num == 2)  %race track
    kroky = 1150;
    checkpoints = cat(2,[one*25;46:53],[8:15;one*33],[one*37;14:21],[one*87;29:36],[one*117;2:9], ...
                        [133:140;one*41],[108:115;one*65],[108:115;one*120],[one*77;113:120], ...
                        [one*50;126:133],[21:28;one*110],[35:42;collum]);
elseif(trasa_num == 3) %kruh
    kroky = 750;
    checkpoints = cat(2,[collum; 21:28],[119:126; collum],[collum; 124:131], [25:32;collum]);  
elseif(trasa_num == 4)  %osmicka
    kroky = 750;
    checkpoints = cat(2,[39:46;one*45],[collum; 9:16],[93:100; one*37],[85:92; one*64],[102:109; one*88],[collum; 131:138],[43:50;one*113], [51:58;one*87]); 
elseif(trasa_num == 5)  %sestuholnik
    kroky = 750;
    checkpoints = cat(2,[collum; 25:32],[120:127; collum],[collum; 117:124],[22:29;collum]);
elseif(trasa_num == 6)  %race track_2
    kroky = 1150;
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


end
checkpoints_pom = checkpoints;

[start,cesta] = vyber_trasy(trasa_num);

[riadok_cesta,stlpec_cesta] = size(cesta);
for spustenie = 1:1:pocetSpusteni
% Inicializacia populacie  
Space = [ones(1,lstring) * (-M); ones(1,lstring)]; % prehladavaci priestor
Delta = Space(2,:) / 50; % krok aditivnej mutacie

Pop = load('pop_natrenovane.mat');%genrpop(lpop,Space);
Pop = Pop.Pop;


min_kroky=kroky;
predchadzajuce_kroky = zeros(2,10); %pozerame predchadzajucihc (2,x) x krokov
% Main cyklus

    checkpoints_pom=checkpoints;
    for i = 1:lpop
    %=====================================================================>
    %                      VYTVORENIE MATIC W1,W2,W3
    %=====================================================================>

W1 = []; W2 = []; W3 = [];    
            % W1 => (10x9 = 90)         (10x17 = 170)
        for j = 10:10:100                  %(10x16 = 160) for j = 17:17:170 
            
            W1(end+1,:) = Pop(i,j-9:j);
          
        end
        
        % W2 => (10x10 = 100)
        for j = 101:10:200
            
            W2(end+1,:) = Pop(i,j-9:j);
                
        end
        
        % W3 => (1x10 = 10)
        for j = 201:10:210
            
            W3(end+1,:) = Pop(i,j-9:j);
                
        end

 %%       
        %=================================================================>
        %                         SPUSTENIE ROBOTA
        %=================================================================>
        
        % Nastavenie zakladnych parametrov
        draha = zeros(riadok_cesta,stlpec_cesta);
        draha_2 = zeros(riadok_cesta,stlpec_cesta);
        draha_akt = 0;
        draha_akt_2 = 0;
        pozicia_1 = start;
        pozicia_2 = start;
        orientacia_1 = 3;
        orientacia = 3;
        predosla_zmena = 0;
        pp = 0;
        
        checkpoints_pom=checkpoints;
        neprejdenie_ch = 0;

        checkpoint_pomoc = 4;
        old_pokuta_vzdialenost_od_cp = 0;

        subY21_1 = 0;
        addY41_1 = 0;
        subX12_1 = 0;
        addX14_1 = 0;
        subX52_1 = 0;
        addX54_1 = 0;
        subY25_1 = 0;
        addY45_1 = 0;

        subY21 = 0;
        addY41 = 0;
        subX12 = 0;
        addX14 = 0;
        subX52 = 0;
        addX54 = 0;
        subY25 = 0;
        addY45 = 0;

       for k = 1:kroky

           if(mod(k,2)==1)

               %    prve vozidlo
            predosla_orientacia_1 = orientacia_1;
            draha(pozicia_1(1,1),pozicia_1(1,2)) = draha(pozicia_1(1,1),pozicia_1(1,2)) + 1;
            draha_akt = draha(pozicia_1(1,1),pozicia_1(1,2)) + 1;
            
            [lidar_16_1] = kontrola_snimacov(pozicia_1,cesta,orientacia_1);
            prvy = 8;
            lidar_16_predne_1 = 0;
            for in = 1:9
                lidar_16_predne_1(in) = lidar_16_1(prvy);
                prvy = prvy+1;
            end
            lidar_16_1(end+1) = predosla_zmena;
            lidar_16_predne_1(end+1) = predosla_zmena;
            
            lidar_16_predne_1 = lidar_16_predne_1';
            
            natocenie_1 = neuronova_siet(W1,W2,W3,lidar_16_predne_1);

            orientacia_1 = aktualizacia_orientacia(natocenie_1,orientacia_1);
            
            [pokuta,posledna_zmena, subY21_1,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1] = kontrola_zmeny_orientaacie(predosla_orientacia_1,orientacia_1,predosla_zmena, kroky,subY21_1,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1);
            
            [riadok_draha,stlpec_draha, subY21_1 ,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1] = pohyb(orientacia_1,pozicia_1,subY21_1,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1);
            
            pozicia_1 = [riadok_draha,stlpec_draha];

           end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          
            if(k > 60)
                %    druhe vozidlo
            predosla_orientacia = orientacia;
            draha_2(pozicia_2(1,1),pozicia_2(1,2)) = draha_2(pozicia_2(1,1),pozicia_2(1,2)) + 1;
            draha_akt_2 = draha_2(pozicia_2(1,1),pozicia_2(1,2)) + 1;
            
            [lidar_16] = kontrola_snimacov(pozicia_2,cesta,orientacia);
            prvy = 8;
            lidar_16_predne = 0;
            for in = 1:9
                lidar_16_predne(in) = lidar_16(prvy);
                prvy = prvy+1;
            end
            lidar_16(end+1) = predosla_zmena;
            lidar_16_predne(end+1) = predosla_zmena;
            
            lidar_16_predne = lidar_16_predne';
            
            natocenie = neuronova_siet(W1,W2,W3,lidar_16_predne);

            orientacia = aktualizacia_orientacia(natocenie,orientacia);
            
            [pokuta,posledna_zmena, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena, kroky,subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45);
            
            [riadok_draha,stlpec_draha, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = pohyb(orientacia,pozicia_2,subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45);
            
            pozicia_2 = [riadok_draha,stlpec_draha];
            end

            if(auticko == 2)
               Vykreslovanie_dveVozidla(riadok_cesta,stlpec_cesta,pozicia_1,pozicia_2,draha,start,cesta,checkpoints)
           else
               Vykreslovanie_jednoVozidlo(riadok_cesta,stlpec_cesta,pozicia_1,pozicia_2,draha,start,cesta,checkpoints)
           end
            

        end
 %%
        

        Fit(i) = pp;
        if min_pp>pp
            min_pp=pp;
            best_draha=draha;
            best_draha_2=draha_2;
            best_pozicia_1=pozicia_1;
            best_pozicia_2=pozicia_2;

%             best_W=[W1,W2,W3];
        end
        
    end
 
Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia_1,best_draha,start,cesta,checkpoints,spustenie)

if(auticko == 2)
    Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia_2,best_draha_2,start,cesta,checkpoints,spustenie)
end

end
