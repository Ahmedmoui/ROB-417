function [link_set,...
            R_joints,...
            R_links,...
            link_set_local,...
            link_vectors_in_world,...
            links_in_world,...
            link_end_set,...
            link_end_set_with_base] = planar_robot_arm_links(link_vectors,joint_angles)
% Take a set of link vectors and joint angles, and return a set of matrices
% for which the columns of each matrix are the endpoints of one of the links.
%
% Inputs:
%
%   link_vectors: a 1xn cell array, each element of which is a 2x1 vector
%       describing the vector from the base of the corresponding link to
%       its end
%   joint_angles: a nx1 vector, each element of which is the joint angle
%       preceeding the corresponding link
%   
% Outputs:
%
%   links: a 1xn cell array, each element of which is 2x2 matrix, whose
%       columns are the endpoints of the corresponding link
%
% Additional outputs (These are intermediate variables. Having the option
%   to return them as outputs lets our automatic code checker tell you
%   where problems are in your code):
%
%   R_joints: The rotation matrices associated with the joints
%   R_links: The rotation matrices for the link orientations
%   link_set_local: The link vectors augmented with a zero vector that
%       represents the start of the link
%   link_vectors_in_world: The link vectors in their current orientations
%   links_in_world: The link start and end points in their current
%       orientations
%   link_end_set: The endpoints of the links after taking the cumulative
%       sum of link vectors


    %%%%%%%%
    % First, generate a cell array named 'R_joints' that contains a set of
    % rotation matrices corresponding to the joint angles
    
    R_joints = planar_rotation_set(joint_angles);
    
    %%%%%%%%
    % Second, generate a cell array named 'R_links' that contains the
    % orientations of the link frames by taking the cumulative products of
    % the joint rotation matrices
    
    R_links = rotation_set_cumulative_product(R_joints);
    
    %%%%%%%%
    % Third, generate a cell array named 'link_set_local' that contains the
    % endpoint-sets for the links (a matrix whose columns are a zero vector
    % and the link vector
    
    link_set_local = build_links(link_vectors);
    
    %%%%%%%%
    % Fourth, generate a cell array named 'link_vectors_in_world' that
    % contains the link vectors rotated by the rotation matrices for the
    % links
    
    link_vectors_in_world = vector_set_rotate(link_vectors, R_links);
    
    %%%%%%%%
    % Fifth, generate a cell array named 'links_in_world' that contains the
    % link start-and-end matrices rotated by the rotation matrices for the
    % links
    
    links_in_world = build_links(link_vectors_in_world);
    
    %%%%%%%%
    % Sixth, generate a cell array named 'link_end_set' that contains the
    % endpoints of each link, found by taking the cumulative sum of the
    % link vectors
    
    link_end_set = vector_set_cumulative_sum(link_vectors_in_world);
                
    %%%%%%%%
    % Seventh, add a cell containing a  zero vector (for the origin point at
    % the base of the first link) to the beginning oflink_end_set, saving
    % the result in a cell array named 'link_end_set_with_base'

    link_end_set_with_base = cell(1,length(link_end_set)+1);
    link_end_set_with_base{1} = zeros(size(link_end_set{1}));
    
                             %      Add an element to a cell array by using square brackets to concatenate two cell arays
                             %      Make a zero vector the same size as the other vectors, and wrap it in a cell array
                             %      Include the original cell array
      for idx = 1:numel(link_end_set)
          link_end_set_with_base{idx+1} = link_end_set{idx};
      end


    %%%%%%%%
    % Eighth, generate a cell array named 'link_set' by adding the
    % basepoint of each link to the start-and-end matrices of that link
    
    link_set = place_links(links_in_world,link_end_set_with_base);

end