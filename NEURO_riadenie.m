clc
clear
addpath("genetic")
%=========================================================================>
%               TRÉNOVANIE NEURÓNOVEJ SIETE - ANALÓGOVÁ FORMA
%=========================================================================>
%% %%%%%%%%%%%%%%%%%%   VOĽBA PARAMETROV GA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numgen = 250;             % počet generácii
lpop = 25;	            % počet chromozónov v populacii
lstring = 210;          % počet génov v chromozone (90+100+10)200
M = 1;                  % maximálny prehladávací priestor
min_pp=inf;             % pre hľadanie jedinca s najlepšou fit funkciou 
Space = [ones(1,lstring) * (-M); ones(1,lstring)]; % prehladavaci priestor
Delta = Space(2,:) / 50;% krok aditivnej mutacie

%% %%%%%%%%%%%%%%%%%%%%   NASTAVENIE MAPY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trasa_num = 2;          %vyber mapy: 1 = stvorec
                        %            2 = race track
                        %            3 = kruh
                        %            4 = osmicka
                        %            5 = sestuholnik
                        %            6 = race track_2
[start,cesta,checkpoints,prekazky] = vyber_trasy(trasa_num);
[riadok_cesta,stlpec_cesta] = size(cesta);

%% %%%%%%%%%%%%%   DĹŽKA POHYBU VOZIDLA PO DRÁHE  %%%%%%%%%%%%%%%%%%%%%%%%%                                          
kroky = 650;           % dt

%% %%%%%%%%%%%%   NASTAVENIE POHYBLIVÝCH PREKÁŽOK  %%%%%%%%%%%%%%%%%%%%%%%% 
prekazky_zapnute = 0;   % 0 = generovanie prekazok vypnute
                        % 1 = generovanie prekazok vypnute

%% %%%%%%%%%%%%%%%   INICIALIZÁCIA POPULÁCIE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NÁHODNÉ VYGENEROVANIE JEDINCOV
Pop = genrpop(lpop,Space);

%ODKOMENTOVAŤ PRE NAČíTANIE PREDTRÉNOVANEJ POPULÁCIE        
% Pop = load('pop');%genrpop(lpop,Space);
% Pop = Pop.Pop;

%%
%=========================================================================>
%           MAIN CYKLUS - cyklus pre jednotlivé generácie
%=========================================================================>

%pozeráme 10 krokov dozadu - aby sa vozidlo nezacyklilo na mieste
predchadzajuce_kroky = zeros(2,10);

