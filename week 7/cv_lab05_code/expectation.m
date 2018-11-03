function P = expectation(mu,var,alpha,X)
% This function calculates the expectation based on the parameters mu, var, alpha and X
% see slide #6 and #11 for the formula
% output is an LxK matrix.

K = length(alpha);
% N = size(imgSqueezed,1); % this makes no sense because there is noimgSqueezed in the parameters
N = size(X,2) ;

P = zeros(N,K);

for n = 1:N   
    for k = 1:K % calculate : alphak * N(xl | mu_k, var_k) (see slide 6)
        P(n,k) = alpha(k)/((2*pi)^(3/2)*(det(var(:,:,k)))^(1/2))*...
                 exp(-0.5*(X(:,n)-mu(:,k))'*inv((var(:,:,k)))*(X(:,n)-mu(:,k)));
    end %divide by them sum over all k, to have a valid probability distribution (see slide 11) 
    P(n,:) = P(n,:)/sum(P(n,:));
end

end