function diffs = diffsGC(img1, img2, dispRange)
% get data costs for graph cut

k = dispRange(end) - dispRange(1) ;
box_size = 7 ;
diffs = zeros(size(img1,1), size(img1,2) ,k) ;

for i = 0:k
    img2_shift = shiftImage( img2, i-ceil(k/2) ) ;
    sz = size(img1);
    diffs(:,:,i+1) = (img1 - img2_shift).^2 ;
    
    box_filter = fspecial('average',box_size) ;
    diffs(:,:,i+1) = conv2( diffs(:,:,i+1), box_filter,'same') ;
    
%     if mod(i,10) == 0
%         fprintf(['I am at range : ' int2str(i) '\n'])
%     end
end

end