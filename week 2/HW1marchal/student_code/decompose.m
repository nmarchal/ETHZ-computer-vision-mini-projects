function [ K, R, C ] = decompose(P)
%decompose P into K, R and t
 M = [] ;
 for i = 1:3
     M(i,:) = P(i,1:3) ;
     KRC(i,:) = -P(i,4) ;
 end
 
 P ;
 [Qdeco,Rdeco] = qr(inv(M)) ;
 K = inv(Rdeco);
 Kscale = (K(end,end)) ;
 K = (1/Kscale) * K ;
 R = inv(Qdeco) ;
 R = Kscale * R ;
 
 [U,S,V] = svd(P);
 C = V(:,end);
 C = 1/(C(end,end))*C ;
end