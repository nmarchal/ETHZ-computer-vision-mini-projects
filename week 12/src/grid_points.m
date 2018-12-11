function vPoints = grid_points(img,nPointsX,nPointsY,border)
    [Ysize Xsize] = size(img) ;
    
    X = int32(linspace(1+border, Xsize-border, nPointsX)) ;
    Y = int32(linspace(1+border, Ysize-border, nPointsY)) ;
    
    [X,Y] = meshgrid(X,Y) ;
    X = reshape(X,nPointsX*nPointsY,1) ;
    Y = reshape(Y,nPointsY*nPointsX,1) ;
    vPoints = [X, Y] ;
    
end
