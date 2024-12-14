function generate_controller_and_simulate()
    % Step 1: Trace Circle Code
    [link_vectors, joint_axes, shape_to_draw, J, joint_velocity, T, a_start, sol, alpha, ax, link_colors, link_set, l, p, l_trace, link_set_history] = ME317_Assignment_trace_circle();

    % Step 2: Save Joint Angle Trajectories
    % Save the joint angle trajectory to a .mat file
    save('joint_angles.mat', 'alpha');
    
    % Step 3: Generate Mass Matrices and Controller Gains
    time_points = [0, 1/8, 1/4, 3/8, 1/2, 5/8, 3/4, 7/8, 1];
    K_matrices = cell(length(time_points));
    
    % Loop through each time point
    for i = 1:length(time_points)
        t = time_points(i);
        
        % Get the joint angles at this time
        joint_angles = alpha(:,(t*100)+1); 
 
        % Compute mass matrix at this configuration (simplified for this example)
        M = mass_matrix(link_vectors, joint_angles); % Replace with actual mass matrix calculation
        
        % Generate A and B matrices for the controller
        A = [zeros(length(joint_angles)), eye(length(joint_angles)); zeros(length(joint_angles)), zeros(length(joint_angles))];
        B = [zeros(length(joint_angles)), inv(M)];
        
        % Specify desired pole locations
        p = -100 * ones(length(joint_angles));
        
        % Calculate the feedback gain matrix K using the place command
        K = place(A, B, p);
        
        % Save the K matrix for this time point
        K_matrices{i} = K;
     end
    
    % Save the K matrices to a .mat file
    save('controller_gains.mat', 'K_matrices');
    
    % Step 4: Modify the Controller (p values change)
    for i = 1:length(time_points)
        t = time_points(i);
        
        % Get the joint angles and velocities
        joint_angles = alpha(:, round(t * length(alpha)));
        joint_velocities = joint_velocity(t, alpha);
        
        % Calculate the error vector (difference between trajectory and current values)
        error_angles = joint_angles - joint_angles; % Placeholder, replace with actual kinematic trajectory
        error_velocities = joint_velocities - joint_velocities; % Same as above
        
        % Modify the p values
        p = 1/10 * ones(1, length(joint_angles));
        
        % Recompute K matrix with new p values
        K = place(A, B, p);
        
        % Compute the control forces (torques) using the error and the controller gain
        u = K * [error_angles; error_velocities];
        
        % Step 5: Simulate the System Motion
        % Apply the controller to simulate the system's motion (simplified here)
        % Integrate using ode45
        [t_sim, alpha_sim] = ode45(@(t, alpha) joint_velocity(t, alpha), T, a_start);
        
        % Step 6: Simulate with new controller (using p = 1/10)
        % Same as previous, just with the updated controller settings
        [t_sim_new, alpha_sim_new] = ode45(@(t, alpha) joint_velocity(t, alpha), T, a_start);
        
        % Optionally plot or save the simulation results
        figure;
        plot(t_sim, alpha_sim);
        title('Joint Angles over Time (Original Controller)');
        
        figure;
        plot(t_sim_new, alpha_sim_new);
        title('Joint Angles over Time (Modified Controller)');
    end
end

function M = mass_matrix(link_vectors, joint_angles)
    % This function should compute the mass matrix for the given link vectors and joint angles.
    % For now, we are returning a dummy matrix. Replace with actual mass matrix calculation.
    n = length(joint_angles);
    M = eye(n); % Dummy identity matrix, replace with real calculation.
end
