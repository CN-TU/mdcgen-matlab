%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% [clusterPoints] = radialBasedDistribution(cluster, distribution, pointsPerCluster, nDimensions, compactness, userDistributions)
%
% Description: This function creates a multivariate distribution of
%              datapoints for the selected distribution function.
%              Multivariate means that the distribution function is applied
%              to every dimension independently. 
%
% Inputs:
%   cluster:            number of the cluster
%   distribution:       the distribution to apply
%   pointsPerCluster:   number of points to generate
%   nDimensions:        number of dimensions
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
function [clusterPoints] = radialBasedDistribution(cluster, distribution, pointsPerCluster, nDimensions, compactness, userDistributions)

if distribution(1, cluster) == 6
    randomPoints = normrnd(0,1, 2 * pointsPerCluster,nDimensions) - 0.5;
else
    randomPoints = normrnd(0,1, pointsPerCluster,nDimensions);
end

nSphere = sqrt(nDimensions) * bsxfun(@rdivide, randomPoints, rms(randomPoints')'); % normalizing 

switch distribution(1, cluster)
    case 1
        probabilityDistribution = makedist('Uniform','Lower',-compactness,'Upper',compactness);
        clusterPoints = random(probabilityDistribution,pointsPerCluster,1);
        clusterPoints = bsxfun(@times, nSphere, clusterPoints);
    case 2
        probabilityDistribution = makedist('Normal','mu',0,'sigma',compactness);
        clusterPoints = random(probabilityDistribution,pointsPerCluster,1);
        clusterPoints = bsxfun(@times, nSphere, clusterPoints);
    case 3
        probabilityDistribution = makedist('Logistic','mu',0,'sigma',compactness);
        clusterPoints = random(probabilityDistribution,pointsPerCluster,1);
        clusterPoints = bsxfun(@times, nSphere, clusterPoints);
    case 4
        probabilityDistribution = makedist('Triangular','a',-compactness,'b',0,'c',compactness);
        clusterPoints = random(probabilityDistribution,pointsPerCluster,1);
        clusterPoints = bsxfun(@times, nSphere, clusterPoints);
    case 5
        probabilityDistribution = makedist('Gamma','a',2+8*rand(),'b',compactness/5);
        clusterPoints = random(probabilityDistribution,pointsPerCluster,1);
        clusterPoints = bsxfun(@times, nSphere, clusterPoints);
    case 6
        probabilityDistribution = makedist('Normal','mu',0,'sigma',compactness); % Ring distribution
        Npi = random(probabilityDistribution,2*pointsPerCluster,1);
        Npi = bsxfun(@times, nSphere, Npi);
        aux = rms(Npi');
        medaux = median(aux);
        clusterPoints = Npi(aux > medaux,:);
    otherwise
        clusterPoints = createOwnDistribution(distribution(1,cluster)-6, userDistributions, compactness,pointsPerCluster);
        clusterPoints = clusterPoints';
        clusterPoints = bsxfun(@times, nSphere, clusterPoints);
end

end

