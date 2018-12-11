function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   
    N = max(size(vPoints)) ;
    
    descriptors = zeros(N,nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(N,4*w*4*h); % image patches stored in rows    
    
    [grad_x,grad_y]=gradient(img); 
    grad_orientation = atan2(grad_y,grad_x) ;
    
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
                descriptors(i,m:m+7) = histcounts(patch_orientation, ...
                                                nBins,'BinLimits',[-pi,pi]);          
                m = m+8 ;
            end
        end
        patches(i,:) = reshape( ...
                    img((vPoints(i,2)-2*h):(vPoints(i,2)+ 2*h-1), ...
                            (vPoints(i,1)-2 *w):(vPoints(i,1)+2*w-1)) ,1,w*h*4*4) ;
        
    end % for all local feature points
    
end
