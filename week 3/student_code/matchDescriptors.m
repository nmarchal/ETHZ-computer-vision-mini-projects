% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)
matches = [] ; distance = [] ;
for i = 1:size(descr1,2)
    secondMinimumdistance = 1000 ;
    for j = 1:size(descr2, 2)
        ssd = 0 ;
        diff = (descr1(:,i) - descr2(:,j)).^2 ;
        ssd = sum(diff) ; 
        if j==1
            minimumdistance = ssd ;
            minimumId = j ;
        elseif ssd < minimumdistance
            secondMinimumdistance = minimumdistance ;
            minimumdistance = ssd ;
            minimumId = j ;
        end
        if ssd < secondMinimumdistance & ssd > minimumdistance
            secondMinimumdistance = ssd ;        
        end
    end
    if (minimumdistance < thresh) & ...
            (abs(minimumdistance)/ secondMinimumdistance < 0.4)
         secondMinimumdistance;
         minimumdistance ;
        matches = [matches [i;minimumId]] ;
    end
    distance = [distance minimumdistance] ;
end

figure(8) ; histogram(distance) ;

end