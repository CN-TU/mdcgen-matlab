%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [ distributedPoints ] = createOwnDistribution( distributionIndex, userDistribution, compactness, nPoints )
%
% Description: This function distributes points based on a user defined
%              distribution
%
% Inputs:
%   distributionIndex: the index of the user distribution to select
%   userDistribution:  struct containing all user distributions
%   compactness:       the compactness value
%   nPoints:           the number of data points to generate
%
% Outputs:
%   distributedPoints: points distributed according to the user defined
%                      distribution
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 08.03.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [ distributedPoints ] = createOwnDistribution( distributionIndex, userDistribution, compactness, nPoints )

binProbability = userDistribution(distributionIndex).binProbability;
edges = userDistribution(distributionIndex).edges * compactness;

binWidths = diff(edges);
[~, ~, bin] = histcounts( rand(1, nPoints), [0 cumsum(binProbability)]);

distributedPoints = edges(bin) + rand(1,nPoints).* binWidths(bin);

end

