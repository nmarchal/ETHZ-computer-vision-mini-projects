function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization (GIVE HOMOGENOUS COORDINATES)

%first compute centroid
xy_centroid = mean(xy') ;
XYZ_centroid = mean(XYZ') ;
xy_centroid(1) ;
%then, compute scale

%create T and U transformation matrices
Txy_centroid = [1 0 -xy_centroid(1) ;   ...
    0 1 -xy_centroid(2); ...
    0 0 1 ] ;

TXYZ_centroid =  [1 0 0 -XYZ_centroid(1) ;   ...
    0 1 0 -XYZ_centroid(2); ...
     0 0 1 -XYZ_centroid(3); ...
    0 0 0 1 ] ;

%find lamda_xy
total_xy = 0 ;
xy_center = Txy_centroid*xy ;
for i = 1:6
    total_xy = total_xy + norm(xy_center(1:2,i)) ;
end
lamda_xy = 6*sqrt(2)/total_xy  ;

%find lamda_XYZ
total_XYZ = 0 ;
XYZ_center = TXYZ_centroid*XYZ ;
for i = 1:6
    total_XYZ = total_XYZ + norm(XYZ_center(1:3,i)) ;
end
lamda_XYZ = 6*sqrt(3)/total_XYZ  ;
%and normalize the points according to the transformations
T = lamda_xy * Txy_centroid ;
T(3,3) = 1 ;
xyn =  T * xy ;

U = lamda_XYZ * TXYZ_centroid ;
U(4,4) = 1 ;
XYZn = U * XYZ ;


% % for testing center: 
% mean((xyn)')
% mean((XYZn)')

% test xy normalization
% total_xy = 0 ;
% for i = 1:6
%     total_xy = total_xy + norm(xyn(1:2,i)) ;
% end
% total_xy/6 

% % test XYZ normalization
% total_XYZ = 0 ;
% for i = 1:6
%     total_XYZ = total_XYZ + norm(XYZn(1:2,i)) ;
% end
% total_XYZ/6 

end