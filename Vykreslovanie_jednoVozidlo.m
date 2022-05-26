function [] = Vykreslovanie_jednoVozidlo(riadok_cesta,stlpec_cesta,pozicia1,pozicia,draha,start,cesta,checkpoints)


% vytvorenie prostredia


prostredie = zeros(riadok_cesta,stlpec_cesta,3);

% Farba pozadia prostredia (biela)
prostredie(:,:,1) = cesta*255;
prostredie(:,:,2) = cesta*255;
prostredie(:,:,3) = cesta*255;

pole = draha > 0;
pole = pole*255;

% Farba drahy (cervena)
% prostredie(:,:,1) = prostredie(:,:,1) + pole;
% prostredie(:,:,2) = prostredie(:,:,2) - pole;
% prostredie(:,:,3) = prostredie(:,:,3) - pole;

% Farba startu (zelena)
% prostredie(start(1,1),start(1,2),1) = 0;
% prostredie(start(1,1),start(1,2),2) = 255;
% prostredie(start(1,1),start(1,2),3) = 0;

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
figure(1)
% I = imshow(uint8(prostredie));
hold on
x=imresize(uint8(prostredie),([700 700]));
imshow(x);
% pause(0.5);
end