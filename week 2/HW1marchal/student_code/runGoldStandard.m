function [K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
xy(3,:) = ones(1, size(xy,2)) ;
XYZ(4,:) = ones(1, size(XYZ,2)) ;
[xy_normalized XYZ_normalized T U] = normalization(xy,XYZ) ;

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized) ;

P_normalized

P_not_opti = inv(T)*P_normalized*U 
%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)] ;
for i=1:18
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end

P_normalized_optimized(1,:) = pn(1:4) ;
P_normalized_optimized(2,:) = pn(5:8) ;
P_normalized_optimized(3,:) = pn(9:12) ; 

P_normalized_optimized ;

%denormalize camera matrix
P = inv(T)*P_normalized_optimized*U 
%factorize camera matrix in to K, R and t
[ K, R, C ] = decompose(P) ;
t = - R*C(1:3) ;

K;
R;
C;
t;

%compute reprojection error
xy_reconstruc = P*XYZ ; 
for i = 1:size(xy,2) 
    scale = xy_reconstruc(3,i) ;
    xy_reconstruc(:,i) = 1/scale * xy_reconstruc(:,i) ;
end

error = 0 ;
errorMat = (xy_reconstruc - xy) ;
for i = 1:size(xy,2) 
    error = error + norm(errorMat(1:2,i)) ;
end
error = 1/(size(xy,2)) * error % I take the average error

% visualisation
visualizePoints(P, xy) ;



end