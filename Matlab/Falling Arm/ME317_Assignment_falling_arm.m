function [link_vectors,...
          joint_axes,...
          T,...
          a_start,...
          sol,...
          alpha,...
          ax,...
          link_set,...
          l,...
          link_set_history] = ME317_Assignment_falling_arm
  % Make an animated plot of a robot arm falling under the effect of gravity
    %%%%%%%%%%%%%%%%%%%%%%%
    % Specify the system structure (link vectors, link_radii, and joint
    % axes)
    % Specify link vectors as a 1x3 cell array of 3x1 vectors, named
    % 'link_vectors'

    link_vectors = {[1;0;0], [1;0;0], [0;1;0]};
    
    % Specify link radii as 1/20 the link length
    for idx = 1:length(link_vectors)
        link_radii(idx) = 1/20 * (sqrt(sum(link_vectors{idx}.^2)));
    end

    % Specify joint axes as a cell array of the same size as link_vectors, named 'joint_axes'
    joint_axes = {'z' 'y' 'z'};
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Generate the system dynamics functions (inertia,
    % derivative-of-inertia, and force)
    
    % Generate the system inertia function 'M_function' as an anonymous
    % function that takes in a single input, uses that input as the
    % 'joint_angles' input to 'chain_inertia_matrix', and takes the rest of
    % the 'chain_inertia_matrix' inputs from the system information
    % specified above
    M_function = @(a_start) chain_inertia_matrix(link_vectors, a_start, joint_axes, link_radii);
    
    % Generate the system inertia derivitive function 'dM_function' by
    % applying 'matrix_derivative' to 'M_function', with the number of
    % configuration variables taken from the system information above
    dM_function = matrix_derivative(M_function, length(link_vectors));

    % Generate the forcing function 'F_function' on the system by constructing an
    % anonymous function that takes in time, configuration, and
    % configuration velocity, uses them to evaluate both the
    % 'gravitational_moment' and 'joint_friction' functions, and sums the
    % result. ('gravitational_moment' needs additional inputs, which should
    % be taken from the system information above)
    F_function = @(time, configuration, velocity) gravitational_moment(link_vectors, configuration, joint_axes, velocity, link_radii) + joint_friction(velocity);

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set up time-span and initial conditions for the simulation
    % Specify the time-span 'T' as being from zero to thirty
    T = [0 30];
    
    % Specify the starting configuration 'a_start' as being zero for all
    % joint angles
    a_start = [0; 0; 0];
    
    % Specify the starting velocity for the system 'adot_start' as being
    % all zeros (i.e., the system starts at rest)
    adot_start = [0; 0; 0];
    
    % Specify the initial state vector 'state_start' by stacking the a_start values on top of
    % the adot_start values
    state_start = [a_start; adot_start];
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Evaluate the system motion for the specified structure, initial
    % conditions, and time-span
    
    % Use the 'M_function','dM_function', and 'F_function' functions
    % generated above to construct an anonymous function
    % 'state_velocity_function' that takes in time and a system state
    % vector, passes them to 'EulerLagrange_trajectory', and returns the
    % corresponding state velocity for the system
    state_velocity_function = @(time, state) EulerLagrange_trajectory(time, state, M_function, dM_function, F_function);
    
    % Run the 'ode45' solver with 'state_velocity_function' as the function
    % that maps from time and configuration to configuration velocity, 'T'
    % as the timespan, and 'state_start' as the initial configuration. Call the
    % output 'sol'
    sol = ode45(state_velocity_function, T, state_start);
    
    % Use 'deval' to find the joint angles at a series of 300 times spaced
    % evenly along the interval T, saving the output to a
    % variable 'state_history'
    state_history = deval(sol, linspace(T(1), T(2), 300));
    
    % Split 'state_history' into two components: 'alpha', with the values
    % in the top half of state_history, and 'alphadot', with the values in
    % the bottom half of state history (note that we don't actually use
    % 'alphadot' in this function).
    alpha = state_history(1:end/2, :);
    alphadot = state_history((end/2) + 1:end, :);

    %%%%%%%%%%%%%%%%%%%%%%
    % Set up a figure in which to animate the motion of the arm as it falls
    % under gravity
    
    % Create figure and axes for the plot using 'create_axes', and store
    % the handle in a variable named 'ax'
    ax = create_axes(317);

    % Specify colors of links as a 1x3 cell array named 'link_colors'. Each
    % entry can be either a standard matlab color string (e.g., 'k' or 'r')
    % or a 1x3 vector of the RGB values for the color (range from 0 to 1)
    link_colors = {'k' 'r' 'b'};

    % Generate a cell array named 'link_set' containing start-and-end
    % points for the links
    link_set = threeD_robot_arm_links(link_vectors, a_start, joint_axes);
    
    % Draw a line for each link, (using threeD_draw_links) and save the handles 
    % to these lines in a cell array named 'l'
    l = threeD_draw_links(link_set, link_colors, ax);
    
    % Use 'view(ax,3)' to get a 3-dimensional view angle on the plot
    view(ax, 3);
    
    % Use axis(ax,'vis3d') to make the arm stay the same size as you rotate
    % it
    axis(ax, 'vis3d');
    
    % Set the axis limits to [-0.5    3   -0.85    1.85   -2    1]
    axis([-0.5 3 -0.85 1.85 -2 1]);

    %%%%%%%%%%%%%%%%%%%%%%%
    % Animate the arm
    
    % For grading, create an empty 1xn cell array named 'link_set_history'
    % to hold the link line points at each time
    link_set_history = cell(1, length(link_vectors));
    
    % Loop over the columns of alpha
        
        % Get the line points for the arm with the joint angles from
        % that column of alpha, saving them in the variable 'link_set'
        
        % Use the elements of link_set to update the illustration
        
        % Use the 'drawnow' command to make matlab update the figure before
        % going to the next step of the loop

        % Save the current link_set into the corresponding element
        % of link_set_history 

    for idx = 1:length(alpha)
        link_set = threeD_robot_arm_links(link_vectors, alpha(:, idx), joint_axes);
        updatedLinks = threeD_update_links(l, link_set);
        drawnow;
        link_set_history{idx} = link_set;
    end    
    
    
 
end