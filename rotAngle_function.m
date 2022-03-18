% function matrix = rotAngle(array, angle)
%     size_array = size(array);
%     center = size_array(1)/2-1;
%     angleToPixel = center*sind(angle)/cosd(angle);
%     angleToPixel = round(angleToPixel);
%     
%     vekt = [rot90(array(:,1)) array(size_array(1),2:end) rot90(rot90(array(1:end-1,size_array(1))')) rot90(rot90(array(1,2:end-1)))];
%     
%     if(angleToPixel > 0)
%         
%         for n = 1:angleToPixel
%             vekt2(1,n) = array();
%         end
%     elseif (angleToPixel < 0)
%             
%     else
%          matrix = array;   
%     end
%         
%     
% %     for i = 1:size_array(1)
% %         for j = 1: size_array(2)
% %             
% %         end
% %     end
% end


% a = [1 2 3;4 0 6;7 8 9];
% b = rotAngle45(a,45)
% c = rotAngle45(a,-45)
% d = rotAngle45(a,90)
% e = rotAngle45(a,-90)

function matrix2 = rotAngle45(array, angle)     % pre 3x3
    if(angle == 0)
        matrix2 = array;
    elseif(angle == 45)
        matrix2(2,1) = array(1,1);
        matrix2(3,1) = array(2,1);
        matrix2(3,2) = array(3,1);
        matrix2(3,3) = array(3,2);
        matrix2(2,3) = array(3,3);
        matrix2(1,3) = array(2,3);
        matrix2(1,2) = array(1,3);
        matrix2(1,1) = array(1,2);
    elseif(angle == 90)
        matrix2(2,1) = array(1,2);
        matrix2(3,1) = array(1,1);
        matrix2(3,2) = array(2,1);
        matrix2(3,3) = array(3,1);
        matrix2(2,3) = array(3,2);
        matrix2(1,3) = array(3,3);
        matrix2(1,2) = array(2,3);
        matrix2(1,1) = array(1,3);
    elseif(angle == -45)
        matrix2(2,1) = array(3,1);
        matrix2(3,1) = array(3,2);
        matrix2(3,2) = array(3,3);
        matrix2(3,3) = array(2,3);
        matrix2(2,3) = array(1,3);
        matrix2(1,3) = array(1,2);
        matrix2(1,2) = array(1,1);
        matrix2(1,1) = array(2,1);
    elseif(angle == -90)
        matrix2(2,1) = array(3,2);
        matrix2(3,1) = array(3,3);
        matrix2(3,2) = array(2,3);
        matrix2(3,3) = array(1,3);
        matrix2(2,3) = array(1,2);
        matrix2(1,3) = array(1,1);
        matrix2(1,2) = array(2,1);
        matrix2(1,1) = array(3,1);
    else
        matrix2 = -1;
    end
end