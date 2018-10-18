% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  
    
for i = 1:size(corners,2)
    x = corners(2,i) ;
    y = corners(1,i) ;
    sizetotal = 9 ;
    offset = floor(sizetotal/2) ;
    %need fix if point is near edge of the image)
    patch = img(y-offset:y+offset,x-offset:x+offset) ;
    descr(:,i) = reshape(patch, sizetotal*sizetotal,1) ;
end