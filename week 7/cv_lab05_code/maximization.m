function [mu, var, alpha] = maximization(P, X)
% see slide 15 for the formulas of updating these parameters

% K = size(prb,2); % I suppose prb is supposed to be P and x supposed to be X
% (otherwise makes no sense)
% K = size(prb,2);
% N = size(x,1);

K = size(P,2) ;
N = size(X,2) ;
alpha = zeros(1,K) ;
mu = zeros(3,K) ;
var = zeros(3,3,K) ;

for k = 1:K
%     reset to zero
    sumproba = 0 ;
    covar = zeros(3,3) ;
    
    sumproba = sum(P(:,k)) ;
    alpha(1,k) = sumproba/N ;
    mu(:,k) = sum(X.*repmat(P(:,k)',[3,1]),2) ;
    mu(:,k) = mu(:,k)/ sumproba ;
    diff = X - repmat(mu(:,k),[1,N]) ;
    for n = 1:N
        covar = covar + P(n,k)*(diff(:,n)*diff(:,n)') ;
    end
    var(:,:,k) = covar./ sumproba ;
end
    
end