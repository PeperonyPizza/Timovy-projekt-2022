
function [image] = dash_cam(start,cesta,checkpoints, pozicia, uhol)
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





% Zobrazenie prostredia 
% figure(2)

% vysek z mapy na zaklade orientacie a polohy
% musia to byt neparne hodnoty
vysek_sirka =21;
vysek_vyska =31;
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

%left down corner
l_d = [pozicia(1) - round(vysek_sirka/2,0), pozicia(2);];
%right down corner
r_d = [pozicia(1) + round(vysek_sirka/2,0) - 1, pozicia(2)];
%left up corner
l_u = [pozicia(1) - round(vysek_sirka/2,0), pozicia(2) + vysek_vyska];
%right up corner
r_u = [pozicia(1) + round(vysek_sirka/2,0) - 1, pozicia(2) + vysek_vyska];
rohy =[l_d; r_d; l_u; r_u];

%Tu si vyratam kde sa nachadzaju rohy obdlznika po rotacii 
%left down corner rotated
l_d_r = rotacia_stvorca(l_d, pozicia, uhol);
r_d_r = rotacia_stvorca(r_d, pozicia, uhol);
l_u_r = rotacia_stvorca(l_u, pozicia, uhol);
r_u_r = rotacia_stvorca(r_u, pozicia, uhol);

rohy_r = [l_d_r; r_d_r; l_u_r; r_u_r];
max_coordinates_val = max(rohy_r,[],1);
min_coordinates_val = min(rohy_r,[],1);
rectangle_crop_coordinates = [min(rohy_r,[],1),max(rohy_r,[],1)];
% rectangle_crop_coordinates = [min(rohy,[],1),max(rohy,[],1)];

croped_image = imcrop(cesta,[rectangle_crop_coordinates]);
imshow(croped_image*255)
rotated_croped_image = imrotate(croped_image,uhol,'bilinear');
imshow(rotated_croped_image*255)
%spojim si body pomocou Bresenhamovho algoritmu a vytvorim nove ohranicenie
[x,y] = bresenham(l_d_r, r_d_r);
spodna_hranica = [x,y];
[x,y] = bresenham(l_u_r, r_u_r);
vrchna_hranica = [x,y];

suradnice=[];
for l = 1:length(spodna_hranica)
        [x, y] = bresenham(spodna_hranica(l,:), vrchna_hranica(l,:));
        suradnice = [suradnice; [x, y]];
        
end

hold off
plot(spodna_hranica(:,1),spodna_hranica(:,2),'sr','MarkerSize',20)
hold on
plot(vrchna_hranica(:,1),vrchna_hranica(:,2),'sr','MarkerSize',20)
plot(suradnice(:,1),suradnice(:,2),'--gs',...
    'LineWidth',0.1,...
    'MarkerSize',20,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
plot(l_d_r(1),l_d_r(2),'ob')
plot(r_d_r(1),r_d_r(2),'ob')
plot(l_u_r(1),l_u_r(2),'ob')
plot(r_u_r(1),r_u_r(2),'ob')
grid on;


vysek = cesta(pozicia(1) - round(vysek_sirka/2,0): pozicia(1) - round(vysek_sirka/2,0) + vysek_sirka, pozicia(2):pozicia(2) + vysek_vyska);

vysek = rot90(vysek,3);
%zvetsenie rozllisenia vyseku
vysek = imresize(vysek, 15);

% imshow(uint8(vysek*255))
% 
img = uint8(vysek*255);


%https://stackoverflow.com/questions/32447767/how-to-warp-an-image-into-a-trapezoidal-shape-in-matlab

%// Create perspective transformation that warps the original 
%// image coordinates to the trapezoid
movingPoints = [1 1; size(img,2) 1; 1 size(img,1); size(img,2) size(img,1)];
fixedPoints = [round(size(img,2)*2/5) 1; round(size(img,2)*3/5) 1; 1 100; size(img,2) 100];
% fixedPoints = [1 1; size(img,2) 1; 1 200; size(img,2) 200];
tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');

%// Create a reference coordinate system where the extent is the size of
%// the image
RA = imref2d([size(img,1) size(img,2)], [1 size(img,2)], [1 size(img,1)]);

%// Warp the image
[out,r] = imwarp(img, tform, 'OutputView', RA);

%// Show the image and turn off the axes
shaped_image = out(1:fixedPoints(4,2),1:fixedPoints(4,1));
imshow(shaped_image)
% 
% x = linspace(-0,vyska,100); 
% mu=0;
% sig=4;
% y2 = gaussmf(x,[sig,mu]); 
% imshow(image)
pause(0.05)

image = shaped_image;
end

