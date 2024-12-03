function q = draw_vectors_at_point(p,V,ax)
% Draw the columns of V as arrows based at point p, in axis ax
%
% Inputs:
%
%   p: a 3x1 vector designating the location of the vectors
%   V: a 3xn matrix, each column of which is a 3x1 vector that should be
%       drawn at point p
%   ax: the axis in which to draw the vectors
%
% Output:
%
%   q: a cell array of handles to the quiver objects for the drawn arrows

    % First use hold(ax,'on') so that when we call quiver, it does not
    % delete the plot
    hold(ax, 'on')
    % Now create an empty cell array named 'q' with one row and as many columns as V
    q = cell(size(V(1,:)));
    % Loop over the columns of V
    
    for idx = 1:length(V)
% Use quiver to plot an arrow at p, with vector components taken
% as the first three rows of the (idx)th column of v. store the 
% output as the(idx)th element of q
q{idx} = quiver3(p(1) ,p(2) ,p(3) , V(1,idx), V(2, idx), V(3, idx), 'parent', ax);

    end

% Use hold(ax, 'off') to return the axis to its normal behavior
hold(ax, 'off');
end