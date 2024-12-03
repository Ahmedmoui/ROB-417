function [link_vectors,...
          joint_axes,...
          shape_to_draw,...
          J,...
          joint_velocity,...
          T,...
          a_start,...
          sol,...
          alpha,...
          ax,...
          link_colors,...
          link_set,...
          l,...
          p,...
          l_trace,...
          link_set_history] = ME317_Assignment_trace_circle
  % Make an animated plot of a robot arm tracing a circle in the yz plane
 



    %%%%%%%%%%
    % Specify link vectors as a 1x3 cell array of 3x1 vectors, named
    % 'link_vectors'
    link_vectors = {[1;0;0] [1;0;0] [0.75;0;0]};

    %%%%%%%%%%
    % Specify joint axes as a cell array of the same size as link_vectors, named 'joint_axes'

    joint_axes = {'y','z','z'};
    
    %%%%%%%%%%
    % Specify the function to be traced as a circle around the x axis with
    % a half-unit radius. Use the @ syntax to create handle to an anonymous
    % function named 'shape_to_draw' that takes in a time 't' and passes it
    % to the 'circle_x' function, then multiplies the result by 1/2

    shape_to_draw = @(t) 0.51*circle_x(t);

    %%%%%%%%%%
    % Create a function 'J' that takes in a set of joint angles and returns
    % the Jacobian of the arm at those joint angles. Use the 
    % '@(b) f(a,b,c)' syntax to specify the inputs to J that should be 
    % passed to arm_Jacobian.

    J = @(joint_angles) arm_Jacobian(link_vectors,joint_angles,joint_axes,3);

 
    %%%%%%%%%%
    % Create a function 'joint_velocity' that takes in time 't' and configuration
    % 'alpha' and passes them to 'follow trajectory' along with J and shape_to_draw

    joint_velocity = @(t,alpha) follow_trajectory(t,alpha,J,shape_to_draw);

    %%%%%%%%%%%%%%
    % Set up parameters for differential equation solver
    
    % Specify the time range 'T' as being from zero to one

    T = [0 1];
    
    % Specify the starting configuration 'a_start' as being zero for the
    % first joint, pi/4 (angled down) for the second joint, and -pi/2
    % (right-angle up) for the third joint

    a_start = [0; pi/4 ; -pi/2];
    
    %%%%%%%%%
    % Run the ode45 solver with 'joint_velocity' as the function that maps
    % from time and configuration to configuration velocity, 'T' as the
    % timespan, and 'a_start' as the initial configuration
    
    sol = ode45(joint_velocity,T,a_start);
    
    % Use deval to find the joint angles at a series of 100 times spaced
    % evenly along the interval from zero to one, saving the output to a
    % variable 'alpha'

    x = linspace(0,1,100);
    alpha = deval(sol,x);
    
    %%%%%%%%%
    % Create figure and axes for the plot, and store the handle in a
    % variable named 'ax'

    ax = create_axes(317);
    
    %%%%%%%%%%
    % Specify colors of links as a 1x3 cell array named 'link_colors'. Each
    % entry can be either a standard matlab color string (e.g., 'k' or 'r')
    % or a 1x3 vector of the RGB values for the color (range from 0 to 1)

    link_colors = {'r','g','b'};

    %%%%%%%%%
    % Generate a cell array named 'link_set' containing start-and-end
    % points for the links

    link_set = threeD_robot_arm_links(link_vectors, alpha(:,1) ,joint_axes);
    
    %%%%%%%%%
    % Draw a line segment for each link with threeD_draw_links, and
    % save the handles into a cell array named 'l'

    l = threeD_draw_links(link_set, link_colors, ax);
    
    %%%%%%%%%
    % Draw the path that the end of the robot follows
    
    % Start by creating an empty matrix 'p' with three rows and as many
    % columns (time-points) as there are in alpha

    p = zeros(3,length(alpha));

    % Next, loop over  the columns of alpha

    for idx = 1:length(alpha)
        
        % For each column, calculate the endpoints for the links in the robot arm
        [~,~,~,~,~, endP{idx}] = threeD_robot_arm_endpoints(link_vectors,alpha(:,idx),joint_axes);
        
        % Save the endpoint of the last link into the corresponding column
        % of p
        p(:,idx) = endP{idx}{end};
    end
    
    % Finally, make a line whose data points are the rows of p, and whose
    % parent is the plotting axis, and save the handle to this line in a
    % variable 'l_trace'
    
    x = p(1,:);
    y = p(2,:);
    z = p(3,:);
    l_trace = line('XData',x,'YData',y,'ZData',z,'Parent',ax,'color','b');

    %%%%%%%%%
    % Use 'view(ax,3)' to get a 3-dimensional view angle on the plot

    view(ax,3)

    % Use axis(ax,'vis3d') to make the arm stay the same size as you rotate
    % it

    axis(ax,'vis3d')
     
    % Use axis(ax,'manual') to make the arm stay the same size as you move
    % the joints

    axis(ax,'manual')

    %%%%%%%%%
    % Animate the arm
    
    % For grading, create an empty 1xn cell array named 'link_set_history'
    % to hold the the endpoints of link at each time

  link_set_history = cell(1, length(alpha));
    
    % Loop over the columns of alpha
    for idx = 1:length(alpha)

        % Get the endpoints for the arm with the joint angles from
        % that column of alpha, saving them in the variable 'link_set'
        
        link_set = threeD_robot_arm_links(link_vectors, alpha(:,idx) ,joint_axes);

        % Use the elements of link_set to update the illustration

        l = threeD_update_links(l,link_set);

        % Use the 'drawnow' command to make matlab update the figure before
        % going to the next step of the loop

        drawnow;

        % Save the current link_set into the corresponding element
        % of link_set_history 

        link_set_history{idx} = link_set;
    end
    
 
end