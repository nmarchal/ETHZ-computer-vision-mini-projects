function [x y E] = tps_model(X,Y,lambda)
%OUTPUTS : 
% outputs w x and w y are the parameters (wi and ai) in the two TPS
% models, E is the total bending energy

% INPUTS :
% points in the template shape, X
% corresponding points in the target shape, Y
% regularization parameter, lambda

% the weights wi and a1, ax, ay for both fx and fy

K = dist2(X,X).*log(dist2(X,X)) ;
K(isnan(K)) = 0 ;
N = size(X,1) ;
P = [ones(N,1), X] ;
A = [K+lambda*eye(N), P ; P', zeros(3,3)];
vx = Y(:,1) ; vy = Y(:,2) ;
bx = [vx;0;0;0] ; by = [vy;0;0;0] ;

x = A\bx ;y = A\by ;

w_x = x(1:N) ; w_y = y(1:N) ;

E = w_x'*K*w_x + w_y'*K*w_y;

end

