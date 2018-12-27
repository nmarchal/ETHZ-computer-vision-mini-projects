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

% function [ updated_particles, updated_w ] = resample( particles, particles_w )
% %RESAMPLE resample the particles based on their weights
% %   Detailed explanation goes here
% 
% low_variance = true; %otherwise resample wheel
% 
% if low_variance
% 
%     N = size(particles,1);
%     i = 1;
%     r = rand()*N^-1;
%     c = particles_w(1);
%     updated_particles = zeros(size(particles));
%     updated_w = zeros(size(particles_w));
%     for m = 1:N
%         u = r + (m-1)*N^-1;
%         while u > c
%             i = i + 1;
%             if i > N
%                i = 1; 
%             end
%             c = c + particles_w(i);
%         end
%     updated_particles(m,:) = particles(i,:);
%     updated_w(m) = particles_w(i);
%     end
%     
% else
%     
%     N = size(particles,1);
%     index = randi(N);
%     beta = 0;
%     mw = max(particles_w);
%     updated_particles = zeros(size(particles));
%     updated_w = zeros(size(particles_w));
%     for i = 1:N
%         beta = beta + rand()*2*mw;
%         while beta > particles_w(index)
%             beta = beta - particles_w(index);
%             index = index+1;
%             if index > N
%                 index = 1;
%             end
%         end
%     updated_particles(i,:) = particles(index,:);
%     updated_w(i) = particles_w(index);
%     end
%     
% end
%     updated_w = updated_w/sum(updated_w);
% end
% 
