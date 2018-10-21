function [in1, in2, out1, out2, m, F_best] = ransac8pF(x1, x2, threshold)

N = 8 ;
p_stop = 0.99 ;
nbr_pts = size(x1,2) ;
x1(3,:) = ones(1,nbr_pts);
x2(3,:) = ones(1,nbr_pts);
maxiter = 10000 ;
max_nbr_matches = 0 ;
 
i = 1 ;
while i <= maxiter ;
    %chose 8 radom points and calculate fundamental matrix
    idx = randperm(nbr_pts,N);
    x1s = x1(:,idx);
    x2s = x2(:,idx);
    [Fh, F] = fundamentalMatrix(x1s, x2s) ;
    matches = [];
    nomatch = [];
    m = i ;
    FF= F ; % By testing I saw taking F gives much better results
    
%     get inliers and outliers 
    for j=i:nbr_pts
        error = distPointLine(x2(1:2,j),FF*x1(:,j)) + ...
            distPointLine(x1(1:2,j),FF'*x2(:,j)) ;
        if error<threshold
            matches = [matches j] ;
        else
           nomatch = [nomatch j] ;
        end
    end
    
    if size(matches,2) > max_nbr_matches
        in1 = x1(1:2,matches);
        in2 = x2(1:2,matches);
        out1 = x1(1:2,nomatch);
        out2 = x2(1:2,nomatch);
        max_nbr_matches = size(matches,2) ;
        F_best = FF ;
        r = max_nbr_matches/nbr_pts ;
    end
    
    proba = 1-(1-r^N)^m ;
    if proba > p_stop
        i = maxiter ; %stops the while loop 
        fprintf('--- I stopped after: %0.2f iterations',m) ;
    end
    i = i+1 ;
end
    
end


