function [XYZn, T] = normalization(XYZ)

%data normalization (GIVE HOMOGENOUS COORDINATES)
size(XYZ) ;
%first compute centroid
XYZ_centroid = mean(XYZ,2) ;
size(XYZ_centroid) ;
%create T transformation matrices

TXYZ_centroid =  [1 0 0 -XYZ_centroid(1) ;   ...
    0 1 0 -XYZ_centroid(2); ...
     0 0 1 -XYZ_centroid(3); ...
    0 0 0 1 ] ;

%find lamda_XYZ
total_XYZ = 0 ;
XYZ_center = TXYZ_centroid*XYZ ;
for i = 1:6
    total_XYZ = total_XYZ + norm(XYZ_center(1:3,i)) ;
end
lamda_XYZ = 6*sqrt(3)/total_XYZ  ;
%and normalize the points according to the transformations
T = lamda_XYZ * TXYZ_centroid ;
T(4,4) = 1 ;
XYZn = T * XYZ ;
end