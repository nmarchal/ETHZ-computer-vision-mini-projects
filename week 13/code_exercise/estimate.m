function meanState = estimate(particles,particles_w)
%This function should estimate the mean state given the particles and their weights
meanState = sum(particles.*particles_w,1) ;
end

