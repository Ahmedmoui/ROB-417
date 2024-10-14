function R = Ry(phi)
% Rotation matrix about the y axis
%
% Input:
%   
%   psi: scalar value for rotation angle
%
% Output:
%
%   R: 3x3 rotation matrix that for rotation by psi around the x axis

R = [cos(phi) 0 sin(phi);...
    0 1 0;...
    -sin(phi) 0 cos(phi)];
end