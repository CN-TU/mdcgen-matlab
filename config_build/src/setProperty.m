%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [property] = setProperty(propertyIn, propertyName, value, valueName)
%
% Description: 
%   The function sets an array for a property.
%
% Inputs:
%   propertyIn: As a scalar applied to all values, as a vector for each
%               value independently
%   propertyName: the name for the error message
%   value: Number of values
%   valueName: the name for the error message
%
% Outputs:
%   property: An initialized array with the length of value.
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 21.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [property] = setProperty(propertyIn, propertyName, value, valueName)
    
    if length(propertyIn) > 1
       if length(propertyIn) ~= value
           error('setProperty:ConfigurationError', "Length of "+ propertyName +" = %d does not match the number of " + valueName + " = %d.", length(propertyIn), value);
       end
       property = propertyIn;
    else
        property = propertyIn * ones(1, value);
    end
end