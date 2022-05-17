clc
clear
addpath("genetic")
numgen = 1;  % pocet generacii
lpop = 25;	   % pocet chromozonov v populacii
lstring = 210; % pocet genov v chromozone (90+100+10)200
M = 1;         % maximalny prehladavaci priestor


collum = [75 75 75 75 75 75 75 75];
one = ones(1,8);
start_line = [36:43; collum];
% start = [39 74];

%x y, 36-43	75, 75	29-36, 109-116	75, 75	114-121
min_pp=inf;

kroky = 4000;


trasa_num = 1;      %Zatial funkčná trasa 1 a celkom funkčná trasa 3

if(trasa_num == 1)  %stvorec
    checkpoints = cat(2,[collum; 29:36],[108:115; collum],[collum; 114:121],[35:42;collum]);
    prekazky = [80 32 112 75 75 118 39 80];
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

%     checkpoints = cat(2, [34:40,40; collum1], [31,31:36,36; collum2], [17:23,23; collum3],[8:15; collum4], [13,13:18,18; 16,16:21,21], [collum5;10:17],[collum6;19,19:24,24] ...
%         ,[collum7; 29:36], [collum8; 29:36], [collum9; 27:34], [101,101:107; 17,17:23],[107,107:113; 5,5:11], [collum10; 2:9], [122:129; collum11] ...
%         ,[collum12; 29:35,35], [126,126:131,131;47,47:52,52], [108:115; collum13], [108:115; collum8], [108:115; collum14], [108:115; collum15] ...
%         ,[108:115; collum16], [108:115; collum17],[collum18;136:143],[collum19;133,133:138,138], [collum20;126:133], [56,56:61,61;135,135:140,140] ...
%         ,[collum21; 139:146], [collum22; 139:146],[22:29; collum23],[21:28; collum24],[collum27; collum26]);
checkpoints = cat(2, [34:40,40; collum1], [17:23,23; collum3], [13,13:18,18; 16,16:21,21], [collum6;19,19:24,24] ...
        , [collum8; 29:36], [collum10; 2:9], ...
        [collum12; 29:35,35], [108:115; collum13], [108:115; collum14], ...
        [108:115; collum16],[collum18;136:143], [collum20;126:133], ...
        [collum22; 139:146],[21:28; collum24]);
prekazky = [36 60 14 17 119 4 110 63 105 138 23 120];

end
checkpoints_pom = checkpoints;

[start,cesta] = vyber_trasy(trasa_num);

[riadok_cesta,stlpec_cesta] = size(cesta);
for spustenie = 1:1:1
% Inicializacia populacie  
Space = [ones(1,lstring) * (-M); ones(1,lstring)]; % prehladavaci priestor
Delta = Space(2,:) / 50; % krok aditivnej mutacie

Pop = genrpop(lpop,Space);
min_kroky=kroky;
predchadzajuce_kroky = zeros(2,10); %pozerame predchadzajucihc (2,x) x krokov
% Main cyklus

for gen = 1:numgen
    
    disp(gen);
    
    checkpoints_pom=checkpoints;
    for i = 1:lpop
    trasa_prekazky = zeros(150,150);
    new_pohybujuce_prekazky = prekazky;
    kolizie_s_prekazkamy = 0;
    %=====================================================================>
    %                      VYTVORENIE MATIC W1,W2,W3
    %=====================================================================>

%     W1 = []; W2 = []; W3 = [];    
%             % W1 => (10x9 = 90)
%         for j = 9:9:90
%             
%             W1(end+1,:) = Pop(i,j-8:j);
%           
%         end
%         
%         % W2 => (10x10 = 100)
%         for j = 91:10:190
%             
%             W2(end+1,:) = Pop(i,j-9:j);
%                 
%         end
%         
%         % W3 => (1x10 = 10)
%         for j = 191:10:200
%             
%             W3(end+1,:) = Pop(i,j-9:j);
%                 
%         end
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
        pozicia = start;
        orientacia = 3;
        predosla_zmena = 0;
        pp = 0;
        
        checkpoints_pom=checkpoints;
        neprejdenie_ch = 0;

        checkpoint_pomoc = 4;
        old_pokuta_vzdialenost_od_cp = 0;

       for k = 1:kroky
            
            new_pohybujuce_prekazky = pohybujuce_prekazky(cesta,new_pohybujuce_prekazky,pozicia);
            for p = 1:2:length(new_pohybujuce_prekazky)
                cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 1;%nastavenie prekazky
            end

            predosla_orientacia = orientacia;
            draha(pozicia(1,1),pozicia(1,2)) = draha(pozicia(1,1),pozicia(1,2)) + 1;
            
            [lidar_16] = kontrola_snimacov(pozicia,cesta,orientacia);
            prvy = 8;
            lidar_16_predne = 0;
            for in = 1:9
                lidar_16_predne(in) = lidar_16(prvy);
                prvy = prvy+1;
            end
            lidar_16(end+1) = predosla_zmena;
            lidar_16_predne(end+1) = predosla_zmena;
            
            lidar_16_predne = lidar_16_predne';
            
            
