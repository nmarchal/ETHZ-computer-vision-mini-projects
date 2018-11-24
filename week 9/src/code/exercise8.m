% =========================================================================
% Exercise 8
% =========================================================================
clc 
close all
% Initialize VLFeat (http://www.vlfeat.org/)
% run vl.setup

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];
%% some threshlds 
% Note that point coordinates are normalised to that their mean distance from the origin is sqrt(2)
% The value of t should be set relative to this, say in the range 0.001 - 0.01  
% (I needed to get a little smaller)
tF = 0.00008 ; 
% No indication given for projection matrix threshold
tP = 0.05;

%% Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%% extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

% don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches2, ~] = vl_ubcmatch(da, db);
x1 = makehomogeneous(fa(1:2, matches2(1,:)));
x2 = makehomogeneous(fb(1:2, matches2(2,:)));

fig = 1 ;
figure(fig)
fig=fig+1 ;
showFeatureMatches(img1, fa(1:2, matches2(1,:)), img2, fb(1:2, matches2(2,:)), 1);
title('Matches before ransac')

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
[F, inliers] = ransacfitfundmatrix(x1,x2,tF);
outliers = setdiff(1:size(matches2,2),inliers); % Try something else

x1_inliers = makeinhomogeneous(x1(:,inliers)) ;
x2_inliers = makeinhomogeneous(x2(:,inliers)) ;

figure(fig)
fig=fig+1 ;
showFeatureMatches(img1, x1_inliers, img2, x2_inliers, 2);
title('Matches after ransac')

%% epipolar lines

% draw epipolar lines in img 1
figure(fig)
fig=fig+1 ;
imshow(img1, []);
hold on 
plot(x1_inliers(1,:), x1_inliers(2,:), '*r');
for k = 1:size(x1_inliers,2)
    drawEpipolarLines(F'*makehomogeneous(x2_inliers(:,k)), img1);
end
title('epipolar lines (img0)')

% draw epipolar lines in img 1
figure(fig)
fig=fig+1 ;
imshow(img2, []);
hold on 
plot(x2_inliers(1,:), x2_inliers(2,:), '*r');
for k = 1:size(x2_inliers,2)
    drawEpipolarLines(F'*makehomogeneous(x1_inliers(:,k)), img2);
end
title('epipolar lines (img4)')

%% triangulation
E = K'*F*K;

x1_calibrated = K\makehomogeneous(x1_inliers);
x2_calibrated = K\makehomogeneous(x2_inliers);

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

if (det(Ps{2}(1:3,1:3)) < 0 )
    Ps{2}(1:3,1:3) = -Ps{2}(1:3,1:3);
    Ps{2}(1:3, 4) = -Ps{2}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix

[X_2, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
fa_in = fa(:,matches2(1,inliers));
da_in = da(:,matches2(1,inliers));

[matches3, ~] = vl_ubcmatch(da_in, dc);

x1_in3 = makehomogeneous(fa_in(1:2, matches3(1,:)));
x3 = makehomogeneous(fc(1:2, matches3(2,:)));

% run 6-point ransac
x3_calibrated = K\x3;
[Ps{3}, inliers3] = ransacfitprojmatrix(x3_calibrated, X_2(:,matches3(1,:)), tP) ;
outliers3 = setdiff(1:size(matches3,2),inliers3);

% chose correct projection matrix
if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
x1_in3_cal = K\x1_in3;
[X_3, ~] = linearTriangulation(Ps{1}, x1_in3_cal(:,inliers3), Ps{3}, x3_calibrated(:,inliers3));

%plot the results
figure(fig)
showFeatureMatchesInOut(img1, x1_in3(1:2,inliers3),x1_in3(1:2,outliers3), ...
                        img3,x3(1:2,inliers3),x3(1:2,outliers3), fig);
hold on ;                    
title('Image 0 and 1')
fig=fig+1 ;

%% Add more views...

imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated
fa_in = fa(:,matches2(1,inliers));
da_in = da(:,matches2(1,inliers));

[matches4, ~] = vl_ubcmatch(da_in, dd);

x1_in4 = makehomogeneous(fa_in(1:2, matches4(1,:)));
x4 = makehomogeneous(fd(1:2, matches4(2,:)));

% run 6-point ransac
x4_calibrated = K\x4;
[Ps{4}, inliers4] = ransacfitprojmatrix(x4_calibrated, X_2(:,matches4(1,:)), tP) ;
outliers4 = setdiff(1:size(matches4,2),inliers4);

% chose correct projection matrix
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
x1_in4_cal = K\x1_in4;
[X_4, ~] = linearTriangulation(Ps{1}, x1_in4_cal(:,inliers4), Ps{4}, x4_calibrated(:,inliers4));

%plot the results
figure(fig)
showFeatureMatchesInOut(img1, x1_in4(1:2,inliers4),x1_in4(1:2,outliers4), ...
                        img4,x4(1:2,inliers4),x4(1:2,outliers4), fig);
title('Image 0 and 2')
fig=fig+1 ;

%% add the last view

imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

% match against the features from image 1 that where triangulated
fa_in = fa(:,matches2(1,inliers));
da_in = da(:,matches2(1,inliers));

[matches5, ~] = vl_ubcmatch(da_in, de);

x1_in5 = makehomogeneous(fa_in(1:2, matches5(1,:)));
x5 = makehomogeneous(fe(1:2, matches5(2,:)));

% run 6-point ransac
x5_calibrated = K\x5;
[Ps{5}, inliers5] = ransacfitprojmatrix(x5_calibrated, X_2(:,matches5(1,:)), tP) ;
outliers5 = setdiff(1:size(matches5,2),inliers5);

% chose correct projection matrix
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
x1_in5_cal = K\x1_in5;
[X_5, ~] = linearTriangulation(Ps{1}, x1_in5_cal(:,inliers5), Ps{5}, x5_calibrated(:,inliers5));

%plot the results
figure(fig)
showFeatureMatchesInOut(img1, x1_in5(1:2,inliers5),x1_in5(1:2,outliers5), ...
                        img5,x5(1:2,inliers5),x5(1:2,outliers5), fig);
title('Image 0 and 3')
fig=fig+1 ;
%%%%%%% the end%%%%%%%

%% Plot stuff

figure(fig);
%use plot3 to plot the triangulated 3D points
hold on
%use plot3 to plot the triangulated 3D points
plot3(X_2(1,:),X_2(2,:),X_2(3,:),'r.')
plot3(X_3(1,:),X_3(2,:),X_3(3,:),'g.')
plot3(X_4(1,:),X_4(2,:),X_4(3,:),'b.')
plot3(X_5(1,:),X_5(2,:),X_5(3,:),'k.')
%draw cameras
drawCameras(Ps, fig); hold on ;
view(25,30)
fig=fig+1 ;