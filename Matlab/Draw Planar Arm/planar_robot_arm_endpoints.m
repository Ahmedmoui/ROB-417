function [link_ends,...
            R_joints,...
            R_links,...
            link_vectors_in_world,...
            link_end_set,...
            link_end_set_with_base] = planar_robot_arm_endpoints(link_vectors,joint_angles)
% Take a set of link vectors and joint angles, and return a matrix whose
% columns are the endpoints of all of the links (including the point that
% is the first end of the first link, which should be placed at the
% origin).
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
%   link_ends: a 3x(n+1) matrix, whose first column is the location
%       of the base of the first link (which should be at the origin), and
%       whose remaining columns are the endpoints of the links
%
% Additional outputs (These are intermediate variables. Having the option
%   to return them as outputs lets our automatic code checker tell you
%   where problems are in your code):
%
%   R_joints: The rotation matrices associated with the joints
%   R_links: The rotation matrices for the link orientations
%   link_vectors_in_world: The link vectors in their current orientations
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
    % Third, generate a cell array named 'link_vectors_in_world' that
    % contains the link vectors rotated by the rotation matrices for the
    % links
    
    link_vectors_in_world = vector_set_rotate(link_vectors,R_links);
    
    %%%%%%%%
    % Fourth, generate a cell array named 'link_end_set' that contains the
    % endpoints of each link, found by taking the cumulative sum of the
    % link vectors
    
    link_end_set = vector_set_cumulative_sum(link_vectors_in_world);
    
    %%%%%%%%
    % Fifth, add a cell containing a zero vector (for the origin point at
    % the base of the first link) to the beginning oflink_end_set, saving
    % the result in a cell array named 'link_end_set_with_base'
    
    link_end_set_with_base = [zeros(size(link_end_set{1})), link_end_set];
                
    %%%%%%%%
    % Sixth, convert the set of link vectors to a simple matrix using the
    % 'cell2mat' command, saving the result in a matrix named 'link_ends'
    
    link_ends = cell2mat(link_end_set_with_base);

end