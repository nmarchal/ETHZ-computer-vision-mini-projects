% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength

function [corners, K] = extractHarrisCorner(img, thresh )
%% filter to blur image (reduce noise)
imgb = imgaussfilt(img,1) ;
close all ;

%% Compute the gradient
[Ix,Iy] = gradient(imgb) ;

%% do harris corner detection (ignore the boundary)

[imageSizeY imageSizeX] = size(imgb) ;

tic ;
Ix2 = Ix.^2 ;
Iy2 = Iy.^2 ;
IxIy = Ix.*Iy ;

% Do sum over neighbors
Wsize = 3 ;
H11 = movsum(movsum(Ix2,Wsize,2),Wsize,1);
H22 = movsum(movsum(Iy2,Wsize,2),Wsize,1);
H12 = movsum(movsum(IxIy,Wsize,2),Wsize,1);
K = (H11.*H22-H12.*H12)./(H11+H22) ;

%calculate the time needed for calculation
time = toc 

        
%% histogram (without 0 on the sides)
figure(21)
histogram(K(2:end-1,2:end-1),'BinWidth',0.0001, 'BinLimits',[0,0.006])

%% non maximum suppression 
%identify the potential corners
tic
corners = [] ;
maxIntensityPatchSize = 3 ; %size of the patch

%offset such don't have 3X3 patch that goes out of the matrix dimensions
offset = floor(maxIntensityPatchSize/2) ;
%only start looking at points far enough from bordure such no problem with
%the descriptor late on (need 4 for 9x9 patch)
offsetDescriptor = 4 ;
compteur = 0 ;
for i = 1+offsetDescriptor:(imageSizeX-offsetDescriptor)
    for j = 1+offsetDescriptor:(imageSizeY-offsetDescriptor)
        intensity = K(j,i) ;
        if intensity > thresh
            compteur = compteur + 1 ;
            maxPatch = max(max(K((max(1,(j-offset))): min(imageSizeY,(j+offset)),  ...
                                max(1,(i-offset)):min(imageSizeX,(i+offset))))) ; 
            if (intensity == maxPatch)
                corners = [corners [j;i]] ;
            end
        end
    end
end
timeCorner = toc ;
compteur ;
end