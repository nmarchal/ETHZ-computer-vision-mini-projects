function particles = propagate(particles,sizeFrame,params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

particles = particles' ; %(2 lines, particle_number columns)

%% update the particules
variance_pos = normrnd(0,params.sigma_position,2,params.num_particles);
variance_vel = normrnd(0,params.sigma_velocity,2,params.num_particles);

if (params.model == 0) % no velocity
    % here it is easy because there is no velocity the A matrix is just
    % the identity as we expect the particules not to move.
    A = eye(2) ;
    particles = (A*particles + variance_pos);
else % constant velocity - here the state length of the particules is 4 because 
%     we have both the position and their velocities
    A =    [1, 0, 1, 0;
            0, 1, 0, 1;
            0, 0, 1, 0;
            0, 0, 0, 1];  
    particles = A*particles +  [variance_pos ; variance_vel] ;
end

%% deal with particules outside the frame

particles(1,:) = min(particles(1,:),sizeFrame(2)); % max y position
particles(1,:) = max(particles(1,:),1); %min y position
particles(2,:) = min(particles(2,:),sizeFrame(1)); %max x position
particles(2,:) = max(particles(2,:),1); %min x position

particles = particles' ; %(2 columns, particle_number lines)
end

