% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% You will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1, x2)

W = [ 0 -1 0 ; 1 0 0 ; 0 0 1 ] ;
    
[U,~,V] = svd(E);
U3 = U(:,end) ;

P0 = [eye(3) zeros(3,1)] ;

P1 = [U*W*V' U3] ;
P2 = [U*W*V' -U3] ;
P3 = [U*W'*V' U3] ;
P4 = [U*W'*V' -U3] ;

P_possible = [P1, P2, P3, P4] ;
truth = [0 0 0 0] ;

for i=1:4
    Pi = P_possible(:,((i-1)*4+1):i*4);
    [XS, err] = linearTriangulation(P0, x1, Pi, x2) ;
    PXs = Pi*XS ;
    if min(XS(3,:) > 0) && min(PXs(3,:)) > 0;
        truth(i) = 1 ;
        showCameras({P0,Pi},i+4);
        figure(i+4)
        hold on ;
        plot3(XS(1,:),XS(2,:),XS(3,:),'x') ; view(30,10)
    end

end
P_idx = find(truth==1) ;

if size(P_idx,2) == 0 || size(P_idx,2) >1
    error('Problem fnding right camera matrix')
else
    P = P_possible(:,((P_idx-1)*4+1):P_idx*4);
end

end