function [C] = chi2_cost(s1,s2)
%function which computes a cost matrix between two sets of shape context
% descriptors. The cost matrix should be an nxm matrix giving the cost of matching
% two sets of points based on their shape context descriptors.

if (size(s1,2)) ~= (size(s2,2))
    error ('the describtors do not have the same size')
end
K = (size(s1,2)) ;
C = zeros(size(s1,1), size(s2,1)) ;

eps = 0.00001 ;% to avoid dividing by 0
% tic
%calculate cost matrix
for i = 1:size(s1,1)
    for j = 1:size(s2,1)
        for k = 1:K
            C(i,j) = C(i,j) + ((s1(i,k)-s2(j,k))^2 /(s1(i,k)+s2(j,k)+eps)) ;
        end
    end
end
% toc
end

