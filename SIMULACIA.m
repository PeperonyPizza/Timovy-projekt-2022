clc
clear
addpath("genetic")
%=========================================================================>
%           SIMULÁCIA NATRÉNOVANEJ NS - DISKRÉTNA FORMA
%=========================================================================>

%% %%%%%%%%%%%%%%%%%%%%   NASTAVENIE MAPY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trasa_num = 2;      %vyber mapy: 1 = stvorec
                    %            2 = race track
                    %            3 = kruh
                    %            4 = osmicka
                    %            5 = sestuholnik
                    %            6 = race track_2
[start,cesta,checkpoints,prekazky] = vyber_trasy(trasa_num);
[riadok_cesta,stlpec_cesta] = size(cesta);

%% %%%%%%%%%%%%%%%%%   NASTAVENIE POČTU AUTÍČOK  %%%%%%%%%%%%%%%%%%%%%%%%%%                    
pocet_vozidiel = 1;        %(1 alebo 2)

%% %%%%%%%%%%%%%%%%%%%   ZOBRAZENIE ANIMACIE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
animacia = 1;       %(0 - zastavene, 1 - pustene)

%% %%%%%%%%%%%%%%   NASTAVENIE POHYBLIVYCH PREKAZOK  %%%%%%%%%%%%%%%%%%%%%%   
prekazky_zapnute = 0;      %vyber mapy: 0 = generovanie prekazok vypnute
                           %            1 = generovanie prekazok vypnute

%% %%%%%%%%%%%%%%%%%%%%%   DĹŽKA SIMULÁCIE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                            
kroky = 650;        %dt
%% %%%%%%%%   POUŽITIE NATRÉNOVANÉHO JEDINCA Z POPULÁCIE  %%%%%%%%%%%%%%%%% 
Pop = load('pop'); %využíva sa len najlepší jedinec (1. z populácie)
Pop = Pop.Pop;

if(trasa_num == 1)  %stvorec
    prekazky = [41 118, 93 30, 93 31,38 98, 40 78, 42 36, 70 34, 110 46, 112 86, 112 106, 99 116, 79 117, 59 114]; 
elseif(trasa_num == 2)  %race track
    prekazky = [25 48 22 15 9 33 37 18 117 6 111 65 77 115 25 110];
elseif(trasa_num == 3) %kruh
    prekazky = [75 26 122 75 75 126 24 75];
elseif(trasa_num == 4)  %osmicka
    prekazky = [41 45 94 37 104 88 45 113];
elseif(trasa_num == 5)  %sestuholnik
    prekazky = [75 26 122 75 75 119 24 75];
elseif(trasa_num == 6)  %race track_2
    prekazky = [36 60 14 17 119 4 110 63 105 138 23 120];
end

%% PREKAZKY - INICIALIZOVANIE PREKÁŽOK
if prekazky_zapnute == 1
    trasa_prekazky = zeros(150,150);
    new_pohybujuce_prekazky = prekazky;
    kolizie_s_prekazkamy = 0;
end
%% Vytvorenie váh pre NS (z najlepšieho jedinca natrenovanej populacie)
%=========================================================================>
%                      VYTVORENIE MATIC W1,W2,W3
%=========================================================================>
W1 = []; W2 = []; W3 = [];  
for j = 10:10:100   % W1 => (10x9 = 90)                              
    W1(end+1,:) = Pop(1,j-9:j);
end
for j = 101:10:200  % W2 => (10x10 = 100)
    W2(end+1,:) = Pop(1,j-9:j);
end
for j = 201:10:210  % W3 => (1x10 = 10)
    W3(end+1,:) = Pop(1,j-9:j);
end

%% Pohyb vozidiel/prekážok       
kolizia_vozidiel = 0;

% Nastavenie zakladnych parametrov
draha_1 = zeros(riadok_cesta,stlpec_cesta);
draha_2 = zeros(riadok_cesta,stlpec_cesta);

%AKTUALNA POZICIA
pozicia_1 = start;
pozicia_2 = start;

