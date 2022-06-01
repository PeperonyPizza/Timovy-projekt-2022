function [final_image] = rotacia_obrazu_v1_BW(cesta, pozicia, uhol, step, vykreslovanie)
% vytvorenie prostredia
[sirka,vyska] = size(cesta);
% 
% prostredie = zeros(sirka,vyska,3);
prostredie = zeros(sirka,vyska);


prostredie(:,:) = cesta*255;


% Zobrazenie prostredia 
% figure(2)

% vysek z mapy na zaklade orientacie a polohy
% % musia to byt neparne hodnoty
vysek_sirka = 31;
vysek_vyska = 21;
%%

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
croped_image = imcrop(prostredie,rectangle_crop_coordinates_1);
%cropnuty obrazok

%%
% croped_image = imcrop(cesta,rectangle_crop_coordinates);
croped_image = imcrop(prostredie,rectangle_crop_coordinates_2);
% croped_image = imcrop([rectangle_crop_coordinates_2, vysek_sirka, vysek_vyska*2]);

%cropnuty obrazok

%%

% imshow(rotated_croped_image*255)
%orotovany obrazok
rotated_croped_image = imrotate(croped_image,uhol,'bilinear');


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

if vykreslovanie == 1
    %origo prostredie
    tiledlayout(4,2)
    nexttile([4,1])

    imshow(prostredie)
    title('Povodne prostredie')
    
    nexttile
    % imshow(croped_image*255)
    imshow(croped_image)
    title('startovaci pohlad(vozidlo v strede)')

    nexttile
    % imshow(croped_image*255)
    imshow(croped_image)
    title('Cropnuty obrazok')

    nexttile
    imshow(rotated_croped_image)
    title('Cropnuty obrazok orotovany okolo vozidla')

    nexttile
    imshow(final_image)
    title('Vysledny obrazok')

    pause(0.001)
end



end

