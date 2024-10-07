function [link_vectors,...
          joint_angles,...
          joint_axes,...
          link_colors,...
          link_set,...
          R_links,...
          joint_axis_vectors,...
          joint_axis_vectors_R,...
          ax,...
          l,...
          l3]= ME317_Assignment_draw_3D_arm_individual_links
% Draw the arm as a set of lines, one per link

    %%%%%%%%%%
    % Specify link vectors as a 1x3 cell array of 3x1 vectors, named
    % 'link_vectors'
    link_vectors = {[1;0;0],[1;0;0],[0;0;0.5]};
    %%%%%%%%%%
    % Specify joint angles as a 3x1 vector, named 'joint_angles'
    joint_angles = [2*pi/5;-pi/4;pi/4];
    %%%%%%%%%%
    % Specify joint axes as a 3x1 cell array, named 'joint_axes'
    joint_axes={'z';'y';'x'};
    %%%%%%%%%%
    % Specify colors of links as a 1x3 cell array named 'link_colors'. Each
    % entry can be either a standard matlab color string (e.g., 'k' or 'r')
    % or a 1x3 vector of the RGB values for the color (range from 0 to 1)
    link_colors={'r','g','b'};
    %%%%%%%%%
    % Generate a cell array named 'link_set' containing start-and-end
    % points for the links. Also get R_links as an output
    % from the function that generates 'link_set'.

    [link_set, ~, R_links] = threeD_robot_arm_links(link_vectors, joint_angles, joint_axes);

    % Use 'threeD_joint_axis_set' to turn the joint axes into
    % a set of axis vectors called 'joint_axis_vectors'
    
    joint_axis_vectors = threeD_joint_axis_set(joint_axes);

    % Use 'vector_set_rotate' to rotate the joint axes by the link
    % orienations (Note that although our convention is that the ith joint
    % is in the (i-1)th link, the vector associated with the joint axis is
    % the same in both frame (i-1) and frame i, so we can rotate the joint
    % axes directly into the corresponding frames (this means we don't have
    % to offset the joint axes when calling 'vector_set_rotate'). Call the
    % output of this rotation 'joint_axis_vectors_R'.
      
    joint_axis_vectors_R = vector_set_rotate(joint_axis_vectors,R_links);

    %%%%%%%%%
    % Create figure and axes for the plot, and store the handle in a
    % variable named 'ax'
 
    ax = create_axes(303);

    %%%%%%%%%
    % Draw a line for each link, and save the handles to these surfaces
    % in a cell array named 'l'

    l = threeD_draw_links(link_set,link_colors,ax);

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
    %
    % Save the handles to these lines into a cell array called 'l3'.
    %
    % As you make these lines, set their color property to be the
    % same as the link immediately after the joint

    l3 = cell(size(link_set));

    for i = 1:numel(link_set)
    x =[link_set{i}(1, 1); link_set{i}(1, 1)+joint_axis_vectors_R{i}(1, 1)];              
    y =[link_set{i}(2, 1); link_set{i}(2, 1)+joint_axis_vectors_R{i}(2, 1)];            
    z =[link_set{i}(3, 1); link_set{i}(3, 1)+joint_axis_vectors_R{i}(3, 1)];
    l3{i} = line(ax,x,y,z,'marker','o','color',link_colors{i},'linestyle','--');
    end
end