function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
% the vectors  send wll be normalized (see runDLT.m)

%create matrix A
A = [] ;
for i = 1:6
    A((i-1)*2+1,:) = [ xy(3,i)*XYZ(:,i)' zeros(1,4) -xy(1,i)*XYZ(:,i)' ] ;
    A((i-1)*2+2,:) = [zeros(1,4) -xy(3,i)*XYZ(:,i)' xy(2,i)*XYZ(:,i)' ] ;
end

%do SVD, take eigenvector with smallest eigenvalue (will not be 0 because of noise)
[U,S,V] = svd(A) ;
PVecteur = V(:,end) ;

P = [] ;
P(1,:) = PVecteur(1:4) ;
P(2,:) = PVecteur(5:8) ;
P(3,:) = PVecteur(9:12) ;

end



