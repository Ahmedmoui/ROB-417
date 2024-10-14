function link_set = build_links(link_vectors)
% Take a set of link vectors and augment each with a zero vector representing
% the base of the link
%
% Input:
%
%   link_vectors: a 1xn cell array, each element of which is an mx1 vector
%       from the base to end of a link, as seen in its *local* coordinate
%       frame 
%
% Output:
%
%   link_set: a 1xn cell array, each element of which is a mx2 matrix whose
%       first column is all zeros (representing the base of the link in its
%       local frame) and whose second column is the link vector (end of the
%       link) in its local frame

    %%%%%%%%%%%%%%
    % Use the 'cell' 'and 'size' commands to create an empty cell array the
    % same size as link_vectors, named 'link_set'
    
    link_set = cell(size(link_vectors));


    % Loop over the vectors in link_vectors, constructing a matrix whose
    % first column is all zeros and whose second column is the link vector,
    % and saving this matrix in the corresponding column of link_set

    
    for idx = 1:numel(link_set)
        
        link_set{idx} = [zeros(size(link_vectors{idx})),link_vectors{idx}];

    end

end
