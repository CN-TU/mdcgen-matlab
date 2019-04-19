%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% function [distribution] = setDistribution(distributionIn, dimensions, nClusters)
%
% Description: 
%   The function sets the distribution depending on the configuration.
%
% Inputs:
%   distributionIn: distribution to be set. As a scalar it is a uniform
%                   distribution for every cluster and every dimension.
%                   As a vector it specifies a distribution per cluster.
%                   As a matrix it specifies a distribution per cluster and
%                   per dimension.
%   dimensions: number of dimensions for the dataset
%   nClusters: Number of clusters
%
% Outputs:
%   distribution: The correctly set distribution
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 21.02.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [distribution] = setDistribution(distributionIn, dimensions, nClusters)

    [m,n] = size(distributionIn);
    if m == 1 && n == 1 % d is scalar, one distribution for all clusters and all dimensions
        distribution = distributionIn * ones(dimensions, nClusters);
       
    elseif m == 1 && n > 1 % 'd' is an array, distribution per cluster for all dimensions
       if length(distributionIn) ~= nClusters
           error('setDistribution:ConfigurationError', 'Length of distributions = %d does not match the number of clusters = %d.', length(distributionIn), nClusters);
       end
       distribution = bsxfun(@times, distributionIn, ones(dimensions, nClusters));
    
    elseif m ~= dimensions || n ~= nClusters % d is matrix, distribution per cluster and per dimension
       error('setDistribution:ConfigurationError', 'Distribution matrix does not match the number of clusters = %d. or dimensions %d', nClusters, dimensions);  % 'd' is a matrix
    else
       distribution = distributionIn;
    end  
end