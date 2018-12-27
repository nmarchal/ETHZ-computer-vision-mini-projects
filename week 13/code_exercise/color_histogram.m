function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% to deal with cases where the bouding box goes out
xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(xMax,size(frame,2)));
yMax = round(min(yMax,size(frame,1)));

%% divide rgb channel
interest_frame_red = frame(yMin:yMax, xMin:xMax, 1 ) ;
interest_frame_green = frame(yMin:yMax, xMin:xMax, 2 ) ;
interest_frame_blue = frame(yMin:yMax, xMin:xMax, 3 ) ;

%% do histogram
hist_red = imhist(interest_frame_red,hist_bin) ;
hist_green = imhist(interest_frame_green,hist_bin) ;
hist_blue = imhist(interest_frame_blue,hist_bin) ;

hist = [hist_red ; hist_green ; hist_blue] ;
hist = hist/sum(hist); %this helps with cases where bounding box out of frame
end

