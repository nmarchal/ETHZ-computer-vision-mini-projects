% show feature matches between two images
%
% Input:
%   img1        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of first image
%   --> transformed to in1 and out1
%   img2        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of second image
%     --> transformed to in2 and out2
%   fig         - figure id

%%%% this is the function showFeatureMatches adapted

function showFeatureMatchesInOut(img1, in1, out1, img2, in2, out2, fig)
    [sx, sy, sz] = size(img1);
    img = [img1, img2];
    
    in2 = in2 + repmat([sy, 0]', [1, size(in2, 2)]);
    out2 = out2 + repmat([sy, 0]', [1, size(out2, 2)]);
    
    %just copy paste and use different colours for inliers and outliers
    figure(fig), imshow(img, []);    
    hold on, plot(in1(1,:), in1(2,:), '+g');
    hold on, plot(out1(1,:), out1(2,:), '+r');
    hold on, plot(in2(1,:), in2(2,:), '+g');  
    hold on, plot(out2(1,:), out2(2,:), '+r');  
    hold on, plot([in1(1,:); in2(1,:)], [in1(2,:); in2(2,:)], 'g');  
    hold on, plot([out1(1,:); out2(1,:)], [out1(2,:); out2(2,:)], 'r');    
end