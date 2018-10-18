function [k, b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with #n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data,2); % Total number of points
best_inliers = 0;       % Best fitting line with largest number of inliers
k=0; b=0;                % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm is useful here 

    % Model is y = k*x + b
    
    % Compute the distances between all points with the fitting line    
        
    % Compute the inliers with distances smaller than the threshold
        
    % Update the number of inliers and fitting model if better model is found
    
end


end
