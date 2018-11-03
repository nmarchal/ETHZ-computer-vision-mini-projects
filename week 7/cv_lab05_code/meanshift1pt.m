function [ mean_1pt ] = meanshift1pt(Xi,X,radius,L)
%finds the mean after iterating a mean shift for 1 point

tol = radius/15 ;
shift = 15 ;
old_center = Xi ;
test = 1 ;

while(shift>tol)
    dists = sqrt(sum(((X-repmat(old_center,[1,L])).^2))); %avoid for loop
    idx = find(dists<radius) ;
    size(X(:,idx)) ;
    new_center = mean(X(:,idx),2) ;
    shift = norm(new_center-old_center) ;
    old_center = new_center ;
    test = test+1;
end
% fprintf([int2str(test) '\n']) ;
mean_1pt = new_center ;
end

