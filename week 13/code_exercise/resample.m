function [particles particles_w] = resample(particles,particles_w)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
N = max(size(particles)) ;
new_particles = datasample(particles, N, 'replace', true, 'Weights', particles_w) ;

%associated weight
new_particles_w = zeros(N,1) ;
for i = 1:N
    index = find(new_particles(i,:) == particles(:,:),1) ;
    new_particles_w(i) = particles_w(index) ;
end

%% return values
particles_w = new_particles_w/sum(new_particles_w) ;
particles = new_particles ;
end

