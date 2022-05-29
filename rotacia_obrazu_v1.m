function [] = rotacia_obrazu_v1(start,cesta,checkpoints, pozicia, uhol,step)
% vytvorenie prostredia
[sirka,vyska] = size(cesta);
% 
% prostredie = zeros(sirka,vyska,3);
prostredie = zeros(sirka,vyska);

% 
% % Farba pozadia prostredia (biela)
% prostredie(:,:,1) = cesta*255;
% prostredie(:,:,2) = cesta*255;
% prostredie(:,:,3) = cesta*255;

prostredie(:,:) = cesta*255;

% % Farba startu (zelena)
% prostredie(start(1,1),start(1,2),1) = 0;
% prostredie(start(1,1),start(1,2),2) = 255;
% prostredie(start(1,1),start(1,2),3) = 0;
% 

% pozicia vozidla
% prostredie(pozicia(1,1),pozicia(1,2),1) = 0;
% prostredie(pozicia(1,1),pozicia(1,2),2) = 155;
% prostredie(pozicia(1,1),pozicia(1,2),3) = 155;

% prostredie=insertMarker(prostredie, [pozicia(2),pozicia(1)],'x','color','magenta');
% prostredie=insertMarker(prostredie, pozicia,'x','color','magenta');
% prostredie=insertMarker(prostredie, [1,1],'x','color','magenta');
% 

% %%checkpointy
% for k=1:length(checkpoints)
%     prostredie(checkpoints(1,k),checkpoints(2,k),1) = 0;
%     prostredie(checkpoints(1,k),checkpoints(2,k),2) = 255;
%     prostredie(checkpoints(1,k),checkpoints(2,k),3) = 0;
% end

% Zobrazenie prostredia 
% figure(2)

% vysek z mapy na zaklade orientacie a polohy
% % musia to byt neparne hodnoty
vysek_sirka = 31;
vysek_vyska = 21;
% vysek_sirka = 15;
% vysek_vyska = 11;
% vysek = zeros([vysek_sirka vysek_vyska]);

%% vypocet pozici pre Bresenham line algoritmus
%potrebujem si rozdelit obdlznik na ciary ktore viem potom davat na vstup
% bresemham algoritmu
% x_povodne = [];
% y_povodne = [];
% x_povodne(1) = pozicia(1) - round(vysek_sirka/2,0);
% y_povodne(1) = pozicia(2);
% x_povodne(2) = pozicia(1) + round(vysek_sirka/2,0) - 1 ;
% y_povodne(2) = pozicia(2) + vysek_vyska;

% %left down corner
% l_d = [pozicia(1) - round(vysek_sirka/2,0), pozicia(2)+ round(vysek_vyska/2);];
% %right down corner
% r_d = [pozicia(1) + round(vysek_sirka/2,0) - 1, pozicia(2)+ round(vysek_vyska/2)];
% %left up corner
% l_u = [pozicia(1) - round(vysek_sirka/2,0), pozicia(2) - (vysek_vyska/2) ];
% %right up corner
% r_u = [pozicia(1) + round(vysek_sirka/2,0) - 1, pozicia(2) - (vysek_vyska/2)];

% %left down corner
% l_d = [pozicia(1) - round(vysek_sirka*2-1), pozicia(2)+ round(vysek_sirka*2-1);];
% %right down corner
% r_d = [pozicia(1) + round(vysek_sirka*2-1), pozicia(2)+ round(vysek_sirka*2-1)];
% %left up corner
% l_u = [pozicia(1) - round(vysek_sirka*2-1), pozicia(2) - round(vysek_sirka*2-1) ];
% %right up corner
% r_u = [pozicia(1) + round(vysek_sirka*2-1) , pozicia(2) - round(vysek_sirka*2-1)];
% 

% %left down corner
% l_d = [pozicia(1) - round(vysek_sirka), pozicia(2) + round(vysek_vyska)];
% %right down corner
% r_d = [pozicia(1) + round(vysek_sirka), pozicia(2) + round(vysek_vyska)];
% %left up corner
% l_u = [pozicia(1) - round(vysek_sirka), pozicia(2) - round(vysek_vyska)];
% %right up corner
% r_u = [pozicia(1) + round(vysek_sirka), pozicia(2) - round(vysek_vyska)];

