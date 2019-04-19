%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [T, p] = calculateCorrelationMatrix(nDimensions,correlation, clusterNumber)
%
% Description: This function calculates the correlation matrix
%
% Inputs:
%   nDimensions:    number of dimensions
%   correlation:    the correlation value
%   clusterNumber:  the cluster number
%   
% Outputs:
%   T:              cholcov matrix       
%   p:              chol value
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 14.03.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [T, p] = calculateCorrelationMatrix(nDimensions,correlation, clusterNumber)

correlationMatrix = ones(nDimensions);

for i = 1 : nDimensions
    for j = 1 : nDimensions
        aux = correlation(clusterNumber) * 2 * (rand() - 0.5);
        if i ~= j
            correlationMatrix(i,j) = aux;
            correlationMatrix(j,i) = aux;
        end
    end
end
addpath(genpath('../../extra_tools'));
correlationMatrix = nearestSPD(correlationMatrix);

[~,p] = chol(correlationMatrix);
T = cholcov(correlationMatrix);
        
end

