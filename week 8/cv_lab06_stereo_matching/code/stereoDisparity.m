function disp = stereoDisparity(img1, img2, dispRange)
% dispRange: range of possible disparity values
% --> not all values need to be checked

box_size = 20 ; %try different values, 3,5,7 etc

img1 = double(img1) ;
img2 = double(img2) ;
% fprintf('starting disparity \n')

for d = dispRange
%     if mod(d,10) == 0
%         fprintf(['I am at range : ' int2str(d) '\n'])
%     end
    
    img2_shift = shiftImage( img2, d ) ;
    diff_img = (img1 - img2_shift).^2 ;
    box_filter = fspecial('average',box_size) ;
    diff = conv2( diff_img, box_filter,'same') ;
    if d == dispRange(1)
        bestDiff = diff ;
        disp = d*ones(size(diff)) ;
    else
        mask = diff < bestDiff ;
        mask_inv = diff >= bestDiff ;
        disp = disp.*mask_inv + d.*mask ;
        bestDiff = bestDiff.*mask_inv + diff.*mask ;
%         bestDiff(mask) = diff(mask) ;
%         disp(mask) = d*find(mask) ;
    end
end    

end