% =========================================================================
% Exercise 4.5: Feature extraction and matching
% =========================================================================
clear
addpath helpers

%don't forget to initialize VLFeat (run vl_setup located in tools [hw2])

%Load images
% imgName1 = ''; % Try with some different pairs
% imgName2 = '';
imgName1 = 'images/pumpkin1.JPG';
imgName2 = 'images/pumpkin2.JPG';

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];

%show matches
clf
showFeatureMatches(img1, x1s(1:2,:), img2, x2s(1:2,:), 1);


%%
% =========================================================================
% Exercise 4.6: 8-point RANSAC
% =========================================================================

threshold = 5;

% TODO: implement ransac8pF
[inliers1, inliers2, outliers1, outliers2, M, F] = ransac8pF(x1s, x2s, threshold);

showFeatureMatches(img1, inliers1(1:2,:), img2, inliers2(1:2,:), 1);
% showFeatureMatches(img1, outliers1(1:2,:), img2, outliers2(1:2,:), 2);

% =========================================================================