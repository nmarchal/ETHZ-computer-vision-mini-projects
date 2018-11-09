% intro
path(path, 'sift');
path(path, 'GCmex1.3');

imgNameL = 'images/0018.png';
imgNameR = 'images/0019.png';
camNameL = 'images/0018.camera';
camNameR = 'images/0019.camera';

% scale = 0.5^2; % try this scale first
scale = 0.5^3; % if it takes too long switch to this one

imgL = imresize(imread(imgNameL), scale);
imgR = imresize(imread(imgNameR), scale);

figure(1);
subplot(121); imshow(imgL);
subplot(122); imshow(imgR);

[K R C] = readCamera(camNameL);
PL = K * [R, -R*C];
[K R C] = readCamera(camNameR);
PR = K * [R, -R*C];

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(2);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);
close all;

se = strel('square', 15);
maskL = imerode(maskL, se);
maskR = imerode(maskR, se);
%%
% set disparity range
% exercise 5.4 (10% bonus if done automatically)
% you may use the following two lines 
% [x1s, x2s] = getClickedPoints(imgRectL, imgRectR); 
% close all;
% to get a good guess

% estimate min max distance (i.e. using x1s and x2s)



% set disparity range (i.e. using x1s and x2s)


% for now try these fixed ranges
% dispRange = -30:30;
dispRange = -40:40;
%%
% compute disparities, winner-takes-all
% exercise 5.1
dispStereoL = ...
    stereoDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange);
dispStereoR = ...
    stereoDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange);

figure(1);
subplot(121); imshow(dispStereoL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispStereoR, [dispRange(1) dispRange(end)]);

thresh = 8;

maskLRcheck = leftRightCheck(dispStereoL, dispStereoR, thresh);
maskRLcheck = leftRightCheck(dispStereoR, dispStereoL, thresh);

maskStereoL = double(maskL).*maskLRcheck;
maskStereoR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskStereoL);
subplot(122); imshow(maskStereoR);
close all;
%%
% compute disparities using graphcut
% exercise 5.2
Labels = ...
    gcDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange);
dispsGCL = double(Labels + dispRange(1));
Labels = ...
    gcDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange);
dispsGCR = double(Labels + dispRange(1));

figure(1);
subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);

maskLRcheck = leftRightCheck(dispsGCL, dispsGCR, thresh);
maskRLcheck = leftRightCheck(dispsGCR, dispsGCL, thresh);

maskGCL = double(maskL).*maskLRcheck;
maskGCR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskGCL);
subplot(122); imshow(maskGCR);
close all;
%%
dispStereoL = double(dispStereoL);
dispStereoR = double(dispStereoR);
dispsGCL = double(dispsGCL);
dispsGCR = double(dispsGCR);

S = [scale 0 0; 0 scale 0; 0 0 1];

% for each pixel (x,y), compute the corresponding 3D point 
% use S for computing the rescaled points with the projection 
% matrices PL PR
% exercise 5.3
coords = ...
    generatePointCloudFromDisps(dispsGCL, ...);
% ... do same for other winner-takes-all
[coords2 ~] = ...
    generatePointCloudFromDisps(...);

imwrite(imgRectL, 'imgRectL.png');
imwrite(imgRectR, 'imgRectR.png');

% use meshlab to open generated textured model
generateObjFile('modelGC', 'imgRectL.png', ...
    coords, maskGCL.*maskGCR);
% ... do same for other winner-takes-all

