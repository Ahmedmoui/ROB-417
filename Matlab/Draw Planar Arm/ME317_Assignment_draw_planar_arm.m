function [link_vectors,...
          joint_angles,...
          link_ends,...
          ax,...
          l] = ME317_Assignment_draw_planar_arm
% Draw the arm as one line

    %%%%%%%%%%
    % Specify link vectors as a 1x3 cell array of 2x1 vectors, named
    % 'link_vectors'

    link_vectors = {[1;0],[1;0],[.5;0]};

    %%%%%%%%%%
    % Specify joint angles as a 3x1 vector, named 'joint_angles'

    joint_angles = [(2/5);(-1/2);(1/4)]*pi;

    %%%%%%%%%%
    % Get the endpoints of the links, in a cell array named 'link_ends'

    link_ends = planar_robot_arm_endpoints(link_vectors,joint_angles);

    %%%%%%%%%
    % Create figure and axes for the plot, and store the handle in a
    % variable named 'ax'

    ax = create_axes(317);

    %%%%%%%%
    % Draw a line from the data, with circles at the endpoints, and save
    % the handle to this line in a variable named 'l'

    l = line('Xdata',link_ends(1,:),'Ydata',link_ends(2,:),'parent',ax,'marker','o','color','r');

end