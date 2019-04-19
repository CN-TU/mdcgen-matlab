%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%[correlation] = setCorrelation(correlationIn, nClusters)
%
% Description: 
%   The function sets the noise property
%
% Inputs:
%   correlationIn: As a scalar applied to all clusters, as a vector for each
%                  cluster independently
%   nClusters: the number of the clusters
%
% Outputs:
%   correlation: An initialized array with the length equal to nClusters.
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 26.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [noise, noiseType] = setNoise(nNoise, dimensions, nClusters)

[m,n] = size(nNoise);
noise=0; 

if m == 1 && n > 1 
   if length(nNoise) > dimensions
       error('setNoise:ConfigurationError', 'Noise array length %d is larger that number of dimensions %d.', length(nNoise), dimensions); 
   end
   
   if(nNoise(nNoise > dimensions))
       error('setNoise:ConfigurationError', 'Noise array contains element larger then dataset dimensionality %d.', dimensions); 
   end
   
   noise = nNoise; 
   noiseType = 'array';
   
elseif m == 1 && n == 1 
    if nNoise > dimensions
       error('setNoise:ConfigurationError', 'Number of noisy dimensions = %d exceeds the total number of dimensions = %d.', nNoise, dimensions);   
    end
    noise = [];
    for i = 1 : nNoise
        noise = [noise, dimensions];
        dimensions = dimensions - 1;
    end
    noiseType = 'array';
    
elseif m > dimensions || n ~= nClusters
    error('setNoise:ConfigurationError', 'Noise matrix does not match the number of clusters = %d. or dimensions %d', dimensions, nClusters);  
    
else 
   if(nNoise(nNoise > dimensions))
       error('setNoise:ConfigurationError', 'Noise matrix contains element larger then dataset dimensionality %d.', dimensions); 
   end
    noise = nNoise; 
    noiseType = 'matrix';
end   

end

