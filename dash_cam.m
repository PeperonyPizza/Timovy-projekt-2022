
function [final_image] = dash_cam(start,cesta,checkpoints, pozicia, uhol)

% vytvorenie prostredia
[sirka,vyska] = size(cesta);

prostredie = zeros(sirka,vyska,3);

% Farba pozadia prostredia (biela)
prostredie(:,:,1) = cesta*255;
prostredie(:,:,2) = cesta*255;
prostredie(:,:,3) = cesta*255;

% Farba startu (zelena)
prostredie(start(1,1),start(1,2),1) = 0;
prostredie(start(1,1),start(1,2),2) = 255;
prostredie(start(1,1),start(1,2),3) = 0;

%%checkpointy
for k=1:length(checkpoints)
    prostredie(checkpoints(1,k),checkpoints(2,k),1) = 0;
    prostredie(checkpoints(1,k),checkpoints(2,k),2) = 255;
    prostredie(checkpoints(1,k),checkpoints(2,k),3) = 0;
end



% vysek z mapy na zaklade orientacie a polohy
% % musia to byt neparne hodnoty
vysek_sirka = 31;
vysek_vyska = 21;

%%
%obdlznik
%left down corner
l_d = [pozicia(1) - round(vysek_sirka), pozicia(2) + round(vysek_vyska/2)-1];
%right down corner
r_d = [pozicia(1) , pozicia(2) + round(vysek_vyska/2)-1];
%left up corner
l_u = [pozicia(1) - round(vysek_sirka), pozicia(2) - round(vysek_vyska/2)-1];
%right up corner
r_u = [pozicia(1) , pozicia(2) - round(vysek_vyska/2)-1];

rohy =[l_d; r_d; l_u; r_u];


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

% rectangle_crop_coordinates_2 = [min(rohy_r,[],1),w,h];

%%
% % origo prostredie
% tiledlayout(4,2)
% nexttile([4,1])
% 
% imshow(prostredie)
% title('Povodne prostredie')
%%
croped_image = imcrop(prostredie,rectangle_crop_coordinates_1);
%cropnuty obrazok
% nexttile
% % imshow(croped_image*255)
% imshow(croped_image)
% title('Cropnuty obrazok (vozidlo v strede)')



%%
% croped_image = imcrop(prostredie,rectangle_crop_coordinates_2);
%cropnuty obrazok
% nexttile
% imshow(croped_image)
% title('Cropnuty obrazok')

%%
% nexttile
%orotovany obrazok
rotated_croped_image = imrotate(croped_image,uhol,'bilinear');
% imshow(rotated_croped_image)
% title('Cropnuty obrazok orotovany okolo vozidla')

%%

cropped_image_size = size(rotated_croped_image);


crop_x_coordinate = round((cropped_image_size(2) - vysek_sirka)/2);
crop_y_coordinate = round((cropped_image_size(1) - vysek_vyska)/2);

rectangle_mask = [crop_x_coordinate,crop_y_coordinate,...
                  vysek_sirka, vysek_vyska];

img = imcrop(rotated_croped_image,rectangle_mask);
% nexttile
% imshow(image)

movingPoints = [1 1; size(img,2) 1; 1 size(img,1); size(img,2) size(img,1)];
% fixedPoints = [round(size(img,2)*2/5) 1; round(size(img,2)*3/5) 1; 1 100; size(img,2) 100];
fixedPoints = [round(size(img,2)*2/10) 1; round(size(img,2)*8/10) 1; 1 100; size(img,2) 100];

% fixedPoints = [1 1; size(img,2) 1; 1 200; size(img,2) 200];
tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');

%// Create a reference coordinate system where the extent is the size of
%// the image
RA = imref2d([size(img,1) size(img,2)], [1 size(img,2)], [1 size(img,1)]);

%// Warp the image
[out,r] = imwarp(img, tform, 'OutputView', RA);

%// Show the image and turn off the axes
% axis off;


% imshow(shaped_image)
% title('Vysledny obrazok')
final_image=out;

end

