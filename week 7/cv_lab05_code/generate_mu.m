% Generate initial values for mu
% K is the number of segments

% Each of is a 3x1 vector that represents a point in
% the L*a*b* space. A possible way to initialize is to
% spread them equally in the L*a*b* space
% --> I used a slightly different technique and initialised them at random in the range of lab

function mu = generate_mu(Lmin, amin, bmin, rangeL, rangea, rangeb, K)
    mu = zeros(3,K) ;
    for i = 1:K
        l = Lmin + rangeL.*rand(1,1) ;
        a = amin + rangea.*rand(1,1) ;
        b = bmin + rangeb.*rand(1,1) ;
        mu(:,i) = [l ; a ; b];
    end
end