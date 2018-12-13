function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)

[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

N = size(vBoWPos,2) ;
P_pos = 0 ; P_neg = 0 ;

for i = 1:N ;
    if (sigmaPos(i) ~=0) %| (muPos(i) == histogram(i))
        P_pos = P_pos + log(normpdf(histogram(i),muPos(i), sigmaPos(i))) ;
     elseif muPos(i) == histogram(i) & muPos(i) ~= 0
        P_pos = P_pos+log(1) ;
    end
    
    if (sigmaNeg(i) ~=0) %| (muNeg(i) == histogram(i))
        P_neg = P_neg + log(normpdf(histogram(i),muNeg(i), sigmaNeg(i))) ;
    elseif muNeg(i) == histogram(i) & muNeg(i)~= 0
        P_neg = P_neg+log(1) ;
    end   
end

label = 0 ;
if P_pos > P_neg
    label = 1 ;
end

end