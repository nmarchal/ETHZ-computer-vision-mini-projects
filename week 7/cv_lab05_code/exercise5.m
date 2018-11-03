% function run_ex5()

% load image
img = imread('cow.jpg');
size(img) ;
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)
figure, imshow(img), title('original image')

% img = imresize(img, [70 60]) ;
% figure, imshow(img), title('image decreased')

%% smooth image (6.1a) DONE
% (replace the following line with your code for the smoothing of the image)
F = fspecial('gaussian',5,5); % first is the filter size (5x5), second is std 
imgSmoothed = imfilter(img,F);
figure, imshow(imgSmoothed), title('smoothed image')

%% convert to L*a*b* image (6.1b) DONE
% (replace the folliwing line with your code to convert the image to lab
% space (see "help makecform" for example)
cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed, cform);
figure, imshow(imglab), title('l*a*b* image')

%% (6.2)
[mapMS peak] = meanshiftSeg(imglab);
visualizeSegmentationResults (mapMS,peak);

%% (6.3)
% [mapEM cluster] = EM(imglab);
% visualizeSegmentationResults (mapEM,cluster);

% end