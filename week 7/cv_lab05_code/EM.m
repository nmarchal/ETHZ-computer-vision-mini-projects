function [map cluster] = EM(img)

%% creat the distribution X (copy paste from meanshiftSeg.m)
width = size(img,2) ; height = size(img,1) ;
L = width*height ;
l = (reshape(img(:,:,1), 1,L)) ;
a = (reshape(img(:,:,2), 1,L)) ;
b = (reshape(img(:,:,3), 1,L)) ;
X = [l;a;b] ;
%I need to normalize the points, This will amke it much easier to chose
%threshold parameters (adapt function from HW1)
Xh = [X ; ones(1,L)] ;
size(Xh) ;
Xh = double(Xh) ;
[Xhn, T] = normalization(Xh) ;
% these will help me understand the distribution in the image to set a
% radius and a tolerance to stop lookign for new mean
max_im = max(max(X)) ; % 249
min_im = min(min(X)) ; % 9
mean_im = mean(norm(double(X))) ; %116

%% generate the parameters
%number of clusters (depends on the image we have)
K = 3 ;
% initialization of alpha (see slides)
alpha = ones(1,K)/K;

% Find ranges of values in L*a*b space
Lmax = max(Xhn(:,1)); Lmin = min(Xhn(:,1)); rangeL = Lmax - Lmin ;
amax = max(Xhn(:,2)); amin = min(Xhn(:,2)); rangea = amax - amin ;
bmax = max(Xhn(:,3)); bmin = min(Xhn(:,3)); rangeb = bmax - bmin ;
% use function generate_mu to initialize mus
mu = generate_mu(Lmin, amin, bmin, rangeL, rangea, rangeb, K);
% figure ; 
% histogram(mu(3,:),5)
% use function generate_cov to initialize covariances
var = generate_cov(rangeL, rangea, rangeb, K) ;

%%
% iterate between maximization and expectation
tol = 1/20*sqrt(3); %need to tune this parameter
deltaMu = tol+1 ;
iter = 0 ;
while deltaMu > tol;
    iter = iter+1 ;
    fprintf('I have performed %d iterations of EM already\n', iter);
    
%     if mod(iter,2) == 0
%         fprintf(int2str(i)) ;
%         fprintf('iterations of EM\n')
%         fprintf(int2str(deltaMu)) ;
%         fprintf('delata mu \n\n')
%     end

    % use function expectation
    P = expectation(mu,var,alpha,Xhn(1:3,:));
    % use function maximization
    [mu1, var1, alpha1] = maximization(P, Xhn(1:3,:));
    deltaMu = norm(mu(:)-mu1(:)) ;
    mu = mu1; 
    var = var1;
    alpha = alpha1;
% %   ids = visualizeMostLikelySegments(Xn,alpha_s,mu_s,var_s);
end

%% find a label for each pixel

[~,label_idx] = max(P,[],2) ;
map = reshape(label_idx ,height, width) ;
cluster = mu ;

%unormalize
clusterh = [cluster;ones(1,size(cluster,2))];
clusteru = T\clusterh;
cluster = clusteru(1:3,:)';

end