% clc
% clear
addpath("genetic")
%=========================================================================>
%               SIMULÁCIA NATRÉNOVANEJ NS - ANALÓGOVÁ FORMA
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
pocet_vozidiel = 2;        %(1 alebo 2)

%% %%%%%%%%%%%%%%%%%%%   ZOBRAZENIE ANIMACIE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
animacia = 1;       %(0 - zastavene, 1 - pustene)

%% %%%%%%%%%%%%%%   NASTAVENIE POHYBLIVYCH PREKAZOK  %%%%%%%%%%%%%%%%%%%%%%   
prekazky_zapnute = 0;      %vyber mapy: 0 = generovanie prekazok vypnute
                           %            1 = generovanie prekazok vypnute

%% %%%%%%%%%%%%%%%%%%%%%   DĹŽKA SIMULÁCIE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                            
kroky = 1300;        %dt
%% %%%%%%%%   POUŽITIE NATRÉNOVANÉHO JEDINCA Z POPULÁCIE  %%%%%%%%%%%%%%%%% 
% Pop = load('pop'); %využíva sa len najlepší jedinec (1. z populácie)
% Pop = Pop.Pop;

if(trasa_num == 1)  %stvorec
    prekazky = [41 118, 38 98, 40 78, 42 36, 70 34, 110 46, 112 86, 112 106, 99 116, 79 117, 59 114];
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
        W11 = []; W12 = []; W2 = []; W3 = [];    
            
        for j = 10:10:200                             
            W11(end+1,:) = Pop(j-9:j);          
        end       
        % W2 => (10x10 = 100)
        for j = 201:24:680            
            W12(end+1,:) = Pop(j-23:j);               
        end      
        for j = 681:20:880
            W2(end+1,:) = Pop(j-19:j);              
        end       
        % W3 => (1x10 = 10)
        for j = 881:10:890
            W3(end+1,:) = Pop(j-9:j);     
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
orientacia_1 = 15;
orientacia_2 = 15;
predosla_zmena = 0;

