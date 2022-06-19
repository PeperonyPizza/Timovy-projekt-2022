function [Fit,best_pozicia,best_draha,Pop,sumpp,sumpokuta,sumpokuta_vybocenie,sumpokuta_cyklus,sumpokuta_vzdialenost_od_cp,summensia_vzdialenost,sumprejdenie_cp,sumpokuta_obraz] = simulacia_jazdy_pokuty(Pop,prekazky_zapnute,riadok_cesta,stlpec_cesta,kroky,predchadzajuce_kroky,start,cesta,checkpoints,prekazky,min_pp,i)
        %% PREKAZKY - INICIALIZOVANIE PREKÁŽOK

        %% Vytvorenie váh pre NS (z najlepšieho jedinca natrenovanej populacie)
        %=====================================================================>
        %                      VYTVORENIE MATIC W1,W2,W3
        %=====================================================================>
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

        %% Pohyb vozidla       
        % Nastavenie zakladnych parametrov
        draha = zeros(riadok_cesta,stlpec_cesta); % ukladanie trajektorie vozidla
        pozicia = start;    % aktualna poloha vozidla
        orientacia = 0;    % natočenie - hodnota 0 až 15:
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
        
            sumpokuta=zeros(kroky);
            sumpokuta_vybocenie=zeros(kroky);
            sumpokuta_cyklus=zeros(kroky);
            sumpokuta_vzdialenost_od_cp=zeros(kroky);
            summensia_vzdialenost =zeros(kroky);
            sumprejdenie_cp=zeros(kroky);
            sumpokuta_obraz=zeros(kroky);
            sumpp=zeros(kroky);
            

        %=================================================================>
        %                       SPUSTENIE ROBOTA
        %=================================================================>
        for k = 1:kroky
           pokuta_obraz = 0;

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
            
%%
            %%% Synteticka kamera
            %vypocet stupnov s hodnoty natocennia
            stupne_pre_kameru=orientacia_na_stupne(orientacia);
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
            natocenie = neuronova_siet(W11,W12,W2,W3,lidar_16_predne,(neuro_image_vector)');


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
            

 %% POKUTOVANIE VYBOČENIA VOZIDLA Z DRÁHY
            if cesta(pozicia(1,1),pozicia(1,2)) == 1
                pokuta_vybocenie = 10000+pokuta_vybocenie;
            else
                pokuta_vybocenie = -2000; %ODMENA AK NEVYBOČÍ
            end
            
            %% POKUTOVANIE ZA ZACYKLENIE
            pokuta_cyklus = 0;
            prejdenie_cp = 0;
            mensia_vzdialenost = +25000;
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
            
            mensia_vzdialenost = +5000;

            
            %% ODMEŇOVANIE ZA PRIBLÍŽENIE K CHECKPOINTU
            % výpočet vzdialenosti od checkpointu
            xdif = abs(pozicia(1,2)-checkpoints(2,checkpoint_pomoc));
            ydif = abs(pozicia(1,1)-checkpoints(1,checkpoint_pomoc));
            pokuta_vzdialenost_od_cp = sqrt((xdif)^2+(ydif)^2);
            % ak sa priblíži k nasledujúcemu checkpointu dostane bonus
            if old_pokuta_vzdialenost_od_cp > pokuta_vzdialenost_od_cp
                mensia_vzdialenost = -2000;
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
                    end
                    cesta(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = 0;%vynulovanie prekazky
                    trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1)) = trasa_prekazky(new_pohybujuce_prekazky(p),new_pohybujuce_prekazky(p+1))+1;
                end
            end

            
%             for pixel=1:size(neuro_image_vector)
%                if  neuro_image_vector(pixel)== 255
%                    pokuta_obraz = pokuta_obraz + 500;
%                else     
%                    pokuta_obraz = pokuta_obraz - 1000;
%                end
%             end
%             
            
%             for riadky=1:4
%                 for stlpce=1:6
%                     if  neuro_imput_image(riadky,stlpce)== 255
%                        pokuta_obraz = pokuta_obraz + 200*stlpce;
%                     else     
%                        pokuta_obraz = pokuta_obraz - 800*stlpce;
%                     end
%                 end
%             end


            %% VÝSLEDNÉ SPOČÍTANIE POKÚT
            pp = 1000 + pp + pokuta + pokuta_vybocenie + pokuta_cyklus + (pokuta_vzdialenost_od_cp) + mensia_vzdialenost - (prejdenie_cp * 10000) ;
            
            sumpp(k) = pp;
            sumpokuta(k) = pokuta;
            sumpokuta_vybocenie(k) = pokuta_vybocenie;
            sumpokuta_cyklus(k)= pokuta_cyklus;
            sumpokuta_vzdialenost_od_cp(k) = pokuta_vzdialenost_od_cp*50;
            summensia_vzdialenost(k) =  mensia_vzdialenost;
            sumprejdenie_cp(k) = - prejdenie_cp * 10000;
            sumpokuta_obraz(k) =  pokuta_obraz;
            
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

