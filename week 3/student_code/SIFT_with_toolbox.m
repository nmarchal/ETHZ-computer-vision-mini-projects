clc
close all
clear all

IMG_NAME1 = 'images/I1.jpg';
IMG_NAME2 = 'images/I2.jpg';

% read in image
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

img1 = imresize(img1, 1);
img2 = imresize(img2, 1);

% convert to gray image
imgBW1 = rgb2gray(img1);
imgBW2 = rgb2gray(img2);

img1 = single(rgb2gray(img1)) ;
img2 = single(rgb2gray(img2)) ;

[f1,d1] = vl_sift(img1) ;
[f2,d2] = vl_sift(img2) ;

%% test image 1
figure(1)
imshow(img1, []);
hold on,

perm1 = randperm(size(f1,2)) ;
sel1 = perm1(1:50) ;
h11 = vl_plotframe(f1(:,sel1)) ;
h21 = vl_plotframe(f1(:,sel1)) ;
set(h11,'color','k','linewidth',3) ;
set(h21,'color','y','linewidth',2) ;

h31 = vl_plotsiftdescriptor(d1(:,sel1),f1(:,sel1)) ;
set(h31,'color','g') ;

%% test image 2
figure(2)
imshow(img2, []);
hold on,

perm2 = randperm(size(f2,2)) ;
sel2 = perm2(1:50) ;
h12 = vl_plotframe(f2(:,sel2)) ;
h22 = vl_plotframe(f2(:,sel2)) ;
set(h12,'color','k','linewidth',3) ;
set(h22,'color','y','linewidth',2) ;

h32 = vl_plotsiftdescriptor(d2(:,sel2),f2(:,sel2)) ;
set(h32,'color','g') ;

%% matching
[matches, scores] = vl_ubcmatch(d1, d2,300) ;

%% not sure
figure(3) ; clf ;
imagesc(cat(2, img1, img2)) ;

xa = f1(1,matches(1,:)) ;
xb = f2(1,matches(2,:)) + size(img1,2) ;
ya = f1(2,matches(1,:)) ;
yb = f2(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(f1(:,matches(1,:))) ;
f2(1,:) = f2(1,:) + size(img1,2) ;
vl_plotframe(f2(:,matches(2,:))) ;
axis image off ;
