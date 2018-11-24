function [X_nsamp] = get_samples(X,nsamp)
%X nsamp is of size nsamp x 2 and contains the cooordinates
% of the sampled points, given the points X and the number of samples to take nsamp

idx = randperm(max(size(X))) ;
X_nsamp = X(idx(1:nsamp),:) ;
end

