function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
N = max(size(particles)) ;
particles_w = zeros(N,1) ;
for i = 1:N
    xMin = particles(i,1) - W/2;
    xMax = particles(i,1) + W/2;
    yMin = particles(i,2) - H/2;
    yMax = particles(i,2) + H/2;
    particule_hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin);
    distance = chi2_cost(hist_target,particule_hist);
    %formula given in the exercise
    particles_w(i) = 1/(sqrt(2*pi)*sigma_observe)* ...
        exp(-(distance^2)/(2*sigma_observe^2));
end
%normalize
particles_w = particles_w/sum(particles_w);
end

