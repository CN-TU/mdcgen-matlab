%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [clusterPoints] = multivariateDistribution(cluster, pointsPerCluster, nDimensions, distribution, compactness, userDistributions)
%
% Description: This function creates a multivariate distribution of
%              datapoints for the selected distribution function.
%              Multivariate means that the distribution function is applied
%              to every dimension independently. 
%
% Inputs:
%   cluster:            number of the cluster
%   pointsPerCluster:   number of points to generate
%   nDimensions:        number of dimensions
%   distribution:       the distribution to apply
%   compactness:        compactness coefficient for the clusters
%   userDistributions:  user distributions to use
%
% Outputs:
%   clusterPoints:      a matrix containing the cluster data points    
%
% Author:     Denis Ojdanic <denis.ojdanic@yahoo.com>
% Supervisor: Félix Iglesias Vázquez <felix.iglesias@nt.tuwien.ac.at>
% Date: 20.03.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [clusterPoints] = multivariateDistribution(cluster, pointsPerCluster, nDimensions, distribution, compactness, userDistributions)

clusterPoints = zeros(pointsPerCluster, nDimensions);

for jDimension = 1 : nDimensions
     
    switch distribution(jDimension,cluster)
        case 1, probabilityDistribution = makedist('Uniform', 'Lower', - compactness, 'Upper', compactness);
        case 2, probabilityDistribution = makedist('Normal', 'mu', 0, 'sigma', compactness);
        case 3, probabilityDistribution = makedist('Logistic', 'mu', 0, 'sigma', compactness);
        case 4, probabilityDistribution = makedist('Triangular', 'a', - compactness, 'b', 0, 'c', compactness);
        case 5, probabilityDistribution = makedist('Gamma', 'a', 2 + 8 * rand(), 'b', compactness / 5);
        case 6, probabilityDistribution = makedist('Normal', 'mu', 0, 'sigma', compactness); % Ring distribution
        otherwise, clusterPoints(:,jDimension) = createOwnDistribution(distribution(jDimension,cluster) - 6, userDistributions, compactness, pointsPerCluster);
    end
    
    if distribution(jDimension, cluster) < 6
        clusterPoints(:,jDimension) = random(probabilityDistribution, pointsPerCluster, 1);
        
    elseif distribution(jDimension,cluster) == 6
        Npi = random(probabilityDistribution, 2 * pointsPerCluster, 1);
        a25 = quantile(Npi, 0.251);
        a75 = quantile(Npi, 0.749);
        aux = Npi(Npi < a25 | Npi > a75)';
        aux = aux(1 : pointsPerCluster);
        clusterPoints(:,jDimension) = aux;
    end
    
end
end

