%
% BAG OF WORDS RECOGNITION EXERCISE
%
N_times = 13 ;
codebook_args = 10:20:300;
acc_by = zeros(length(codebook_args),1);
acc_nn = zeros(length(codebook_args),1);
i = 0 ;
for sizeCodebook = codebook_args
    i = i+1 ;
    for j=1:N_times
        %training
        
        numIterations = 10;
        vCenters = create_codebook('../data/cars-training-pos',sizeCodebook,numIterations);
        %keyboard;
        disp('processing positve training images');
        vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
        disp('processing negative training images');
        vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
        disp('processing positve testing images');
        vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
        disp('processing negative testing images');
        vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);

        nrPos = size(vBoWPos_test,1);
        nrNeg = size(vBoWNeg_test,1);

        test_histograms = [vBoWPos_test;vBoWNeg_test];
        labels = [ones(nrPos,1);zeros(nrNeg,1)];

        disp('______________________________________')
        disp('Nearest Neighbor classifier')
        acc_nn(i) = acc_nn(i) + 1/N_times*bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
        disp('______________________________________')
        disp('Bayesian classifier')
        acc_by(i) = acc_by(i) + 1/N_times*bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
        disp('______________________________________')
    end
end