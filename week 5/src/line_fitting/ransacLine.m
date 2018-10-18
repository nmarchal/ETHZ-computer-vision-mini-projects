function [k, b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with #n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data,2); % Total number of points
best_inliers = 0;       % Best fitting line with largest number of inliers
k=0; b=0;                % parameters for best fitting line
data = [data ; zeros(1,num_pts)] ; % extend to 3d to compute distances

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm is useful here 
    randomSelect = randperm(num_pts) ;
    x1 = data(1,randomSelect(1)) ; y1 = data(2,randomSelect(1)) ; z1 = 0 ;
    x2 = data(1,randomSelect(2)) ; y2 = data(2,randomSelect(2)) ; z2 = 0 ;
     
    point1 = [x1;y1;z1] ;
    point2 = [x2;y2;z2] ;

    % Compute the distances between all points with the fitting line    
    for j = 1:num_pts
        distance(j) = norm(cross(point1-point2,data(:,j)-point2))/norm(point1-point2) ;
    end
    % Compute the inliers with distances smaller than the threshold
        nbr_inliers = size(find(distance < threshold),2) ;
    % Update the number of inliers and fitting model if better model is found
    if nbr_inliers > best_inliers
        best_inliers = nbr_inliers ;
        point1_best = point1 ;
        point2_best = point2 ;
    end
    
end

    % Model is y = k*x + b
    k = (point1_best(2)-point2_best(2)) / (point1_best(1)-point2_best(1)) ;
    b = point1_best(2) - k*point1_best(1) ;
end
