function [d] = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
%function which computes the shape context descriptors for a set of points
% 
% d containing the shape context descriptors for all input points
% 
% set of points, X
% number of bins in the angular dimension, nbBins_theta
% number of bins in the radial dimension, nbBins_r
% the length of the smallest radius, smallest_r
% the length of the biggest radius, biggest_r

%do normalization 
N = size(X,1) ;
normalization = 0 ;
for i = 1:N ;
    diff = X(i) - X ;
    size(diff)
    for j = 1:N
        normalization = normalization + 1/(N^2)*(norm(diff(j,:))) ;
%         normalization = normalization + 1/(N^2)*(norm(diff(j,:))^2) ;
    end
    size(normalization);
end
normalization = 1/(sqrt(2)/normalization) ;
% normalization = 1/(2/normalization) 

smallest_r = smallest_r*normalization ;
biggest_r = biggest_r*normalization ;


theta_size = 360/nbBins_theta ;
delta_r(1) = smallest_r ;
for i = 1:nbBins_r
    delta_r(i+1) =  exp(log(smallest_r) + (log(biggest_r) - log(smallest_r))*i/nbBins_r) ;
end
delta_r;

d = zeros(max(size(X)), theta_size*nbBins_r) ;
for i = 1:size(X,1)
    for j = 1:size(X,1)
        distance_r = norm(X(i,:)-X(j,:)) ;
        if  (distance_r < biggest_r && distance_r > smallest_r)
            deltax = X(j,1) - X(i,1) ;
            deltay = X(j,2) - X(i,2) ;
            theta = rad2deg(atan2 (deltay,deltax)) ;
            if theta<0
                theta = 360 + theta ;
            end
            theta_idx = ceil(theta/nbBins_theta) ;
            if theta_idx == 0 %avoid 0 index
                theta_idx = 1 ;
            end
            r_idx = max(find(distance_r >= delta_r)) ;
            % vector embedding
            d(i,theta_idx + (r_idx-1)*theta_size) = ...
                                        d(i,theta_idx + (r_idx-1)*theta_size) +1 ; 
        end
    end
end
