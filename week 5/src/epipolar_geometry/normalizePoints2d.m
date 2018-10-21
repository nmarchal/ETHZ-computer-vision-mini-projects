% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [xyn, T] = normalizePoints2d(xy)
nbr_pts = size(xy,2) ;

%first compute centroid
xy_centroid = mean(xy') ;

%then, compute scale

%create T and U transformation matrices
Txy_centroid = [1 0 -xy_centroid(1) ;   ...
    0 1 -xy_centroid(2); ...
    0 0 1 ] ;

%find lamda_xy
total_xy = 0 ;
xy_center = Txy_centroid*xy ;
for i = 1:nbr_pts
    total_xy = total_xy + norm(xy_center(1:2,i)) ;
end
lamda_xy = nbr_pts*sqrt(2)/total_xy  ;

%and normalize the points according to the transformations
T = lamda_xy * Txy_centroid ;
T(3,3) = 1 ;
xyn =  T * xy ;

% % test xy normalization
% total_xy = 0 ;
% for i = 1:nbr_pts
%     total_xy = total_xy + norm(xyn(1:2,i)) ;
% end
% tot = total_xy/nbr_pts 
end
