function l = threeD_solid_draw_links(link_set,link_colors,ax)
% Draw a set of surfaces for a link structure into a specified axis
%
% Inputs:
%
%   link_set: A 1xn cell array, each entry of which is a matrix whose
%       columns are the endpoints of the lines describing one link of the
%       system (as constructed by planar_build_links or
%       planar_build_links_prismatic
%   ax: The handle to an axis in which to plot the links
%
% Output:
%
%   l: A cell array of the same size as link_set, in which each entry is a
%       handle to a surface structure for that link


    %%%%%%%%

        % Start by creating an empty cell array of the same size as link_set,
    % named 'l'

l = cell(size(link_set));

    %%%%%%%%
    % Draw a surface for each link, and save the handle for this line in
    % the corresponding element of 'l'. Note that you want the 'surface'
    % command and not 'surf', because the 'surf' command resets the plot.
    % The color of the surface can be set using the 'FaceColor' attribute;
    % be sure to set the 'Parent' of the surface as 'ax'

for idx = 1:numel(link_set)
        x = link_set{idx}{1};
        y = link_set{idx}{2};
        z = link_set{idx}{3};

        l{idx} = surface('Parent', ax, 'XData', x, 'YData', y, 'ZData', z, 'facecolor', link_colors{idx});

end
end