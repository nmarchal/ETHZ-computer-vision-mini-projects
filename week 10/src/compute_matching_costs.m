function [matchingCostMatrix] = compute_matching_costs(objects,nbSamples)
%UNTITLED Summary of this function goes here

N = max(size(objects)) ;
matchingCostMatrix = zeros(N) ;

for i = 1:N
%     img1 = get_samples_1(objects(i).X,nbSamples);
    img1 = get_samples(objects(i).X,nbSamples) ;
%     fprintf([int2str(i) '\n']);
    for j = 1:N
        if i == j
            matchingCostMatrix(i,j) = inf ;
            continue
        end
%         img2 = get_samples_1(objects(j).X,nbSamples);
        img2 = get_samples(objects(j).X,nbSamples) ;
        matchingCostMatrix(i,j) = shape_matching(img1,img2,false);
%         fprintf([int2str(i) 'and' int2str(j) '\n']);
    end
end
imagesc(matchingCostMatrix)        

end