for gen = 1:numgen
    if mod(gen,5) == 0 %zobrazenie poradia aktuálnej generácie GA
        disp(gen);
    end

    kolizie_s_prekazkamy = 0;   %pre ukladanie počtu kolízii pri trénovaní

    %% Skontrolovanie každého riešenia - každý jedinec z populácie
    for i = 1:lpop
        %% PREKAZKY - INICIALIZOVANIE PREKÁŽOK
    %     if mod(gen,20) == 0
    %         [start,cesta] = vyber_trasy(trasa_num);
    %     end
        if prekazky_zapnute == 1
            trasa_prekazky = zeros(150,150);
            new_pohybujuce_prekazky = prekazky;
            kolizie_s_prekazkamy = 0;
        end

        %% Vytvorenie váh pre NS (z najlepšieho jedinca natrenovanej populacie)
        %=====================================================================>
        %                      VYTVORENIE MATIC W1,W2,W3
        %=====================================================================>
        W1 = []; W2 = []; W3 = [];    
        for j = 10:10:100   % W1 => (10x9 = 90)
            W1(end+1,:) = Pop(i,j-9:j);
        end    
        for j = 101:10:200  % W2 => (10x10 = 100)
            W2(end+1,:) = Pop(i,j-9:j);   
        end     
        for j = 201:10:210  % W3 => (1x10 = 10)
            W3(end+1,:) = Pop(i,j-9:j); 
        end

        %% Pohyb vozidla       
        % Nastavenie zakladnych parametrov
        draha = zeros(riadok_cesta,stlpec_cesta); % ukladanie trajektorie vozidla
        pozicia = start;    % aktualna poloha vozidla
        orientacia = 15;    % natočenie - hodnota 0 až 15:
                            % smer po osi X/Y: 4 nahor, 8 doprava, 12 dole, 0 doľava
                            % smer po uhlopriečkach: 2,6,10,14
                            % ostatne - medzi uhloprieckou a osou: 1,3,5,7,9,11,13,15
        predosla_zmena = 0;
        pp = 0;             % pokutovanie

        checkpoint_pomoc = 4; % checkpoint ma dĺžku 8 pixelov (pri výpočte sa počíta z jeho stredom)
        old_pokuta_vzdialenost_od_cp = 0; % pre ukladanie vzdialenosti od checkpointu z predošlého kroku

        %POMOCNE PREMENNE PRE ODCITANIE/PRICITANIE K SURADNICI X/Y POLOHY ROBOTA
        %   PRI ORIENTACII - 1, 3, 5, 7, 9, 11, 13, 15
        subY21 = 0;
        addY41 = 0;
        subX12 = 0;
        addX14 = 0;
        subX52 = 0;
        addX54 = 0;
        subY25 = 0;
        addY45 = 0;
        %=================================================================>
        %                       SPUSTENIE ROBOTA
        %=================================================================>
        for k = 1:kroky
            %%% PREKAZKY - pohyb prekazok
            %            - pre staticke prekazky zakomentovat volanie funkcie
            %            pohybujuce_prekazky()
            if prekazky_zapnute == 1
                new_pohybujuce_prekazky = pohybujuce_prekazky(cesta,new_pohybujuce_prekazky,pozicia);
                for p = 1:2:length(new_pohybujuce_prekazky)
                    cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 1;%nastavenie prekazky
                end
            end 

            % uloženie smeru pohybu vozidla z predošlého kroku
            predosla_orientacia = orientacia;
            % ukladanie trajektorie pre vykreslenie
            draha(pozicia(1,1),pozicia(1,2)) = draha(pozicia(1,1),pozicia(1,2)) + 1;
            
            %ZÍSKANIE HODNôT Z LIDARU
            [lidar_16] = kontrola_snimacov(pozicia,cesta,orientacia);
            prvy = 1;
            %DO NS VSTUPUJÚ LEN LÚČE Z PREDNEJ ČASTI VOZIDLA (9 LÚČOV)
            lidar_16_predne = 0;
            for in = 1:9
                lidar_16_predne(in) = lidar_16(prvy);
                prvy = prvy+1;
            end
            lidar_16_predne(end+1) = predosla_zmena;
            lidar_16_predne = lidar_16_predne';

            %NS - VRACIA NOVÚ HODNOTU ZMENY ŽIADANÉHO NATOČENIA
            natocenie = neuronova_siet(W1,W2,W3,lidar_16_predne);

            %VYPOČÍTA SA NATOČENIE VOZIDLA NA ZÁKLADE ZMENY NATOČENIA
            orientacia = aktualizacia_orientacia(natocenie,orientacia);
            
            %PRÍPADNÉ POKUTOVANIE - PRI NEŽIADÚCEJ ZMENE SMERU POHYBU
            % vyuzivaju sa pomocne premenne subY,subX pre pohyb robota 
            [pokuta,posledna_zmena, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia,predosla_zmena, kroky,subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45);
            
            %VYKONANIE SAMOTNÉHO POHYBU VOZIDLA - NOVÁ POLOHA ROBOTA [X; Y]
            [riadok_draha,stlpec_draha, subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45] = pohyb(orientacia,pozicia,subY21,addY41, subX12, addX14, subX52,addX54,subY25,addY45);
            %ULOŽENIE POLOHY ROBOTA AKO VEKTOR 
            pozicia = [riadok_draha,stlpec_draha];
            %%
            %=============================================================>
            %                       POKUTOVANIE
            %=============================================================>
            %% POKUTOVANIE VYBOČENIA VOZIDLA Z DRÁHY
            if cesta(pozicia(1,1),pozicia(1,2)) == 1
                pokuta_vybocenie = 75000;
            else
                pokuta_vybocenie = -0.1; %ODMENA AK NEVYBOČÍ
            end
            
            %% POKUTOVANIE ZA ZACYKLENIE
            pokuta_cyklus = 0;
            prejdenie_cp = 0;
            mensia_vzdialenost = -10000;
            %pokuta ak sa zacykli
            for j = 1:length(predchadzajuce_kroky)
                if (predchadzajuce_kroky(1,j) == pozicia(1,1)) && (predchadzajuce_kroky(2,j) == pozicia(1,2))
                    pokuta_cyklus = pokuta_cyklus + 10000;
                end
            end
            % aktualizácia predchádzajúcich krokov
            for j = 1:(length(predchadzajuce_kroky)-1)
                predchadzajuce_kroky(1,j) = predchadzajuce_kroky(1,j+1);
                predchadzajuce_kroky(2,j) = predchadzajuce_kroky(2,j+1);
            end
            % uloženie aktuálnej polohy do predchadzajuce_kroky
            predchadzajuce_kroky(1,length(predchadzajuce_kroky)) = pozicia(1,1);
            predchadzajuce_kroky(2,length(predchadzajuce_kroky)) = pozicia(1,2);
            
            %% ODMEŇOVANIE ZA PRIBLÍŽENIE K CHECKPOINTU
            % výpočet vzdialenosti od checkpointu
            xdif = abs(pozicia(1,2)-checkpoints(2,checkpoint_pomoc));
            ydif = abs(pozicia(1,1)-checkpoints(1,checkpoint_pomoc));
            pokuta_vzdialenost_od_cp = sqrt((xdif)^2+(ydif)^2);
            % ak sa priblíži k nasledujúcemu checkpointu dostane bonus
            if old_pokuta_vzdialenost_od_cp > pokuta_vzdialenost_od_cp
                mensia_vzdialenost = 100000;
            end
            old_pokuta_vzdialenost_od_cp = pokuta_vzdialenost_od_cp;

            %% ODMEŇOVANIE ZA PRECHOD CHECKPOINTOM
            % bonus ak prejde cez checkpoint v poradí
            for j = checkpoint_pomoc-3:checkpoint_pomoc+4 %j = checkpoint_pomoc-1:checkpoint_pomoc+1
                if (pozicia(1,2) == checkpoints(2,j)) && (pozicia(1,1) == checkpoints(1,j))
                    prejdenie_cp = 1;
                    checkpoint_pomoc = checkpoint_pomoc + 8;
                    if checkpoint_pomoc > length(checkpoints)
                        checkpoint_pomoc = 4;
                    end
                end
            end

            %% KONTROLA KOLIZIE S PREKÁŽKAMI
            % Viktor s Mišom skúsia dorobiť aby prekážka išla dlhšie rovno a náhodne nezatáčala
            if prekazky_zapnute == 1
                for p = 1:2:length(new_pohybujuce_prekazky)
                if (new_pohybujuce_prekazky(p) == pozicia(1) && new_pohybujuce_prekazky(p+1) == pozicia(2))
                    kolizie_s_prekazkamy = kolizie_s_prekazkamy + 1;
                else
                    cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 0;%vynulovanie prekazky
                    trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1))+1;
                end
                
                end
            end

            %% VÝSLEDNÉ SPOČÍTANIE POKÚT
            pp = 1 + pp + pokuta + pokuta_vybocenie + pokuta_cyklus + pokuta_vzdialenost_od_cp - 100 * mensia_vzdialenost - prejdenie_cp * 500000;
        end

        %% uloženie najlepšieho riešenia (jedinca)
        Fit(i) = pp;
        if min_pp>pp
            min_pp=pp;
            best_draha=draha;
            best_pozicia=pozicia;
%             best_W=[W1,W2,W3];
        end
        
    end
    evolution(gen) = min(Fit);
    %% GA pre optimalizáciu riešenia 
    Pop = geneticky_algoritmus(Pop,Fit,Space,Delta);
 
end

%% VYHODNOTENIE TRÉNOVANIA NS
%=========================================================================>
%                   ZOBRAZENIE VYSLEDKOV TRÉNOVANIA
%=========================================================================>
kolizie_s_prekazkamy
% Najlepsie riesenie - vykreslenie
figure(1)
plot(evolution) 

title('Evolúcia');
xlabel('Generácie');
ylabel('Fitnes');

Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,best_draha,start,cesta,checkpoints)
if prekazky_zapnute == 1
    Vykreslovanie(riadok_cesta,stlpec_cesta,best_pozicia,trasa_prekazky,start,cesta,checkpoints)
end

save('NS_premenne-vystup_Trenovania')