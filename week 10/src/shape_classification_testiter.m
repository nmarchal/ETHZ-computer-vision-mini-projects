function classificationAccuracy_test = shape_classification_testiter(testiter, testk)

% perform the shape classification task

DONT_REDO_COST = false ;
SAVE_COST_MAT = false ;

temp = load('dataset.mat');
objects = temp.objects;

nbObjects = length(objects);
nbSamples = 100;
iter_testiter = 0 ;
iter_k = 0 ;
numberiter = max(size(testiter)) ;

for i = testiter
    fprintf(['number iteration = ' int2str(i) '/' int2str(numberiter) '\n \n'])
    iter_testiter = iter_testiter +1 ;
    %write the computeMatchingCosts.m function
    iter_k = 0 ;
    
    for k = testk ;
        iter_k = iter_k +1 ;
        %write the computeMatchingCosts.m function

        if DONT_REDO_COST
            load('matchingCostMatrix') ;
        elseif iter_k ==1
            matchingCostMatrix = compute_matching_costs_testiter(objects,nbSamples, i);
        end

        if SAVE_COST_MAT 
            %this basically kills the function as we won't compute the accuracy
           classificationAccuracy = matchingCostMatrix ; 
        else
            %be sure that the diagonal matrix matchingCostMatrix contains infinite energies
            for o1 = 1:length(objects)
               matchingCostMatrix(o1,o1) = inf; 
            end

            allClasses = {objects(:).class};

            hits = 0;
            for o1 = 1:length(objects)        
                %nearest neighbour classification    
                %write the nn_classify.m function
                testClass = nn_classify(matchingCostMatrix(o1,:),allClasses,k)  ;  
                if strcmpi(allClasses{o1},testClass)        
                    hits = hits + 1;                
                end
            end

            classificationAccuracy_test(iter_k, iter_testiter) = hits/nbObjects;
        end
    end
end
