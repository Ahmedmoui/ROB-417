function [link_vectors,...
          joint_angles,...
          link_colors,...
          link_set,...
          ax,...
          l] = ME317_Assignment_draw_planar_arm_individual_links
% Draw the arm as a set of lines, one per link and each of a different color

    %%%%%%%%%%
    % Specify link vectors as a 1x3 cell array of 2x1 vectors, named
    % 'link_vectors'

    link_vectors = {[1;0],[1;0],[0.5;0]};

    %%%%%%%%%%
    % Specify joint angles as a 3x1 vector, named 'joint_angles'

    joint_angles = [2*pi/5;-pi/2;pi/4];

    %%%%%%%%%%
    % Specify colors of links as a 1x3 cell array named 'link_colors'. Each
    % entry can be either a standard matlab color string (e.g., 'k' or 'r')
    % or a 1x3 vector of the RGB values for the color (range from 0 to 1)

    link_colors={'r','g','b'};

    %%%%%%%%%
    % Generate a cell array named 'link_set' containing start-and-end
    % points for the links, named link_set


       
    link_set = planar_robot_arm_links(link_vectors,joint_angles);


    %%%%%%%%%
    % Create figure and axes for the plot, and store the handle in a
    % variable named 'ax'
    
    ax = create_axes(382);
    %%%%%%%%%
    % Use 'draw_links' to draw the link set, saving the output as a
    % variable 'l'
    l = draw_links(link_set,link_colors,ax);
end