%left down corner
l_d = [pozicia(1) - round(vysek_sirka), pozicia(2) + round(vysek_vyska/2)-1];
%right down corner
r_d = [pozicia(1) , pozicia(2) + round(vysek_vyska/2)-1];
%left up corner
l_u = [pozicia(1) - round(vysek_sirka), pozicia(2) - round(vysek_vyska/2)-1];
%right up corner
r_u = [pozicia(1) , pozicia(2) - round(vysek_vyska/2)-1];

rohy =[l_d; r_d; l_u; r_u];

% rectangle_crop_coordinates_1 = min(rohy,[],1);

rectangle_crop_coordinates_1 =[min(rohy,[],1),vysek_sirka,vysek_vyska];

%Tu si vyratam kde sa nachadzaju rohy obdlznika po rotacii 
%left down corner rotated
l_d_r = rotacia_stvorca(l_d, pozicia, (uhol * pi)/180);
r_d_r = rotacia_stvorca(r_d, pozicia, (uhol * pi)/180);
l_u_r = rotacia_stvorca(l_u, pozicia, (uhol * pi)/180);
r_u_r = rotacia_stvorca(r_u, pozicia, (uhol * pi)/180);

rohy_r = [l_d_r; r_d_r; l_u_r; r_u_r];
max_coordinates_val = max(rohy_r,[],1);
min_coordinates_val = min(rohy_r,[],1);
w = max_coordinates_val(1)- min_coordinates_val(1);
h = max_coordinates_val(2)- min_coordinates_val(2);

% rectangle_crop_coordinates_2 = min(rohy_r(),[],1);
rectangle_crop_coordinates_2 = [min(rohy_r,[],1),w,h];

% rectangle_crop_coordinates = [min(rohy,[],1),max(rohy,[],1)];
%%
%origo prostredie
tiledlayout(4,2)
nexttile([4,1])

imshow(prostredie)
title('Povodne prostredie')
%%
% croped_image = imcrop(cesta,rectangle_crop_coordinates);
% imcrop(I,rect)
% rect = [xmin ymin width height] 
% rect = 
% croped_image = imcrop(prostredie,[rectangle_crop_coordinates_1, vysek_sirka, vysek_sirka ]);
croped_image = imcrop(prostredie,rectangle_crop_coordinates_1);
%cropnuty obrazok
nexttile
% imshow(croped_image*255)
imshow(croped_image)
title('startovaci pohlad(vozidlo v strede)')



%%
% croped_image = imcrop(cesta,rectangle_crop_coordinates);
croped_image = imcrop(prostredie,rectangle_crop_coordinates_2);
% croped_image = imcrop([rectangle_crop_coordinates_2, vysek_sirka, vysek_vyska*2]);

%cropnuty obrazok
nexttile
% imshow(croped_image*255)
imshow(croped_image)
title('Cropnuty obrazok')

%%
nexttile
% imshow(rotated_croped_image*255)
%orotovany obrazok
rotated_croped_image = imrotate(croped_image,uhol,'bilinear');
imshow(rotated_croped_image)
title('Cropnuty obrazok orotovany okolo vozidla')

%%

% 
% rotate_around_f_output=rotateAround(croped_image, pozicia(2), pozicia(1), uhol, 'bilinear');
% nexttile
% imshow(rotate_around_f_output)
% title('Cropnuty obrazok z inej funckie')
% 


%%

cropped_image_size = size(rotated_croped_image);


crop_x_coordinate = round((cropped_image_size(2) - vysek_sirka)/2);
crop_y_coordinate = round((cropped_image_size(1) - vysek_vyska)/2);

rectangle_mask = [crop_x_coordinate,crop_y_coordinate,...
                  vysek_sirka, vysek_vyska];

image = imcrop(rotated_croped_image,rectangle_mask);

image_size = size(image);
x_step=floor(image_size(1)/step);
y_step=floor(image_size(2)/step);

for (i=1:1:x_step)
    for (j=1:1:y_step)
        final_image(i,j)=image(i*step,j*step);
    end
end
nexttile
imshow(final_image)
title('Vysledny obrazok')

pause(0.001)

%spojim si body pomocou Bresenhamovho algoritmu a vytvorim nove ohranicenie
% [x,y] = bresenham(l_d_r, r_d_r);
% spodna_hranica = [x,y];
% [x,y] = bresenham(l_u_r, r_u_r);
% vrchna_hranica = [x,y];
% 
% suradnice=[];
% for l = 1:length(spodna_hranica)
%         [x, y] = bresenham(spodna_hranica(l,:), vrchna_hranica(l,:));
%         suradnice = [suradnice; [x, y]];
end

