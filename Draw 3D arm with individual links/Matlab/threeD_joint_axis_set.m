function joint_axis_vectors = threeD_joint_axis_set(joint_axes)
% Generate a set of unit vectors along specified x, y, or z axes
%
% Input:
%
%   joint_axes: a cell array , each element of which is a 
%       one-character string 'x','y', or 'z' that specifies
%       an axis of rotation
%
% Output:
%
%   joint_axis_vectors: a cell array of the same size as the vector
%       joint_axes, in which each cell contains the 3x1 unit vector in the
%       direction specified in the corresponding entry of joint_axes

    %%%%%%%%
    % Start by creating an empty cell array of the same size as joint_axes,
    % named 'joint_axis_vectors'
    
joint_axis_vectors = cell(size(joint_axes));

    %%%%%%%%
    % Loop over the joint axes
        
        %%%%%%%
        % Use 'switch/case' to check which axis the joint is aligned with
        % around. For 'x','y', or 'z', this should result in a unit vector
        % along the appropriate axis.
        %
        % Any other string should trigger the 'otherwise' part of
        % switch/case, in which there should be an 'error' function that
        % tells the user what they did wrong. For example, 
        %
        % error([joint_axis ' is not a known joint axis'])
        % 
        % would make the program stop, and tell the user what string was
        % incorrectly supplied as the description of a unit vector.
               
        for idx = 1:numel(joint_axes)
            switch joint_axes{idx}
                case 'x'
                    joint_axis_vectors{idx}=[1;0;0];
                case 'y'
                    joint_axis_vectors{idx}=[0;1;0];
                case 'z'
                    joint_axis_vectors{idx}=[0;0;1];
                otherwise
                    error([joint_axis ' is not a known joint axis'])
            end
        end
end