function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   
    N = max(size(vPoints)) ;
    
    descriptors = zeros(N,nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(N,4*w*4*h); % image patches stored in rows    
    
    [grad_x,grad_y]=gradient(img); 
    grad_orientation = atan2(grad_y,grad_y) ;
    
    for i = [1:size(vPoints,1)] % for all local feature points
        m=1 ;
        n=1 ;
        for j = -2:1
            for k = -2:1
                patch = img((vPoints(i,2)+k*h):(vPoints(i,2)+(k+1)*h-1), ...
                            (vPoints(i,1)+j*w):(vPoints(i,1)+(j+1)*w-1)); 
                patch_orientation = grad_orientation( ...
                                (vPoints(i,2)+k*h):(vPoints(i,2)+(k+1)*h-1), ...
                                (vPoints(i,1)+j*w):(vPoints(i,1)+(j+1)*w-1)) ;
                descriptors(m:m+7) = histcounts(patch_orientation, ...
                                                nBins,'BinLimits',[-pi,pi]);
                patches(i,n:n + w*h-1) = reshape(patch,1,w*h) ;
                m = m+8 ;
                n = n + w*h ;
            end
        end
        
        
    end % for all local feature points
    
end
