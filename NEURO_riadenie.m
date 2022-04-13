clc
clear
addpath("genetic")
numgen = 500;  % pocet generacii
lpop = 25;	   % pocet chromozonov v populacii
lstring = 200; % pocet genov v chromozone (90+100+10)
M = 1;         % maximalny prehladavaci priestor


collum = [75 75 75 75 75 75 75 75];
one = ones(1,8);
start_line = [36:43; collum];
% start = [39 74];

%x y, 36-43	75, 75	29-36, 109-116	75, 75	114-121
min_pp=inf;

kroky = 800;

trasa_num = 2;      %Zatial funkčná trasa 1 a celkom funkčná trasa 3

if(trasa_num == 1)  %stvorec
    checkpoints = cat(2,[collum; 29:36],[108:115; collum],[collum; 114:121],[35:42;collum]);
elseif(trasa_num == 2)  %race track
    checkpoints = cat(2,[one*25;46:53],[8:15;one*33],[one*37;14:21],[one*87;29:36],[one*117;2:9], ...
                        [133:140;one*41],[108:115;one*65],[108:115;one*120],[one*77;113:120], ...
                        [one*50;126:133],[21:28;one*110],[35:42;collum]);
elseif(trasa_num == 3) %kruh
    checkpoints = cat(2,[collum; 21:28],[119:126; collum],[collum; 124:131], [25:32;collum]);  
elseif(trasa_num == 4)  %osmicka
    checkpoints = cat(2,[39:46;one*45],[collum; 9:16],[85:92; one*64],[collum; 131:138],[43:50;one*113]); 
elseif(trasa_num == 5)  %sestuholnik
    checkpoints = cat(2,[collum; 25:32],[120:127; collum],[collum; 117:124],[22:29;collum]);
end
checkpoints_pom = checkpoints;

[start,cesta] = vyber_trasy(trasa_num);

[riadok_cesta,stlpec_cesta] = size(cesta);

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
    %=====================================================================>
    %                      VYTVORENIE MATIC W1,W2,W3
    %=====================================================================>

    W1 = []; W2 = []; W3 = [];    
            % W1 => (10x9 = 90)
        for j = 9:9:90
            
            W1(end+1,:) = Pop(i,j-8:j);
          
        end
        
        % W2 => (10x10 = 100)
        for j = 91:10:190
            
            W2(end+1,:) = Pop(i,j-9:j);
                
        end
        
        % W3 => (1x10 = 10)
        for j = 191:10:200
            
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
            predosla_orientacia = orientacia;
            draha(pozicia(1,1),pozicia(1,2)) = draha(pozicia(1,1),pozicia(1,2)) + 1;
            
            [snimace, lidar] = kontrola_snimacov(pozicia,cesta,orientacia);
            snimace(end+1) = predosla_zmena;
             lidar(end+1) = predosla_zmena;
            
%             natocenie = neuronova_siet(W1,W2,W3,snimace);
            natocenie = neuronova_siet(W1,W2,W3,lidar);

            orientacia = aktualizacia_orientacia(natocenie,orientacia);
            
            [pokuta,posledna_zmena] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena);
            
            [riadok_draha,stlpec_draha] = pohyb(orientacia,pozicia);
            
            pozicia = [riadok_draha,stlpec_draha];

            if cesta(pozicia(1,1),pozicia(1,2)) == 1
                pokuta_vybocenie = 10000;
            else
                pokuta_vybocenie = -0.1;
            end
            
          pokuta_ciklus = 0;
            prejdenie_cp = 0;
            mansia_vzdialenost = 0;

            %pokuta ak sa zacikli
            for j = 1:length(predchadzajuce_kroky)
                if (predchadzajuce_kroky(1,j) == pozicia(1,1)) && (predchadzajuce_kroky(2,j) == pozicia(1,2))
                    pokuta_ciklus = pokuta_ciklus + 10000;
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
                mansia_vzdialenost = 1;
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

            pp = 1 + pp + pokuta + pokuta_vybocenie + pokuta_ciklus + pokuta_vzdialenost_od_cp - 100 * mansia_vzdialenost - prejdenie_cp * 5000;
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
figure(1)
plot(evolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');

%%

Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,best_draha,start,cesta,checkpoints)
% 
