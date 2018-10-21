% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)

%normalization of points
[x1sn, T1] = normalizePoints2d( x1s )   ; 
[x2sn, T2] = normalizePoints2d( x2s )   ; 

% Construct matrix A
x1 = x1sn(1,:)' ; y1 = x1sn(2,:)' ;
x2 = x2sn(1,:)' ; y2 = x2sn(2,:)' ;

A = [ x1.*x2, y1.*x2, x2, x1.*y2, y1.*y2, y2, x1, y1, ones(size(x1,1),1) ];

% Do SVD and take last column of V as solution (reshape as a matrix)
[U,S,V] = svd(A) ;
E = V(:,end) ;

E = [   E(1) E(2) E(3) 
        E(4) E(5) E(6) 
        E(7) E(8) E(9) ] ;
    
%unscale 
E = T2'*E*T1;

%enforce constraints
[U,S,V] = svd(E) ;
temp = (S(1,1) + S(2,2))/2 ;
S(1,1) = temp ;S(2,2) = temp ;
S(:,3) = zeros(3,1) 
Eh = U*S*V';

end
