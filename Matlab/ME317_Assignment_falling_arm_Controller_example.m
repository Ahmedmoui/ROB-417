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
  % Modified falling arm code for a 2-link planar arm with PD control

  %%%%%%%%%%%%%%%%%%%%%%%%
  % Specify the system structure (link vectors, link_radii, and joint axes)
  link_vectors = {[1; 0; 0], [1; 0; 0]}; % 2-link planar arm

  % Specify link radii as 1/20 the link length
  for idx = 1:length(link_vectors)
      link_radii(idx) = 1/20 * (sqrt(sum(link_vectors{idx}.^2)));
  end

  % Specify joint axes for planar arm
  joint_axes = {'z', 'z'};

  %%%%%%%%%%%%%%%%%%%%%%
  % Generate the system dynamics functions
  M_function = @(a_start) chain_inertia_matrix(link_vectors, a_start, joint_axes, link_radii);
  dM_function = matrix_derivative(M_function, length(link_vectors));

  % Desired joint angles for PD control
  initial_angles = [pi/4; pi/6];
  desired_angles = initial_angles * 0.9; % Mean value at 90% of initial

  % PD control gains (adjusted for oscillation and cycles)
  Kp = [5; 5]; % Proportional gains
  Kd = [2; 2]; % Derivative gains

  % Define the PD control force
  PD_control = @(time, configuration, velocity) ...
      -Kp .* (configuration - desired_angles) - Kd .* velocity;

  % Update forcing function to include PD control
  F_function = @(time, configuration, velocity) ...
      gravitational_moment(link_vectors, configuration, joint_axes, velocity, link_radii) + ...
      joint_friction(velocity) + ...
      PD_control(time, configuration, velocity);

  %%%%%%%%%%%%%%%%%%%%%%%%%%
  % Set up time-span and initial conditions for the simulation
  T = [0, 5];
  a_start = initial_angles;
  adot_start = [0; 0];
  state_start = [a_start; adot_start];

  %%%%%%%%%%%%%%%%%%%%%%
  % Evaluate the system motion
  state_velocity_function = @(time, state) EulerLagrange_trajectory(time, state, M_function, dM_function, F_function);
  sol = ode45(state_velocity_function, T, state_start);

  % Use 'deval' to find the joint angles and velocities over time
  state_history = deval(sol, linspace(T(1), T(2), 300));
  alpha = state_history(1:end/2, :);
  alphadot = state_history((end/2) + 1:end, :);

  %%%%%%%%%%%%%%%%%%%%%%
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

  %%%%%%%%%%%%%%%%%%%%%%
  % Set up a figure for animation
  ax = create_axes(317);
  link_colors = {'k', 'r'};
  link_set = threeD_robot_arm_links(link_vectors, a_start, joint_axes);
  l = threeD_draw_links(link_set, link_colors, ax);
  view(ax, 2);
  axis(ax, 'equal');
  axis([-2, 2, -2, 2]);

  %%%%%%%%%%%%%%%%%%%%%%
  % Animate the arm and save as a video
  writer = VideoWriter('falling_arm_animation', 'MPEG-4');
  open(writer);

  link_set_history = cell(1, length(alpha));
  for idx = 1:size(alpha, 2)
      link_set = threeD_robot_arm_links(link_vectors, alpha(:, idx), joint_axes);
      threeD_update_links(l, link_set);
      drawnow;
      frame = getframe(gcf);
      writeVideo(writer, frame);
      link_set_history{idx} = link_set;
  end

  close(writer);
end
