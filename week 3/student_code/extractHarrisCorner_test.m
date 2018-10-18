% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength

%% FIXME : dont take K (just for more speed while testing - put K=0 tor ecomputre K
function [corners, H,K] = extractHarrisCorner(img, thresh,Kprime )
%% filter to blur image (reduce noise)
imgb = imgaussfilt(img) ;
close all ;

%% Compute the gradient
[Ix,Iy] = gradient(imgb) ;

%%   je suis pas sur de mon filtering la
% H = fspecial('gaussian');
% imgb = imfilter(img,H);
% figure(1) ;
% imshow(img) ;
%  figure(2) ;
%  imshow(imgb) ;
%% do harris corner detection (ignore the boundary)
%FIXME 
[ imageSizeY imageSizeX] = size(imgb) ;

tic ;
% just to gain some time if alreay have K
if Kprime == 0
    for i = 2:(imageSizeX-1)
        for j = 2:(imageSizeY-1)
            % je pense pas qu'il faille enlever le pixel du milieu
    % % % %         Ix2 = sum(sum(Ix(j-1:j+1, i-1:i+1).^2)) - Ix(j,i)^2;
    % % % %         Iy2 = sum(sum(Iy(j-1:j+1, i-1:i+1).^2)) - Iy(j,i)^2;
    % % % %         IxIy = sum(sum(Iy(j-1:j+1, i-1:i+1).*(Ix(j-1:j+1, i-1:i+1)))) - Ix(j,i)*Iy(j,i) ;
            Ix2 = sum(sum(Ix(j-1:j+1, i-1:i+1).^2));
            Iy2 = sum(sum(Iy(j-1:j+1, i-1:i+1).^2));
            IxIy = sum(sum(Iy(j-1:j+1, i-1:i+1).*(Ix(j-1:j+1, i-1:i+1))));
            H = [Ix2 IxIy ; IxIy Iy2] ;
            K(j,i) = det(H)/(trace(H)) ;
        end
    end
    %set K = 0 for the border pixels (some were automatically set to zero)
    K(:,imageSizeX) = zeros(imageSizeY-1,1) ;
    K(imageSizeY,:) = zeros(1,imageSizeX) ;
    %calculate the time needed for calculation
else
    K = Kprime ;
end
    
timeFindAllK = toc 

        
%% histogram
figure(3)
histogram(K(2:end-1,2:end-1),'BinLimits',[-0.01,0.07]) ;

%% non maximum suppression 
%identify the potential corners
tic
corners = [] ;
maxIntensityPatchSize = 3 ;

offset = floor(maxIntensityPatchSize/2) ;

for i = 2:(imageSizeX-1)
    for j = 2:(imageSizeY-1)
        intensity = K(j,i) ;
        if intensity > thresh
            keep = 1;
            maxPatch = max(max(K((max(1,(j-offset))): min(imageSizeY,(j+offset)),  ...
                                max(1,(i-offset)):min(imageSizeX,(i+offset))))) ; 
            if (intensity < maxPatch)
                keep = 0 ;
            end
            if keep == 1
                corners = [corners [j;i]] ;
            end
        end
    end
end
timeCorner = toc 


%% visualize the points
figure(4)
imshow(img); hold on ;
for i = 1:size(corners,2)
    plot(corners(2,i), corners(1,i) , 'Marker','.','MarkerEdgeColor', ...
            'b','MarkerSize',7,'linewidth', 5) ; hold on;

%% dummies
beep on
beep
beep
H = 0 ;
end