%PREDCHADZAJUCE POLOHY
pozicia_1_prev = start;
pozicia_2_prev = start;

%PREDCHADZAJUCA HODNOTA CESTA
cesta_prev_1 = 0; % pre auto 1
cesta_prev_2 = 0; % pre auto 2

%NATOČENIE VOZIDLA 1,2
orientacia_1 = 3;
orientacia_2 = 3;

predosla_zmena = 0;
%=========================================================================>
%                          SPUSTENIE ROBOTA/ROBOTOV
%=========================================================================>
for k = 1:kroky

    %%% PREKAZKY - pohyb prekazok
    %            - pre staticke prekazky zakomentovat volanie funkcie
    %            pohybujuce_prekazky()
    if prekazky_zapnute == 1
%   new_pohybujuce_prekazky = pohybujuce_prekazky(cesta,new_pohybujuce_prekazky,pozicia);
        for p = 1:2:length(new_pohybujuce_prekazky)
            cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 1;%nastavenie prekazky
        end
    end
    %%%

    %=====================================================================>
    %                          POHYB PRVEHO VOZIDLA
    %=====================================================================>
    if(mod(k,2)==1)

        %VYNULOVANIE PREKÁŽKY Z PREDCHÁDZAJÚCEHO KROKU
        pozicia_1_prev(1) = pozicia_1(1,1);
        pozicia_1_prev(2) = pozicia_1(1,2);
        cesta(pozicia_1_prev(1), pozicia_1_prev(2)) = cesta_prev_1;
        predosla_orientacia = orientacia_1;
        draha_1(pozicia_1(1,1),pozicia_1(1,2)) = draha_1(pozicia_1(1,1),pozicia_1(1,2)) + 1;

        %ZÍSKANIE HODNôT Z LIDARU
        [lidar_16] = kontrola_snimacov(pozicia_1,cesta,orientacia_1);
        prvy = 1;
        %DO NS VSTUPUJÚ LEN LÚČE Z PREDNEJ ČASTI VOZIDLA (9 LÚČOV)
        lidar_16_predne_1 = 0;
        for in = 1:9
            lidar_16_predne_1(in) = lidar_16(prvy);
            prvy = prvy+1;
        end
        lidar_16_predne_1(end+1) = predosla_zmena;
        lidar_16_predne_1 = lidar_16_predne_1';

        %NS - VRACIA NOVÚ HODNOTU ZMENY ŽIADANÉHO NATOČENIA
        natocenie = neuronova_siet(W1,W2,W3,lidar_16_predne_1);

        %VYPOČÍTA SA NATOČENIE VOZIDLA NA ZÁKLADE ZMENY NATOČENIA
        orientacia_1 = aktualizacia_orientacia(natocenie,orientacia_1);

        %VYKONANIE SAMOTNÉHO POHYBU VOZIDLA - NOVÁ POLOHA ROBOTA [X; Y]
        [riadok_draha,stlpec_draha] = pohyb(orientacia_1,pozicia_1);
        %ULOŽENIE POLOHY ROBOTA AKO VEKTOR  
        pozicia_1 = [riadok_draha,stlpec_draha];

        %ZAPÍSANIE POLOHY VOZIDLA DO MAPY (ABY HO DRUHÉ VOZIDLO VIDELO AKO PREKÁŽKU)
        cesta_prev_1 = cesta(pozicia_1(1), pozicia_1(2));
        cesta(pozicia_1(1), pozicia_1(2)) = 1;     
    end
    %=====================================================================>
    %                          POHYB DRUHEHO VOZIDLA
    %=====================================================================>
    if(k > 60 && pocet_vozidiel == 2)
        
        %VYNULOVANIE PREKÁŽKY Z PREDCHÁDZAJÚCEHO KROKU
        pozicia_2_prev(1) = pozicia_2(1,1);
        pozicia_2_prev(2) = pozicia_2(1,2);
        cesta(pozicia_2_prev(1), pozicia_2_prev(2)) = cesta_prev_2; 
        predosla_orientacia_2 = orientacia_2;
        draha_2(pozicia_2(1,1),pozicia_2(1,2)) = draha_2(pozicia_2(1,1),pozicia_2(1,2)) + 1;

        %ZÍSKANIE HODNôT Z LIDARU
        [lidar_16_2] = kontrola_snimacov(pozicia_2,cesta,orientacia_2);
        prvy = 1;
        %DO NS VSTUPUJÚ LEN LÚČE Z PREDNEJ ČASTI VOZIDLA (9 LÚČOV)
        lidar_16_predne_2 = 0;
        for in = 1:9
            lidar_16_predne_2(in) = lidar_16_2(prvy);
            prvy = prvy+1;
        end
        lidar_16_predne_2(end+1) = predosla_zmena;
        lidar_16_predne_2 = lidar_16_predne_2';

        %NS - VRACIA NOVÚ HODNOTU ZMENY ŽIADANÉHO NATOČENIA
        natocenie_2 = neuronova_siet(W1,W2,W3,lidar_16_predne_2);

        %VYPOČÍTA SA NATOČENIE VOZIDLA NA ZÁKLADE ZMENY NATOČENIA
        orientacia_2 = aktualizacia_orientacia(natocenie_2,orientacia_2);
        
        %VYKONANIE SAMOTNÉHO POHYBU VOZIDLA - NOVÁ POLOHA ROBOTA [X; Y]
        [riadok_draha,stlpec_draha] = pohyb(orientacia_2,pozicia_2);
        %ULOŽENIE POLOHY ROBOTA AKO VEKTOR     
        pozicia_2 = [riadok_draha,stlpec_draha];

        %ZAPÍSANIE POLOHY VOZIDLA DO MAPY (ABY HO DRUHÉ VOZIDLO VIDELO AKO PREKÁŽKU)
        cesta_prev_2 = cesta(pozicia_2(1), pozicia_2(2));
        cesta(pozicia_2(1), pozicia_2(2)) = 1;
        
        %KONTROLA KOLÍZIE S DRUHÝM VOZIDLOM
        if(pozicia_1(1) == pozicia_2(1) && pozicia_1(2) == pozicia_2(2))
            kolizia_vozidiel = kolizia_vozidiel + 1;
        end
    end
    %=====================================================================>
    %                          ANIMACIA POHYBU
    %=====================================================================>
    %TRAJEKTÓRIA SA PRE KAŽDÉ VOZIDLO VYKRESLUJE ZVLÁŠŤ
    if animacia == 1
        Vykreslovanie_simulacia(riadok_cesta,stlpec_cesta,pozicia_1,pozicia_2,draha_1,start,cesta,checkpoints,pocet_vozidiel)
    end

    %KONTROLA KOLIZIE S PREKÁŽKAMI
    if prekazky_zapnute == 1
        for p = 1:2:length(new_pohybujuce_prekazky)
            if (new_pohybujuce_prekazky(p) == pozicia_1(1) && new_pohybujuce_prekazky(p+1) == pozicia_1(2))
                kolizie_s_prekazkamy = kolizie_s_prekazkamy + 1;
            end
                trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1))+1;
%                 cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 0;%vynulovanie prekazky
        end
    end
end
%% Vypísanie počtu kolízii s druhým vozidlom/prekážkami, vykreslenie trajektórii
%=========================================================================>
%                   ZOBRAZENIE VYSLEDKOV SIMULACIE
%=========================================================================>
if prekazky_zapnute == 1
    kolizie_s_prekazkamy
end
    kolizia_vozidiel

%TRAJEKTÓRIA SA PRE KAŽDÉ VOZIDLO VYKRESLUJE ZVLÁŠŤ
Vykreslovanie(riadok_cesta,stlpec_cesta,pozicia_1,draha_1,start,cesta,checkpoints)
if(pocet_vozidiel == 2)
    Vykreslovanie(riadok_cesta,stlpec_cesta,pozicia_2,draha_2,start,cesta,checkpoints)
end