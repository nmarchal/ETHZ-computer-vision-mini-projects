% Generate initial values for the K
% covariance matrices

% 3x3 matrix and could be initialized as a
% diagonal matrix with elements corresponding to the
% range of the L*, a* and b* values.

function cov = generate_cov(rangeL, rangea, rangeb, K)
    cov = zeros(3,3,K);
    for i = 1:K
        cov(:,:,i) = diag([rangeL, rangea, rangeb]);
    end
end