function [link_vectors,...
          joint_angles,...
          joint_axes,...
          link_colors,...
          link_set,...
          joint_axis_vectors_R,...
          ax,...
          l,...
          l3]= ME317_Assignment_draw_3D_arm_solid_links
% Draw the arm as a set of hexagonal prisms, one per link

    %%%%%%%%%%
    % Specify link vectors as a 1x3 cell array of 3x1 vectors, named
    % 'link_vectors'
    link_vectors = {[1; 0; 0],[1; 0; 0], [0; 0; 0.5]};
    
    %%%%%%%%%%
    % Specify joint angles as a 3x1 vector, named 'joint_angles'
    joint_angles = [pi*2/5; -pi/4; pi/4];

    %%%%%%%%%%
    % Specify joint axes as a 1x3 cell array, named 'joint_axes'
    joint_axes = {'z', 'y', 'x'};
    
    %%%%%%%%%%
    % Specify colors of links as a 1x3 cell array named 'link_colors'. Each
    % entry can be either a standard matlab color string (e.g., 'k' or 'r')
    % or a 1x3 vector of the RGB values for the color (range from 0 to 1)
    link_colors = {'green', 'red', 'cyan'};

    %%%%%%%%%
    % Generate a cell array named 'link_set' containing start-and-end
    % points for the links, named link_set
    link_set = threeD_solid_robot_arm_links(link_vectors,joint_angles,joint_axes);

    %%%%%%%%%%
    % Use arm_Jacobian to get link_ends and joint_axis_vectors_R (we will
    % use these to draw the axes onto the plot, so that it's easier to see
    % how each joint rotates). Any value of 'link_number' should be good
    % for this
    [~,...
          link_ends,...
          ~,...   
          ~,...
          ~,...
          ~,...
          joint_axis_vectors_R,...
          ~] = arm_Jacobian(link_vectors,joint_angles,joint_axes,3);
    
 
    %%%%%%%%%
    % Create figure and axes for the plot, and store the handle in a
    % variable named 'ax'
    ax = create_axes(317);

    %%%%%%%%%
    % Draw a surface for each link, and save the handles to these surfaces
    % in a cell array named 'l'
    l = threeD_solid_draw_links(link_set,link_colors,ax);
    
    %%%%%%%%%
    % Use 'view(ax,3)' to get a 3-dimensional view angle on the plot
    view(ax,3)

    % Use axis(ax,'vis3d') to make the arm stay the same size as you rotate
    % it
    axis(ax,'vis3d')

    %%%%%%%%%
    % Loop over the locations of the joints (the base points of
    % the links), and draw a dashed line from that joint to the point one
    % unit from the joint in the direction of that joint's axis
    for idx = 1:3
        x = [link_ends(1,idx),link_ends(1,idx)+joint_axis_vectors_R{idx}(1)];
        y = [link_ends(2,idx),link_ends(2,idx)+joint_axis_vectors_R{idx}(2)];
        z = [link_ends(3,idx),link_ends(3,idx)+joint_axis_vectors_R{idx}(3)];
            
    % Save the handles to these lines into a cell array called 'l3'.
        l3{idx} = line('XData', x, 'YData', y, 'ZData', z,...
             'linestyle', '--' ,'color', link_colors{idx});
    end     
    % As you make these lines, set their color property to be the
    % same as the link immediately after the joint
    
end