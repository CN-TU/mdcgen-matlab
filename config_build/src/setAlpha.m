%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [property] = setAlpha(propertyIn, propertyName, value, valueName)
%
% Description: 
%   The function sets an array for a property.
%
% Inputs:
%   alpha: As a scalar applied to all values, as a vector for each
%               value independently
%   alphaFactor: the name for the error message
%   nDimensions: Number of values
%   
% Outputs:
%   property: An initialized array with the length of value.
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 21.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [alpha, alphaFactor] = setAlpha(alphaIn, alphaFactorIn, nDimensions)
      
lenAlpha = length(alphaIn);
lenAlphaFactor = length(alphaFactorIn);

if lenAlpha == 1 && lenAlphaFactor == 0
    alpha = alphaIn * ones(1, nDimensions);
    alphaFactor = [];
elseif lenAlphaFactor == 1 && lenAlpha == 0
    alphaFactor = alphaFactorIn * ones(1, nDimensions);
    alpha = zeros(1, nDimensions);
else
    if lenAlpha ~= nDimensions && lenAlphaFactor == 0
        error('setAlpha:ConfigurationError', "Length of alpha = %d does not match nDimensions = %d.", lenAlpha, nDimensions);
    elseif lenAlphaFactor ~= nDimensions && lenAlpha == 0
        error('setAlpha:ConfigurationError', "Length of alphaFactor = %d does not match nDimensions = %d.", lenAlphaFactor, nDimensions);
    elseif lenAlpha > 0 && lenAlphaFactor > 0
        if lenAlpha ~= nDimensions || lenAlphaFactor ~= nDimensions
            error('setAlpha:ConfigurationError', "Length of alpha = %d, alphaFactor = %d must be equal to nDimensions = %d.", lenAlpha, lenAlphaFactor, nDimensions);
        end
    end
    
    if lenAlpha == nDimensions && lenAlphaFactor == 0
        alpha = alphaIn;
        alphaFactor = [];
    elseif lenAlphaFactor == nDimensions && lenAlpha == 0
        alphaFactor = alphaFactorIn;
        alpha = zeros(1, nDimensions);
    elseif lenAlphaFactor == nDimensions && lenAlpha == nDimensions
        alpha = alphaIn;
        alphaFactor = alphaFactorIn;
    end
    
end
      
end