%             natocenie = neuronova_siet(W1,W2,W3,snimace);lidar_16_predne
            natocenie = neuronova_siet(W1,W2,W3,lidar_16_predne);

            orientacia = aktualizacia_orientacia(natocenie,orientacia);
            
            [pokuta,posledna_zmena] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena);
            
            [riadok_draha,stlpec_draha] = pohyb(orientacia,pozicia);
            
            pozicia = [riadok_draha,stlpec_draha];

            if cesta(pozicia(1,1),pozicia(1,2)) == 1
                pokuta_vybocenie = 75000;
            else
                pokuta_vybocenie = -0.1;
            end
            
          pokuta_ciklus = 0;
            prejdenie_cp = 0;
            mansia_vzdialenost = -10000;

            %pokuta ak sa zacikli
            for j = 1:length(predchadzajuce_kroky)
                if (predchadzajuce_kroky(1,j) == pozicia(1,1)) && (predchadzajuce_kroky(2,j) == pozicia(1,2))
                    pokuta_ciklus = pokuta_ciklus + 10000;
%                 else
%                     pokuta_ciklus = pokuta_ciklus -1;
                end
            end

            %prepisovanie predchadajucich korokov
            for j = 1:(length(predchadzajuce_kroky)-1)
                predchadzajuce_kroky(1,j) = predchadzajuce_kroky(1,j+1);
                predchadzajuce_kroky(2,j) = predchadzajuce_kroky(2,j+1);
            end
            %ulozenie aktualnej polohy do predchadzajuce kroky
            predchadzajuce_kroky(1,length(predchadzajuce_kroky)) = pozicia(1,1);
            predchadzajuce_kroky(2,length(predchadzajuce_kroky)) = pozicia(1,2);
            
            %checkpoint
            xdif = abs(pozicia(1,2)-checkpoints(2,checkpoint_pomoc));
            ydif = abs(pozicia(1,1)-checkpoints(1,checkpoint_pomoc));
            pokuta_vzdialenost_od_cp = sqrt((xdif)^2+(ydif)^2);
            
            %ak sa priblizi k nasledujucemu checkpointu 
            %dostane bonus
            if old_pokuta_vzdialenost_od_cp > pokuta_vzdialenost_od_cp
                mansia_vzdialenost = 100000;
            end
            
            old_pokuta_vzdialenost_od_cp = pokuta_vzdialenost_od_cp;

            %bonus ak prejde cez checkpoint v poradi
            for j = checkpoint_pomoc-3:checkpoint_pomoc+4
                if (pozicia(1,2) == checkpoints(2,j)) && (pozicia(1,1) == checkpoints(1,j))
                    prejdenie_cp = 1;
                    checkpoint_pomoc = checkpoint_pomoc + 8;
                    if checkpoint_pomoc > length(checkpoints)
                        checkpoint_pomoc = 4;
                    end
                end
            end

%             aktualna_pozicia = cesta(pozicia(1,1),pozicia(1,2));
            for p = 1:2:length(new_pohybujuce_prekazky)
                if (new_pohybujuce_prekazky(p) == pozicia(1) && new_pohybujuce_prekazky(p+1) == pozicia(2))
                    kolizie_s_prekazkamy = kolizie_s_prekazkamy + 1;
                end
                trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1))+1;
                cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 0;%vynulovanie prekazky
            end

            pp = 1 + pp + pokuta + pokuta_vybocenie + pokuta_ciklus + pokuta_vzdialenost_od_cp - 100 * mansia_vzdialenost - prejdenie_cp * 500000 + kolizie_s_prekazkamy * 500000;
%             for index = 1:9
%                 
%                 if (double(lidar(index)) == 11)
%                     if (index == 4 || index == 5 || index == 6 || index == 7 || index == 8 )
%                         pokutaAkt = -0.1; %záporná pokuta ak je lidar 11 a predná časť robota + boky
%                     else   %do úvahy sa neberie zadná časť robota (nulová pokuta)
%                         if(trasa_num == 1)  %toto treba spravit lepsie
%                             pokutaAkt = 5 * (double(lidar(index)));
%                         else
%                             pokutaAkt = 0 * (double(lidar(index)));
%                         end
%                     end
%                 else       %pokutovanie pri hodnote lidaru menšej ako 11
%                     pokutaAkt = 5*(1 - double(lidar(index))/10);
%                 end
%  
%                pp = pp + pokutaAkt;
%             end

        end
 %%
        

        Fit(i) = pp;
        if min_pp>pp
            min_pp=pp;
            best_draha=draha;
            best_pozicia=pozicia;
%             best_W=[W1,W2,W3];
        end
        
    end
    
    evolution(gen) = min(Fit);
   
    Pop = geneticky_algoritmus(Pop,Fit,Space,Delta);
 
end

% Najlepsie riesenie
figure(spustenie)
plot(evolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');

%%
spustenie
if spustenie == 1
    save('spustenie_1')
elseif spustenie == 2
    save('spustenie_2')
elseif spustenie == 3
    save('spustenie_3')
elseif spustenie == 4
    save('spustenie_4')
elseif spustenie == 5
    save('spustenie_5')
elseif spustenie == 6
    save('spustenie_6')
elseif spustenie == 7
    save('spustenie_7')
elseif spustenie == 8
    save('spustenie_8')
elseif spustenie == 9
    save('spustenie_9')
elseif spustenie == 10
    save('spustenie_10')
elseif spustenie == 11
    save('spustenie_11') 
elseif spustenie == 12
    save('spustenie_12')
elseif spustenie == 13
    save('spustenie_13')
elseif spustenie == 14
    save('spustenie_14')
elseif spustenie == 15
    save('spustenie_15')
elseif spustenie == 16
    save('spustenie_16')
elseif spustenie == 17
    save('spustenie_17')
elseif spustenie == 18
    save('spustenie_18')
elseif spustenie == 19
    save('spustenie_19')
else
    save('spustenie_20')    
end
Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,best_draha,start,cesta,checkpoints, spustenie)
end

