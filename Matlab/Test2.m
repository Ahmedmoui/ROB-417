function robotic_arm_simulation
    % STEP 1: Trace Circle code and trajectory generation
    [link_vectors, joint_axes, shape_to_draw, J, joint_velocity, T, a_start, sol, alpha, ax, link_colors, link_set, l, p, link_set_history] = ME317_Assignment_trace_circle();
    
    % Save the joint angles to a .mat file for future use
    save('joint_trajectories.mat', 'alpha');
    
    % STEP 2: Generate Mass Matrices at specified time points
    time_points = [0, 1/8, 1/4, 3/8, 1/2, 5/8, 3/4, 7/8, 1];
    mass_matrices = cell(length(time_points), 1);
    K_matrices = cell(length(time_points), 1);
    
    for i = 1:length(time_points)
        t = time_points(i);
        % Get the joint angles at time t
        joint_angles_at_t = alpha(:, round(t * length(alpha)));
        
        % Compute mass matrix at time t
        M_t = inertia_matrix(link_vectors, joint_angles_at_t, joint_axes);
        mass_matrices{i} = M_t;
        
        % Define the system matrices A, B, and P for place function
        n = length(joint_angles_at_t);
        A = zeros(n); % Placeholder for A matrix
        B = ones(n, 1); % Placeholder for B matrix
        P = eye(n) * 1/100; % Placeholder for P matrix, initially set to 1/100
        
        % Use place function to compute the gain matrix K
        K_matrices{i} = place(A, B, P);
    end
    
    % STEP 3: Controller Implementation
    % Define the controller that computes the joint forces based on the error in joint angles and velocities
    controller = @(current_time, current_angles, current_velocities) controller_function(current_time, current_angles, current_velocities, alpha, K_matrices, time_points);
    
    % STEP 4: Simulate the system motion with controller forces
    % Setup ODE solver for robot motion under controller influence
    simulate_system(controller, T, a_start);
    
    % STEP 5: Modify Controller with P values 1/10 instead of 1/100
    modified_P = eye(n) * 1/10;
    for i = 1:length(time_points)
        t = time_points(i);
        % Use the modified P value to recompute K matrices
        K_matrices{i} = place(A, B, modified_P);
    end
    
    % Simulate the system again with the modified controller
    simulate_system(controller, T, a_start);
end

function M = inertia_matrix(link_vectors, joint_angles, joint_axes)
    % Compute the mass matrix (simplified for this example)
    % In a real implementation, this would be a function of the robot's physical properties
    M = eye(length(joint_angles)); % Placeholder for the inertia matrix
end

function controller_forces = controller_function(current_time, current_angles, current_velocities, alpha, K_matrices, time_points)
    % Find the nearest time index based on current time
    [~, idx] = min(abs(current_time - time_points));
    
    % Get the desired joint angles and velocities from the trajectory at the corresponding time
    desired_angles = alpha(:, round(current_time * length(alpha)));
    desired_velocities = diff(desired_angles, 1, 2) / (1/100); % Approximate velocity
    
    % Calculate error in angles and velocities
    angle_error = current_angles - desired_angles;
    velocity_error = current_velocities - desired_velocities;
    
    % Compute the control forces using the gain matrix at the nearest time point
    K = K_matrices{idx};
    controller_forces = -K * [angle_error; velocity_error];
end

function simulate_system(controller, T, a_start)
    % Simulate the robot's motion under the controller
    % Setup ODE function to include control forces
    state_start = [a_start; zeros(length(a_start), 1)];
    ODE_func = @(t, state) state_derivative(t, state, controller);
    
    % Use ode45 to solve the system's motion over the time span
    sol = ode45(ODE_func, T, state_start);
    
    % Get the joint states over time
    state_history = deval(sol, linspace(T(1), T(2), 300));
    alpha = state_history(1:end/2, :);
    alphadot = state_history((end/2)+1:end, :);
    
    % Plot joint angles over time
    figure;
    plot(linspace(T(1), T(2), 300), alpha(1, :), 'r', 'DisplayName', 'Joint 1');
    hold on;
    plot(linspace(T(1), T(2), 300), alpha(2, :), 'b', 'DisplayName', 'Joint 2');
    title('Joint Angles Over Time');
    xlabel('Time (s)');
    ylabel('Angle (rad)');
    legend;
    grid on;
end

function dstate = state_derivative(t, state, controller)
    % Compute the state derivative based on the controller forces
    % State is [angles; velocities], return the derivative [velocities; accelerations]
    angles = state(1:end/2);
    velocities = state((end/2)+1:end);
    
    % Compute control forces using the controller
    controller_forces = controller(t, angles, velocities);
    
    % Placeholder dynamics (for simplicity, use identity dynamics)
    M = eye(length(angles)); % Mass matrix (identity for simplicity)
    C = zeros(length(angles)); % Coriolis/centrifugal forces (zero for simplicity)
    G = zeros(length(angles), 1); % Gravitational forces (zero for simplicity)
    
    % Derivative of state: [velocities; accelerations]
    accelerations = M \ (controller_forces - C * velocities - G);
    dstate = [velocities; accelerations];
end
