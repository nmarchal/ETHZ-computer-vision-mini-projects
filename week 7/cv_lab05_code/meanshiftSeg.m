function [map peak] = meanshiftSeg(img)
% input : img (image which we want to cluster)
% output : TODO

%% creat the distribution X
width = size(img,2) ; height = size(img,1) ;
L = width*height ;
l = (reshape(img(:,:,1), 1,L)) ;
a = (reshape(img(:,:,2), 1,L)) ;
b = (reshape(img(:,:,3), 1,L)) ;
X = [l;a;b] ;
%I need to normalize the points, This will amke it much easier to chose
%threshold parameters (adapt function from HW1)
Xh = [X ; ones(1,L)] ;
size(Xh) ;
Xh = double(Xh) ;
[Xhn, T] = normalization(Xh) ;
% these will help me understand the distribution in the image to set a
% radius and a tolerance to stop lookign for new mean
max_im = max(max(X)) ; % 249
min_im = min(min(X)) ; % 9
mean_im = mean(norm(double(X))) ; %116

map = zeros(1,L); %initiate a map of the right size
peak = [] ;

%% go through all pixels and look for clusters
radius = 1/sqrt(3) ; % I will have to tune this parameter
tol_peaks = radius/2 ;
% tol_peaks = 0.00001 ;

 for i = 1:L %project tips fo not do loops ... I start witha loop and evaluate performances
     mean_1pt = find_peak(Xhn(1:3,i),Xhn(1:3,:),radius) ;
     if i==1 %first run
         peak = mean_1pt ;
         map(i) = 1 ;      
     else
         % distance with existing peaks
        dist = sqrt(sum(((peak-repmat(mean_1pt,[1,size(peak,2)])).^2)));
        idx = find(dist < tol_peaks,1);
        if(idx>=1)
            map(i) = idx;
        else
            peak = [peak mean_1pt];
            map(i) = size(peak,2);
            fprintf('New peak detected \n') ;
        end
     end
        
    if mod(i,1000) == 0
        fprintf(int2str(i)) ;
        fprintf('pixels treated \n')
    end

 end
 
 map = reshape(map, size(img,1), size(img,2)) ;
 % Unormalize the peaks
 peakh = [peak;ones(1,size(peak,2))];
 peaku = T \ peakh;
 peak = peaku(1:3,1:end)';
 
end