%POMOCNE PREMENNE PRE ODCITANIE/PRICITANIE K SURADNICI X/Y POLOHY ROBOTA
%   PRI ORIENTACII - 1, 3, 5, 7, 9, 11, 13, 15
% PRE VOZIDLO 1
subY21_1 = 0;
addY41_1 = 0;
subX12_1 = 0;
addX14_1 = 0;
subX52_1 = 0;
addX54_1 = 0;
subY25_1 = 0;
addY45_1 = 0;
% PRE VOZIDLO 2
subY21_2 = 0;
addY41_2 = 0;
subX12_2 = 0;
addX14_2 = 0;
subX52_2 = 0;
addX54_2 = 0;
subY25_2 = 0;
addY45_2 = 0;

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
        predosla_orientacia_1 = orientacia_1;
        draha_1(pozicia_1(1,1),pozicia_1(1,2)) = draha_1(pozicia_1(1,1),pozicia_1(1,2)) + 1;

        %ZÍSKANIE HODNôT Z LIDARU    
        [lidar_16_1] = kontrola_snimacov(pozicia_1,cesta,orientacia_1);
        prvy = 1;
        %DO NS VSTUPUJÚ LEN LÚČE Z PREDNEJ ČASTI VOZIDLA (9 LÚČOV)
        lidar_16_predne_1 = 0;
        for in = 1:9
            lidar_16_predne_1(in) = lidar_16_1(prvy);
            prvy = prvy+1;
        end
        lidar_16_predne_1(end+1) = predosla_zmena;    
        lidar_16_predne_1 = lidar_16_predne_1';
        
         stupne_pre_kameru=orientacia_na_stupne(orientacia_1);
            try
                %ziskane obrazu ako vstup pre NS
                neuro_imput_image=rotacia_obrazu_v1_BW(cesta,[pozicia(2),pozicia(1)], stupne_pre_kameru, 5,0);
                if sum(size(neuro_imput_image))~=10
                      neuro_imput_image = ones([4 6])*255;
                end
            catch
                neuro_imput_image = ones([4 6])*255;
            end
            
            neuro_image_vector=[];            
            
            %[rows_im,collums_im]=size(neuro_imput_image);
            
            %vektor vstupov z obrazu pre NS
            for placement=1:size(neuro_imput_image,1)
                neuro_image_vector=[neuro_image_vector neuro_imput_image(placement,:)];
            end
            
            %uistenie sa ci vstupuje spravny vektor do NS
            if size(neuro_image_vector)<24
                neuro_image_vector=ones(1,24)*255;
            end
        
        %NS - VRACIA NOVÚ HODNOTU ZMENY ŽIADANÉHO NATOČENIA
        natocenie_1 = neuronova_siet(W11,W12,W2,W3,lidar_16_predne_1,(neuro_image_vector)');

        %VYPOČÍTA SA NATOČENIE VOZIDLA NA ZÁKLADE ZMENY NATOČENIA
        orientacia_1 = aktualizacia_orientacia(natocenie_1,orientacia_1);
                
        %Pokuta, posledna_zmena - nevyuziva sa
        %vyuzivaju sa pomocne premenne subY,subX pre pohyb robota 
        [pokuta,posledna_zmena, subY21_1,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1] = kontrola_zmeny_orientaacie(predosla_orientacia_1,orientacia_1,predosla_zmena, kroky,subY21_1,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1);
        
        %VYKONANIE SAMOTNÉHO POHYBU VOZIDLA - NOVÁ POLOHA ROBOTA [X; Y]
        [riadok_draha,stlpec_draha, subY21_1 ,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1] = pohyb(orientacia_1,pozicia_1,subY21_1,addY41_1, subX12_1, addX14_1, subX52_1,addX54_1,subY25_1,addY45_1);
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
        cesta(pozicia_2_prev(1), pozicia_2_prev(2)) = cesta_prev_2; %vynulovanie prekazky z predchadzajuceho kroku
        predosla_orientacia = orientacia_2;
        draha_2(pozicia_2(1,1),pozicia_2(1,2)) = draha_2(pozicia_2(1,1),pozicia_2(1,2)) + 1;
            
        %ZÍSKANIE HODNôT Z LIDARU    
        [lidar_16] = kontrola_snimacov(pozicia_2,cesta,orientacia_2);
        prvy = 1;
        %DO NS VSTUPUJÚ LEN LÚČE Z PREDNEJ ČASTI VOZIDLA (9 LÚČOV)
        lidar_16_predne = 0;
        for in = 1:9
            lidar_16_predne(in) = lidar_16(prvy);
            prvy = prvy+1;
        end
        lidar_16_predne(end+1) = predosla_zmena;
        lidar_16_predne = lidar_16_predne';
           
        %%
            %%% Synteticka kamera
            %vypocet stupnov s hodnoty natocennia
            stupne_pre_kameru=orientacia_na_stupne(orientacia_2);
            try
                %ziskane obrazu ako vstup pre NS
                neuro_imput_image=rotacia_obrazu_v1_BW(cesta,[pozicia(2),pozicia(1)], stupne_pre_kameru, 5,0);
                if sum(size(neuro_imput_image))~=10
                      neuro_imput_image = ones([4 6])*255;
                end
            catch
                neuro_imput_image = ones([4 6])*255;
            end
            
            neuro_image_vector=[];            
            
            %[rows_im,collums_im]=size(neuro_imput_image);
            
            %vektor vstupov z obrazu pre NS
            for placement=1:size(neuro_imput_image,1)
                neuro_image_vector=[neuro_image_vector neuro_imput_image(placement,:)];
            end
            
            %uistenie sa ci vstupuje spravny vektor do NS
            if size(neuro_image_vector)<24
                neuro_image_vector=ones(1,24)*255;
            end
%%            
            
        %NS - VRACIA NOVÚ HODNOTU ZMENY ŽIADANÉHO NATOČENIA
        natocenie_2 = neuronova_siet(W11,W12,W2,W3,lidar_16_predne,(neuro_image_vector)');

        %VYPOČÍTA SA NATOČENIE VOZIDLA NA ZÁKLADE ZMENY NATOČENIA
        orientacia_2 = aktualizacia_orientacia(natocenie_2,orientacia_2);

        %Pokuta, posledna_zmena - nevyuziva sa
        %vyuzivaju sa pomocne premenne subY,subX pre pohyb robota             
        [pokuta,posledna_zmena, subY21_2,addY41_2, subX12_2, addX14_2, subX52_2,addX54_2,subY25_2,addY45_2] = kontrola_zmeny_orientaacie(predosla_orientacia,orientacia_2,predosla_zmena, kroky,subY21_2,addY41_2, subX12_2, addX14_2, subX52_2,addX54_2,subY25_2,addY45_2);
            
        %VYKONANIE SAMOTNÉHO POHYBU VOZIDLA - NOVÁ POLOHA ROBOTA [X; Y]
        [riadok_draha,stlpec_draha, subY21_2,addY41_2, subX12_2, addX14_2, subX52_2,addX54_2,subY25_2,addY45_2] = pohyb(orientacia_2,pozicia_2,subY21_2,addY41_2, subX12_2, addX14_2, subX52_2,addX54_2,subY25_2,addY45_2);
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
    figure(1)
    tiledlayout(2,2);
    if animacia == 1
        nexttile([2,1]);        
        Vykreslovanie_simulacia(riadok_cesta,stlpec_cesta,pozicia_1,pozicia_2,draha_1,start,cesta,checkpoints,pocet_vozidiel)
        title('Mapa')
        axis off;

        nexttile;
        
        image(dash_cam(start,cesta,checkpoints, pozicia_1, orientacia_na_stupne(orientacia_1)))
        title('Vozidlo 1')
        axis off;
        nexttile;
        
        image(dash_cam(start,cesta,checkpoints, pozicia_2, orientacia_na_stupne(orientacia_2)))
        title('Vozidlo 2')
        axis off;
    end
    pause(0.01)

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
%TRAJEKTÓRIA PREKÁŽOK
if prekazky_zapnute == 1
    Vykreslovanie(riadok_cesta,stlpec_cesta,pozicia_1,trasa_prekazky,start,cesta,checkpoints)
end