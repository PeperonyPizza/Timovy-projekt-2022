function [rotated_point] = rotacia_stvorca(point,position,theta)
% // cx, cy - center of square coordinates
% // x, y - coordinates of a corner point of the square
% // theta is the angle of rotation
% 
% // translate point to origin
cx = position(1);
cy = position(2);
tempX = point(1) - cx;
tempY = point(2) - cy;

% // now apply rotation
rotatedX = tempX*cos(theta) - tempY*sin(theta);
rotatedY = tempX*sin(theta) + tempY*cos(theta);

% // translate back
x = round(rotatedX + cx);
y = round(rotatedY + cy);
rotated_point = [x,y];
end

