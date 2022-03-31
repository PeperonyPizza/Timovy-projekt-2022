
function [image] = dash_cam(start,cesta,checkpoints, pozicia, orientacia)
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
vysek_sirka =20;
vysek_vyska =35;
vysek = zeros([vysek_sirka vysek_vyska]);

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
% fixedPoints = [round(size(img,2)*2/5) 1; round(size(img,2)*3/5) 1; 1 100; size(img,2) 100];
fixedPoints = [1 1; size(img,2) 1; 1 200; size(img,2) 200];
tform = fitgeotrans(movingPoints, fixedPoints, 'Projective');

%// Create a reference coordinate system where the extent is the size of
%// the image
RA = imref2d([size(img,1) size(img,2)], [1 size(img,2)], [1 size(img,1)]);

%// Warp the image
[out,r] = imwarp(img, tform, 'OutputView', RA);
w
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

