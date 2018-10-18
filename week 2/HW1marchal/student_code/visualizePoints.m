function visualizePoints(P,xy) 

IMG_NAME = 'images/image3d.jpg';
img = imread(IMG_NAME);
imshow(img); hold on ;
numberx = 7 ; numbery = 7 ; numberz = 8;

%left pannel
for i = 0:7
    for j = 0:8
        X = i*0.027 ; Y = 0 ; Z= j*0.027 ; 
        object_homogeneous = [X Y Z 1]' ;
        point_homogeneous = P*object_homogeneous ;
        scale = point_homogeneous(3) ;
        point_homogeneous = 1/scale * point_homogeneous ;
        point = transpose(point_homogeneous(1:2)) ;
        plot(point(1), point(2) , 'Marker','+','MarkerEdgeColor', ...
            'b','MarkerSize',10,'linewidth', 2) ; hold on;
    end
end
%right pannel
for i = 0:7
    for j = 0:8
        Y = i*0.027 ; X = 0 ; Z= j*0.027 ; 
        object_homogeneous = [X Y Z 1]' ;
        point_homogeneous = P*object_homogeneous ;
        scale = point_homogeneous(3) ;
        point_homogeneous = 1/scale * point_homogeneous ;
        point = transpose(point_homogeneous(1:2)) ;
        plot(point(1), point(2) , 'Marker','+','MarkerEdgeColor', ...
            'b','MarkerSize',10,'linewidth', 2) ; hold on;
    end  
end
%show reference points
for i = 1:(size(xy,2))
    plot(xy(1,i), xy(2,i) , 'Marker','o','MarkerEdgeColor', ...
            'r','MarkerSize',15,'linewidth', 2) ; hold on;
end

end