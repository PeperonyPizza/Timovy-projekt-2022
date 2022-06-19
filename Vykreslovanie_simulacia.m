function [] = Vykreslovanie_simulacia(riadok_cesta,stlpec_cesta,pozicia1,pozicia2,draha,start,cesta,checkpoints,pocet_vozidiel)
%=========================================================================>
%               VYKRESLOVANIE SIMULACIA - Analógová forma
%=========================================================================>
% Táto funkcia je rovnaká pre diskrétnu aj analógovú formu pohybu robota.
%
% 
% VYKRESLOVANIE_SIMULACIA  Vykreslenie aktualnej polohy vozidiel/prekazok
%   [] = VYKRESLOVANIE_SIMULACIA(RIADOK_CESTA, STLPEC_CESTA, POZICIA1, POZICIA2, DRAHA, START, CESTA, CHECKPOINTS, POCET_VOZIDIEL)
%      RIADOK_CESTA, STLPEC_CESTA   rozmer prostredia n x m    
%      POZICIA1                     aktualna poloha vozidla 1 vektor [x, y]
%      POZICIA2                     aktualna poloha vozidla 2 vektor [x, y]
%      DRAHA                        trajektória vozidla
%      START                        startovacia poloha vozidla v tvare [x, y]
%      CESTA                        mapa prostredia
%      CHECKPOINTS                  poloha checkpointov
%      POCET_VOZIDIEL               pocet vozidiel (1 alebo 2)
%                           
%
% See also KONTROLA_SNIMACOV, NEURONOVA_SIET, AKTUALIZACIA_ORIENTACIA, 
%          KONTROLA_ZMENY_ORIENTAACIE, POHYB, GENETICKY_ALGORITMUS,
%          VYBER_TRASY, VYKRESLOVANIE, POHYBUJUCE_PREKAZKY.


    if pocet_vozidiel == 1
        % vytvorenie prostredia
        prostredie = zeros(riadok_cesta,stlpec_cesta,3);
        % Farba pozadia prostredia (biela)
        prostredie(:,:,1) = cesta*255;
        prostredie(:,:,2) = cesta*255;
        prostredie(:,:,3) = cesta*255;

        %%checkpointy
        for k=1:length(checkpoints)
            prostredie(checkpoints(1,k),checkpoints(2,k),1) = 0;
            prostredie(checkpoints(1,k),checkpoints(2,k),2) = 255;
            prostredie(checkpoints(1,k),checkpoints(2,k),3) = 0;
        end
        
        % Farba ciela (cervena)
        prostredie(pozicia1(1,1),pozicia1(1,2),1) = 255;
        prostredie(pozicia1(1,1),pozicia1(1,2),2) = 0;
        prostredie(pozicia1(1,1),pozicia1(1,2),3) = 0;
        
        % Zobrazenie prostredia 
        % I = imshow(uint8(prostredie));
        hold on
%         x=imresize(uint8(prostredie),([700 700]));
%         imshow(x);
%         image(imrotate(prostredie,180));
        image(imrotate(flip(prostredie,2),180));
    
    elseif pocet_vozidiel == 2
        % vytvorenie prostredia
        prostredie = zeros(riadok_cesta,stlpec_cesta,3);
        % Farba pozadia prostredia (biela)
        prostredie(:,:,1) = cesta*255;
        prostredie(:,:,2) = cesta*255;
        prostredie(:,:,3) = cesta*255;

        %%checkpointy
        for k=1:length(checkpoints)
            prostredie(checkpoints(1,k),checkpoints(2,k),1) = 0;
            prostredie(checkpoints(1,k),checkpoints(2,k),2) = 255;
            prostredie(checkpoints(1,k),checkpoints(2,k),3) = 0;
        end
        
        % Farba ciela (cervena)
        prostredie(pozicia2(1,1),pozicia2(1,2),1) = 210;
        prostredie(pozicia2(1,1),pozicia2(1,2),2) = 105;
        prostredie(pozicia2(1,1),pozicia2(1,2),3) = 30;
        
        prostredie(pozicia1(1,1),pozicia1(1,2),1) = 255;
        prostredie(pozicia1(1,1),pozicia1(1,2),2) = 0;
        prostredie(pozicia1(1,1),pozicia1(1,2),3) = 0;
        
        % Zobrazenie prostredia 
        % I = imshow(uint8(prostredie));
        hold on
%         x=imresize(uint8(prostredie),([700 700]));
%         imshow(x);
%         image(imrotate(prostredie,180));
        image(imrotate(flip(prostredie,2),180));
    end

end