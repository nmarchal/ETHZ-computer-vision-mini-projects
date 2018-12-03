function [testClass] = nn_classify(matchingCostVector,trainClasses,k)
% matchingCostVector:
% shape matching costs obtained by matching the test shape to all training shapes 
% 
% trainClasses :
% the class labels of the training shapes 
% 
% k :
% number of neighbours to consider
% 
% testClass:
% class label of the test shape as its output

[~,idx_sort] = sort(matchingCostVector, 'ascend') ;
heart = 0 ; fork = 0 ; watch = 0 ;

for i = idx_sort(1:k)
    if strcmpi(trainClasses(i),'Heart')  
        heart = heart+1 ;
    elseif strcmpi(trainClasses(i),'fork')  
        fork = fork+1 ;
    elseif strcmpi(trainClasses(i),'watch')  
        watch = watch+1 ;
    end
end

results = [heart fork watch] ;
results_label = {'Heart', 'fork', 'watch'} ;
[~,max_idx] = max(results) ;

if max(size(max_idx)) > 1
    fprintf('This one had an equal amount of nearest neighbour \n')
    max_idx = datasample(max_idx,1) ; %randomly select 1 class
end 

testClass = results_label{max_idx} ;




