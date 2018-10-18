function [K, R, t, error] = runDLT(xy, XYZ)

xy(3,:) = ones(1, size(xy,2)) ;
XYZ(4,:) = ones(1, size(XYZ,2)) ;

%normalize data points
[xy_normalized XYZ_normalized T U] = normalization(xy,XYZ) ;


%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized) ;

%denormalize camera matrix
P = inv(T)*P_normalized*U ;
P ;
P_normalized ; 
%factorize camera matrix in to K, R and t

[ K, R, C ] = decompose(P)  ;
t = - R*C(1:3) ; %need to check
K ;
R;
C;
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
error = 1/(size(xy,2)) * error   % I take the average error

% visualize(K) ;
visualizePoints(P,xy) ;

end

