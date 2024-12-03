function [C,...
          dM,...
          C_1_components,...
          C_1,...
          C_2] =...
    CoriolisCentrifugal(dM_function,configuration,velocity)
% Calculate the C vector in the Euler-Lagrange equations as a function of
% the current configuration and velocity
%
% Inputs:
%
%   dM_function: A handle to a function that takes in a configuration
%       vector and returns a 1xn cell array, whose entries are the
%       derivative of the inertia matrix with respect to configuration
%       (e.g., the joint angles).
%   configuration: An nx1 or 1xn vector describing the current
%       configuration of the system (e.g., its joint angles)
%   velocity: A nx1 vector describing the current configuration velocity of
%       the system (e.g., its joint angle velocities)
%       
% Output:
%
%   C: A nx1 vector describing the centripetal and coriolis forces as the
%       appear from the perspective of the configuration variables (e.g.,
%       the torques that they produce on the joints)
%
% Additonal outputs:
%
%   dM: The derivative of the inertia matrix, as evaluated at the current
%       configuration
%   C_1_components: The results of the individual calculations that
%       contribute to the first term in C
%   C_1: The first term in C
%   C_2: The second term in C

    %%%%%%%%%%%%%
    % First, evaluate the derivative of the inertia matrix at the current
    % configuration

      dM = dM_function(configuration);

    %%%%%%%%%%%%%
    % Second, calculate the first component of C
    % Create an empty [n x 1] cell array called 'C_1_components'
    C_1_components = cell(numel(configuration), 1);

    % Loop over the entries of 'dM' performing two operations on each, and
    % saving the resulting vector into the corresponding element of
    % C_1_components:
    %   A. Multiplying the dM matrix by the corresponding entry of
    %       velocity
    %   B. Multiplying this scaled dM component by the full velocity vector
        for idx = 1:numel(dM)
            temp = dM{idx} * velocity(idx);
            C_1_components{idx} = temp * velocity;
        end

    % Create a zero vector of the same size as velocity, named 'C_1'
    C_1 = zeros(size(velocity));
    
    % Loop over the entries of 'C_1_components', adding them to 'C_1'
    for idx = 1:numel(C_1_components)
        C_1 = C_1 + C_1_components{idx};
    end
    
    %%%%%%%%%%%%%
    % Third, calculate the second component of C
    % Create a zero vector of the same size as velocity,
    % named 'C_2'
    C_2 = zeros(size(velocity));

    % Loop over the entries of 'dM' performing two operations on each, and
    % saving the resulting scalar value into the corresponding element of
    % C_2:
    %   A. Pre-ultiplying the dM matrix with the transpose of
    %       velocity
    %   B. Post-multiplying the result of step A by velocity
    for idx = 1:numel(dM)
        temp = velocity.' * dM{idx};
        C_2(idx) = temp * velocity;
    end

    
    %%%%%%%%%%%%%
    % Finally, subtract C_2 from C_1 to generate C
    C = C_1 - C_2;

end