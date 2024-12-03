function R = R_planar(theta)
% Planar rotation matrix
%
% Input:
x = theta;
%   theta: scalar value for rotation angle']\
%
% Output:
R = [cos(x) -sin(x); sin(x) cos(x)];
%   R: 2x2 rotation matrix that for rotation by theta

end