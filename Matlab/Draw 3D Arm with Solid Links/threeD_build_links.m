function link_set = threeD_build_links(link_vectors)
% Take a set of link vectors and create a cylinder pointing in the
% direction of that link
%
% Input:
%
% link_vectors: A 1xn cell array in which each entry is a 3x1 link vector
%
% Output:
%
% link_set: A cell array the same size as link_vectors in which each
% entry is itself a cell array whose entries are the X,Y, and Z point
% matrices for a hexagonal prism shell around the link vector


%%%%%%%%%%%%%%
% Use the 'cell' 'and 'size' commands to create an empty cell array the
% same size as link_vectors, named 'link_set'
link_set = cell(size(link_vectors));



%%%%%%%%%%%%%%
% Loop over vectors in link_set, scaling and stretching the basic link
% shape to fit each link.
for i = 1:numel(link_set)


% Get the length of the link
len = norm(link_vectors{i});


% Create a rotation matrix whose first column is aligned with the link vector
R = orthonormal_basis_from_vector(link_vectors{i});
% Create a hexagonal prism with radius 1/20 of the link length,
% oriented along the x axis. (Use the cylinder command with radius 1
% and 6 points around the circumference. Setting the outputs as
% [Z,Y,X] makes the cylinder axis parallel with the x direction.)
[Z,Y,X] = cylinder(len/20,6);

% Use 'rotate_surface' to rotate the prism points by the matrix
link_set{i} = rotate_surface({X*len,Y,Z},R);
link_set{i} = transpose(link_set{i});
end

end