function [link_set,...
    link_normals] = planar_build_links_prismatic(link_vectors,link_extensions,prismatic)
% Take a set of link vectors and augment each with a zero vector to form
% the base of the link. If the link is prismatic, represent the link as
% three lines: 
%   The base of the link is two lines that are each 3/4
% the zero-extension length of the link and are offset laterally (to the
% left and right) by a small amount from the line between the link start
% and endpoints.
%   The moving part of the link is a line 1/2 the zero-extension link
% length, and offset along the link vector by 1/2 the zero-extension length, plus
% the link extension
%
% Input:
%
%   link_vectors: a 1xn cell array, each element of which is the vector
%       from the base to end of a link, as seen in its *local* coordinate
%       frame 
%   link_extensions: a nx1 vector, each element of which is the extended 
%       length of the corresponding link.
%   prismatic: a nx1 vector, each element of which contains the information 
%        if the corresponding link is the prismatic or not, and
%        acts as a boolean.(0: false, 1: true)
%
% Outputs:
%
%   link_set: a 1xn cell array, each element of which is either:
%
%       1. A 2x2 matrix whose columns are the [0;0] base of the link in its
%       local frame and the link vector (end of the link) in its local
%       frame
%
%       or
%
%       2. A 2x8 matrix formed of three 2x2 matrices separated by 2x1 NaN
%       matrices. The columns of the three submatrices are the start and
%       endpoints of the three lines illustrating a prismatic link
%
%   link_normals: a cell array of the same size as link_vectors, containing
%       the unit normal vectors to the links


    %%%%%%%%%%%%%%
    % Use the 'cell' 'and 'size' commands to create an empty cell array the
    % same size as link_vectors named 'link_set'
    
    link_set = cell(size(link_vectors));

    %%%%%%%%%%%%%
    % Loop over the vectors in link_vectors, constructing a matrix whose
    % first column is all zeros and whose second column is the link vector,
    % and saving this matrix in the corresponding column of link_set

    for idx = 1:numel(link_vectors)
        link_set{idx} = [zeros(size(link_vectors{idx})),link_vectors{idx}];
    end

    %%%%%%%%%%%%%%
    % Create a normal vector for each link -- first create an empty cell
    % array the same size as link_vectors named 'link_normals', and then
    % loop over the link_vectors creating a unit-length vector that is
    % rotated 90 degrees with respect to the link vector
    
    link_normals = cell(size(link_vectors));

    for idx = 1:numel(link_vectors)
        link_normals{idx} = R_planar(pi/2)*link_vectors{idx}/norm(link_vectors{idx});
    end


    
    for idx = 1:length(link_vectors)

    if prismatic(idx) == 1 
matrix_1 = (3/4)*link_set{idx};
    %           2. Add a vector 1/50 the link length in the link_normal
    %               direction to each column
    matrix_1(:,1) = matrix_1(:,1) + 1/50 * norm(link_vectors{idx}) .* link_normals{idx};
    matrix_1(:,2) = matrix_1(:,2) + 1/50 * norm(link_vectors{idx}) .* link_normals{idx};
    %           3. Make a second 3/4 scale copy of the link vector
    matrix_2 = (3/4)*link_set{idx};
    %           4. Add a vector 1/50 the link length in the *negative* 
    %               link_normal direction to each column of this second
    %               matrix
    matrix_2(:,1) = matrix_2(:,1) - (1/50 * norm(link_vectors{idx}) .* link_normals{idx});
    matrix_2(:,2) = matrix_2(:,2) - (1/50 * norm(link_vectors{idx}) .* link_normals{idx});
    %           5. Make a 1/2 scale copy of the link vector
    matrix_3 = link_set{idx} * 1/2;
    %           6. Add a vector 1/2 the zero-extension link length plus the
    %               link extension amount in the direction of the link to
    %               each column of this third matrix
    matrix_3 = matrix_3 + (1/2 * link_vectors{idx}) + (link_vectors{idx}.*(link_extensions(idx)/norm(link_vectors{idx})));
   
    %           7. Join the three resulting 2x2 matrices together into a
    %               2x8 matrix, using 2x1 NaN matrices as spacers.
    fill = NaN(2,1);
    link_set{idx} = [matrix_1 fill matrix_2 fill matrix_3];
    else

    end
    end
end