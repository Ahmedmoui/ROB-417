function b = orthonormal_basis_from_vector(v)
% Take an input vector, and create an orthonormal basis (i.e., a rotation
% matrix) whose first column is parallel to the provided vector.
%
% Input:
%
%   v: an nx1 vector
%
% Output:
%
%   b: an nxn matrix whose first column is aligned with v, and whose other
%       columns are perpendicular to both v and each other

    % Divide the input vector by its length. The length of a vector can be
    % calculated using the function 'norm'. Call the normalized vector 'x'

    % Find two vectors perpendicular to x and to each other. This can be
    % found by applying the function 'null' to the transpose of the vector
    % 'x'

    % Combine the normalized input vector and the perpendicular vectors (by
    % grouping them them as columns of a single matrix)
x = v/norm(v); % finding normalised vector

per = null(transpose(x)); % finding 2 perpendicular vectors

b = [x per]; % combining the normalized vecor and 2 perpendicular vectors


end